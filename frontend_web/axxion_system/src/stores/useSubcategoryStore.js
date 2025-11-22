import { defineStore } from "pinia";
import SubCategoryService from "@/services/SubCategoryService";

export const useSubcategoryStore = defineStore("subcategory", {
  state: () => ({
    subcategorias: [],
    loading: false,
  }),

  actions: {
    async fetchSubcategorias(categoriaId) {
      this.loading = true;
      try {
        const res = await SubCategoryService.getSubcategoriasByCategoria(categoriaId);
        this.subcategorias = res.data;
      } catch (error) {
        console.error("Error cargando subcategorías:", error);
      } finally {
        this.loading = false;
      }
    },

    async addSubcategoria(data) {
      try {
        const res = await SubCategoryService.createSubcategoria(data);
        this.subcategorias.push(res.data);
      } catch (error) {
        console.error("Error creando subcategoría:", error);
      }
    },

    async updateSubcategoria(id, data) {
      try {
        const res = await SubCategoryService.updateSubcategoria(id, data);
        const index = this.subcategorias.findIndex((s) => s.id === id);
        if (index !== -1) this.subcategorias[index] = res.data;
      } catch (error) {
        console.error("Error actualizando subcategoría:", error);
      }
    },

    async deleteSubcategoria(id) {
      try {
        await SubCategoryService.deleteSubcategoria(id);
        this.subcategorias = this.subcategorias.filter((s) => s.id !== id);
      } catch (error) {
        console.error("Error eliminando subcategoría:", error);
      }
    },
  },
});


