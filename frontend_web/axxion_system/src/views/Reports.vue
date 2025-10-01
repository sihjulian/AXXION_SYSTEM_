<template>
  <div class="App flex">
    <SideBar />
    <main class="container h-screen p-4 flex-1 overflow-y-auto flex flex-col">
      <headerP />
      <div class="flex flex-row justify-between">
        <h1 class="text-3xl font-bold mb-6 text-black">Reportes de Inventario</h1>
        <section>
                <div class="flex justify-end mb-4">
                    <ExportWorksheet
                    filename="inventario.xlsx"
                    sheetName="Inventario"
                    :data="inventario"
                    :columns="[
                    { key: 'id', label: 'ID' },
                    { key: 'nombre', label: 'Nombre' },
                    { key: 'marca', label: 'Marca' },
                    { key: 'modelo', label: 'Modelo' },
                    { key: 'estado', label: 'Estado' },
                    { key: 'ubicacion', label: 'Ubicación' },
                    ]"
                />
                </div>
            </section>
      </div>
    <section class="flex flex-wrap gap-6">
        <fwb-card class="w-sm flex-1 min-w-[300px] ">
            <div class="p-5">
                <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900  dark:text-white">
                    Items Totales
                </h5>
                <p class="text-4xl font-extrabold text-blue-600 dark:text-blue-400">
                    {{ itemsTotales }}
                </p>
            </div>
        </fwb-card>
        <fwb-card class="w-sm flex-1 min-w-[300px]">
            <div class="p-5">
                <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900  dark:text-white">
                    Valor Total del Inventario
                </h5>
                <p class="text-4xl font-extrabold text-emerald-600 dark:text-emerald-400">
                    ${{ valorTotal.toLocaleString() }}
                </p>
            </div>
        </fwb-card>
        <fwb-card class="w-sm flex-1 min-w-[300px]">
            <div class="p-5">
                <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900  dark:text-white">
                    Equipos disponibles
                </h5>
                <p class="text-4xl font-extrabold text-indigo-600 dark:text-indigo-400">
                    {{ equiposDisponibles }}
                </p>
            </div>
        </fwb-card>
    </section>
<br><br>
    <section class="flex flex-wrap gap-6">
        <!-- Gráfico por Categoría -->
        <article class="bg-gray-200 shadow-xl/30 text-black rounded-md p-4 flex-1 min-w-[300px]">
            <h2 class="font-bold text-2xl mb-4">Equipos por Categoría</h2>
            <v-chart :option="chartByCategory" style="height: 300px;" autoresize />
        </article>
        <!-- Gráfico por Valor -->
        <article class="bg-gray-800 shadow-xl/30 text-amber-50 rounded-md pl-4 p-4 flex-1 min-w-[300px]">
            <h2 class="font-bold text-2xl mb-4">Valor Total por Categoría</h2>
            <v-chart :option="chartByValue" style="height: 300px;" autoresize />
        </article>
        <!-- Gráfico por Condicion -->
        <article class="bg-gray-200 shadow-xl/30 text-black rounded-md p-4 flex-1 min-w-[300px]">
            <h2 class="font-bold text-2xl mb-4">Equipos por Condición</h2>
            <v-chart :option="chartByCondition" style="height: 300px;" autoresize />
        </article>
        
    </section>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import SideBar from '@/components/SideBar.vue'
import headerP from '@/components/headerP.vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart, BarChart } from 'echarts/charts'
import { FwbCard } from 'flowbite-vue'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'
import InventoryService from '@/services/InventoryService'
import ReportService from '@/services/ReportService'

import ExportWorksheet from '@/components/ExportWorksheet .vue'

use([
  CanvasRenderer,
  PieChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

const chartByCategory = ref({})
const chartByValue = ref({})
const chartByCondition = ref({})
const inventario = ref([])
const itemsTotales = ref(0)
const valorTotal = ref(0)
const equiposDisponibles = ref(0)
onMounted(async () => {
    try {
        const data = await ReportService.getMetrics()
        itemsTotales.value = data.items_totales
        valorTotal.value = data.valor_total
        equiposDisponibles.value = data.equipos_disponibles
    } catch (error) {
        console.error('Error cargando métricas:', error)
    }


  try {
const items = await InventoryService.getProducts() 
console.log('Inventario (productos):', items)


    console.log('Inventario (productos):', items)

    const categorias = {}
    const valores = {}
    const condiciones = {}

    items.forEach(item => {
        const categoria = item.categoria || 'Sin categoría'
        categorias[categoria] = (categorias[categoria] || 0) + 1
        valores[categoria] = (valores[categoria] || 0) + parseFloat(item.valor_actual || 0)
        const condicion = item.condicion || 'No definida'
        condiciones[condicion] = (condiciones[condicion] || 0) + 1
    })

    chartByCategory.value = {
        tooltip: { trigger: 'item' },
        legend: { top: '5%', left: 'center' },
        series: [
            {
            name: 'Equipos',
            type: 'pie',
            radius: '60%',
            data: Object.entries(categorias).map(([name, value]) => ({ name, value }))
            }
        ]
        
    }

    chartByValue.value = {
      tooltip: { trigger: 'axis' },
      xAxis: { type: 'category', data: Object.keys(valores) },
      yAxis: { type: 'value' },
      series: [
        {
          data: Object.values(valores),
          type: 'bar',
          itemStyle: { color: '#3b82f6' }
        }
      ]
    }

    chartByCondition.value = {
      tooltip: { trigger: 'item' },
      series: [
        {
          name: 'Condición',
          type: 'pie',
          radius: '60%',
          data: Object.entries(condiciones).map(([name, value]) => ({ name, value }))
        }
      ]
    }
  } catch (error) {
    console.error('Error cargando inventario:', error)
  }
})
</script>



