<template>
  <div class="App flex">
    <SideBar />
    <main class="container h-screen p-4 flex-1 overflow-y-auto">
      <headerP />

      <div class="mb-4 flex gap-3">
        <fwb-button gradient="cyan-blue" outline @click="openAddCategory">+ Agregar Categoria</fwb-button>
        <fwb-button gradient="cyan-blue" outline @click="showAddSubModal">+ Agregar Subcategoria</fwb-button>
      </div>

      <section class="flex flex-row space-x-4">
        <!-- categorias -->
        <article class="basis-2/5 bg-black text-amber-50 rounded-md p-4">
          <h2 class="font-bold text-2xl mb-4">Categorias</h2>
          <ul>
            <li v-for="cat in categorias" :key="cat.id"
                @click="selectCategoria(cat)"
                :class="['cursor-pointer p-2 rounded-md mb-2', selectedCategoria?.id === cat.id ? 'bg-amber-600 text-black' : 'bg-gray-800 hover:bg-indigo-700']">
              {{ cat.nombre }}
              <div class="float-right">
                <fwb-button gradient="blue" pill square @click.stop="openEditCategory(cat)">✏️</fwb-button>
                <fwb-button gradient="red" pill square @click.stop="openDeleteCategory(cat)">🗑️</fwb-button>
              </div>
            </li>
          </ul>
        </article>

        <!-- subcategorias -->
        <article class="basis-3/5 bg-black text-amber-50 rounded-md p-4">
          <h2 class="font-bold text-2xl mb-4">Subcategorias</h2>

          <div v-if="selectedCategoria">
            <h3 class="text-xl font-semibold mb-2">{{ selectedCategoria.nombre }}</h3>
            <p class="mb-2">{{ selectedCategoria.descripcion }}</p>
            <p class="italic text-sm text-gray-400 mb-4">Tipo: {{ selectedCategoria.tipo_categoria }}</p>

            <div class="mb-2">
              <fwb-button @click="showAddSubModal" gradient="cyan-blue" outline>Agregar Subcategoría</fwb-button>
            </div>

            <h4 class="text-lg font-semibold">Lista de subcategorías:</h4>
            <ul>
              <li v-for="sub in selectedCategoria.subcategorias ?? []" :key="sub.id" class="bg-gray-800 p-2 rounded-md mb-2 flex justify-between items-center">
                <div>{{ sub.nombre }} - <span class="text-gray-400">{{ sub.descripcion }}</span></div>
                <div class="flex gap-2">
                  <fwb-button gradient="blue" pill square @click.stop="showEditSubModal(sub)">✏️</fwb-button>
                  <fwb-button gradient="red" pill square @click.stop="confirmDeleteSub(sub)">🗑️</fwb-button>
                </div>
              </li>
            </ul>
          </div>

          <div v-else>
            <p>Selecciona una categoría para ver sus subcategorías.</p>
          </div>
        </article>
      </section>

      <!-- Modales -->
      <CategoryModal v-if="showCategoryModal" :mode="categoryModalMode" :category="selectedCategoryForModal" @close="closeCategoryModal" @save="handleSaveCategory" @delete="handleDeleteCategory" />
      <SubcategoryModal v-if="showSubModal" :mode="subModalMode" :subcategoria="selectedSubForModal" :categoria-id="selectedCategoria?.id" @close="closeSubModal" @save="handleSaveSub" @delete="handleDeleteSub" />
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import SideBar from '@/components/SideBar.vue'
import headerP from '@/components/headerP.vue'
import CategoryModal from '@/components/CategoryModal.vue'
import SubcategoryModal from '@/components/SubcategoryModal.vue'
import CategoryService from '@/services/CategoryService'
import SubCategoryService from '@/services/SubCategoryService'
import { FwbButton } from 'flowbite-vue'

// estado
const categorias = ref([])
const selectedCategoria = ref(null)

// modales categorias
const showCategoryModal = ref(false)
const categoryModalMode = ref('add')
const selectedCategoryForModal = ref(null)

// modales subcategorias
const showSubModal = ref(false)
const subModalMode = ref('add')
const selectedSubForModal = ref(null)

// --- fetch initial
async function fetchCategorias() {
  try {
    const data = await CategoryService.getAll()
    categorias.value = data ?? []
    // mantener selección si existe
    if (selectedCategoria.value) {
      selectedCategoria.value = categorias.value.find(c => c.id === selectedCategoria.value.id) ?? null
    }
  } catch (err) {
    console.error('fetchCategorias error', err)
    alert('Error al cargar categorías. Revisa la consola.')
  }
}
onMounted(fetchCategorias)

// selección
function selectCategoria(cat) { selectedCategoria.value = cat }

// ---------- CATEGORÍA CRUD (padre maneja requests) ----------
function openAddCategory() {
  categoryModalMode.value = 'add'
  selectedCategoryForModal.value = null
  showCategoryModal.value = true
}
function openEditCategory(cat) {
  categoryModalMode.value = 'edit'
  selectedCategoryForModal.value = cat
  showCategoryModal.value = true
}
function openDeleteCategory(cat) {
  categoryModalMode.value = 'delete'
  selectedCategoryForModal.value = cat
  showCategoryModal.value = true
}
function closeCategoryModal() {
  showCategoryModal.value = false
  selectedCategoryForModal.value = null
  categoryModalMode.value = 'add'
}

async function handleSaveCategory(payload) {
  try {
    if (categoryModalMode.value === 'add') await CategoryService.createCategory(payload)
    else if (categoryModalMode.value === 'edit') await CategoryService.updateCategory(selectedCategoryForModal.value.id, payload)
    await fetchCategorias()
  } catch (err) {
    console.error('handleSaveCategory', err)
    alert('Error guardando categoría (ver consola)')
  } finally {
    closeCategoryModal()
  }
}

async function handleDeleteCategory(id) {
  try {
    await CategoryService.deleteCategory(id)
    await fetchCategorias()
  } catch (err) {
    console.error('handleDeleteCategory', err)
    alert('Error eliminando categoría (ver consola)')
  } finally {
    closeCategoryModal()
  }
}

// ---------- SUBCATEGORÍA CRUD ----------
function showAddSubModal() {
  if (!selectedCategoria.value) { alert('Selecciona primero una categoría'); return }
  subModalMode.value = 'add'
  selectedSubForModal.value = null
  showSubModal.value = true
}
function showEditSubModal(sub) {
  subModalMode.value = 'edit'
  selectedSubForModal.value = sub
  showSubModal.value = true
}
function confirmDeleteSub(sub) {
  if (!confirm(`¿Eliminar subcategoría "${sub.nombre}"?`)) return
  handleDeleteSub(sub.id)
}
function closeSubModal() {
  showSubModal.value = false
  selectedSubForModal.value = null
  subModalMode.value = 'add'
}

async function handleSaveSub(payload) {
  try {
    if (payload.id) {
      await SubCategoryService.update(payload.id, payload)
    } else {
      // ensure categoria_id present
      payload.categoria_id = payload.categoria_id ?? selectedCategoria.value?.id
      await SubCategoryService.create(payload)
    }
    await fetchCategorias()
  } catch (err) {
    console.error('handleSaveSub', err)
    alert('Error guardando subcategoría (ver consola)')
  } finally {
    closeSubModal()
  }
}

async function handleDeleteSub(id) {
  try {
    await SubCategoryService.delete(id)
    await fetchCategorias()
  } catch (err) {
    console.error('handleDeleteSub', err)
    alert('Error eliminando subcategoría (ver consola)')
  } finally {
    closeSubModal()
  }
}
</script>







