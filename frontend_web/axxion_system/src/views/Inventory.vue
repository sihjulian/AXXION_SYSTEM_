<template>
  <div class="app flex">
    <SideBar/>
    <RouterView></RouterView>

    <main class="container h-screen p-4 flex-1 overflow-y-auto">
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
            gradient="purple" 
            size="lg" 
            @click="exportReport"
          >
            <font-awesome-icon icon="fa-solid fa-file-export" class="mr-2"/>
            Exportar Reporte
          </fwb-button>
          
          <!-- Botón temporal para debug -->
          <fwb-button 
            gradient="gray" 
            size="lg" 
            @click="forceRefresh"
          >
            <font-awesome-icon icon="fa-solid fa-refresh" class="mr-2"/>
            Actualizar Vista
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
              <select 
                v-model="statusFilter"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
              >
                <option value="">Todos los estados</option>
                <option 
                  v-for="state in inventoryStore.uniqueStates" 
                  :key="state.value" 
                  :value="state.value"
                >
                  {{ state.label }}
                </option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Categoría
              </label>
              <select 
                v-model="categoryFilter"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
              >
                <option value="">Todas las categorías</option>
                <option 
                  v-for="category in inventoryStore.categoryList" 
                  :key="category.id" 
                  :value="category.nombre"
                >
                  {{ category.nombre }}
                </option>
              </select>
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
        
        <!-- Grid de Productos -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <EquipmentCard 
            v-for="product in paginatedProducts" 
            :key="product.id" 
            :equipment="product" 
            @view-details="viewProductDetails"
            @edit-equipment="editProduct"
            @delete-equipment="showDeleteModal"
            @rent-equipment="rentProduct"
            @maintenance-equipment="showMaintenanceModalForEquipment"
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
          :selectedEquipment="selectedProduct"
          @success="handleProductSuccess"
          @cancel="closeModal"
        />
        <div v-else class="text-center">
          <font-awesome-icon icon="fa-solid fa-exclamation-triangle" class="text-6xl text-red-500 mb-4"/>
          <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">
            ¿Está seguro de eliminar este equipo?
          </h3>
          <p class="text-gray-600 dark:text-gray-400 mb-6">
            Esta acción no se puede deshacer. Se eliminará permanentemente:
            <strong>{{ selectedProduct?.nombre }} - {{ selectedProduct?.modelo }}</strong>
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
<!-- ... -->
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
    
    <!-- Modal para Programar Mantenimiento -->
    <fwb-modal v-if="isShowMaintenanceModal" @close="closeMaintenanceModal" size="2xl">
      <template #header>
        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
          <font-awesome-icon icon="fa-solid fa-tools" class="mr-2 text-yellow-500" />
          Programar Mantenimiento
        </h3>
      </template>
      <template #body>
        <form @submit.prevent="scheduleMaintenance" class="space-y-4">
          <div v-if="selectedEquipmentForMaintenance" class="bg-blue-50 dark:bg-blue-900/20 p-4 rounded-lg mb-4">
            <h4 class="font-semibold text-blue-700 dark:text-blue-300 mb-2">Equipo Seleccionado</h4>
            <p class="text-sm text-blue-600 dark:text-blue-400">
              {{ selectedEquipmentForMaintenance.nombre }} - {{ selectedEquipmentForMaintenance.marca }} {{ selectedEquipmentForMaintenance.modelo }}
            </p>
            <p class="text-xs text-blue-500 dark:text-blue-500">
              Serie: {{ selectedEquipmentForMaintenance.numero_serie }}
            </p>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Tipo de Mantenimiento *
            </label>
            <select v-model="maintenanceForm.tipo" required
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white">
              <option v-for="type in maintenanceTypes" :key="type.value" :value="type.value">
                {{ type.name }}
              </option>
            </select>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Descripción del Mantenimiento *
            </label>
            <textarea v-model="maintenanceForm.descripcion" required rows="3"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white"
              placeholder="Descripción detallada del mantenimiento a realizar..."></textarea>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Fecha de Inicio *
              </label>
              <input type="date" v-model="maintenanceForm.fecha_inicio" required
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Fecha de Fin Estimada
              </label>
              <input type="date" v-model="maintenanceForm.fecha_fin"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white" />
            </div>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Técnico Asignado *
              </label>
              <select v-model="maintenanceForm.tecnico_asignado" required
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white">
                <option value="">Seleccionar técnico</option>
                <option v-for="technician in technicianOptions" :key="technician.value" :value="technician.value">
                  {{ technician.name }}
                </option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Prioridad *
              </label>
              <select v-model="maintenanceForm.prioridad" required
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white">
                <option v-for="priority in maintenancePriorities" :key="priority.value" :value="priority.value">
                  {{ priority.name }}
                </option>
              </select>
            </div>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Costo Estimado
              </label>
              <input type="number" v-model.number="maintenanceForm.costo_estimado" step="0.01" min="0"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Estado Inicial
              </label>
              <select v-model="maintenanceForm.estado"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white">
                <option value="PROGRAMADO">Programado</option>
                <option value="EN_PROCESO">En Proceso</option>
              </select>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Observaciones
            </label>
            <textarea v-model="maintenanceForm.observaciones" rows="2"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white"
              placeholder="Observaciones adicionales..."></textarea>
          </div>
        </form>
      </template>
      <template #footer>
        <div class="flex justify-end gap-2">
          <fwb-button @click="closeMaintenanceModal" color="alternative">
            Cancelar
          </fwb-button>
          <fwb-button @click="scheduleMaintenance" gradient="yellow">
            <font-awesome-icon icon="fa-solid fa-tools" class="mr-2" />
            Programar Mantenimiento
          </fwb-button>
        </div>
      </template>
    </fwb-modal>
  </div>
