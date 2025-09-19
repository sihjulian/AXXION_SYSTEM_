import { defineStore } from 'pinia'
import InventoryService from '@/services/InventoryService'
import CategoryService from '@/services/CategoryService'

export const useInventoryStore = defineStore('inventory', {
  state: () => ({
    // Lista de productos
    productList: [],
    
    // Lista de categorías
    categoryList: [],
    
    // Estado de carga
    loading: false,
    categoriesLoading: false,
    
    // Errores
    error: null,
    categoriesError: null,
    
    // Filtros activos
    filters: {
      category: '',
      status: '',
      brand: '',
      location: '',
      search: ''
    },
    
    // Paginación
    pagination: {
      currentPage: 1,
      itemsPerPage: 10,
      totalItems: 0,
      totalPages: 0
    },
    
    // Ordenamiento
    sorting: {
      field: 'nombre',
      direction: 'asc'
    },
    
    // Producto seleccionado para detalles/edición
    selectedProduct: null
  }),

  getters: {
    // Productos disponibles
    availableProducts: (state) => 
      state.productList.filter(item => item.estado === 'disponible'),
    
    // Productos alquilados
    rentedProducts: (state) => 
      state.productList.filter(item => item.estado === 'alquilado'),
    
    // Productos en mantenimiento
    maintenanceProducts: (state) => 
      state.productList.filter(item => item.estado === 'mantenimiento'),
    
    // Total de productos
    totalProducts: (state) => state.productList.length,
    
    // Productos por categoría
    productsByCategory: (state) => {
      const categories = {};
      state.productList.forEach(item => {
        if (!categories[item.categoria]) {
          categories[item.categoria] = [];
        }
        categories[item.categoria].push(item);
      });
      return categories;
    },
    
    // Productos filtrados
    filteredProducts: (state) => {
      let filtered = state.productList;
      
      // Filtrar por búsqueda
      if (state.filters.search) {
        const searchTerm = state.filters.search.toLowerCase();
        filtered = filtered.filter(item => 
          item.nombre?.toLowerCase().includes(searchTerm) ||
          item.modelo?.toLowerCase().includes(searchTerm) ||
          item.numero_serie?.toLowerCase().includes(searchTerm) ||
          item.marca?.toLowerCase().includes(searchTerm)
        );
      }
      
      // Filtrar por estado
      if (state.filters.status) {
        filtered = filtered.filter(item => item.estado === state.filters.status);
      }
      
      // Filtrar por categoría
      if (state.filters.category) {
        filtered = filtered.filter(item => item.categoria === state.filters.category);
      }
      
      // Filtrar por marca
      if (state.filters.brand) {
        filtered = filtered.filter(item => item.marca === state.filters.brand);
      }
      
      // Filtrar por ubicación
      if (state.filters.location) {
        filtered = filtered.filter(item => item.ubicacion === state.filters.location);
      }
      
      return filtered;
    },

    // Obtener estados únicos de los productos
    uniqueStates: (state) => {
      const states = [...new Set(state.productList.map(product => product.estado).filter(Boolean))];
      const labels = {
        'disponible': 'Disponible',
        'alquilado': 'Alquilado',
        'mantenimiento': 'Mantenimiento',
        'fuera_de_servicio': 'Fuera de Servicio'
      };
      return states.map(estado => ({
        value: estado,
        label: labels[estado] || estado
      }));
    }
  },

  actions: {
    // Obtener todos los productos
    async fetchProducts() {
      this.loading = true;
      this.error = null;
      
      try {
        console.log('Store: Iniciando fetchProducts...');
        const response = await InventoryService.getProducts();
        console.log('Store: Products API response:', response);
        
        const products = response.data || response;
        console.log('Store: Productos procesados:', products.length);
        
        this.productList = products;
        this.pagination.totalItems = this.productList.length;
        this.pagination.totalPages = Math.ceil(this.pagination.totalItems / this.pagination.itemsPerPage);
        
        console.log('Store: ProductList actualizada:', this.productList.length, 'productos');
      } catch (err) {
        this.error = err.message || 'Error al cargar productos';
        console.error('Store: Error al cargar productos:', err);
      } finally {
        this.loading = false;
      }
    },

    // Crear nuevo producto
    async createProduct(productData) {
      this.loading = true;
      this.error = null;
      
      try {
        const response = await InventoryService.createProduct(productData);
        console.log('Store: Product created:', response);
        const newProduct = response.data || response;
        this.productList.push(newProduct);
        this.pagination.totalItems = this.productList.length;
        this.pagination.totalPages = Math.ceil(this.pagination.totalItems / this.pagination.itemsPerPage);
        return newProduct;
      } catch (err) {
        this.error = err.message || 'Error al crear producto';
        throw err;
      } finally {
        this.loading = false;
      }
    },

    // Actualizar producto existente
    async updateProduct(id, productData) {
      this.loading = true;
      this.error = null;
      
      try {
        console.log('Store: Actualizando producto ID:', id);
        console.log('Store: Datos a actualizar:', productData);
        
        const response = await InventoryService.updateProduct(id, productData);
        console.log('Store: Respuesta de actualización:', response);
        
        const updatedProduct = response.data || response;
        const index = this.productList.findIndex(item => item.id == id);
        
        console.log('Store: Índice del producto en la lista:', index);
        
        if (index !== -1) {
          this.productList[index] = updatedProduct;
          console.log('Store: Producto actualizado en la lista');
        } else {
          console.warn('Store: No se encontró el producto en la lista para actualizar');
        }
        
        return updatedProduct;
      } catch (err) {
        console.error('Store: Error al actualizar producto:', err);
        this.error = err.message || 'Error al actualizar producto';
        throw err;
      } finally {
        this.loading = false;
      }
    },

    // Eliminar producto
    async deleteProduct(id) {
      this.loading = true;
      this.error = null;
      
      try {
        console.log('Store: Eliminando producto con ID:', id);
        
        // Intentar eliminar del backend
        try {
          await InventoryService.deleteProduct(id);
          console.log('Store: Producto eliminado del backend exitosamente');
        } catch (apiError) {
          console.warn('Store: Error en API, eliminando solo del frontend:', apiError.message);
          // Continuar con la eliminación del frontend aunque falle el backend
        }
        
        // Eliminar del estado local
        const originalLength = this.productList.length;
        this.productList = this.productList.filter(item => item.id != id);
        const newLength = this.productList.length;
        
        console.log(`Store: Productos antes: ${originalLength}, después: ${newLength}`);
        
        // Actualizar paginación
        this.pagination.totalItems = this.productList.length;
        this.pagination.totalPages = Math.ceil(this.pagination.totalItems / this.pagination.itemsPerPage);
        
        return true;
      } catch (err) {
        this.error = err.message || 'Error al eliminar producto';
        console.error('Store: Error al eliminar producto:', err);
        throw err;
      } finally {
        this.loading = false;
      }
    },

    // Obtener producto por ID
    getProductById(id) {
      return this.productList.find(item => item.id === id);
    },

    // Seleccionar producto
    selectProduct(product) {
      this.selectedProduct = product;
    },
    // Limpiar producto seleccionado
    clearSelectedProduct() {
      this.selectedProduct = null;
    },

    // Aplicar filtros
    setFilters(filters) {
      this.filters = { ...this.filters, ...filters };
      this.pagination.currentPage = 1; // Reset pagination
    },

    // Limpiar filtros
    clearFilters() {
      this.filters = {
        category: '',
        status: '',
        brand: '',
        location: '',
        search: ''
      };
      this.pagination.currentPage = 1;
    },

    // Cambiar página
    setCurrentPage(page) {
      this.pagination.currentPage = page;
    },

    // Cambiar ordenamiento
    setSorting(field, direction) {
      this.sorting.field = field;
      this.sorting.direction = direction;
    },

    // Limpiar errores
    clearError() {
      this.error = null;
    },

    // ===== GESTIÓN DE CATEGORÍAS =====

    // Obtener todas las categorías
    async fetchCategories() {
      this.categoriesLoading = true;
      this.categoriesError = null;

      try {
        const response = await CategoryService.getAll();
        console.log('Store: Categories API response:', response);

        // El servicio devuelve el array de categorías directamente
        if (response && Array.isArray(response)) {
          this.categoryList = response;
          console.log('Store: Categories loaded:', this.categoryList);
        } else {
          console.error('Estructura de respuesta inesperada:', response);
          this.categoryList = [];
        }
      } catch (err) {
        this.categoriesError = err.message || 'Error al cargar categorías';
        console.error('Error al cargar categorías:', err);
        this.categoryList = [];
      } finally {
        this.categoriesLoading = false;
      }
    },

    // Crear nueva categoría
    async createCategory(categoryData) {
      this.categoriesLoading = true;
      this.categoriesError = null;
      
      try {
        const response = await CategoryService.createCategory(categoryData);
        const newCategory = response.categoria || response.data || response;
        this.categoryList.push(newCategory);
        return newCategory;
      } catch (err) {
        this.categoriesError = err.message || 'Error al crear categoría';
        throw err;
      } finally {
        this.categoriesLoading = false;
      }
    },

    // Limpiar errores de categorías
    clearCategoriesError() {
      this.categoriesError = null;
    }
  }
})
