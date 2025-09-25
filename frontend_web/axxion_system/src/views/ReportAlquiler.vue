<template>
    <div class="app flex">
        <SideBar />
        <RouterView />
        <main class="container h-screen p-4 flex-1 overflow-y-auto flex flex-col">
            <headerP />
            <h1 class="text-3xl font-bold mb-6 text-black">Reportes de Alquileres</h1>
            <select v-model="selected" class="bg-gray-800  rounded-xl text-amber-50">
            <option class="rounded-xl text-amber-50" disabled value="">Selecciona un gráfico</option>
            <option>lineBar</option>
            <option>barChart</option>
            <option>pieGraph</option>
            </select>
            <p>Selected: {{ selected }}</p>
            <div v-if="currentComponent" class="flex-1 mt-4">
                <component :is="currentComponent" :items="filteredItems" :metrics="metrics" :mode-prop="modeProp"/>
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import SideBar from '@/components/SideBar.vue'
import headerP from '@/components/headerP.vue'
import { RouterView } from 'vue-router'
import * as echarts from 'echarts';
import { FwbCard } from 'flowbite-vue'
import LineBar from '@/components/LineBar.vue'
import { FwbSelect } from 'flowbite-vue'
import BarChart from '@/components/BarChart.vue';   
import { PieChart } from 'echarts/charts';
import PieGraph from '@/components/PieGraph.vue';
import InventoryService from '@/services/InventoryService'
import ReportService from '@/services/ReportService'

const lineal = ref(LineBar)
const Barras = ref(BarChart)
const Pastel = ref(PieGraph)

const selected = ref('lineBar')

// flowbite select espera objetos con propiedades en minúscula; usar 'value' y 'label'


// mapa de identificadores a componentes (añadir más si se crean otros componentes)
const componentsMap = {
    lineBar: LineBar,
    barChart: BarChart,
    pieGraph: PieGraph,
}
const currentComponent = computed(() => componentsMap[selected.value] || null)

// datos que podemos pasar a los componentes reutilizables
const items = ref([])
const metrics = ref(null)
const loading = ref(true)
const loadError = ref(null)
const selectedCategory = ref('')
const dateFrom = ref('')
const dateTo = ref('')
const categories = ref([])
const filteredItems = ref([])
const modeProp = ref('all')

onMounted(async () => {
    loading.value = true
    loadError.value = null
    try {
        const [fetchedItems, fetchedMetrics] = await Promise.all([
            InventoryService.getProducts(),
            ReportService.getMetrics()
        ])
        items.value = Array.isArray(fetchedItems) ? fetchedItems : []
        metrics.value = fetchedMetrics || null
    } catch (err) {
        console.error('Error cargando datos en ReportAlquiler:', err)
        loadError.value = err
    } finally {
        loading.value = false
    }
        // extraer categorías únicas
        categories.value = Array.from(new Set(items.value.map(i => i.categoria).filter(Boolean)))
        // inicializar filteredItems
        filteredItems.value = items.value.slice()
})

function applyFilters() {
    let result = items.value.slice()
    if (selectedCategory.value) {
        result = result.filter(i => i.categoria === selectedCategory.value)
    }
    if (dateFrom.value) {
        const from = new Date(dateFrom.value)
        result = result.filter(i => i.fecha ? new Date(i.fecha) >= from : true)
    }
    if (dateTo.value) {
        const to = new Date(dateTo.value)
        result = result.filter(i => i.fecha ? new Date(i.fecha) <= to : true)
    }
    filteredItems.value = result
}

function resetFilters() {
    selectedCategory.value = ''
    dateFrom.value = ''
    dateTo.value = ''
    filteredItems.value = items.value.slice()
}

</script>

<style >
.fwb-select, .fwb-select select, .fwb-select option, .fwb-select .fwbdropdown {
  color: #f9fafb !important;       /* texto visible en dark */
  background-color: #111827 !important; /* fondo oscuro */
}

/* opción seleccionada resaltada */
.fwb-select option:checked {
  background-color: #2563eb !important; /* azul seleccionado */
  color: #ffffff !important;
}
</style>

