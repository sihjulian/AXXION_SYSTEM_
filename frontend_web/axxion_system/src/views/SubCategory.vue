<template>
  <div class="app flex">
    <SideBar />
    <RouterView />
    <main class="container h-screen p-4 flex-1 overflow-auto">
      <headerP />
      <section>
        <FwbButton class=" transition  duration-300 ease-in-out hover:-translate-y-1 hover:scale-110" @click="showModal" color="dark" gradient="green-blue" outline >
          <font-awesome-icon class="mr-1" icon="fa-solid fa-plus" size="xl" style="color: #ffffff;" /> Agregar Subcategoría
        </FwbButton>
      </section>
      <br><br>
        <fwb-modal  v-if="isShowModal" @close="closeModal" class="text-amber-50">
          <template #header>
            <div class="flex items-center text-lg text-amber-50">
              Agregar Subcategoria
            </div>
          </template>
          <template  #body >
            <fwb-input 
              v-model="nombre"
              placeholder="enter your first name"
              label="Nombre"
              required
            />
            <br>
            <fwb-input class="text-amber-50"
              v-model="descripcion"
              placeholder="enter your first name"
              label="Descripcion"
              required
            />
          </template>
          <template #footer>
            <div class="flex justify-between">
              <fwb-button @click="closeModal" color="alternative">
                Cancelar
              </fwb-button>
              <fwb-button @click="closeModal" color="green">
                Guardar
              </fwb-button>
            </div>
          </template>
        </fwb-modal>
        <div class="flex gap-15">
        <fwb-card
          img-alt="Desk"
          img-src="https://flowbite.com/docs/images/blog/image-4.jpg"
          variant="horizontal"
          class="w-lg transition duration-300 ease-in-out hover:-translate-y-1 hover:scale-100"
        >
        <div class="p-5 h-max">
          <fwb-button gradient="cyan" shadow pill square class="mr-9 mb-5 ml-9 transition  duration-300 ease-in-out hover:-translate-y-1 hover:scale-110"><font-awesome-icon icon="fa-solid fa-pen-to-square" size="xl" style="color: #ffffff;" /></fwb-button>
          <fwb-button gradient="red" shadow pill square class="transition  duration-300 ease-in-out hover:-translate-y-1 hover:scale-110"><font-awesome-icon icon="fa-solid fa-trash" size="xl" style="color: #ffffff;" /></fwb-button>
          <br>
          <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
            Excavadoras
          </h5>
          <p class="font-normal text-gray-700 dark:text-gray-400">
            Maquinas para excavacion
          </p>
        </div>
      </fwb-card>
        <fwb-card
          img-alt="Desk"
          img-src="https://flowbite.com/docs/images/blog/image-4.jpg"
          variant="horizontal"
          class="w-lg transition duration-300 ease-in-out hover:-translate-y-1 hover:scale-100"
        >
        <div class="p-5">
          <fwb-button gradient="cyan" shadow pill square class="mr-9 mb-5 ml-9 transition  duration-300 ease-in-out hover:-translate-y-1 hover:scale-110"><font-awesome-icon icon="fa-solid fa-pen-to-square" size="xl" style="color: #ffffff;" /></fwb-button>
          <fwb-button gradient="red" shadow pill square class="transition  duration-300 ease-in-out hover:-translate-y-1 hover:scale-110"><font-awesome-icon icon="fa-solid fa-trash" size="xl" style="color: #ffffff;" /></fwb-button>
          <br>
          <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
            Noteworthy technology acquisitions 2021
          </h5>
          <p class="font-normal text-gray-700 dark:text-gray-400">
            Here are the biggest enterprise technology acquisitions of 2021 so far, in reverse chronological order.
          </p>
        </div>
      </fwb-card>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import { FwbButton, FwbModal, FwbAlert, FwbInput } from 'flowbite-vue';
import { FwbCard } from 'flowbite-vue'

const name = ref('')

const isShowModal = ref(false)

function closeModal () {
  isShowModal.value = false
}
function showModal () {
  isShowModal.value = true
}

</script>

<style>

</style>