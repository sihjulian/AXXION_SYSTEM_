<template>
    <FwbModal v-if="show" @close="emit('close')">
        <!-- Encabezado -->
        <template #header>
            <div class="text-lg font-bold text-white">
                <span v-if="mode === 'add'"><font-awesome-icon class="mr-2" icon="fa-solid fa-plus" />Agregar renta</span>
                <span v-else-if="mode === 'edit'">Editar renta #{{ targetId }}</span>
                <span v-else-if="mode === 'delete'">Confirmar eliminación</span>
            </div>
</template>
<!-- Cuerpo -->
<template #body>
    <!-- Modo eliminar -->
    <div v-if="mode === 'delete'">
        ¿Seguro que quieres eliminar la renta #{{ targetId }}?
    </div>
    <!-- Modo agregar/editar -->
    <div v-else>
        <!-- Cliente -->
        <div class="mb-3">
            <label class="block mb-2 text-white">Cliente *</label>
            <select v-model="localPayload.cliente_id" class="w-full p-2 border rounded bg-gray-700 text-white">
                <option disabled value="">Seleccione cliente</option>
                <option v-for="c in clientes" :key="c.id" :value="c.id">
                    {{ c.nombre }} {{ c.apellido1 }}
                </option>
            </select>
        </div>
        <!-- Fechas -->
        <div class="mb-3">
            <label class="block mb-2 text-white">Fecha inicio *</label>
            <input type="datetime-local" v-model="localPayload.fecha_inicio" class="w-full p-2 border rounded bg-gray-700 text-white" />
        </div>
        <div class="mb-3">
            <label class="block mb-2 text-white">Fecha fin prevista *</label>
            <input type="datetime-local" v-model="localPayload.fecha_fin_prevista" class="w-full p-2 border rounded bg-gray-700 text-white" />
        </div>
        <div class="mb-3">
            <label class="block mb-2 text-white">Fecha devolución real *</label>
            <input type="datetime-local" v-model="localPayload.fecha_devolucion_real" class="w-full p-2 border rounded bg-gray-700 text-white" />
        </div>
        <!-- Estado -->
        <div class="mb-3">
            <label class="block mb-2 text-white">Estado *</label>
            <select v-model="localPayload.estado_renta" class="w-full p-2 border rounded bg-gray-700 text-white">
                <option value="Programada">Programada</option>
                <option value="EnCurso">En curso</option>
                <option value="Finalizada">Finalizada</option>
                <option value="Retrasada">Retrasada</option>
                <option value="Cancelada">Cancelada</option>
            </select>
        </div>
        <!-- Valores -->
        <div class="mb-3 grid grid-cols-2 gap-2">
            <div>
                <label class="block mb-2 text-white">Monto total *</label>
                <input type="number" step="0.01" v-model="localPayload.monto_total_renta" class="w-full p-2 border rounded bg-gray-700 text-white" />
            </div>
            <div>
                <label class="block mb-2 text-white">Depósito garantía *</label>
                <input type="number" step="0.01" v-model="localPayload.deposito_garantia" class="w-full p-2 border rounded bg-gray-700 text-white" />
            </div>
        </div>
        <!-- Notas -->
        <div class="mb-3">
            <label class="block mb-2 text-white">Notas</label>
            <textarea v-model="localPayload.notas" rows="3" class="w-full p-2 border rounded bg-gray-700 text-white"></textarea>
        </div>
    </div>
</template>
<!-- Footer -->
<template #footer>
    <div class="flex justify-end gap-2">
        <FwbButton color="alternative" @click="emit('close')">Cancelar</FwbButton>
        <FwbButton color="green" @click="save" :disabled="loading">
            <span v-if="mode === 'delete'">Eliminar</span>
            <span v-else>Guardar</span>
        </FwbButton>
    </div>
</template>
</FwbModal>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import { FwbModal, FwbButton } from 'flowbite-vue';
import ClienteService from '@/services/ClienteService';

const props = defineProps({
  show: Boolean,
  mode: String,
  targetId: Number,
  payload: Object,
  loading: Boolean
});
const emit = defineEmits(['close', 'save']);

const localPayload = ref({});
const clientes = ref([]);

const toInputDateTime = (iso) => {
  if (!iso) return '';
  try {
    // limpia microsegundos si existen y la Z final
    const cleaned = iso.replace(/\.\d+Z?$/, 'Z').replace(/Z$/, '');
    const d = new Date(cleaned);
    if (isNaN(d)) return '';
    const pad = (n) => String(n).padStart(2, '0');
    const yyyy = d.getFullYear();
    const mm = pad(d.getMonth() + 1);
    const dd = pad(d.getDate());
    const hh = pad(d.getHours());
    const min = pad(d.getMinutes());
    return `${yyyy}-${mm}-${dd}T${hh}:${min}`;
  } catch (e) {
    return '';
  }
};

// convierte "YYYY-MM-DDTHH:MM" -> "YYYY-MM-DD HH:MM:00" (formato que usa tu normalize en el padre)
const fromInputToServer = (val) => {
  if (!val) return null;
  // si viene con segundos, cortamos a minutos
  const v = val.split('.')[0]; // quitar ms si vienen
  return v.replace('T', ' ') + ':00';
};

// cargar clientes al montar
onMounted(async () => {
  try {
    const res = await ClienteService.getAll();
    clientes.value = res.cliente || [];
  } catch (e) {
    console.error("Error cargando clientes:", e);
  }
});

// sincronizar props.payload → localPayload
watch(
  () => props.payload,
  (newVal) => {
    if (!newVal) {
      localPayload.value = {
        cliente_id: '',
        cotizacion_id: null,
        fecha_inicio: '',
        fecha_fin_prevista: '',
        fecha_devolucion_real: '',
        estado_renta: 'Programada',
        monto_total_renta: '',
        deposito_garantia: '',
        notas: ''
      };
      return;
    }

    localPayload.value = {
      ...newVal,
      // si vienen como ISO con Z o microsegundos los convertimos al formato que acepta datetime-local
      fecha_inicio: newVal.fecha_inicio ? toInputDateTime(newVal.fecha_inicio) : '',
      fecha_fin_prevista: newVal.fecha_fin_prevista ? toInputDateTime(newVal.fecha_fin_prevista) : '',
      fecha_devolucion_real: newVal.fecha_devolucion_real ? toInputDateTime(newVal.fecha_devolucion_real) : ''
    };

    console.log('📦 Payload recibido en modal (transformado para inputs):', localPayload.value);
  },
  { immediate: true }
);

// convertir datetime-local a formato aceptado por backend
const toDateTime = (val) => (val ? val.replace("T", " ") + ":00" : null);

const normalizePayload = () => ({
  cliente_id: localPayload.value.cliente_id ? Number(localPayload.value.cliente_id) : null,
  fecha_inicio: toDateTime(localPayload.value.fecha_inicio),
  fecha_fin_prevista: toDateTime(localPayload.value.fecha_fin_prevista),
  fecha_devolucion_real: toDateTime(localPayload.value.fecha_devolucion_real),
  estado_renta: localPayload.value.estado_renta || "Programada",
  monto_total_renta: localPayload.value.monto_total_renta ? Number(localPayload.value.monto_total_renta) : 0,
  deposito_garantia: localPayload.value.deposito_garantia ? Number(localPayload.value.deposito_garantia) : 0,
  notas: localPayload.value.notas || ""
});

const save = () => {
  console.log('Emitendo desde modal (raw):', localPayload.value);
  emit('save', localPayload.value);
}
</script>

