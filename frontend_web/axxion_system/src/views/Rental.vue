<template>
  <div class="app flex">
    <SideBar />
    <main class="container h-screen p-4 flex-1 overflow-y-auto">
      <headerP />
      <section class="flex flex-col">
        <div class="mb-4 flex items-baseline">
          <FwbButton gradient="green-blue" @click="rentalStore.openAddModal"><font-awesome-icon class="mr-2" icon="fa-solid fa-plus" />Agregar renta</FwbButton>
        </div>
        
        <div v-if="rentalStore.loading" class="p-4 justify-items-center h-screen text-white"><span class="loader"></span></div>
        <div v-else-if="rentalStore.error" class="p-4 text-red-500">{{ rentalStore.error }}</div>
        
        <div v-else class="flex flex-wrap gap-4 justify-center">
          <FwbCard v-for="r in rentalStore.rentals" :key="r.id" class="w-sm">
            <div class="p-5 flex-1 basis-1/3">
              <h5 class="flex justify-between items-center">
                <div class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white order-1 ">Renta #{{ r.id }}</div>
                <div class="order-2 text-xs self-start text-[#39FF14] rounded-xl p-1 bg-[#00401A]">{{ r.estado_renta }}</div> 
              </h5>
              <!-- Cliente -->
              <div class="text-sm text-gray-700 dark:text-gray-400 mb-2">
                <strong>Cliente:</strong>
                {{ (r.cliente?.nombre || '') + ' ' + (r.cliente?.nombre2 ? r.cliente.nombre2 + ' ' : '') + (r.cliente?.apellido1 || '') + (r.cliente?.apellido2 ? ' ' + r.cliente.apellido2 : '') }}
              </div>
              <!-- Fechas -->
              <div class="text-sm text-gray-500 dark:text-gray-400">
                <div><strong>Inicio:</strong> {{ formatDate(r.fecha_inicio) }}</div>
                <div><strong>Fin prevista:</strong> {{ formatDate(r.fecha_fin_prevista) }}</div>
                <div><strong>Devolución real:</strong> {{ formatDate(r.fecha_devolucion_real) }}</div>
              </div>
              <!-- Montos -->
              <div class="mt-3 text-sm text-black bg-gray-600 rounded-xl p-2">
                <div class="flex"><strong>Monto total:</strong><div class="text-[#4CBB17] font-bold">{{ formatCurrency(r.monto_total_renta) }}</div></div>
                <div><strong>Depósito garantia:</strong> {{ formatCurrency(r.deposito_garantia) }}</div>
              </div>
              <!-- Productos -->
              <div class="mt-3">
                <strong class="text-white">Equipos:</strong>
                <ol class="list-disc list-inside text-sm text-white">
                  <li v-for="item in r.inventario_items || []" :key="item.id" class="mt-2">
                    <div><strong>Producto (serie):</strong> {{ item.numero_serie || item.producto_id }}</div>
                    <div><strong>Estado item:</strong> {{ item.estado_item }}</div>
                    <div><strong>Precio renta:</strong> {{ formatCurrency(item.pivot?.precio_renta_item) }}</div>
                    <div><strong>Condición salida:</strong> {{ item.pivot?.condicion_salida || '-' }}</div>
                    <div v-if="item.pivot?.notas"><strong>Notas item:</strong> {{ item.pivot.notas }}</div>
                  </li>
                </ol>
              </div>
              <!-- ... resto de los detalles de la tarjeta ... -->
              <p class="mt-3 font-normal text-gray-700 dark:text-gray-400"><strong>Notas:</strong> {{ r.notas || '-' }}</p>
              <div class="mt-4 flex flex-row justify-center gap-9">
                <button @click="rentalStore.openEditModal(r)" class="px-3 py-1 bg-linear-to-bl from-yellow-500 to-yellow-300 text-black rounded transition ...">
                  <font-awesome-icon icon="fa-solid fa-pen-to-square" /><br>Editar
                </button>
                <button @click="rentalStore.openDeleteModal(r)" class="px-3 py-1 bg-linear-to-bl from-red-700 to-red-500 text-white rounded transition ...">
                  <font-awesome-icon icon="fa-solid fa-trash" /><br>Eliminar
                </button>
              </div>
            </div>
          </FwbCard>
        </div>

        <RentalModal
          :show="rentalStore.showModal"
          :mode="rentalStore.modalMode"
          :payload="rentalStore.selectedRental"
          :cliente-options="rentalStore.clienteOptions"
          @close="rentalStore.closeModal"
          @save="rentalStore.saveRental"
          @delete="rentalStore.deleteRental"
        />
      </section>
    </main>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRentalStore } from '@/stores/rentalStore';

