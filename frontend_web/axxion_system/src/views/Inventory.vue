<template>
  <div class="app flex">
    <SideBar/>
    <RouterView></RouterView>

    <main class="container">
      <div class="rounded-lg flex-col">
        <headerP></headerP>
        
        <!-- Panel de Control Principal -->
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-6">
            <font-awesome-icon icon="fa-solid fa-laptop" class="mr-3 text-blue-600"/>
            Gestión de Inventario
          </h1>
          
          <!-- Métricas KPIs -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <fwb-card class="bg-gradient-to-r from-blue-500 to-blue-600 text-white">
              <div class="p-6">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-blue-100 text-sm font-medium">Equipos Disponibles</p>
                    <p class="text-3xl font-bold">{{ metrics.available }}</p>
                  </div>
                  <font-awesome-icon icon="fa-solid fa-check-circle" class="text-4xl text-blue-200"/>
                </div>
              </div>
            </fwb-card>

            <fwb-card class="bg-gradient-to-r from-green-500 to-green-600 text-white">
              <div class="p-6">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-green-100 text-sm font-medium">Equipos Alquilados</p>
                    <p class="text-3xl font-bold">{{ metrics.rented }}</p>
                  </div>
                  <font-awesome-icon icon="fa-solid fa-handshake" class="text-4xl text-green-200"/>
                </div>
              </div>
            </fwb-card>

            <fwb-card class="bg-gradient-to-r from-yellow-500 to-yellow-600 text-white">
              <div class="p-6">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-yellow-100 text-sm font-medium">En Mantenimiento</p>
                    <p class="text-3xl font-bold">{{ metrics.maintenance }}</p>
                  </div>
                  <font-awesome-icon icon="fa-solid fa-tools" class="text-4xl text-yellow-200"/>
                </div>
              </div>
            </fwb-card>

            <fwb-card class="bg-gradient-to-r from-purple-500 to-purple-600 text-white">
              <div class="p-6">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-purple-100 text-sm font-medium">Ingresos del Mes</p>
                    <p class="text-3xl font-bold">${{ metrics.monthlyRevenue.toLocaleString() }}</p>
                  </div>
                  <font-awesome-icon icon="fa-solid fa-dollar-sign" class="text-4xl text-purple-200"/>
                </div>
              </div>
            </fwb-card>
          </div>

          <!-- Alertas y Notificaciones -->
          <div v-if="alerts.length > 0" class="mb-6">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              <font-awesome-icon icon="fa-solid fa-bell" class="mr-2 text-orange-500"/>
              Alertas del Sistema
            </h3>
            <div class="space-y-3">
              <fwb-alert 
                v-for="alert in alerts" 
                :key="alert.id"
                :type="alert.type"
                :icon="alert.icon"
                closable
                @close="removeAlert(alert.id)"
              >
                <span class="font-medium">{{ alert.title }}</span>
                <p class="mt-1">{{ alert.message }}</p>
              </fwb-alert>
            </div>
          </div>
        </div>

        <!-- Controles de Acción -->
        <div class="flex flex-wrap gap-4 mb-6">
          <fwb-button 
            gradient="green-blue" 
            size="lg" 
            @click="showAddModal"
          >
            <font-awesome-icon icon="fa-solid fa-plus" class="mr-2"/>
            Agregar Equipo
          </fwb-button>
          
          <fwb-button 
            gradient="purple-blue" 
            size="lg" 
            @click="showMaintenanceModal"
          >
            <font-awesome-icon icon="fa-solid fa-tools" class="mr-2"/>
            Programar Mantenimiento
          </fwb-button>
          
          <fwb-button 
            gradient="cyan-blue" 
            size="lg" 
            @click="exportReport"
          >
            <font-awesome-icon icon="fa-solid fa-file-export" class="mr-2"/>
            Exportar Reporte
          </fwb-button>
        </div>

        <!-- Filtros y Búsqueda -->
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 mb-6">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Buscar Equipo
              </label>
              <fwb-input 
                v-model="searchQuery"
                placeholder="Buscar por nombre, modelo o serie..."
                icon="fa-solid fa-search"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Estado
              </label>
              <fwb-select v-model="statusFilter">
                <option value="">Todos los estados</option>
                <option value="available">Disponible</option>
                <option value="rented">Alquilado</option>
                <option value="maintenance">Mantenimiento</option>
                <option value="out_of_service">Fuera de Servicio</option>
              </fwb-select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Categoría
              </label>
              <fwb-select v-model="categoryFilter">
                <option value="">Todas las categorías</option>
                <option value="laptop">Laptop</option>
                <option value="desktop">Desktop</option>
                <option value="projector">Proyector</option>
                <option value="monitor">Monitor</option>
                <option value="accessory">Accesorio</option>
              </fwb-select>
            </div>
            
            <div class="flex items-end">
              <fwb-button 
                gradient="red-yellow" 
                size="lg" 
                @click="clearFilters"
                class="w-full"
              >
                <font-awesome-icon icon="fa-solid fa-times" class="mr-2"/>
                Limpiar Filtros
              </fwb-button>
            </div>
          </div>
        </div>

        <!-- Loader -->
        <div v-if="isLoading" class="overlay" aria-hidden="true">
          <span class="loader" aria-hidden="true"></span>
        </div>
        
        <!-- Grid de Equipos -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <EquipmentCard 
            v-for="equipment in paginatedEquipment" 
            :key="equipment.id" 
            :equipment="equipment" 
            @view-details="viewEquipmentDetails"
            @edit-equipment="editEquipment"
            @delete-equipment="showDeleteModal"
            @rent-equipment="rentEquipment"
          />
        </div>

        <!-- Paginación -->
        <div v-if="totalPages > 1" class="mt-8 flex justify-center">
          <fwb-pagination 
            v-model="currentPage"
            :total-pages="totalPages"
            :show-icons="true"
            @page-change="handlePageChange"
          />
        </div>
      </div>  
    </main>

    <!-- Modal para Agregar/Editar Equipo -->
    <fwb-modal v-if="isShowModal" @close="closeModal" size="4xl">
      <template #header>
        <div class="flex items-center text-lg font-semibold text-gray-900 dark:text-white">
          <font-awesome-icon 
            :icon="modalMode === 'add' ? 'fa-solid fa-plus' : modalMode === 'edit' ? 'fa-solid fa-edit' : 'fa-solid fa-trash'" 
            :class="modalMode === 'add' ? 'mr-2 text-green-600' : modalMode === 'edit' ? 'mr-2 text-blue-600' : 'mr-2 text-red-600'"
          />
          {{ modalMode === 'add' ? 'Agregar Nuevo Equipo' : modalMode === 'edit' ? 'Editar Equipo' : 'Eliminar Equipo' }}
        </div>
      </template>
      <template #body>
        <EquipmentForm 
          v-if="modalMode !== 'delete'"
          :mode="modalMode"
          :selectedEquipment="selectedEquipment"
          @success="handleEquipmentSuccess"
          @cancel="closeModal"
        />
        <div v-else class="text-center">
          <font-awesome-icon icon="fa-solid fa-exclamation-triangle" class="text-6xl text-red-500 mb-4"/>
          <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">
            ¿Está seguro de eliminar este equipo?
          </h3>
          <p class="text-gray-600 dark:text-gray-400 mb-6">
            Esta acción no se puede deshacer. Se eliminará permanentemente:
            <strong>{{ selectedEquipment?.name }} - {{ selectedEquipment?.model }}</strong>
          </p>
          <div class="flex justify-center gap-4">
            <fwb-button gradient="red-yellow" @click="confirmDelete">
              <font-awesome-icon icon="fa-solid fa-trash" class="mr-2"/>
              Eliminar
            </fwb-button>
            <fwb-button gradient="gray" @click="closeModal">
              Cancelar
            </fwb-button>
          </div>
        </div>
      </template>
    </fwb-modal>

    <!-- Modal de Detalles del Equipo -->
    <fwb-modal v-if="isShowDetailsModal" @close="closeDetailsModal" size="6xl">
      <template #header>
        <div class="flex items-center text-lg font-semibold text-gray-900 dark:text-white">
          <font-awesome-icon icon="fa-solid fa-info-circle" class="mr-2 text-blue-600"/>
          Detalles del Equipo
        </div>
      </template>
      <template #body>
        <EquipmentDetails 
          :equipment="selectedEquipment"
          @close="closeDetailsModal"
          @edit="editEquipment"
        />
      </template>
    </fwb-modal>
  </div>

  <fwb-footer>
    <fwb-footer-copyright
      by="Flowbite™"
      href="https://flowbite.com/"
      copyright-message="All Rights Reserved."
    />
    <fwb-footer-link-group>
      <fwb-footer-link href="#">
        About
      </fwb-footer-link>
      <fwb-footer-link href="#">
        Privacy Policy
      </fwb-footer-link>
      <fwb-footer-link href="#">
        Licensing
      </fwb-footer-link>
      <fwb-footer-link href="#">
        Contact
      </fwb-footer-link>
    </fwb-footer-link-group>
  </fwb-footer>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useInventoryStore } from '@/stores/inventory.js';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import EquipmentCard from '@/components/EquipmentCard.vue';
