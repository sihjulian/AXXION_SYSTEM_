<template>
  <aside class="w-70 h-auto  bg-gray-800 text-white flex-shrink-0">
    <div
      class="p-10 flex h-18 items-center justify-center text-2xl font-bold border-b border-gray-700"
    >
      AXION SYSTEM
    </div>
    <nav class="mt-6">
      <ul>
        <li>
      <RouterLink class="sidebar-item flex items-center py-3 px-6" to="/home">Inicio</RouterLink>
        </li>
        <li>
      <RouterLink class="sidebar-item flex items-center py-3 px-6" to="/User">Usuarios</RouterLink>
        </li>
        <li>
          <RouterLink class="sidebar-item flex items-center py-3 px-6" to="/Category">Categorias</RouterLink>
        </li>
        <li>
          <RouterLink class="sidebar-item flex items-center py-3 px-6" to="/Inventory">Inventario</RouterLink>
        </li>
              <div>
        <button 
          @click="toggleReports"
          class="w-full flex justify-between items-center py-3 px-1 hover:bg-[#01995f]"
        >
          <span>Reportes</span>
          <span>{{ showReports ? "▲" : "▼" }}</span>
        </button>
        <ul v-if="showReports" class="ml-4">
          <li>
            <RouterLink to="/reports" class="block px-4 py-2 hover:bg-[#01995f]">
              Inventario
            </RouterLink>
          </li>
          <li>
            <RouterLink to="/reportUsers" class="block px-4 py-2 hover:bg-[#01995f]">
              Empleados
            </RouterLink>
          </li>
          <li>
            <RouterLink to="/ReportMaintenance" class="block px-4 py-2 hover:bg-[#01995f]">
              Mantenimientos
            </RouterLink>
          </li>
          <li>
            <RouterLink to="/ReportAlquiler" class="block px-4 py-2 hover:bg-[#01995f]">
              Alquileres
            </RouterLink>
          </li>
        </ul>
      </div>
        <RouterLink class="sidebar-item flex items-center py-3 px-6" to="/Alertas">Alertas</RouterLink>
        <li>
        </li>
        <li>
          <RouterLink class="sidebar-item flex items-center py-3 px-6" to="/Mantenace">Mantenimientos</RouterLink>
        </li>
        <li>
          <a href="#" class="sidebar-item flex items-center py-3 px-6 "   
          >Alquiler</a
          >
        </li>
      </ul>
    </nav>
  </aside>
</template>

<script setup>
import { RouterLink } from 'vue-router';
import { ref } from "vue";

const showReports = ref(false);

function toggleReports() {
  showReports.value = !showReports.value;
}
</script>

<style lang="scss" scoped>
.sidebar-item {
  padding-left: 6px;
  display: flex;
  transition:
    background-color 0.3s,
    transform 0.3s;
  height: 50px;
  &:hover {
    background-color: #01995f; // Cambia el color de fondo al pasar el ratón
    transform: translateX(5px); // Desplaza ligeramente el elemento a la derecha
  }
}
// CSS Custom Properties
:root {
  --sidebar-width-collapsed: calc(2rem + 32px);
  --sidebar-width-expanded: 250px;
  --sidebar-transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  --sidebar-bg: var(--dark, #1a1a1a);
  --sidebar-text: var(--light, #ffffff);
  --sidebar-primary: var(--primary, #3b82f6);
  --sidebar-hover-bg: var(--dark-alt, #2a2a2a);
  --sidebar-border-radius: 8px;
  --sidebar-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
}

.sidebar {
  position: relative;
  display: flex;
  flex-direction: column;
  background-color: var(--sidebar-bg);
  color: var(--sidebar-text);
  width: var(--sidebar-width-collapsed);

  padding: 1rem;
  transition: var(--sidebar-transition);
  z-index: 1000;
  box-shadow: var(--sidebar-shadow);

  // Expanded state
  &.is-expanded {
    width: var(--sidebar-width-expanded);

    .toggle-icon {
      transform: rotate(180deg);
    }
  }

  // Mobile responsive
  @media (max-width: 768px) {
    position: fixed;
    left: 0;
    top: 0;
    z-index: 999;
    transform: translateX(calc(-100% + var(--sidebar-width-collapsed)));

    &.is-expanded {
      transform: translateX(0);
    }
  }
}

// 
// Print styl
</style>