<!--footer-->
  <footer>
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
</footer>
</template>

<script setup>
import { ref, computed, watch, onMounted, nextTick } from 'vue';
import { useInventoryStore } from '@/stores/inventory.js';
import { useMaintenanceStore } from '@/stores/maintenance.js';
import { useUserStore } from '@/stores/user.js';
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
  FwbPagination,
  FwbFooter,
  FwbFooterCopyright,
  FwbFooterLink,
  FwbFooterLinkGroup
} from 'flowbite-vue';

// Stores
const inventoryStore = useInventoryStore();
const maintenanceStore = useMaintenanceStore();
const userStore = useUserStore();

// Estado local
const displayedProducts = ref([]);
const isShowModal = ref(false);
const isShowDetailsModal = ref(false);
const isShowMaintenanceModal = ref(false);
const modalMode = ref('add'); // 'add', 'edit', 'delete'
const selectedProduct = ref(null);
const selectedEquipmentForMaintenance = ref(null);
const searchQuery = ref('');
const statusFilter = ref('');
const categoryFilter = ref('');
const currentPage = ref(1);
const itemsPerPage = 12;

// Formulario de mantenimiento
const maintenanceForm = ref({
  inventario_item_id: '',
  descripcion: '',
  tipo: 'PREVENTIVO',
  fecha_inicio: '',
  fecha_fin: '',
  tecnico_asignado: '',
  estado: 'PROGRAMADO',
  prioridad: 'MEDIA',
  costo_estimado: 0,
  observaciones: ''
});

// Opciones para el formulario de mantenimiento
const maintenanceTypes = computed(() => maintenanceStore.getAvailableTypes());
const maintenancePriorities = computed(() => maintenanceStore.getAvailablePriorities());

const technicianOptions = computed(() => {
  const users = userStore.users || [];
  return users
    .filter(user => user.rol && (user.rol.nombre === 'Técnico' || user.rol.nombre === 'Administrador'))
    .map(user => ({ 
      value: user.id, 
      name: `${user.nombre} ${user.apellido}` 
    }));
});

// Computed del store
const products = computed(() => inventoryStore.productList);
const isLoading = computed(() => inventoryStore.loading);

