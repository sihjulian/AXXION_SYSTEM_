<template>
  <div class="app flex">
    <SideBar />
    <RouterView />

    <main class="container h-screen">
      <div class="rounded-lg flex-col">
        <headerP />

        <!-- Main Content -->
        <div class="p-4 sm:p-6 lg:p-8 bg-gray-50 dark:bg-gray-800 rounded-lg h-full">
          <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">
              <font-awesome-icon icon="fa-solid fa-tools" class="mr-3 text-yellow-500" />
              Gestión de Mantenimiento
            </h1>
            <p class="text-gray-600 dark:text-gray-400">
              Planifica, rastrea y gestiona todas las tareas de mantenimiento de equipos.
            </p>
          </div>

          <!-- Action Controls -->
          <div class="flex flex-wrap gap-4 mb-6">
            <fwb-button gradient="green-blue" size="lg" @click="showAddModal">
              <font-awesome-icon icon="fa-solid fa-plus" class="mr-2" />
              Programar Tarea
            </fwb-button>
          </div>

          <!-- Filters and Search -->
          <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Buscar Tarea
                </label>
                <fwb-input v-model="searchQuery" placeholder="Buscar por equipo, tarea..." />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Estado
                </label>
                <fwb-select v-model="statusFilter">
                  <option value="">Todos</option>
                  <option value="Programado">Programado</option>
                  <option value="En Progreso">En Progreso</option>
                  <option value="Completado">Completado</option>
                  <option value="Cancelado">Cancelado</option>
                </fwb-select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Técnico Asignado
                </label>
                <fwb-select v-model="technicianFilter">
                  <option value="">Todos</option>
                  <option value="Juan Perez">Juan Perez</option>
                  <option value="Maria Rodriguez">Maria Rodriguez</option>
                  <option value="Carlos Sanchez">Carlos Sanchez</option>
                </fwb-select>
              </div>
              <div class="flex items-end">
                <fwb-button gradient="red-yellow" size="lg" @click="clearFilters" class="w-full">
                  <font-awesome-icon icon="fa-solid fa-times" class="mr-2" />
                  Limpiar
                </fwb-button>
              </div>
            </div>
          </div>

          <!-- Maintenance Table -->
          <div class="overflow-x-auto bg-white dark:bg-gray-800 rounded-lg shadow">
            <fwb-table>
              <fwb-table-head>
                <fwb-table-head-cell>Equipo</fwb-table-head-cell>
                <fwb-table-head-cell>Tarea</fwb-table-head-cell>
                <fwb-table-head-cell>Fecha Programada</fwb-table-head-cell>
                <fwb-table-head-cell>Técnico</fwb-table-head-cell>
                <fwb-table-head-cell>Estado</fwb-table-head-cell>
                <fwb-table-head-cell>
                  <span class="sr-only">Acciones</span>
                </fwb-table-head-cell>
              </fwb-table-head>
              <fwb-table-body>
                <fwb-table-row v-for="task in filteredTasks" :key="task.id">
                  <fwb-table-cell>{{ task.equipment }}</fwb-table-cell>
                  <fwb-table-cell>{{ task.task }}</fwb-table-cell>
                  <fwb-table-cell>{{ task.scheduledDate }}</fwb-table-cell>
                  <fwb-table-cell>{{ task.technician }}</fwb-table-cell>
                  <fwb-table-cell>
                    <span :class="getStatusClass(task.status)">
                      {{ task.status }}
                    </span>
                  </fwb-table-cell>
                  <fwb-table-cell class="flex gap-2">
                    <fwb-button size="xs" gradient="blue" @click="editTask(task)">
                      Editar
                    </fwb-button>
                    <fwb-button size="xs" gradient="red" @click="showDeleteModal(task)">
                      Eliminar
                    </fwb-button>
                  </fwb-table-cell>
                </fwb-table-row>
              </fwb-table-body>
            </fwb-table>
          </div>
        </div>
      </div>
    </main>

    <!-- Add/Edit Modal -->
    <fwb-modal v-if="isShowModal" @close="closeModal" size="2xl">
      <template #header>
        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
          {{ isEditMode ? 'Editar Tarea' : 'Programar Nueva Tarea' }}
        </h3>
      </template>
      <template #body>
        <form @submit.prevent="saveTask" class="space-y-4">
          <div>
            <fwb-input
              v-model="taskForm.equipment"
              label="Equipo"
              placeholder="Ej: Laptop HP ProBook 450"
              required
            />
          </div>
          <div>
            <fwb-textarea
              v-model="taskForm.task"
              label="Descripción de la Tarea"
              placeholder="Ej: Limpieza interna y cambio de pasta térmica"
              required
            />
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
                <fwb-input
                    v-model="taskForm.scheduledDate"
                    label="Fecha Programada"
                    type="date"
                    required
                />
            </div>
            <div>
                <fwb-select
                    v-model="taskForm.technician"
                    label="Técnico Asignado"
                    :options="technicianOptions"
                    required
                />
            </div>
          </div>
          <div>
            <fwb-select
                v-model="taskForm.status"
                label="Estado"
                :options="statusOptions"
                required
            />
          </div>
        </form>
      </template>
      <template #footer>
        <div class="flex justify-end gap-2">
          <fwb-button @click="closeModal" color="alternative">
            Cancelar
          </fwb-button>
          <fwb-button @click="saveTask" color="green">
            {{ isEditMode ? 'Guardar Cambios' : 'Guardar' }}
          </fwb-button>
        </div>
      </template>
    </fwb-modal>

    <!-- Delete Confirmation Modal -->
    <fwb-modal v-if="isShowDeleteModal" @close="closeDeleteModal">
      <template #body>
        <div class="text-center p-4">
            <font-awesome-icon icon="fa-solid fa-triangle-exclamation" class="text-5xl text-red-500 mb-4"/>
            <h3 class="mb-5 text-lg font-normal text-gray-500 dark:text-gray-400">
                ¿Está seguro de que desea eliminar esta tarea?
            </h3>
            <div class="flex justify-center gap-4">
                <fwb-button @click="deleteTask" color="red">Sí, estoy seguro</fwb-button>
                <fwb-button @click="closeDeleteModal" color="alternative">No, cancelar</fwb-button>
            </div>
        </div>
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
import { ref, computed } from 'vue';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import {
  FwbButton,
  FwbTable,
  FwbTableBody,
  FwbTableCell,
  FwbTableHead,
  FwbTableHeadCell,
  FwbTableRow,
  FwbModal,
  FwbInput,
  FwbSelect,
  FwbTextarea,
  FwbFooter,
  FwbFooterCopyright,
} from 'flowbite-vue';
import {
  FwbAlert,
  FwbFooterLink,
  FwbFooterLinkGroup,
} from 'flowbite-vue';