import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import { FwbCard, FwbButton } from 'flowbite-vue'
import RentalModal from '@/components/RentalModal.vue'
import RentalService from '@/services/RentalService';
import ClienteService from '@/services/ClienteService'
import { useCartStore } from '@/stores/cart.js'; // Import Cart Store

const rentalStore = useRentalStore();
const cartStore = useCartStore(); // Init Cart Store

const loading = ref(false);
const error = ref(null);
const rentals = ref([]);
const actionLoading = ref({});
const showModal = ref(false);
const modalMode = ref('');
const modalPayload = ref({});
const modalTargetId = ref(null);

const formatDate = (iso) => iso ? new Date(iso).toLocaleString() : '-';
const formatCurrency = (val) => (val === null || val === undefined) ? '-' : Number(val).toLocaleString('es-CO', { style: 'currency', currency: 'COP' });

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

const loadClientes = async () => {
  try {
    await rentalStore.fetchClientes();
  } catch (err) {
    console.error('Error al cargar clientes:', err);
  }
};

onMounted(() => {
  rentalStore.fetchRentals();
  rentalStore.fetchClientes();
  loadRentals();
  loadClientes();

  if (cartStore.items.length > 0) {
    openAddWithCart();
  }
});

const openAddWithCart = () => {
  modalMode.value = 'add';
  const total = cartStore.totalPrice;
  const deposit = total * 0.1;

  modalPayload.value = {
    cliente_id: '',
    cotizacion_id: null,
    fecha_inicio: '',
    fecha_fin_prevista: '',
    fecha_devolucion_real: '',
    estado_renta: 'Programada',
    monto_total_renta: total,
    deposito_garantia: deposit,
    notas: 'Renta generada desde el carrito',
    inventarioItems: [...cartStore.items]
  };
  modalTargetId.value = null;
  showModal.value = true;
};

const openAdd = () => {
  modalMode.value = 'add';
  modalPayload.value = {
    cliente_id: '',
    cotizacion_id: null,
    fecha_inicio: '',
    fecha_fin_prevista: '',
    fecha_devolucion_real: '',
    estado_renta: 'Programada',
    monto_total_renta: '',
    deposito_garantia: '',
    notas: '',
    inventarioItems: []
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
  };
};

const saveModal = async (payloadFromModal) => {
  const sourcePayload = payloadFromModal ?? modalPayload.value;
  const normalized = normalizePayload(sourcePayload);
  const id = modalTargetId.value;

  console.log("Payload recibido del modal:", sourcePayload);
  console.log("Payload normalizado:", normalized);

  if (modalMode.value === 'add') {
    try {
      const created = await RentalService.createRental(normalized);
      rentals.value.unshift(created.renta ?? created);

      if (normalized.inventarioItems && normalized.inventarioItems.length > 0) {
        cartStore.clearCart();
      }
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
    try {
      await RentalService.deleteRental(modalTargetId.value);
      rentals.value = rentals.value.filter(r => r.id !== modalTargetId.value);
      closeModal();
    } catch (err) {
      console.error("Error eliminando renta:", err);
      alert("No se pudo eliminar la renta.");
    }
  }
};
</script>

<style scoped>
.loader {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  max-width: 6rem;
  margin-top: 3rem;
  margin-bottom: 3rem;
}

.loader:before,
.loader:after {
  content: "";
  position: absolute;
  border-radius: 50%;
  animation: pulsOut 1.8s ease-in-out infinite;
  filter: drop-shadow(0 0 1rem rgba(25,25,112));
}

.loader:before {
  width: 100%;
  padding-bottom: 100%;
  box-shadow: inset 0 0 0 1rem #191970;
  animation-name: pulsIn;
}

.loader:after {
  width: calc(100% - 2rem);
  padding-bottom: calc(100% - 2rem);
  box-shadow: 0 0 0 0 #191970;
}

@keyframes pulsIn {
  0% {
    box-shadow: inset 0 0 0 1rem #191970;
    opacity: 1;
  }
  50%, 100% {
    box-shadow: inset 0 0 0 0 #191970;
    opacity: 0;
  }
}

@keyframes pulsOut {
  0%, 50% {
    box-shadow: 0 0 0 0 #191970;
    opacity: 0;
  }
  100% {
    box-shadow: 0 0 0 1rem #191970;
    opacity: 1;
  }
}
</style>
