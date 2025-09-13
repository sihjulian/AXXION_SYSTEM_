import { defineStore } from 'pinia'
import InventoryService from '@/services/InventoryService'

export const useInventoryStore = defineStore('inventory', {
  state: () => ({
    // Lista de productos
    productList: [],
    
    // Estado de carga
    loading: false,
    
    // Errores
    error: null,
    
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
      let filtered = [...state.productList];
      
      // Aplicar filtros
      if (state.filters.category) {
        filtered = filtered.filter(item => item.categoria === state.filters.category);
      }
      
      if (state.filters.status) {
        filtered = filtered.filter(item => item.estado === state.filters.status);
      }
      
      if (state.filters.brand) {
        filtered = filtered.filter(item => item.marca === state.filters.brand);
      }
      
      if (state.filters.search) {
        const searchTerm = state.filters.search.toLowerCase();
        filtered = filtered.filter(item => 
          item.nombre.toLowerCase().includes(searchTerm) ||
          item.modelo.toLowerCase().includes(searchTerm) ||
          item.numero_serie.toLowerCase().includes(searchTerm) ||
          item.marca.toLowerCase().includes(searchTerm)
        );
      }
      
      return filtered;
    }
  },

  actions: {
    // Obtener todos los productos
    async fetchProducts() {
      this.loading = true;
      this.error = null;
      
      try {
        const response = await InventoryService.getProducts();
        console.log('Store: Products fetched:', response);
        this.productList = response.data || response;
        this.pagination.totalItems = this.productList.length;
        this.pagination.totalPages = Math.ceil(this.pagination.totalItems / this.pagination.itemsPerPage);
      } catch (err) {
        this.error = err.message || 'Error al cargar productos';
        console.error('Error al cargar productos:', err);
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
        const newProduct = response.data || response;
        this.productList.push(newProduct);
        this.pagination.totalItems = this.productList.length;
        return newProduct;
      } catch (err) {
        this.error = err.message || 'Error al crear producto';
        throw err;
      } finally {
        this.loading = false;
      }
    },

    // Actualizar producto
    async updateProduct(id, productData) {
      this.loading = true;
      this.error = null;
      
      try {
        const response = await InventoryService.updateProduct(id, productData);
        const updatedProduct = response.data || response;
        const index = this.productList.findIndex(item => item.id === id);
        if (index !== -1) {
          this.productList[index] = updatedProduct;
        }
        return updatedProduct;
      } catch (err) {
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
        await InventoryService.deleteProduct(id);
        this.productList = this.productList.filter(item => item.id !== id);
        this.pagination.totalItems = this.productList.length;
      } catch (err) {
        this.error = err.message || 'Error al eliminar producto';
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
    }
  }
})
