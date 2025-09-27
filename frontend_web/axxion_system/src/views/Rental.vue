<template>
  <div class="app flex">
    <SideBar />
    <routerView />
    <main class="container h-screen p-4 flex-1 overflow-y-auto">
      <headerP />
      <section>
        <!-- Botón para agregar renta -->
        <div class="mb-4 flex justify-start">
          <FwbButton gradient="green-blue" @click="openAdd"><font-awesome-icon class="mr-2" icon="fa-solid fa-plus" />Agregar renta</FwbButton>
        </div>

        <!-- Estado de carga / error -->
        <div v-if="loading" class="p-4">Cargando rentas...</div>
        <div v-else-if="error" class="p-4 text-red-600">{{ error }}</div>

        <!-- Grid de tarjetas -->
        <div v-else class="grid gap-4 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
          <FwbCard v-for="r in rentals" :key="r.id" class="w-sm">
            <div class="p-5">
              <h5 class="flex justify-between">
                <div class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white order-1">Renta #{{ r.id }}</div><div class="order-2 text-xs self-start text-[#39FF14] rounded-xl p-1 bg-[#00401A]">{{ r.estado_renta }}</div> 
              </h5>

              <!-- Cliente -->
              <div class="text-sm text-gray-700 dark:text-gray-400 mb-2">
                <strong>Cliente:</strong>
                {{ (r.cliente?.nombre || '') + ' ' + (r.cliente?.nombre2 ? r.cliente.nombre2 + ' ' : '') + (r.cliente?.apellido1 || '') + (r.cliente?.apellido2 ? ' ' + r.cliente.apellido2 : '') }}
              </div>

              <!-- Fechas -->
              <div class="text-sm text-gray-700 dark:text-gray-400">
                <div><strong>Inicio:</strong> {{ formatDate(r.fecha_inicio) }}</div>
                <div><strong>Fin prevista:</strong> {{ formatDate(r.fecha_fin_prevista) }}</div>
                <div><strong>Devolución real:</strong> {{ r.fecha_devolucion_real ? formatDate(r.fecha_devolucion_real) : '-' }}</div>
              </div>

              <!-- Montos -->
              <div class="mt-3 text-sm text-gray-600">
                <div><strong>Monto total:</strong> {{ formatCurrency(r.monto_total_renta) }}</div>
                <div><strong>Depósito garantia:</strong> {{ formatCurrency(r.deposito_garantia) }}</div>
              </div>

              <!-- Notas -->
              <p class="mt-3 font-normal text-gray-700 dark:text-gray-400">
                <strong>Notas:</strong>
                {{ r.notas || '-' }}
              </p>

              <!-- Estado -->
              <div class="mt-2">
                <strong>Estado:</strong>
                <span class="ml-2">{{ r.estado_renta }}</span>
              </div>

              <!-- Inventario -->
              <div class="mt-3">
                <strong>Inventario:</strong>
                <ul class="list-disc list-inside text-sm text-gray-700">
                  <li v-for="item in r.inventario_items || []" :key="item.id" class="mt-2">
                    <div><strong>Producto (serie):</strong> {{ item.numero_serie || item.producto_id }}</div>
                    <div><strong>Estado item:</strong> {{ item.estado_item }}</div>
                    <div><strong>Precio renta:</strong> {{ formatCurrency(item.pivot?.precio_renta_item) }}</div>
                    <div><strong>Condición salida:</strong> {{ item.pivot?.condicion_salida || '-' }}</div>
                    <div v-if="item.pivot?.notas"><strong>Notas item:</strong> {{ item.pivot.notas }}</div>
                  </li>
                </ul>
              </div>

              <!-- Acciones -->
              <div class="mt-4 flex justify-center-safe gap-9">
                <button @click="openEdit(r)" class="px-3 py-1 bg-linear-to-bl from-yellow-500 to-yellow-300 text-black rounded transition delay-150 duration-300 ease-in-out hover:-translate-y-1 hover:scale-110 hover:bg-red-500">
                  <font-awesome-icon icon="fa-solid fa-pen-to-square" />
                  <br>
                  Editar
                </button>
                <button @click="openDeleteConfirm(r.id)" :disabled="actionLoading[r.id]" class="px-3 py-1 bg-linear-to-bl from-red-700 to-red-500 text-white rounded transition delay-150 duration-300 ease-in-out hover:-translate-y-1 hover:scale-110 hover:bg-red-500">
                  <font-awesome-icon icon="fa-solid fa-trash" />
                  <br>
                  Eliminar
                </button>
              </div>
            </div>
          </FwbCard>
        </div>

        <!-- Modal reutilizable -->
        <RentalModal
          :show="showModal"
          :mode="modalMode"
          :target-id="modalTargetId"
          :payload="modalPayload"
          :loading="actionLoading[modalTargetId || 'add']"
          @close="closeModal"
          @save="saveModal"
        />
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import { FwbCard, FwbButton } from 'flowbite-vue'
import RentalModal from '@/components/RentalModal.vue'
import RentalService from '@/services/RentalService';
import ClienteService from '@/services/ClienteService'


const rentals = ref([]);
const loading = ref(false);
const error = ref(null);

// Opciones de clientes
const clientes = ref([])
const clienteOptions = ref([])

// Cargar clientes desde la API
const loadClientes = async () => {
  try {
    const data = await ClienteService.getAll()
    console.log('Clientes cargados:', data)

    // Si la API devuelve un objeto con data, normalizamos
    const arr = Array.isArray(data) ? data : data.data || []

    clientes.value = arr
    clienteOptions.value = arr.map(c => ({
      value: c.id,
      label: `${c.nombre} ${c.nombre2 || ''} ${c.apellido1 || ''} ${c.apellido2 || ''}`.trim()
    }))
  } catch (error) {
    console.error('Error cargando clientes:', error)
  }
}


// Emitir cambios
const save = () => {
  emit('save', localPayload.value)
}


const loadRentals = async () => {
  loading.value = true;
  error.value = null;
  try {
    const data = await RentalService.getRental();
    console.log('Rental API raw response in view:', data);

    // Extraer array de forma segura
    const extractArrayFromResponse = (obj) => {
      if (Array.isArray(obj)) return obj;
      if (!obj || typeof obj !== 'object') return [];
      if ('id' in obj) return [obj];
      for (const key of Object.keys(obj)) {
        if (Array.isArray(obj[key])) return obj[key];
      }
      for (const key of Object.keys(obj)) {
        const val = obj[key];
        if (val && typeof val === 'object') {
          for (const subKey of Object.keys(val)) {
            if (Array.isArray(val[subKey])) return val[subKey];
          }
        }
      }
      return [];
    };

    rentals.value = extractArrayFromResponse(data);
    console.log('Parsed rentals:', rentals.value);
  } catch (err) {
    console.error('Error al cargar rentas:', err);
    error.value = 'No se pudieron cargar las rentas';
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  loadRentals();
  loadClientes()
});

// Helpers de formato
const formatDate = (iso) => {
  if (!iso) return '-';
  try {
    const d = new Date(iso);
    return d.toLocaleString();
  } catch (e) {
    return iso;
  }
};

const formatCurrency = (val) => {
  if (val === null || val === undefined || val === '') return '-';
  const num = Number(val);
  if (Number.isNaN(num)) return val;
  return num.toLocaleString(undefined, { style: 'currency', currency: 'MXN' });
};

// Estado del modal
const actionLoading = ref({});
const showModal = ref(false);
const modalMode = ref(''); // 'add' | 'edit' | 'delete'
const modalPayload = ref({});
const modalTargetId = ref(null);

// Acciones para abrir modal
const openAdd = () => {
  modalMode.value = 'add';
  modalPayload.value = {
    cliente_id: '',            // 🔹 pon vacío, no null
    cotizacion_id: null,
    fecha_inicio: '',
    fecha_fin_prevista: '',
    fecha_devolucion_real: '',
    estado_renta: 'Programada',
    monto_total_renta: '',
    deposito_garantia: '',
    notas: ''
  };
  modalTargetId.value = null;
  showModal.value = true;
};

const openEdit = (r) => {
  modalMode.value = 'edit';
  modalTargetId.value = r.id;
  modalPayload.value = {
    cliente_id: r.cliente_id || '',
    cotizacion_id: r.cotizacion_id || null,
    fecha_inicio: r.fecha_inicio ? r.fecha_inicio.replace(' ', 'T') : '',
    fecha_fin_prevista: r.fecha_fin_prevista ? r.fecha_fin_prevista.replace(' ', 'T') : '',
    fecha_devolucion_real: r.fecha_devolucion_real ? r.fecha_devolucion_real.replace(' ', 'T') : '',
    estado_renta: r.estado_renta,
    monto_total_renta: r.monto_total_renta,
    deposito_garantia: r.deposito_garantia,
    notas: r.notas
  };
  showModal.value = true;
};

const openDeleteConfirm = (id) => {
  modalMode.value = 'delete';
  modalTargetId.value = id;
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
  modalMode.value = '';
  modalPayload.value = {};
  modalTargetId.value = null;
};

const toDateTime = (val) => {
  if (!val) return null;
  return val.replace("T", " ") + ":00";
};

  const normalizePayload = (payload) => {
  return {
    cliente_id: payload.cliente_id ? Number(payload.cliente_id) : null,
    cotizacion_id: payload.cotizacion_id ?? null,
    fecha_inicio: payload.fecha_inicio ? payload.fecha_inicio.replace("T", " ") + ":00" : null,
    fecha_fin_prevista: payload.fecha_fin_prevista ? payload.fecha_fin_prevista.replace("T", " ") + ":00" : null,
    fecha_devolucion_real: payload.fecha_devolucion_real ? payload.fecha_devolucion_real.replace("T", " ") + ":00" : null,
    estado_renta: payload.estado_renta || "Programada",
    monto_total_renta: payload.monto_total_renta ? Number(payload.monto_total_renta) : 0,
    deposito_garantia: payload.deposito_garantia ? Number(payload.deposito_garantia) : 0,
    notas: payload.notas || "",
    inventarioItems: payload.inventarioItems || []
  }
}


// Guardar en modal — ahora recibe el payload emitido por el modal
const saveModal = async (payloadFromModal) => {
  // si el modal no mandó payload (por compatibilidad), fallback al modalPayload.value
  const sourcePayload = payloadFromModal ?? modalPayload.value;

  // normalizamos lo que viniera (fechas, números, etc.)
  const normalized = normalizePayload(sourcePayload);

  const id = modalTargetId.value;

  console.log("Payload recibido del modal:", sourcePayload);
  console.log("Payload normalizado:", normalized);

  if (modalMode.value === 'add') {
    try {
      const created = await RentalService.createRental(normalized);
      rentals.value.unshift(created.renta ?? created);
      closeModal();
    } catch (err) {
      console.error("Error creando renta:", err);
      alert("No se pudo crear la renta.");
    }
  } else if (modalMode.value === 'edit') {
    try {
      const updated = await RentalService.updateRental(modalTargetId.value, normalized);
      const idx = rentals.value.findIndex(r => r.id === modalTargetId.value);
      if (idx !== -1) rentals.value[idx] = { ...rentals.value[idx], ...updated.renta };
      closeModal();
    } catch (err) {
      console.error("Error actualizando renta:", err);
      alert("No se pudo actualizar la renta.");
    }
  } else if (modalMode.value === 'delete') {
    const idDel = modalTargetId.value;
    actionLoading.value = { ...actionLoading.value, [idDel]: true };
    try {
      await RentalService.deleteRental(idDel);
      rentals.value = rentals.value.filter(r => r.id !== idDel);
      closeModal();
    } catch (err) {
      console.error('Error eliminando renta:', err);
      alert('No se pudo eliminar la renta.');
    } finally {
      actionLoading.value = { ...actionLoading.value, [idDel]: false };
    }
  }
};


</script>
