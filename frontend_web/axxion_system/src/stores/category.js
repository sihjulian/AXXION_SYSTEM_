import { defineStore } from 'pinia';
import CategoryService from '@/services/CategoryService';
import SubCategoryService from '@/services/SubCategoryService';

export const useCategoryStore = defineStore('category', {
  state: () => ({
    categorias: [],
    loading: false,
    error: null,
    selectedCategoria: null,
    showCategoryModal: false,
    categoryModalMode: 'add', 
    selectedCategoryForModal: null,
    showSubModal: false,
    subModalMode: 'add',
    selectedSubForModal: null,
  }),
  getters: {
    subcategoriasDeSeleccionada: (state) => state.selectedCategoria?.subcategorias ?? [],
  },
  actions: {
    async fetchCategorias() {
      this.loading = true;
      this.error = null;
      try {
        const data = await CategoryService.getAll();
        this.categorias = Array.isArray(data) ? data : (data?.categoria ?? []);
        if (this.selectedCategoria) {
          this.selectedCategoria = this.categorias.find(c => c.id === this.selectedCategoria.id) ?? null;
        }
      } catch (err) {
        console.error('Error al cargar categorías:', err);
      } finally {
        this.loading = false;
      }
    },
    selectCategoria(categoria) {
      this.selectedCategoria = categoria;
    },
    openAddCategoryModal() {
      this.categoryModalMode = 'add';
      this.selectedCategoryForModal = null;
      this.showCategoryModal = true;
    },
    openEditCategoryModal(categoria) {
      this.categoryModalMode = 'edit';
      this.selectedCategoryForModal = { ...categoria }; 
      this.showCategoryModal = true;
    },
    openDeleteCategoryModal(categoria) {
      this.categoryModalMode = 'delete';
      this.selectedCategoryForModal = categoria;
      this.showCategoryModal = true;
    },
    closeCategoryModal() {
      this.showCategoryModal = false;
    },
    async saveCategory(payload) {
      try {
        if (this.categoryModalMode === 'add') {
          await CategoryService.createCategory(payload);
        } else if (this.categoryModalMode === 'edit') {
          await CategoryService.updateCategory(this.selectedCategoryForModal.id, payload);
        }
        await this.fetchCategorias(); // Recargar datos frescos
      } catch (e) {
        console.error('Error guardando categoría:', e);
      } finally {
        this.closeCategoryModal();
      }
    },
    async deleteCategory(id) {
        try {
            await CategoryService.deleteCategory(id);
            if (this.selectedCategoria?.id === id) {
                this.selectedCategoria = null;
            }
            await this.fetchCategorias();
        } catch(e) {
            console.error('Error eliminando categoría:', e);
        } finally {
            this.closeCategoryModal();
        }
    },

    // --- Acciones de Modales de Subcategoría ---
    openAddSubModal() {
        if (!this.selectedCategoria) return;
        this.subModalMode = 'add';
        this.selectedSubForModal = null;
        this.showSubModal = true;
    },
    openEditSubModal(subcategoria) {
        this.subModalMode = 'edit';
        this.selectedSubForModal = { ...subcategoria };
        this.showSubModal = true;
    },
    closeSubModal() {
        this.showSubModal = false;
    },
    async saveSubcategoria(payload) {
        try {
            const send = {
                nombre: payload.nombre,
                descripcion: payload.descripcion,
                categorias: payload.categorias ?? [this.selectedCategoria.id]
            };
            if (this.subModalMode === 'add') {
                await SubCategoryService.create(send);
            } else if (this.subModalMode === 'edit') {
                await SubCategoryService.update(payload.id, send);
            }
            await this.fetchCategorias();
        } catch (err) {
            console.error('Error guardando subcategoría:', err);
        } finally {
            this.closeSubModal();
        }
    },
    async deleteSubcategoria(id) {
        if (!confirm('¿Estás seguro de que quieres eliminar esta subcategoría?')) return;
        try {
            await SubCategoryService.delete(id);
            await this.fetchCategorias();
        } catch (err) {
            console.error('Error eliminando subcategoría:', err);
        } finally {
            this.closeSubModal();
        }
    },
  },
});