// Métricas del panel de control
const metrics = computed(() => {
  const available = inventoryStore.productList.filter(p => p.estado === 'disponible').length;
  const rented = inventoryStore.productList.filter(p => p.estado === 'alquilado').length;
  const maintenance = inventoryStore.productList.filter(p => p.estado === 'mantenimiento').length;
  
  return {
    available,
    rented,
    maintenance,
    monthlyRevenue: 15420 // Placeholder - calcular desde datos reales
  };
});

// Alertas del sistema
const alerts = ref([
  {
    id: 1,
    type: 'warning',
    icon: true,
    title: 'Mantenimiento Programado',
    message: '3 equipos requieren mantenimiento preventivo esta semana'
  },
  {
    id: 2,
    type: 'info',
    icon: true,
    title: 'Devolución Pendiente',
    message: '2 equipos tienen devoluciones programadas para hoy'
  }
]);

// Filtros y búsqueda
const filteredProducts = computed(() => {
  let filtered = inventoryStore.productList;

  // Filtro de búsqueda
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(p =>
      (p.nombre && p.nombre.toLowerCase().includes(query)) ||
      (p.modelo && p.modelo.toLowerCase().includes(query)) ||
      (p.numero_serie && p.numero_serie.toLowerCase().includes(query)) ||
      (p.marca && p.marca.toLowerCase().includes(query))
    );
  }

  // Filtro de estado
  if (statusFilter.value) {
    filtered = filtered.filter(p => p.estado === statusFilter.value);
  }

  // Filtro de categoría
  if (categoryFilter.value) {
    filtered = filtered.filter(p => p.categoria && p.categoria.toLowerCase() === categoryFilter.value.toLowerCase());
  }

  return filtered;
});

// Paginación
const totalPages = computed(() => 
  Math.ceil(filteredProducts.value.length / itemsPerPage)
);

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  return filteredProducts.value.slice(start, end);
});

// Funciones de modal
function closeModal() {
  isShowModal.value = false;
  modalMode.value = 'add';
  selectedProduct.value = null;
}

function closeDetailsModal() {
  isShowDetailsModal.value = false;
  selectedProduct.value = null;
}

function showAddModal() {
  modalMode.value = 'add';
  selectedProduct.value = null;
  isShowModal.value = true;
}

function showDeleteModal(product) {
  modalMode.value = 'delete';
  selectedProduct.value = product;
  isShowModal.value = true;
}

function editProduct(product) {
  modalMode.value = 'edit';
  selectedProduct.value = product;
  isShowModal.value = true;
}

function viewProductDetails(product) {
  selectedProduct.value = product;
  isShowDetailsModal.value = true;
}

function showMaintenanceModal() {
  selectedEquipmentForMaintenance.value = null;
  resetMaintenanceForm();
  isShowMaintenanceModal.value = true;
}

function showMaintenanceModalForEquipment(equipment) {
  selectedEquipmentForMaintenance.value = equipment;
  resetMaintenanceForm();
  maintenanceForm.value.inventario_item_id = equipment.id;
  isShowMaintenanceModal.value = true;
}

function closeMaintenanceModal() {
  isShowMaintenanceModal.value = false;
  selectedEquipmentForMaintenance.value = null;
  resetMaintenanceForm();
}

function resetMaintenanceForm() {
  maintenanceForm.value = {
    inventario_item_id: '',
    descripcion: '',
    tipo: 'PREVENTIVO',
    fecha_inicio: '',
    fecha_fin: '',
    tecnico_asignado: '',
    estado: 'PROGRAMADO',
    prioridad: 'MEDIA',
    costo_estimado: 0,
    observaciones: ''
  };
}

