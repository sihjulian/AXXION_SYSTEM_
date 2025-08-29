<template>
  <div class="app flex">
    <!-- SideBar -->
    <SideBar></SideBar>

    <!-- Main Content -->
    <RouterView></RouterView>

    <main class="flex-1 p-8 overflow-x-auto">
      <div class="max-w-7xl mx-auto bg-white rounded-lg shadow-xl p-8 h-full flex flex-col">
        <!-- Encabezado del contenido - REUTILIZADO -->
        <headerP></headerP>

        <!-- Contenido del Panel de Inicio -->
        <div class="flex-grow flex justify-center">
          <div class="w-full max-w-5xl">
            <h2 class="text-5xl font-bold text-center text-gray-800 mb-12">AXION SYSTEM</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <!-- Módulo Categorías -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
                href="categorias.html"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10.325 4.317c.54-1.341 2.016-1.341 2.556 0A1.996 1.996 0 0013 7h1c.604 0 1.139.387 1.348.948l1.378 4.298c.118.368.172.766.172 1.171 0 .221-.019.43-.058.625M17 13.795L12 17.5l-5-3.705m5 0v-4.5"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Categorías</span>
              </div>

              <!-- Módulo Productos (No en el Sidebar pero en la HOME) -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 11H5a2 2 0 01-2-2V7a2 2 0 012-2h14a2 2 0 012 2v2a2 2 0 01-2 2zM3 11v6a2 2 0 002 2h14a2 2 0 002-2v-6m-7 6h-2"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Productos</span>
              </div>

              <!-- Módulo Proveedores -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10l9-7 9 7M4 10v11h16V10"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Proveedores</span>
              </div>

              <!-- Módulo Subcategorías -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10 21h7a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2zm2-10V4.414L16.586 9H12zm2 10a4 4 0 100-8 4 4 0 000 8zm-8-4a4 4 0 100-8 4 4 0 000 8z"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Subcategorias</span>
              </div>

              <!-- Módulo Usuarios -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2h2m3-5l4 4m0 0l4-4m-4 4V7"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Usuarios</span>
              </div>

              <!-- Módulo Rutas de Distribución -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8 7V3m8 4V3m-9 8h8M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2zm13 0v-6a1 1 0 00-1-1H6a1 1 0 00-1 1v6m8-6a1 1 0 00-1-1h-2a1 1 0 00-1 1"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Rutas de distribucion</span>
              </div>

              <!-- Módulo Mantenimientos -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 6V4m0 2a2 2 0 100 4m0-4c-.754 0-1.458.113-2.115.31C9.61 7.152 9 7.765 9 8.5M8 15V8.5C8 7.765 8.61 7.152 9.248 6.315C10.334 5.385 11.233 5 12 5s1.666.385 2.752 1.315C15.39 7.152 16 7.765 16 8.5V15M8 15v3c0 .53.25.96.6 1.25S9.47 20 10 20s.95-.27 1.3-.5S12.01 18.5 12.01 18s.25-.96.6-1.25S13.53 16 14 16h-.01c.53 0 .96.25 1.25.6s.5 1.47.5 2v3c0 .53-.25.96-.6 1.25S14.53 20 14 20h-.01z"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Mantenimiento</span>
              </div>

              <!-- Módulo Reporte -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 4h6m-3-1v4m-3-4a2 2 0 002-2h2a2 2 0 002 2h2m-6 0v2"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Reporte</span>
              </div>

              <!-- Módulo Alerta -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 17L9 11M6.5 17H6"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Alerta</span>
              </div>

              <!-- Módulo Alquiler -->
              <div
                class="p-8 bg-gray-300 rounded-lg shadow-lg flex flex-col items-center justify-center hover:bg-gray-400 transition-colors duration-200 cursor-pointer"
              >
                <svg
                  class="h-24 w-24 text-gray-700 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h3l2 4M8 20l3-4m1 0h3"
                  ></path>
                </svg>
                <span class="text-xl font-semibold text-gray-800">Alquiler</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { RouterLink } from 'vue-router';
import SideBar from '@/components/SideBar.vue'
import headerP from '@/components/headerP.vue'
</script>
<style></style>
