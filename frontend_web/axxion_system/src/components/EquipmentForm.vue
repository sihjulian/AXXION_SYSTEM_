<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Información Básica -->
    <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
      <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        <font-awesome-icon icon="fa-solid fa-info-circle" class="mr-2 text-blue-500"/>
        Información Básica
      </h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Nombre del Equipo *
          </label>
          <fwb-input 
            v-model="form.name"
            placeholder="Ej: Laptop Dell Inspiron 15"
            :error="errors.name"
            required
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Marca *
          </label>
          <fwb-input 
            v-model="form.brand"
            placeholder="Ej: Dell, HP, Apple"
            :error="errors.brand"
            required
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Modelo *
          </label>
          <fwb-input 
            v-model="form.model"
            placeholder="Ej: Inspiron 15 3000"
            :error="errors.model"
            required
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Número de Serie *
          </label>
          <fwb-input 
            v-model="form.serialNumber"
            placeholder="Ej: DL001234567"
            :error="errors.serialNumber"
            required
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Categoría *
          </label>
          <fwb-select v-model="form.category" :error="errors.category" required>
            <option value="">Seleccionar categoría</option>
            <option value="laptop">Laptop</option>
            <option value="desktop">Desktop</option>
            <option value="projector">Proyector</option>
            <option value="monitor">Monitor</option>
            <option value="accessory">Accesorio</option>
          </fwb-select>
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Estado *
          </label>
          <fwb-select v-model="form.status" :error="errors.status" required>
            <option value="">Seleccionar estado</option>
            <option value="available">Disponible</option>
            <option value="rented">Alquilado</option>
            <option value="maintenance">Mantenimiento</option>
            <option value="out_of_service">Fuera de Servicio</option>
          </fwb-select>
        </div>
      </div>
    </div>

    <!-- Especificaciones Técnicas -->
    <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
      <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        <font-awesome-icon icon="fa-solid fa-cogs" class="mr-2 text-green-500"/>
        Especificaciones Técnicas
      </h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Procesador
          </label>
          <fwb-input 
            v-model="form.specifications.processor"
            placeholder="Ej: Intel Core i5-1135G7"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Memoria RAM
          </label>
          <fwb-input 
            v-model="form.specifications.ram"
            placeholder="Ej: 8GB DDR4"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Almacenamiento
          </label>
          <fwb-input 
            v-model="form.specifications.storage"
            placeholder="Ej: 256GB SSD"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Tarjeta Gráfica
          </label>
          <fwb-input 
            v-model="form.specifications.graphics"
            placeholder="Ej: Intel Iris Xe"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Pantalla
          </label>
          <fwb-input 
            v-model="form.specifications.screen"
            placeholder="Ej: 15.6\"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Sistema Operativo
          </label>
          <fwb-input 
            v-model="form.specifications.os"
            placeholder="Ej: Windows 11 Home"
          />
        </div>
      </div>
    </div>

    <!-- Información Financiera -->
    <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
      <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        <font-awesome-icon icon="fa-solid fa-dollar-sign" class="mr-2 text-purple-500"/>
        Información Financiera
      </h3>
      
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Tarifa Diaria *
          </label>
          <fwb-input 
            v-model.number="form.dailyRate"
            type="number"
            step="0.01"
            min="0"
            placeholder="25.00"
            :error="errors.dailyRate"
            required
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Tarifa Semanal
          </label>
          <fwb-input 
            v-model.number="form.weeklyRate"
            type="number"
            step="0.01"
            min="0"
            placeholder="150.00"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Tarifa Mensual
          </label>
          <fwb-input 
            v-model.number="form.monthlyRate"
            type="number"
            step="0.01"
            min="0"
            placeholder="500.00"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Precio de Compra
          </label>
          <fwb-input 
            v-model.number="form.purchasePrice"
            type="number"
            step="0.01"
            min="0"
            placeholder="899.99"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Valor Actual
          </label>
          <fwb-input 
            v-model.number="form.currentValue"
            type="number"
            step="0.01"
            min="0"
            placeholder="650.00"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Fecha de Compra
          </label>
          <fwb-input 
            v-model="form.purchaseDate"
            type="date"
          />
        </div>
      </div>
    </div>

    <!-- Información Adicional -->
    <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
      <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        <font-awesome-icon icon="fa-solid fa-info" class="mr-2 text-orange-500"/>
        Información Adicional
      </h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Condición
          </label>
          <fwb-select v-model="form.condition">
            <option value="">Seleccionar condición</option>
            <option value="excellent">Excelente</option>
            <option value="good">Buena</option>
            <option value="fair">Regular</option>
            <option value="poor">Mala</option>
          </fwb-select>
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Ubicación
          </label>
          <fwb-input 
            v-model="form.location"
            placeholder="Ej: Almacén Principal"
          />
        </div>
        
        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Notas
          </label>
          <fwb-textarea 
            v-model="form.notes"
            placeholder="Información adicional sobre el equipo..."
            rows="3"
          />
        </div>
      </div>
    </div>

    <!-- Botones de Acción -->
    <div class="flex justify-end gap-4 pt-6 border-t border-gray-200 dark:border-gray-600">
      <fwb-button 
        gradient="gray" 
        @click="$emit('cancel')"
        type="button"
      >
        Cancelar
      </fwb-button>
      
      <fwb-button 
        gradient="blue" 
        type="submit"
        :disabled="isSubmitting"
      >
        <font-awesome-icon 
          v-if="isSubmitting" 
          icon="fa-solid fa-spinner" 
          class="animate-spin mr-2"
        />
        {{ mode === 'add' ? 'Agregar Equipo' : 'Actualizar Equipo' }}
      </fwb-button>
    </div>
  </form>