import EquipmentForm from '@/components/EquipmentForm.vue';
import EquipmentDetails from '@/components/EquipmentDetails.vue';
import { 
  FwbAlert,
  FwbButton,
  FwbModal,
  FwbCard,
  FwbInput,
  FwbSelect,
  FwbPagination,
  FwbFooter,
  FwbFooterCopyright,
  FwbFooterLink,
  FwbFooterLinkGroup
} from 'flowbite-vue';

// Store
const inventoryStore = useInventoryStore();

// Estado local
const displayedEquipment = ref([]);
const isShowModal = ref(false);
const isShowDetailsModal = ref(false);
const modalMode = ref('add'); // 'add', 'edit', 'delete'
const selectedEquipment = ref(null);
const searchQuery = ref('');
const statusFilter = ref('');
const categoryFilter = ref('');
const currentPage = ref(1);
const itemsPerPage = 12;

// Computed del store
const equipment = computed(() => inventoryStore.equipment);
const isLoading = computed(() => inventoryStore.isLoading);

// Métricas del panel de control
const metrics = computed(() => ({
  available: equipment.value.filter(e => e.status === 'available').length,
  rented: equipment.value.filter(e => e.status === 'rented').length,
  maintenance: equipment.value.filter(e => e.status === 'maintenance').length,
  monthlyRevenue: equipment.value
    .filter(e => e.status === 'rented')
    .reduce((sum, e) => sum + (e.dailyRate * 30), 0)
}));

