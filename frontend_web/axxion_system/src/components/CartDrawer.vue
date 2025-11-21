<template>
  <div class="relative z-50">
    <!-- Overlay -->
    <transition
      enter-active-class="ease-in-out duration-500"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="ease-in-out duration-500"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div 
        v-if="cartStore.isOpen" 
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" 
        @click="cartStore.closeCart"
      ></div>
    </transition>

    <!-- Drawer -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none">
      <div class="absolute inset-0 overflow-hidden">
        <div class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
          <transition
            enter-active-class="transform transition ease-in-out duration-500 sm:duration-700"
            enter-from-class="translate-x-full"
            enter-to-class="translate-x-0"
            leave-active-class="transform transition ease-in-out duration-500 sm:duration-700"
            leave-from-class="translate-x-0"
            leave-to-class="translate-x-full"
          >
            <div v-if="cartStore.isOpen" class="pointer-events-auto w-screen max-w-md">
              <div class="flex h-full flex-col overflow-y-scroll bg-white dark:bg-gray-800 shadow-xl">
                <div class="flex-1 overflow-y-auto px-4 py-6 sm:px-6">
                  <div class="flex items-start justify-between">
                    <h2 class="text-lg font-medium text-gray-900 dark:text-white">Carrito de Renta</h2>
                    <div class="ml-3 flex h-7 items-center">
                      <button 
                        type="button" 
                        class="relative -m-2 p-2 text-gray-400 hover:text-gray-500"
                        @click="cartStore.closeCart"
                      >
                        <span class="absolute -inset-0.5"></span>
                        <span class="sr-only">Cerrar panel</span>
                        <font-awesome-icon icon="fa-solid fa-times" class="h-6 w-6" />
                      </button>
                    </div>
                  </div>

                  <div class="mt-8">
                    <div v-if="cartStore.items.length === 0" class="text-center py-10">
                      <font-awesome-icon icon="fa-solid fa-shopping-cart" class="text-4xl text-gray-300 mb-4" />
                      <p class="text-gray-500 dark:text-gray-400">El carrito está vacío</p>
                    </div>
                    <div v-else class="flow-root">
                      <ul role="list" class="-my-6 divide-y divide-gray-200 dark:divide-gray-700">
                        <li v-for="item in cartStore.items" :key="item.id" class="flex py-6 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors rounded-lg px-2 -mx-2">
                          <div class="h-24 w-24 flex-shrink-0 overflow-hidden rounded-md border border-gray-200 dark:border-gray-600">
                            <img 
                              v-if="item.images && item.images.length > 0" 
                              :src="item.images[0].url || item.images[0]" 
                              :alt="item.nombre" 
                              class="h-full w-full object-cover object-center"
                            >
                            <div v-else class="h-full w-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center">
                              <font-awesome-icon icon="fa-solid fa-image" class="text-gray-400" />
                            </div>
                          </div>

                          <div class="ml-4 flex flex-1 flex-col">
                            <div>
                              <div class="flex justify-between text-base font-medium text-gray-900 dark:text-white">
                                <h3>
                                  <a href="#">{{ item.nombre }}</a>
                                </h3>
                                <p class="ml-4">{{ formatCurrency(item.precio_alquiler_dia) }}</p>
                              </div>
                              <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">{{ item.marca }} - {{ item.modelo }}</p>
                            </div>
                            <div class="flex flex-1 items-end justify-between text-sm">
                              <p class="text-gray-500 dark:text-gray-400">Serie: {{ item.numero_serie }}</p>

                              <div class="flex">
                                <button 
                                  type="button" 
                                  class="font-medium text-red-600 hover:text-red-500"
                                  @click="cartStore.removeItem(item.id)"
                                >
                                  Eliminar
                                </button>
                              </div>
                            </div>
                          </div>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>

                <div class="border-t border-gray-200 dark:border-gray-700 px-4 py-6 sm:px-6">
                  <div class="flex justify-between text-base font-medium text-gray-900 dark:text-white">
                    <p>Subtotal (por día)</p>
                    <p>{{ formatCurrency(cartStore.totalPrice) }}</p>
                  </div>
                  <p class="mt-0.5 text-sm text-gray-500 dark:text-gray-400">Impuestos y envío calculados al finalizar.</p>
                  <div class="mt-6">
                    <button
                      @click="proceedToCheckout"
                      :disabled="cartStore.items.length === 0"
                      class="flex w-full items-center justify-center rounded-md border border-transparent bg-blue-600 px-6 py-3 text-base font-medium text-white shadow-sm hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                    >
                      Proceder a Rentar
                    </button>
                  </div>
                  <div class="mt-6 flex justify-center text-center text-sm text-gray-500 dark:text-gray-400">
                    <p>
                      o
                      <button 
                        type="button" 
                        class="font-medium text-blue-600 hover:text-blue-500"
                        @click="cartStore.closeCart"
                      >
                        Continuar Explorando
                        <span aria-hidden="true"> &rarr;</span>
                      </button>
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </transition>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useCartStore } from '@/stores/cart.js';
import { useRouter } from 'vue-router';

const cartStore = useCartStore();
const router = useRouter();

const formatCurrency = (val) => {
  if (val === null || val === undefined || val === '') return '-';
  const num = Number(val);
  if (Number.isNaN(num)) return val;
  return num.toLocaleString(undefined, { style: 'currency', currency: 'MXN' });
};

const proceedToCheckout = () => {
  cartStore.closeCart();
  router.push({ name: 'Rental' }); // Asegúrate de que la ruta se llame 'Rental' o ajusta según router
};
</script>
