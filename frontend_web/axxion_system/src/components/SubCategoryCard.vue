<template>
  <div>
        <button 
          class="w-full text-left px-4 py-2 bg-gray-700 text-white rounded hover:bg-gray-600"
          @click="toggleCategoria(categoria.id)"
        >
          {{ categoria.nombre }}
        </button>
  </div>
</template>

<script setup>
import { FwbButton } from 'flowbite-vue'
import SubCategoryService from '@/services/SubCategoryService';
const fetchCategorias = async () => {
  try {
    const response = await CategoryService.getCategory();
    categorias.value = response.categoria;
  } catch (error) {
    console.error("Error al cargar categorías:", error);
  }
};

const categorias = ref([]);
const selectedCategoria = ref(null);

const toggleCategoria = (id) => {
  if (selectedCategoria.value?.id === id) {
    selectedCategoria.value = null;
  } else {
    selectedCategoria.value = categorias.value.find(cat => cat.id === id);
  }
};


onMounted(fetchCategorias);
</script>

<style scoped>

</style>>

