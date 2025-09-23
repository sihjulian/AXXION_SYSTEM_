<template>
  <div class="App flex">
    <SideBar />
    <main class="container h-screen p-4 flex-1 overflow-y-auto">
      <headerP />

      <div class="mb-4 flex gap-3">
        <fwb-button class="transition delay-150 duration-300 ease-in-out hover:-translate-y-1 hover:scale-110" gradient="cyan-blue" outline @click="openAddCategory">+ Agregar Categoria</fwb-button>
      </div>

      <section class="flex flex-row space-x-4">
        <!-- CATEGORIAS -->
        <article class="basis-2/5 bg-gray-800 text-amber-50 rounded-md p-4">
          <h2 class="font-bold text-2xl mb-4">Categorias</h2>
          <ul>
            <li
              v-for="cat in categorias"
              :key="cat.id"
              @click="selectCategoria(cat)"
              :class="['cursor-pointer p-2 rounded-md mb-2  flex justify-between items-center', selectedCategoria?.id === cat.id ? 'bg-purple-950 text-white' : 'bg-gray-800 hover:bg-[#01995f]'] "
            >
              {{ cat.nombre }}
              <div class="flex gap-2">
                <fwb-button  color="blue" fill="currentColor" outline square @click.stop="openEditCategory(cat)"><font-awesome-icon icon="fa-solid fa-pen-to-square" size="lg" /></fwb-button>
                <fwb-button color="red" fill="currentColor" outline square @click.stop="openDeleteCategory(cat)"><font-awesome-icon icon="fa-solid fa-trash" size="lg" /></fwb-button>
              </div>
            </li>
          </ul>
        </article>

        <!-- SUBCATEGORIAS -->
        <article class="basis-3/5 bg-gray-800 text-amber-50 rounded-md p-4">

          <div v-if="selectedCategoria">
            <h3 class="text-xl font-semibold mb-2">{{ selectedCategoria.nombre }}</h3>
            <p class="mb-2">{{ selectedCategoria.descripcion }}</p>
            <p class="italic text-sm text-gray-400 mb-4">Tipo: {{ selectedCategoria.tipo_categoria }}</p>

            <div class="mb-2">
              <fwb-button @click="showAddSubModal" class="transition delay-150 duration-300 ease-in-out hover:-translate-y-1 hover:scale-110" gradient="cyan-blue" outline>Agregar Subcategoría</fwb-button>
            </div>

            <h4 class="text-lg font-semibold">Lista de subcategorías:</h4>
            <ul>
              <li v-for="sub in selectedCategoria.subcategorias ?? []" :key="sub.id" class="bg-gray-800 p-2 rounded-md mb-2 flex justify-between items-center">
                <div>{{ sub.nombre }} - <span class="text-gray-400">{{ sub.descripcion }}</span></div>
                <div class="flex gap-2">
                  <fwb-button color="blue" fill="currentColor" outline square @click.stop="showEditSubModal(sub)"><font-awesome-icon icon="fa-solid fa-pen-to-square" size="lg" /></fwb-button>
                  <fwb-button color="red" fill="currentColor" outline square @click.stop="confirmDeleteSub(sub)"><font-awesome-icon icon="fa-solid fa-trash" size="lg" /></fwb-button>
                </div>
              </li>
            </ul>
          </div>

          <div v-else>
            <p>Selecciona una categoría para ver sus subcategorías.</p>
          </div>
        </article>
      </section>

      <!-- MODALES -->
      <!-- El modal de categoría asumo que ya lo tienes; si no, quítalo temporalmente -->
      <CategoryModal v-if="showCategoryModal" :mode="categoryModalMode" :category="selectedCategoryForModal" @close="closeCategoryModal" @save="handleSaveCategory" @delete="handleDeleteCategory" />

      <!-- Modal de subcategoría (controlado por padre) -->
      <SubcategoryModal
          v-if="showSubModal"
  :mode="subModalMode"
  :subcategoria="selectedSubForModal"
  :categoria-id="selectedCategoria?.id"
  @close="closeSubModal"
  @save="saveSubcategoria"
  @delete="handleDeleteSub"
      />
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

// ---------- ESTADO ----------
const categorias = ref([])
const selectedCategoria = ref(null)

// modales de categoría
const showCategoryModal = ref(false)
const categoryModalMode = ref('add')
const selectedCategoryForModal = ref(null)

// modales de subcategoría
const showSubModal = ref(false)
const subModalMode = ref('add') // 'add' | 'edit' | 'delete'
const selectedSubForModal = ref(null)

// FORM para subcategoría (asegúrate que existe)
const subForm = ref({ nombre: '', descripcion: '', categoria_id: null })