// Alertas del sistema
const alerts = ref([
  {
    id: 1,
    type: 'warning',
    icon: 'fa-solid fa-exclamation-triangle',
    title: 'Mantenimiento Programado',
    message: '3 equipos requieren mantenimiento preventivo esta semana'
  },
  {
    id: 2,
    type: 'info',
    icon: 'fa-solid fa-info-circle',
    title: 'Devolución Pendiente',
    message: '2 equipos tienen devoluciones programadas para hoy'
  }
]);

// Filtros y búsqueda
const filteredEquipment = computed(() => {
  let filtered = equipment.value;

  // Filtro de búsqueda
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(e => 
      e.name.toLowerCase().includes(query) ||
      e.model.toLowerCase().includes(query) ||
      e.serialNumber.toLowerCase().includes(query)
    );
  }

  // Filtro de estado
  if (statusFilter.value) {
    filtered = filtered.filter(e => e.status === statusFilter.value);
  }

  // Filtro de categoría
  if (categoryFilter.value) {
    filtered = filtered.filter(e => e.category === categoryFilter.value);
  }

  return filtered;
});

// Paginación
const totalPages = computed(() => 
  Math.ceil(filteredEquipment.value.length / itemsPerPage)
);

const paginatedEquipment = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  return filteredEquipment.value.slice(start, end);
});

