<template>
  <aside 
    :class="[
      'sidebar bg-gray-800 text-white flex-shrink-0 transition-all duration-300 relative',
      isCollapsed ? 'w-20' : 'w-70'
    ]"
  >
    <!-- Toggle Button -->
    <button
      @click="toggleSidebar"
      class="absolute -right-3 top-6 bg-[#01995f] hover:bg-[#017a4a] text-white rounded-full p-2 shadow-lg transition-all duration-300 z-10"
      :title="isCollapsed ? 'Expandir sidebar' : 'Colapsar sidebar'"
    >
      <font-awesome-icon 
        :icon="isCollapsed ? 'fa-solid fa-chevron-right' : 'fa-solid fa-chevron-left'" 
        class="w-3 h-3"
      />
    </button>

    <!-- Header -->
    <div
      class="p-4 flex h-18 items-center justify-center text-xl font-bold border-b border-gray-700 overflow-hidden"
    >
      <transition name="fade" mode="out-in">
        <span v-if="!isCollapsed" key="full">AXION SYSTEM</span>
        <span v-else key="short" class="text-2xl">AX</span>
      </transition>
    </div>

    <!-- Navigation -->
    <nav class="mt-6">
      <ul class="space-y-1">
        <!-- Inicio -->
        <li>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/home"
          >
            <font-awesome-icon icon="fa-solid fa-home" class="w-5 h-5 flex-shrink-0" />
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3">Inicio</span>
            </transition>
          </RouterLink>
        </li>

        <!-- Usuarios -->
        <li>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/User"
          >
            <font-awesome-icon icon="fa-solid fa-users" class="w-5 h-5 flex-shrink-0" />
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3">Usuarios</span>
            </transition>
          </RouterLink>
        </li>

        <!-- Categorías -->
        <li>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/Category"
          >
            <font-awesome-icon icon="fa-solid fa-tags" class="w-5 h-5 flex-shrink-0" />
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3">Categorías</span>
            </transition>
          </RouterLink>
        </li>

        <!-- Inventario -->
        <li>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/Inventory"
          >
            <font-awesome-icon icon="fa-solid fa-boxes" class="w-5 h-5 flex-shrink-0" />
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3">Inventario</span>
            </transition>
          </RouterLink>
        </li>

        <!-- Reportes (Dropdown) -->
        <li v-if="!isCollapsed">
          <button 
            @click="toggleReports"
            class="w-full flex justify-between items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2"
          >
            <div class="flex items-center">
              <font-awesome-icon icon="fa-solid fa-chart-bar" class="w-5 h-5 flex-shrink-0" />
              <span class="ml-3">Reportes</span>
            </div>
            <font-awesome-icon 
              :icon="showReports ? 'fa-solid fa-chevron-up' : 'fa-solid fa-chevron-down'" 
              class="w-3 h-3"
            />
          </button>
          <transition name="slide-down">
            <ul v-if="showReports" class="ml-4 mt-1 space-y-1">
              <li>
                <RouterLink to="/reports" class="block px-4 py-2 hover:bg-[#01995f] rounded-lg transition-all duration-200">
                  <font-awesome-icon icon="fa-solid fa-box" class="w-4 h-4 mr-2" />
                  Inventario
                </RouterLink>
              </li>
              <li>
                <RouterLink to="/reportUsers" class="block px-4 py-2 hover:bg-[#01995f] rounded-lg transition-all duration-200">
                  <font-awesome-icon icon="fa-solid fa-user-tie" class="w-4 h-4 mr-2" />
                  Empleados
                </RouterLink>
              </li>
              <li>
                <RouterLink to="/ReportMaintenance" class="block px-4 py-2 hover:bg-[#01995f] rounded-lg transition-all duration-200">
                  <font-awesome-icon icon="fa-solid fa-wrench" class="w-4 h-4 mr-2" />
                  Mantenimientos
                </RouterLink>
              </li>
              <li>
                <RouterLink to="/ReportAlquiler" class="block px-4 py-2 hover:bg-[#01995f] rounded-lg transition-all duration-200">
                  <font-awesome-icon icon="fa-solid fa-handshake" class="w-4 h-4 mr-2" />
                  Alquileres
                </RouterLink>
              </li>
            </ul>
          </transition>
        </li>

        <!-- Reportes (Collapsed - Solo icono) -->
        <li v-else>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/reports"
            title="Reportes"
          >
            <font-awesome-icon icon="fa-solid fa-chart-bar" class="w-5 h-5 flex-shrink-0" />
          </RouterLink>
        </li>

        <!-- Alertas -->
        <li>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/Alerts"
          >
            <font-awesome-icon icon="fa-solid fa-bell" class="w-5 h-5 flex-shrink-0" />
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3">Alertas</span>
            </transition>
          </RouterLink>
        </li>

        <!-- Mantenimientos -->
        <li>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/Mantenace"
          >
            <font-awesome-icon icon="fa-solid fa-tools" class="w-5 h-5 flex-shrink-0" />
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3">Mantenimientos</span>
            </transition>
          </RouterLink>
        </li>

        <!-- Alquiler -->
        <li>
          <RouterLink 
            class="sidebar-item flex items-center py-3 px-4 hover:bg-[#01995f] transition-all duration-200 rounded-lg mx-2" 
            to="/Rental"
          >
            <font-awesome-icon icon="fa-solid fa-calendar-check" class="w-5 h-5 flex-shrink-0" />
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3">Alquiler</span>
            </transition>
          </RouterLink>
        </li>
      </ul>
    </nav>
  </aside>
</template>

<script setup>
import { RouterLink } from 'vue-router';
import { ref } from "vue";

const showReports = ref(false);
const isCollapsed = ref(false);

function toggleReports() {
  showReports.value = !showReports.value;
}

function toggleSidebar() {
  isCollapsed.value = !isCollapsed.value;
  // Cerrar el menú de reportes al colapsar
  if (isCollapsed.value) {
    showReports.value = false;
  }
}
</script>

<style lang="scss" scoped>
.sidebar-item {
  display: flex;
  align-items: center;
  transition: all 0.2s ease;
  
  &:hover {
    transform: translateX(2px);
  }

  &.router-link-active {
    background-color: #01995f;
  }
}

// Transiciones
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.slide-fade-enter-active {
  transition: all 0.3s ease;
}
.slide-fade-leave-active {
  transition: all 0.2s ease;
}
.slide-fade-enter-from {
  transform: translateX(-10px);
  opacity: 0;
}
.slide-fade-leave-to {
  transform: translateX(-10px);
  opacity: 0;
}

.slide-down-enter-active {
  transition: all 0.3s ease;
}
.slide-down-leave-active {
  transition: all 0.2s ease;
}
.slide-down-enter-from {
  max-height: 0;
  opacity: 0;
  overflow: hidden;
}
.slide-down-leave-to {
  max-height: 0;
  opacity: 0;
  overflow: hidden;
}
</style>