// Sample Data
const maintenanceTasks = ref([
  { id: 1, equipment: 'Laptop HP ProBook 450', task: 'Limpieza interna', scheduledDate: '2025-10-15', technician: 'Juan Perez', status: 'Programado' },
  { id: 2, equipment: 'Proyector Epson PowerLite', task: 'Cambio de lámpara', scheduledDate: '2025-10-12', technician: 'Maria Rodriguez', status: 'En Progreso' },
  { id: 3, equipment: 'PC de Escritorio Dell', task: 'Actualización de RAM', scheduledDate: '2025-09-30', technician: 'Juan Perez', status: 'Completado' },
  { id: 4, equipment: 'Monitor Samsung 24"', task: 'Revisión de puerto HDMI', scheduledDate: '2025-10-20', technician: 'Carlos Sanchez', status: 'Programado' },
  { id: 5, equipment: 'Laptop Lenovo ThinkPad T14', task: 'Formateo y reinstalación SO', scheduledDate: '2025-09-28', technician: 'Maria Rodriguez', status: 'Completado' },
]);

// Form and Modal State
const isShowModal = ref(false);
const isShowDeleteModal = ref(false);
const isEditMode = ref(false);
const selectedTask = ref(null);
const taskForm = ref({});

const defaultFormState = {
    equipment: '',
    task: '',
    scheduledDate: '',
    technician: 'Juan Perez',
    status: 'Programado',
};

// Options for Selects
const technicianOptions = [
    { value: 'Juan Perez', name: 'Juan Perez' },
    { value: 'Maria Rodriguez', name: 'Maria Rodriguez' },
    { value: 'Carlos Sanchez', name: 'Carlos Sanchez' },
];
const statusOptions = [
    { value: 'Programado', name: 'Programado' },
    { value: 'En Progreso', name: 'En Progreso' },
    { value: 'Completado', name: 'Completado' },
    { value: 'Cancelado', name: 'Cancelado' },
];


// Filter State
const searchQuery = ref('');
const statusFilter = ref('');
const technicianFilter = ref('');

const filteredTasks = computed(() => {
  return maintenanceTasks.value.filter(task => {
    const search = searchQuery.value.toLowerCase();
    const matchesSearch = !search || task.equipment.toLowerCase().includes(search) || task.task.toLowerCase().includes(search);
    const matchesStatus = !statusFilter.value || task.status === statusFilter.value;
    const matchesTechnician = !technicianFilter.value || task.technician === technicianFilter.value;
    return matchesSearch && matchesStatus && matchesTechnician;
  });
});

function clearFilters() {
  searchQuery.value = '';
  statusFilter.value = '';
  technicianFilter.value = '';
}

// Modal Functions
function showAddModal() {
  isEditMode.value = false;
  taskForm.value = { ...defaultFormState };
  selectedTask.value = null;
  isShowModal.value = true;
}

function editTask(task) {
  isEditMode.value = true;
  taskForm.value = { ...task };
  selectedTask.value = task;
  isShowModal.value = true;
}

function closeModal() {
  isShowModal.value = false;
}

function saveTask() {
    if (isEditMode.value) {
        // Update existing task
        const index = maintenanceTasks.value.findIndex(t => t.id === selectedTask.value.id);
        if (index !== -1) {
            maintenanceTasks.value[index] = { ...selectedTask.value, ...taskForm.value };
        }
    } else {
        // Add new task
        const newId = maintenanceTasks.value.length > 0 ? Math.max(...maintenanceTasks.value.map(t => t.id)) + 1 : 1;
        maintenanceTasks.value.push({ id: newId, ...taskForm.value });
    }
    closeModal();
}

function showDeleteModal(task) {
    selectedTask.value = task;
    isShowDeleteModal.value = true;
}

function closeDeleteModal() {
    isShowDeleteModal.value = false;
    selectedTask.value = null;
}

function deleteTask() {
    if(selectedTask.value) {
        maintenanceTasks.value = maintenanceTasks.value.filter(t => t.id !== selectedTask.value.id);
    }
    closeDeleteModal();
}


// Helper for styling status
function getStatusClass(status) {
  switch (status) {
    case 'Programado':
      return 'bg-blue-100 text-blue-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-blue-900 dark:text-blue-300';
    case 'En Progreso':
      return 'bg-yellow-100 text-yellow-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-yellow-900 dark:text-yellow-300';
    case 'Completado':
      return 'bg-green-100 text-green-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-green-900 dark:text-green-300';
    case 'Cancelado':
        return 'bg-red-100 text-red-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-red-900 dark:text-red-300';
    default:
      return 'bg-gray-100 text-gray-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-gray-300';
  }
}
</script>

<style scoped>
/* Add any specific styles for this view here */
</style>
