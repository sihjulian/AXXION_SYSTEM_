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
          <select 
            v-model="form.category" 
            :class="[
              'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5',
              'dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500',
              errors.category ? 'border-red-500' : ''
            ]"
            required
          >
            <option value="">Seleccionar categoría</option>
            <option v-if="loadingCategories" disabled>Cargando categorías...</option>
            <option v-if="!loadingCategories && categories.length === 0" disabled>No hay categorías disponibles</option>
            <option 
              v-for="category in categories" 
              :key="category.id" 
              :value="category.nombre"
            >
              {{ category.nombre }}
            </option>
          </select>
          <!-- Debug info -->
          <div v-if="categories.length > 0" class="text-xs text-green-600 mt-1">
            {{ categories.length }} categorías cargadas
          </div>
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Estado *
          </label>
          <select 
            v-model="form.status" 
            :class="[
              'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5',
              'dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500',
              errors.status ? 'border-red-500' : ''
            ]"
            required
          >
            <option value="">Seleccionar estado</option>
            <option 
              v-for="state in availableStates" 
              :key="state.value" 
              :value="state.value"
            >
              {{ state.label }}
            </option>
          </select>
          <!-- Debug info -->
          <div v-if="availableStates.length > 0" class="text-xs text-blue-600 mt-1">
            {{ availableStates.length }} estados disponibles
          </div>
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
          <select 
            v-model="form.condition"
            class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
          >
            <option value="">Seleccionar condición</option>
            <option value="excelente">Excelente</option>
            <option value="buena">Buena</option>
            <option value="regular">Regular</option>
            <option value="mala">Mala</option>
          </select>
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
import CategoryService from '@/services/CategoryService.js';
import { 
  FwbInput, 
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
const categories = ref([]);
const loadingCategories = ref(false);

// Estados disponibles
const availableStates = ref([
  { value: 'disponible', label: 'Disponible' },
  { value: 'alquilado', label: 'Alquilado' },
  { value: 'mantenimiento', label: 'Mantenimiento' },
  { value: 'fuera_de_servicio', label: 'Fuera de Servicio' }
]);

// Inicializar categorías con datos de prueba para asegurar que funcione
const testCategories = [
  { id: 1, nombre: 'Sonido' },
  { id: 2, nombre: 'Video' },
  { id: 3, nombre: 'Iluminación' },
  { id: 4, nombre: 'Mobiliario' },
  { id: 5, nombre: 'Estructuras' }
];

// Formulario
const form = reactive({
  name: '',
  brand: '',
  model: '',
  serialNumber: '',
  category: '',
  status: 'disponible',
  dailyRate: 0,
  weeklyRate: 0,
  monthlyRate: 0,
  purchasePrice: 0,
  currentValue: 0,
  purchaseDate: '',
  condition: 'excelente',
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
  console.log('handleSubmit iniciado, modo:', props.mode);
  console.log('Datos del formulario:', form);
  
  if (!validateForm()) {
    console.log('Validación falló, errores:', errors.value);
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    // Mapear campos del formulario a los campos del backend
    const productData = {
      nombre: form.name,
      descripcion: form.notes || '',
      marca: form.brand,
      modelo: form.model,
      numero_serie: form.serialNumber,
      categoria: form.category,
      estado: form.status,
      especificaciones: form.specifications,
      precio_alquiler_dia: form.dailyRate,
      precio_alquiler_semanal: form.weeklyRate,
      precio_alquiler_mensual: form.monthlyRate,
      precio_compra: form.purchasePrice,
      valor_actual: form.currentValue,
      fecha_compra: form.purchaseDate,
      condicion: form.condition,
      ubicacion: form.location,
      notas: form.notes
    };

    console.log('Datos mapeados para enviar:', productData);

    if (props.mode === 'add') {
      console.log('Creando nuevo producto...');
      await inventoryStore.createProduct(productData);
    } else {
      console.log('Actualizando producto ID:', props.selectedEquipment.id);
      await inventoryStore.updateProduct(props.selectedEquipment.id, productData);
    }
    
    console.log('Operación exitosa, emitiendo success...');
    emit('success');
  } catch (error) {
    console.error('Error al guardar producto:', error);
    alert('Error al guardar el producto: ' + (error.message || 'Error desconocido'));
  } finally {
    isSubmitting.value = false;
  }
};

const loadEquipmentData = () => {
  console.log('loadEquipmentData llamado con:', props.selectedEquipment);
  console.log('Modo actual:', props.mode);
  
  if (props.selectedEquipment) {
    const equipment = props.selectedEquipment;
    console.log('Datos del equipo a cargar:', equipment);
    
    // Asignar datos básicos
    form.name = equipment.nombre || '';
    form.brand = equipment.marca || '';
    form.model = equipment.modelo || '';
    form.serialNumber = equipment.numero_serie || '';
    form.category = equipment.categoria || '';
    form.status = equipment.estado || 'disponible';
    form.dailyRate = equipment.precio_alquiler_dia || 0;
    form.weeklyRate = equipment.precio_alquiler_semanal || 0;
    form.monthlyRate = equipment.precio_alquiler_mensual || 0;
    form.purchasePrice = equipment.precio_compra || 0;
    form.currentValue = equipment.valor_actual || 0;
    form.purchaseDate = equipment.fecha_compra || '';
    form.condition = equipment.condicion || 'excelente';
    form.location = equipment.ubicacion || '';
    form.notes = equipment.notas || '';
    
    // Asignar especificaciones
    if (equipment.especificaciones) {
      form.specifications.processor = equipment.especificaciones.procesador || '';
      form.specifications.ram = equipment.especificaciones.memoria_ram || '';
      form.specifications.storage = equipment.especificaciones.almacenamiento || '';
      form.specifications.graphics = equipment.especificaciones.tarjeta_grafica || '';
      form.specifications.screen = equipment.especificaciones.pantalla || '';
      form.specifications.os = equipment.especificaciones.sistema_operativo || '';
    }
    
    console.log('Formulario después de cargar datos:', form);
  } else {
    console.log('No hay selectedEquipment para cargar');
  }
};

const resetForm = () => {
  Object.assign(form, {
    name: '',
    brand: '',
    model: '',
    serialNumber: '',
    category: '',
    status: 'disponible',
    dailyRate: 0,
    weeklyRate: 0,
    monthlyRate: 0,
    purchasePrice: 0,
    currentValue: 0,
    purchaseDate: '',
    condition: 'excelente',
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

// Watcher para categorías del store
watch(() => inventoryStore.categoryList, (newCategories) => {
  if (newCategories && newCategories.length > 0) {
    categories.value = newCategories;
    console.log('Categorías actualizadas en el formulario:', categories.value);
  }
}, { immediate: true, deep: true });

// Función para cargar categorías
const loadCategories = async () => {
  loadingCategories.value = true;
  
  // Primero, cargar categorías de prueba para garantizar que funcione
  categories.value = testCategories;
  console.log('Categorías de prueba cargadas:', categories.value);
  
  try {
    // Intentar cargar desde el store
    await inventoryStore.fetchCategories();
    
    if (inventoryStore.categoryList && inventoryStore.categoryList.length > 0) {
      categories.value = inventoryStore.categoryList;
      console.log('Categorías actualizadas desde store:', categories.value);
    } else {
      // Si el store no tiene categorías, cargar directamente desde el servicio
      console.log('Store vacío, intentando cargar desde API...');
      const response = await CategoryService.getCategories();
      console.log('Respuesta directa del API:', response);
      
      if (response && response.categoria && Array.isArray(response.categoria)) {
        categories.value = response.categoria;
        console.log('Categorías actualizadas desde API:', categories.value);
      } else {
        console.log('Manteniendo categorías de prueba');
      }
    }
  } catch (error) {
    console.error('Error al cargar categorías, usando categorías de prueba:', error);
    // Mantener las categorías de prueba en caso de error
  } finally {
    loadingCategories.value = false;
  }
};

// Lifecycle
onMounted(async () => {
  console.log('EquipmentForm mounted, loading categories...');
  
  // Cargar categorías
  await loadCategories();
  
  // Debug: verificar estado después de cargar
  console.log('Categories after load:', categories.value);
  console.log('Store categoryList:', inventoryStore.categoryList);
  
  if (props.mode === 'edit' && props.selectedEquipment) {
    loadEquipmentData();
  }
});
</script>

<style scoped>
/* Estilos adicionales si son necesarios */
</style>
