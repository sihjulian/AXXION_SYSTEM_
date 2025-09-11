<template>
  <fwb-card class="equipment-card hover:shadow-lg transition-shadow duration-300">
    <!-- Imagen del equipo -->
    <div class="relative">
      <img 
        :src="equipmentImage" 
        :alt="equipment.name"
        class="w-full h-48 object-cover rounded-t-lg"
        @error="handleImageError"
      />
      
      <!-- Badge de estado -->
      <div class="absolute top-3 right-3">
        <StatusBadge :status="equipment.status" />
      </div>
      
      <!-- Badge de categoría -->
      <div class="absolute top-3 left-3">
        <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
          {{ getCategoryLabel(equipment.category) }}
        </span>
      </div>
    </div>

    <!-- Contenido de la tarjeta -->
    <div class="p-6">
      <!-- Información principal -->
      <div class="mb-4">
        <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-1">
          {{ equipment.name }}
        </h3>
        <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">
          {{ equipment.brand }} {{ equipment.model }}
        </p>
        <p class="text-xs text-gray-500 dark:text-gray-500">
          Serie: {{ equipment.serialNumber }}
        </p>
      </div>

      <!-- Especificaciones principales -->
      <div class="mb-4 space-y-2">
        <div v-if="equipment.specifications?.processor" class="flex items-center text-sm text-gray-600 dark:text-gray-400">
          <font-awesome-icon icon="fa-solid fa-microchip" class="w-4 h-4 mr-2 text-blue-500"/>
          {{ equipment.specifications.processor }}
        </div>
        <div v-if="equipment.specifications?.ram" class="flex items-center text-sm text-gray-600 dark:text-gray-400">
          <font-awesome-icon icon="fa-solid fa-memory" class="w-4 h-4 mr-2 text-green-500"/>
          {{ equipment.specifications.ram }}
        </div>
        <div v-if="equipment.specifications?.storage" class="flex items-center text-sm text-gray-600 dark:text-gray-400">
          <font-awesome-icon icon="fa-solid fa-hard-drive" class="w-4 h-4 mr-2 text-purple-500"/>
          {{ equipment.specifications.storage }}
        </div>
      </div>

      <!-- Información de alquiler -->
      <div class="mb-4 p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
        <div class="flex justify-between items-center mb-2">
          <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Tarifa Diaria</span>
          <span class="text-lg font-bold text-green-600">${{ equipment.dailyRate }}</span>
        </div>
        <div class="flex justify-between items-center text-sm text-gray-600 dark:text-gray-400">
          <span>Alquileres:</span>
          <span>{{ equipment.rentalCount || 0 }}</span>
        </div>
        <div class="flex justify-between items-center text-sm text-gray-600 dark:text-gray-400">
          <span>Ingresos:</span>
          <span>${{ (equipment.totalRevenue || 0).toLocaleString() }}</span>
        </div>
      </div>

      <!-- Información de alquiler actual -->
      <div v-if="equipment.status === 'rented' && equipment.currentRental" class="mb-4 p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
        <div class="flex items-center mb-2">
          <font-awesome-icon icon="fa-solid fa-user" class="w-4 h-4 mr-2 text-blue-500"/>
          <span class="text-sm font-medium text-blue-700 dark:text-blue-300">Cliente Actual</span>
        </div>
        <p class="text-sm text-blue-600 dark:text-blue-400">{{ equipment.currentRental.clientName }}</p>
        <p class="text-xs text-blue-500 dark:text-blue-500">
          Hasta: {{ formatDate(equipment.currentRental.endDate) }}
        </p>
      </div>

      <!-- Información de mantenimiento -->
      <div v-if="equipment.status === 'maintenance' && equipment.maintenanceSchedule" class="mb-4 p-3 bg-yellow-50 dark:bg-yellow-900/20 rounded-lg">
        <div class="flex items-center mb-2">
          <font-awesome-icon icon="fa-solid fa-tools" class="w-4 h-4 mr-2 text-yellow-500"/>
          <span class="text-sm font-medium text-yellow-700 dark:text-yellow-300">En Mantenimiento</span>
        </div>
        <p class="text-sm text-yellow-600 dark:text-yellow-400">{{ equipment.maintenanceSchedule.description }}</p>
        <p class="text-xs text-yellow-500 dark:text-yellow-500">
          Técnico: {{ equipment.maintenanceSchedule.technician }}
        </p>
      </div>

      <!-- Botones de acción -->
      <div class="flex flex-wrap gap-2">
        <fwb-button 
          size="sm" 
          gradient="blue" 
          @click="$emit('view-details', equipment)"
          class="flex-1"
        >
          <font-awesome-icon icon="fa-solid fa-eye" class="mr-1"/>
          Ver
        </fwb-button>
        
        <fwb-button 
          v-if="equipment.status === 'available'"
          size="sm" 
          gradient="green" 
          @click="$emit('rent-equipment', equipment)"
          class="flex-1"
        >
          <font-awesome-icon icon="fa-solid fa-handshake" class="mr-1"/>
          Alquilar
        </fwb-button>
        
        <fwb-button 
          size="sm" 
          gradient="purple" 
          @click="$emit('edit-equipment', equipment)"
          class="flex-1"
        >
          <font-awesome-icon icon="fa-solid fa-edit" class="mr-1"/>
          Editar
        </fwb-button>
        
        <fwb-button 
          size="sm" 
          gradient="red" 
          @click="$emit('delete-equipment', equipment)"
          class="flex-1"
        >
          <font-awesome-icon icon="fa-solid fa-trash" class="mr-1"/>
          Eliminar
        </fwb-button>
      </div>
    </div>
  </fwb-card>
</template>

<script setup>
import { computed } from 'vue';
import { FwbCard, FwbButton } from 'flowbite-vue';
import StatusBadge from './StatusBadge.vue';

// Props
const props = defineProps({
  equipment: {
    type: Object,
    required: true
  }
});

// Emits
const emit = defineEmits([
  'view-details',
  'edit-equipment', 
  'delete-equipment',
  'rent-equipment'
]);

// Computed
const equipmentImage = computed(() => {
  if (props.equipment.images && props.equipment.images.length > 0) {
    return props.equipment.images[0];
  }
  
  // Imagen por defecto según la categoría
  const defaultImages = {
    laptop: '/images/defaults/laptop.jpg',
    desktop: '/images/defaults/desktop.jpg',
    projector: '/images/defaults/projector.jpg',
    monitor: '/images/defaults/monitor.jpg',
    accessory: '/images/defaults/accessory.jpg'
  };
  
  return defaultImages[props.equipment.category] || '/images/defaults/equipment.jpg';
});

// Métodos
const getCategoryLabel = (category) => {
  const labels = {
    laptop: 'Laptop',
    desktop: 'Desktop',
    projector: 'Proyector',
    monitor: 'Monitor',
    accessory: 'Accesorio'
  };
  return labels[category] || category;
};

const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
};

const handleImageError = (event) => {
  // Si la imagen falla, usar imagen por defecto
  event.target.src = '/images/defaults/equipment.jpg';
};
</script>

<style scoped>
.equipment-card {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.equipment-card .p-6 {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.equipment-card .flex.flex-wrap.gap-2 {
  margin-top: auto;
}
</style>

