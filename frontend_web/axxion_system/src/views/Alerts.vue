<template>
    <div class="App flex">
        <SideBar />
        <main class="container h-screen p-4 flex-1 overflow-y-auto text-white">
      <headerP />
      <h1 class="text-3xl font-bold mb-6">Alertas del Sistema</h1>

      <!-- Filtros -->
      <div class="flex gap-4 mb-6">
        <button 
          v-for="f in filtros" 
          :key="f"
          @click="filtroActivo = f"
          :class="['px-4 py-2 rounded', filtroActivo === f ? 'bg-blue-600' : 'bg-gray-700']"
        >
          {{ f }}
        </button>
      </div>

      <!-- Tarjetas -->
      <div class="space-y-4">
        <div
          v-for="(a, i) in alertasFiltradas"
          :key="i"
          class="p-4 rounded-md"
          :class="{
            'bg-red-900': a.nivel === 'Crítica',
            'bg-yellow-800': a.nivel === 'Advertencia',
            'bg-blue-800': a.nivel === 'Informativa'
          }"
        >
        <div class="flex justify-between items-center mb-2">
            <span class="font-bold">{{ a.nivel }}</span>
            <span class="text-sm text-gray-300">{{ formatDate(a.fecha) }}</span>
          </div>
          <h2 class="text-xl font-semibold">{{ a.titulo }}</h2>
          <p class="text-gray-200">{{ a.mensaje }}</p>
          <div class="mt-2 text-sm bg-gray-700 px-2 py-1 rounded inline-block">
            {{ a.referencia }}
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import SideBar from "@/components/SideBar.vue";
import headerP from "@/components/headerP.vue";
import AlertService from "@/services/AlertService";

const alertas = ref([]);
const filtroActivo = ref("Todas");
const filtros = ["Todas", "Inventario", "Mantenimiento", "Alquiler"];


const cargarAlertas = async () => {
    try {
        alertas.value = await AlertService.getAlerts();
    } catch (e) {
        console.error("Error cargando alertas:", e);
    }
};

const alertasFiltradas = computed(() => {
    if (filtroActivo.value === "Todas") return alertas.value;
    return alertas.value.filter((a) => a.tipo === filtroActivo.value);
});

const formatDate = (date) => new Date(date).toLocaleString();

onMounted(cargarAlertas);
</script>