// ---------- CARGAR CATEGORIAS ----------
async function fetchCategorias() {
  try {
    const data = await CategoryService.getAll()
    categorias.value = Array.isArray(data) ? data : (data?.categoria ?? [])
    // mantener selección si existía
    if (selectedCategoria.value) {
      selectedCategoria.value = categorias.value.find(c => c.id === selectedCategoria.value.id) ?? null
    }
  } catch (err) {
    console.error('fetchCategorias error', err)
    alert('Error al cargar categorías (ver consola)')
  }
}

onMounted(fetchCategorias)

// ---------- SELECCIONAR CATEGORIA ----------
function selectCategoria(cat) {
  selectedCategoria.value = cat
}

// ---------- CATEGORIA CRUD (stubs) ----------
function openAddCategory(){ categoryModalMode.value = 'add'; selectedCategoryForModal.value = null; showCategoryModal.value = true }
function openEditCategory(cat){ categoryModalMode.value = 'edit'; selectedCategoryForModal.value = cat; showCategoryModal.value = true }
function openDeleteCategory(cat){ categoryModalMode.value = 'delete'; selectedCategoryForModal.value = cat; showCategoryModal.value = true }
function closeCategoryModal(){ showCategoryModal.value = false; selectedCategoryForModal.value = null; categoryModalMode.value = 'add' }
async function handleSaveCategory(payload){
  try{
    if(categoryModalMode.value === 'add') await CategoryService.createCategory(payload)
    else if(categoryModalMode.value === 'edit') await CategoryService.updateCategory(selectedCategoryForModal.value.id, payload)
    await fetchCategorias()
  }catch(e){ console.error('handleSaveCategory', e); alert('Error guardando categoría') } finally { closeCategoryModal() }
}
async function handleDeleteCategory(id){
  try{ await CategoryService.deleteCategory(id); await fetchCategorias() } catch(e){ console.error(e); alert('Error eliminando categoría') } finally { closeCategoryModal() }
}

// ---------- SUBCATEGORÍA: abrir/editar/eliminar ----------
function showAddSubModal() {
  console.log('DEBUG showAddSubModal - before:', { selectedCategoria: selectedCategoria.value, subFormDefined: typeof subForm !== 'undefined' })
  if (!selectedCategoria.value) {
    alert('Selecciona primero una categoría')
    return
  }
  subModalMode.value = 'add'
  selectedSubForModal.value = null
  // inicializar subForm
  subForm.value = { nombre: '', descripcion: '', categoria_id: selectedCategoria.value.id }
  showSubModal.value = true
  console.log('DEBUG showAddSubModal - after open:', { showSubModal: showSubModal.value, subForm: subForm.value })
}

function showEditSubModal(sub) {
  console.log('DEBUG showEditSubModal', sub)
  subModalMode.value = 'edit'
  selectedSubForModal.value = sub
  // llenar el form con la subcategoria seleccionada
  subForm.value = { id: sub.id, nombre: sub.nombre ?? '', descripcion: sub.descripcion ?? '', categoria_id: selectedCategoria.value?.id ?? null }
  showSubModal.value = true
}

function showDeleteSubModal(sub) {
  subModalMode.value = 'delete'
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
  // limpiar form
  subForm.value = { nombre: '', descripcion: '', categoria_id: null }
}

// ---------- SAVE SUBCATEGORIA (usado por el modal) ----------
async function saveSubcategoria(payload) {
  console.log('Parent saveSubcategoria received payload:', payload)

  if (!payload) {
    console.error('No se recibió subcategoria en saveSubcategoria (payload undefined)')
    return
  }

  // validar nombre/descripcion
  if (!payload.nombre || payload.nombre.trim() === '') {
    alert('El nombre de la subcategoría es obligatorio')
    return
  }

  try {
    // preparar payload según tu controlador: espera 'categorias' => array
    const send = {
      nombre: payload.nombre,
      descripcion: payload.descripcion,
      categorias: payload.categorias ?? (selectedCategoria.value ? [selectedCategoria.value.id] : [])
    }

    console.log('Parent will send to API:', send)

    if (subModalMode.value === 'add') {
      await SubCategoryService.create(send)
      console.log('Subcategoria creada')
    } else if (subModalMode.value === 'edit') {
      const id = payload.id ?? selectedSubForModal.value?.id
      if (!id) throw new Error('ID faltante para update')
      await SubCategoryService.update(id, send)
      console.log('Subcategoria actualizada')
    }

    await fetchCategorias()
    closeSubModal()
  } catch (err) {
    console.error('handleSaveSub error:', err)
    alert('Error guardando subcategoría (ver consola)')
  }
}



async function handleDeleteSub(id) {
  try {
    await SubCategoryService.delete(id)
    await fetchCategorias()
    closeSubModal()
  } catch (err) {
    console.error('handleDeleteSub', err)
    alert('Error al eliminar subcategoría (ver consola)')
  }
}
</script>








