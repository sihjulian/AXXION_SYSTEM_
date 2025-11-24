<template>
  <div class=" app flex">
    
  <SideBar/>

    <RouterView></RouterView>

  <main class="container h-screen">

  <div class="rounded-lg flex-col">
    <headerP></headerP>
      <div class="p-4 sm:p-6 lg:p-8 bg-gray-50 dark:bg-gray-800 rounded-lg h-full">
        <div class="mb-4">
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestión de Usuarios</h1>
          <p class="text-gray-500 dark:text-gray-400">Administra los usuarios del sistema</p>
        </div>

        <div class="flex  mb-4">
         <FwbAlert
            v-if="userStore.error"
            :color="'red'"
            :dismissible="true"
            class="w-full"
          >
            {{ userStore.error }}
          </FwbAlert>
        </div>
        
        </div>  

     <div class=" flex-col h-30 m-auto  w-1/2  justify-start md:justify-between " >
          <!-- Botón Agregar -->
     
          <fwb-button  gradient="green-blue" outline size="lg" hover:bg-sky-700  @click="showAddModal"><font-awesome-icon icon="fa-solid fa-user-plus" style="color: #63E6BE;"/>
    Agregar Usuario
  </fwb-button>
          <!-- Botón Eliminar -->
          <fwb-button gradient="red-yellow" outline size="lg" @click="showDeleteModal(null)"><font-awesome-icon icon="fa-solid fa-user-minus" style="color: #d60000;"/>
    Eliminar Usuario
  </fwb-button>





        </div>

        <div v-if="isLoading" class="overlay" aria-hidden="true">
          <span class="loader" aria-hidden="true"></span>
        </div>
        
        <div class="flex-col">
           <div class="flex justify-start  gap-4">
                <UserCard 
                  v-for="user in displayedUsers" 
                  :key="user.id" 
                  :user="user" 
                  @delete-user="showDeleteModal"
                  @update-user="showUpdateModal"
                />
            </div>
        </div>

        <!-- Loader overlay centered while cards are loading -->
        
      </div>  
    </main>




<fwb-modal v-if="isShowModal" @close="closeModal" size="4xl">
    <template #header>
      <div class="flex items-center text-lg font-semibold text-gray-900 dark:text-white">
        <font-awesome-icon 
          :icon="modalMode === 'add' ? 'fa-solid fa-user-plus' : (modalMode === 'update' ? 'fa-solid fa-user-pen' : 'fa-solid fa-user-minus')" 
          :class="modalMode === 'add' ? 'mr-2 text-green-600' : (modalMode === 'update' ? 'mr-2 text-blue-600' : 'mr-2 text-red-600')"
        />
        {{ modalMode === 'add' ? 'Agregar Nuevo Usuario' : (modalMode === 'update' ? 'Actualizar Usuario' : 'Eliminar Usuario') }}
      </div>
    </template>
    <template #body>
      <UserForm 
        :mode="modalMode"
        :selectedUser="selectedUser"
        @success="handleUserSuccess"
        @cancel="closeModal"
      />
    </template>
  </fwb-modal>
  </div>

  <Footer />
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';
import { useUserStore } from '@/stores/user.js';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import Footer from '@/components/Footer.vue';
import Modal from '@/components/modal.vue';
import UserCard from '@/components/UserCard.vue';
import UserForm from '@/components/UserForm.vue';
import { FwbAlert, FwbButton, FwbModal } from 'flowbite-vue';
// Store
const userStore = useUserStore();

// Estado local
const displayedUsers = ref([]);
const isShowModal = ref(false);
const modalMode = ref('add'); // 'add', 'delete' or 'update'
const selectedUser = ref(null);

// Computed del store
const users = computed(() => userStore.users);
const isLoading = computed(() => userStore.isLoading);

function closeModal () {
  isShowModal.value = false;
  modalMode.value = 'add';
  selectedUser.value = null;
}

function showAddModal () {
  modalMode.value = 'add';
  selectedUser.value = null;
  isShowModal.value = true;
}

function showDeleteModal (user) {
  modalMode.value = 'delete';
  selectedUser.value = user;
  isShowModal.value = true;
}

function showUpdateModal (user) {
  modalMode.value = 'update';
  selectedUser.value = user;
  isShowModal.value = true;
}

const getuserdata = async () => {
  try {
    await userStore.fetchUsers();
    console.log(users.value);
    
    // Clear displayedUsers and then reveal each user with a small delay
    displayedUsers.value = [];
    const delayPerCard = 500; // ms per card reveal

    for (let i = 0; i < users.value.length; i++) {
      // wait before pushing the next user so UI updates between pushes
      await new Promise(resolve => setTimeout(resolve, delayPerCard));
      displayedUsers.value.push(users.value[i]);
    }
  } catch (e) {
    console.error('Error al cargar usuarios:', e);
    userStore.error = e.message || 'Error al cargar usuarios';
    userStore.isLoading = false;
  }
}

const handleUserSuccess = () => {
  closeModal();
  getuserdata(); // Recargar la lista de usuarios
};

// Cargar datos al montar el componente
onMounted(() => {
  getuserdata();
});

</script>

<style scoped>
/* overlay to center the loader */
.overlay {
  position: relative;
   top:100px; right:0; bottom:0; left:0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255,255,255,0.7);
  z-index: 10;
}
</style>