async function scheduleMaintenance() {
  try {
    // Validar que haya un equipo seleccionado o en el formulario
    if (!maintenanceForm.value.inventario_item_id && selectedEquipmentForMaintenance.value) {
      maintenanceForm.value.inventario_item_id = selectedEquipmentForMaintenance.value.id;
    }

    console.log('Programando mantenimiento:', maintenanceForm.value);
    
    // Crear el mantenimiento usando el store
    await maintenanceStore.createMaintenance(maintenanceForm.value);
    
    // Actualizar el estado del producto a 'mantenimiento'
    if (selectedEquipmentForMaintenance.value) {
      await inventoryStore.updateProduct(selectedEquipmentForMaintenance.value.id, {
        ...selectedEquipmentForMaintenance.value,
        estado: 'mantenimiento'
      });
    }
    
    // Cerrar modal
    closeMaintenanceModal();
    
    // Mostrar mensaje de éxito
    alerts.value.unshift({
      id: Date.now(),
      type: 'success',
      icon: true,
      title: 'Mantenimiento Programado',
      message: `Se ha programado el mantenimiento para el equipo ${selectedEquipmentForMaintenance.value?.nombre || 'seleccionado'}`
    });
    
    // Actualizar la vista
    await forceRefresh();
    
  } catch (error) {
    console.error('Error al programar mantenimiento:', error);
    alerts.value.unshift({
      id: Date.now(),
      type: 'error',
      icon: true,
      title: 'Error al Programar Mantenimiento',
      message: error.response?.data?.message || error.message || 'Error desconocido'
    });
  }
}

// Funciones de acción
async function confirmDelete() {
  if (selectedProduct.value) {
    console.log('Iniciando eliminación del producto:', selectedProduct.value.nombre);
    try {
      const productId = selectedProduct.value.id;
      const productName = selectedProduct.value.nombre;
      
      console.log('Llamando a deleteProduct con ID:', productId);
      await inventoryStore.deleteProduct(productId);
      
      console.log('Producto eliminado del store, cerrando modal...');
      closeModal();
      
      // Mostrar mensaje de éxito
      console.log(`Producto "${productName}" eliminado exitosamente`);
      
      // Forzar actualización completa de la vista
      await forceRefresh();
      
      // Opcional: mostrar notificación de éxito
      alerts.value.unshift({
        id: Date.now(),
        type: 'success',
        icon: true,
        title: 'Producto Eliminado',
        message: `El producto "${productName}" ha sido eliminado exitosamente.`
      });
      
    } catch (error) {
      console.error('Error al eliminar producto:', error);
      
      // Mostrar error al usuario
      alerts.value.unshift({
        id: Date.now(),
        type: 'error',
        icon: true,
        title: 'Error al Eliminar',
        message: 'No se pudo eliminar el producto. ' + (error.message || 'Error desconocido')
      });
    }
  } else {
    console.error('No hay producto seleccionado para eliminar');
  }
}

function rentProduct(product) {
  // Implementar lógica de alquiler
  console.log('Alquilar producto:', product);
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

// Función para forzar actualización completa
async function forceRefresh() {
  console.log('Forzando actualización completa de la vista...');
  try {
    await inventoryStore.fetchProducts();
    await nextTick();
    console.log('Actualización completa exitosa');
  } catch (error) {
    console.error('Error en actualización completa:', error);
  }
}

async function handleProductSuccess() {
  console.log('Producto guardado exitosamente, actualizando vista...');
  closeModal();
  
  // Usar función de actualización completa
  await forceRefresh();
}

// Cargar datos
const loadProducts = async () => {
  try {
    await inventoryStore.fetchProducts();
    
    // Animación de carga progresiva
    displayedProducts.value = [];
    const delayPerCard = 200;

    for (let i = 0; i < products.value.length; i++) {
      await new Promise(resolve => setTimeout(resolve, delayPerCard));
      displayedProducts.value.push(products.value[i]);
    }
  } catch (error) {
    console.error('Error al cargar productos:', error);
  }
};

// Watchers
watch([searchQuery, statusFilter, categoryFilter], () => {
  currentPage.value = 1; // Reset pagination when filters change
});

watch(() => inventoryStore.productList, (newProducts) => {
  console.log('Vista: Productos del store actualizados:', newProducts.length);
  // Forzar re-renderizado
  nextTick(() => {
    console.log('Vista: Re-renderizado completado');
  });
}, { deep: true, immediate: true });

// Al montar el componente
onMounted(async () => {
  console.log('Vista de inventario montada');
  // Cargar productos y categorías
  await Promise.all([
    loadProducts(),
    inventoryStore.fetchCategories(),
    userStore.fetchUsers() // Cargar usuarios para el selector de técnicos
  ]);
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