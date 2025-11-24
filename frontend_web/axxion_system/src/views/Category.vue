<template>
  <div>
    <div class="App flex">
      <SideBar />
      <main class="container h-screen p-4 flex-1 overflow-y-auto">
        <headerP />
        <div class="mb-4 flex gap-3">
          <fwb-button class="cursor-pointer transition delay-150 duration-300 ease-in-out hover:-translate-y-1 hover:scale-110" gradient="cyan-blue" outline @click="categoryStore.openAddCategoryModal"><font-awesome-icon icon="fa-solid fa-plus" />Agregar Categoria</fwb-button>
        </div>
        <section class="flex flex-row space-x-4">
          <!-- CATEGORIAS -->
          <article class="basis-2/5 bg-gray-800 text-amber-50 rounded-md p-4">
            <h2 class="font-bold text-2xl mb-4">Categorias</h2>
            <div v-if="categoryStore.loading" class="p-4 place-items-center flex"><span class="loader mr-5"></span>Cargando Categorias</div>
            <div v-else-if="categoryStore.error" class="p-4 text-red-500">{{ categoryStore.error }}</div>
            <ul>
              <li
                v-for="cat in categoryStore.categorias"
                :key="cat.id"
                @click="categoryStore.selectCategoria(cat)"
                :class="['cursor-pointer p-2 rounded-md mb-2 flex justify-between items-center', categoryStore.selectedCategoria?.id === cat.id ? 'bg-purple-950 text-white' : 'bg-[#2A3439] hover:bg-[#01995f]'] "
              >
                {{ cat.nombre }}
                <div class="flex gap-2">
                  <fwb-button color="blue" fill="currentColor" outline square @click.stop="categoryStore.openEditCategoryModal(cat)"><font-awesome-icon icon="fa-solid fa-pen-to-square" size="lg" /></fwb-button>
                  <fwb-button color="red" fill="currentColor" outline square @click.stop="categoryStore.openDeleteCategoryModal(cat)"><font-awesome-icon icon="fa-solid fa-trash" size="lg" /></fwb-button>
                </div>
              </li>
            </ul>
          </article>
          <!-- SUBCATEGORIAS -->
          <article class="basis-3/5 bg-gray-800 text-amber-50 rounded-md p-4">
            <div v-if="categoryStore.selectedCategoria">
              <h3 class="text-xl font-semibold mb-2">{{ categoryStore.selectedCategoria.nombre }}</h3>
              <p class="mb-2">{{ categoryStore.selectedCategoria.descripcion }}</p>
              <p class="italic text-sm text-gray-400 mb-4">Tipo: {{ categoryStore.selectedCategoria.tipo_categoria }}</p>
              <div class="mb-2">
                <fwb-button @click="categoryStore.openAddSubModal" class="cursor-pointer transition delay-150 duration-300 ease-in-out hover:-translate-y-1 hover:scale-110" gradient="cyan-blue" outline>Agregar Subcategoría</fwb-button>
              </div>
              <h4 class="text-lg font-semibold">Lista de subcategorías:</h4>
              <ul>
                <li v-for="sub in categoryStore.subcategoriasDeSeleccionada" :key="sub.id" class="bg-[#2A3439] p-2 rounded-md mb-2 flex justify-between items-center">
                  <div>{{ sub.nombre }} - <span class="text-gray-400">{{ sub.descripcion }}</span></div>
                  <div class="flex gap-2">
                    <fwb-button color="blue" fill="currentColor" outline square @click.stop="categoryStore.openEditSubModal(sub)"><font-awesome-icon icon="fa-solid fa-pen-to-square" size="lg" /></fwb-button>
                    <fwb-button color="red" fill="currentColor" outline square @click.stop="categoryStore.deleteSubcategoria(sub.id)"><font-awesome-icon icon="fa-solid fa-trash" size="lg" /></fwb-button>
                  </div>
                </li>
              </ul>
            </div>
            <div v-else>
              <p>Selecciona una categoría para ver sus subcategorías.</p>
            </div>
          </article>
        </section>
        <CategoryModal 
          v-if="categoryStore.showCategoryModal" 
          :mode="categoryStore.categoryModalMode" 
          :category="categoryStore.selectedCategoryForModal" 
          @close="categoryStore.closeCategoryModal" 
          @save="categoryStore.saveCategory" 
          @delete="categoryStore.deleteCategory" />

        <SubcategoryModal
          v-if="categoryStore.showSubModal"
          :mode="categoryStore.subModalMode"
          :subcategoria="categoryStore.selectedSubForModal"
          :categoria-id="categoryStore.selectedCategoria?.id"
          @close="categoryStore.closeSubModal"
          @save="categoryStore.saveSubcategoria"
          @delete="categoryStore.deleteSubcategoria"
        />
      </main>
    </div>
    <Footer />
  </div>
</template>

<script setup>
import { onMounted } from 'vue';
import { useCategoryStore } from '@/stores/category';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import Footer from '@/components/Footer.vue';
import CategoryModal from '@/components/CategoryModal.vue';
import SubcategoryModal from '@/components/SubcategoryModal.vue';
import { FwbButton } from 'flowbite-vue';

/**
 * Vista Category.
 * 
 * Gestión principal de categorías y subcategorías.
 * Permite:
 * - Listar categorías existentes.
 * - Ver detalles y subcategorías de una categoría seleccionada.
 * - CRUD completo (Crear, Leer, Actualizar, Eliminar) para categorías y subcategorías mediante modales.
 */

const categoryStore = useCategoryStore();

onMounted(() => {
  // Carga inicial de todas las categorías.
  categoryStore.fetchCategorias();
});
</script>

<style scoped>
 
</style>