// Funciones de modal
function closeModal() {
  isShowModal.value = false;
  modalMode.value = 'add';
  selectedEquipment.value = null;
}

function closeDetailsModal() {
  isShowDetailsModal.value = false;
  selectedEquipment.value = null;
}

function showAddModal() {
  modalMode.value = 'add';
  selectedEquipment.value = null;
  isShowModal.value = true;
}

function showDeleteModal(equipment) {
  modalMode.value = 'delete';
  selectedEquipment.value = equipment;
  isShowModal.value = true;
}

function editEquipment(equipment) {
  modalMode.value = 'edit';
  selectedEquipment.value = equipment;
  isShowModal.value = true;
}

function viewEquipmentDetails(equipment) {
  selectedEquipment.value = equipment;
  isShowDetailsModal.value = true;
}

function showMaintenanceModal() {
  // Implementar modal de mantenimiento
  console.log('Mostrar modal de mantenimiento');
}

// Funciones de acción
function confirmDelete() {
  if (selectedEquipment.value) {
    inventoryStore.deleteEquipment(selectedEquipment.value.id);
    closeModal();
    loadEquipment();
  }
}

function rentEquipment(equipment) {
  // Implementar lógica de alquiler
  console.log('Alquilar equipo:', equipment);
}

function exportReport() {
  // Implementar exportación de reportes
  console.log('Exportar reporte');
}

function clearFilters() {
  searchQuery.value = '';
  statusFilter.value = '';
  categoryFilter.value = '';
  currentPage.value = 1;
}

function removeAlert(alertId) {
  alerts.value = alerts.value.filter(alert => alert.id !== alertId);
}

function handlePageChange(page) {
  currentPage.value = page;
}

function handleEquipmentSuccess() {
  closeModal();
  loadEquipment();
}

// Cargar datos
const loadEquipment = async () => {
  try {
    await inventoryStore.fetchEquipment();
    
    // Animación de carga progresiva
    displayedEquipment.value = [];
    const delayPerCard = 200;

    for (let i = 0; i < equipment.value.length; i++) {
      await new Promise(resolve => setTimeout(resolve, delayPerCard));
      displayedEquipment.value.push(equipment.value[i]);
    }
  } catch (error) {
    console.error('Error al cargar equipos:', error);
  }
};

// Watchers
watch([searchQuery, statusFilter, categoryFilter], () => {
  currentPage.value = 1;
});

// Cargar datos al montar el componente
onMounted(() => {
  loadEquipment();
});
</script>

<style scoped>
.loader {
  width: 60px;
  height: 40px;
  position: relative;
  display: inline-block;
  --base-color: #263238;
}
.loader::before {
  content: '';  
  left: 0;
  top: 0;
  position: absolute;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: #FFF;
  background-image: radial-gradient(circle 8px at 18px 18px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 18px 0px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 0px 18px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 36px 18px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 18px 36px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 30px 5px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 30px 5px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 30px 30px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 5px 30px, var(--base-color) 100%, transparent 0), radial-gradient(circle 4px at 5px 5px, var(--base-color) 100%, transparent 0);
  background-repeat: no-repeat;
  box-sizing: border-box;
  animation: rotationBack 3s linear infinite;
}
.loader::after {
  content: '';  
  left: 35px;
  top: 15px;
  position: absolute;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background-color: #FFF;
  background-image: radial-gradient(circle 5px at 12px 12px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 12px 0px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 0px 12px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 24px 12px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 12px 24px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 20px 3px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 20px 3px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 20px 20px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 3px 20px, var(--base-color) 100%, transparent 0), radial-gradient(circle 2.5px at 3px 3px, var(--base-color) 100%, transparent 0);
  background-repeat: no-repeat;
  box-sizing: border-box;
  animation: rotationBack 4s linear infinite reverse;
}
@keyframes rotationBack {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(-360deg);
  }
}  
.overlay {
  position: relative;
  top: 100px; 
  right: 0; 
  bottom: 0; 
  left: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255,255,255,0.7);
  z-index: 10;
}
</style>