</template>

<script setup>
import { ref, reactive, watch, onMounted } from 'vue';
import { useInventoryStore } from '@/stores/inventory.js';
import { 
  FwbInput, 
  FwbSelect, 
  FwbTextarea, 
  FwbButton 
} from 'flowbite-vue';

// Props
const props = defineProps({
  mode: {
    type: String,
    default: 'add',
    validator: (value) => ['add', 'edit'].includes(value)
  },
  selectedEquipment: {
    type: Object,
    default: null
  }
});

// Emits
const emit = defineEmits(['success', 'cancel']);

// Store
const inventoryStore = useInventoryStore();

// Estado
const isSubmitting = ref(false);
const errors = ref({});

// Formulario
const form = reactive({
  name: '',
  brand: '',
  model: '',
  serialNumber: '',
  category: '',
  status: 'available',
  dailyRate: 0,
  weeklyRate: 0,
  monthlyRate: 0,
  purchasePrice: 0,
  currentValue: 0,
  purchaseDate: '',
  condition: 'excellent',
  location: '',
  notes: '',
  specifications: {
    processor: '',
    ram: '',
    storage: '',
    graphics: '',
    screen: '',
    os: ''
  }
});

// Métodos
const validateForm = () => {
  errors.value = {};
  
  if (!form.name.trim()) {
    errors.value.name = 'El nombre es requerido';
  }
  
  if (!form.brand.trim()) {
    errors.value.brand = 'La marca es requerida';
  }
  
  if (!form.model.trim()) {
    errors.value.model = 'El modelo es requerido';
  }
  
  if (!form.serialNumber.trim()) {
    errors.value.serialNumber = 'El número de serie es requerido';
  }
  
  if (!form.category) {
    errors.value.category = 'La categoría es requerida';
  }
  
  if (!form.status) {
    errors.value.status = 'El estado es requerido';
  }
  
  if (!form.dailyRate || form.dailyRate <= 0) {
    errors.value.dailyRate = 'La tarifa diaria debe ser mayor a 0';
  }
  
  return Object.keys(errors.value).length === 0;
};

const handleSubmit = async () => {
  if (!validateForm()) {
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    if (props.mode === 'add') {
      await inventoryStore.addEquipment(form);
    } else {
      await inventoryStore.updateEquipment(props.selectedEquipment.id, form);
    }
    
    emit('success');
  } catch (error) {
    console.error('Error al guardar equipo:', error);
    // Aquí podrías mostrar un mensaje de error al usuario
  } finally {
    isSubmitting.value = false;
  }
};

const loadEquipmentData = () => {
  if (props.selectedEquipment) {
    Object.assign(form, {
      ...props.selectedEquipment,
      specifications: {
        ...form.specifications,
        ...props.selectedEquipment.specifications
      }
    });
  }
};

const resetForm = () => {
  Object.assign(form, {
    name: '',
    brand: '',
    model: '',
    serialNumber: '',
    category: '',
    status: 'available',
    dailyRate: 0,
    weeklyRate: 0,
    monthlyRate: 0,
    purchasePrice: 0,
    currentValue: 0,
    purchaseDate: '',
    condition: 'excellent',
    location: '',
    notes: '',
    specifications: {
      processor: '',
      ram: '',
      storage: '',
      graphics: '',
      screen: '',
      os: ''
    }
  });
  errors.value = {};
};

// Watchers
watch(() => props.selectedEquipment, () => {
  if (props.mode === 'edit' && props.selectedEquipment) {
    loadEquipmentData();
  } else {
    resetForm();
  }
}, { immediate: true });

// Lifecycle
onMounted(() => {
  if (props.mode === 'edit' && props.selectedEquipment) {
    loadEquipmentData();
  }
});
</script>

<style scoped>
/* Estilos adicionales si son necesarios */
</style>
