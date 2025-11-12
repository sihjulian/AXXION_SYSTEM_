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
import { onMounted } from 'vue'
import { useRentalStore } from '@/stores/rentalStore';

import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import { FwbCard, FwbButton } from 'flowbite-vue';
import RentalModal from '@/components/RentalModal.vue';

const rentalStore = useRentalStore();

onMounted(() => {
  rentalStore.fetchRentals();
  rentalStore.fetchClientes();
});

const formatDate = (iso) => iso ? new Date(iso).toLocaleString() : '-';
const formatCurrency = (val) => (val === null || val === undefined) ? '-' : Number(val).toLocaleString('es-CO', { style: 'currency', currency: 'COP' });
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