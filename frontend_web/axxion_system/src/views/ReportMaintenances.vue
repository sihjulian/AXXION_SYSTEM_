<template>
  <div class="App flex">
    <SideBar />
    <main class="container h-screen p-4 flex-1 overflow-y-auto">
      <headerP />
      <div class="flex flex-row justify-between">
        <h1 class="text-3xl font-bold mb-6 text-black">Reportes de Mantenimientos</h1>
        <WorksheetMant />
      </div>

      <!-- Tarjeta costo total -->
      <section class="flex flex-wrap gap-6 mb-6">
        <fwb-card class="flex-1 min-w-[300px] bg-gray-800 text-amber-50">
          <div class="p-5">
            <h5 class="mb-2 text-2xl font-bold">Costo Total de Mantenimientos</h5>
            <p class="text-3xl font-bold text-green-400">
              $ {{ costoTotal.toLocaleString() }}
            </p>
          </div>
        </fwb-card>

        <!-- Gráfico por estado -->
        <fwb-card class="flex-1 min-w-[300px] bg-gray-800 text-amber-50">
          <div class="p-5">
            <h5 class="mb-2 text-2xl font-bold">Mantenimientos por Estado</h5>
            <v-chart :option="chartByEstado" style="height: 250px;" autoresize />
          </div>
        </fwb-card>
      </section>

      <!-- Tabla mantenimientos -->
      <section class="bg-white rounded-md shadow-md p-4">
        <h2 class="text-xl font-bold mb-4">Detalle de Mantenimientos</h2>
        <div class="overflow-x-auto">
          <table class="w-full text-sm text-left text-gray-700 border">
            <thead class="bg-gray-200 text-gray-900">
              <tr>
                <th class="p-2 border">Fecha Inicio</th>
                <th class="p-2 border">Prevista</th>
                <th class="p-2 border">Fin Real</th>
                <th class="p-2 border">Tipo</th>
                <th class="p-2 border">Costo Estimado</th>
                <th class="p-2 border">Costo Real</th>
                <th class="p-2 border">Estado</th>
                <th class="p-2 border">Responsable</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="m in mantenimientos" :key="m.id" class="hover:bg-gray-100">
                <td class="p-2 border">{{ m.fecha_inicio }}</td>
                <td class="p-2 border">{{ m.fecha_fin_prevista }}</td>
                <td class="p-2 border">{{ m.fecha_fin_real || '-' }}</td>
                <td class="p-2 border">{{ m.tipo_mantenimiento }}</td>
                <td class="p-2 border">$ {{ m.costo_estimado }}</td>
                <td class="p-2 border">$ {{ m.costo_real }}</td>
                <td class="p-2 border">
                  <span
                    :class="{
                      'text-blue-600 font-bold': m.estado_mantenimiento === 'Programado',
                      'text-yellow-600 font-bold': m.estado_mantenimiento === 'EnProceso',
                      'text-green-600 font-bold': m.estado_mantenimiento === 'Finalizado',
                      'text-red-600 font-bold': m.estado_mantenimiento === 'Cancelado'
                    }"
                  >
                    {{ m.estado_mantenimiento }}
                  </span>
                </td>
                <td class="p-2 border">{{ m.responsable }}</td>
              </tr>
            </tbody>
          </table>
        </div>
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
import { PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, LegendComponent } from 'echarts/components'
import ReportService from '@/services/ReportService'
import WorksheetMant from '@/components/WorksheetMant.vue'


use([CanvasRenderer, PieChart, TitleComponent, TooltipComponent, LegendComponent])

/**
 * Vista ReportMaintenances.
 * 
 * Genera reportes detallados sobre las actividades de mantenimiento.
 * Funcionalidades:
 * - Visualización del costo total de mantenimientos.
 * - Gráfico circular (Pie Chart) de mantenimientos por estado.
 * - Tabla detallada con información de costos, fechas, tipos y responsables.
 * - Exportación de datos a Excel mediante WorksheetMant.
 */

const mantenimientos = ref([])
const costoTotal = ref(0)
const chartByEstado = ref({})
const mantenimiento = ref([]);

// cargar datos
// Obtiene los mantenimientos del servicio, calcula costos totales y prepara datos para el gráfico.
onMounted(async () => {
  try {
    const response = await ReportService.getMaintenances()
    const data = response.data

    mantenimientos.value = data

    // calcular costo total
    costoTotal.value = data.reduce((acc, m) => acc + (parseFloat(m.costo_real) || 0), 0)

    // agrupar por estado
    const estados = data.reduce((acc, m) => {
      acc[m.estado_mantenimiento] = (acc[m.estado_mantenimiento] || 0) + 1
      return acc
    }, {})

    chartByEstado.value = {
      tooltip: { trigger: 'item' },
      legend: { top: '5%', left: 'center' },
      series: [
        {
          name: 'Mantenimientos',
          type: 'pie',
          radius: '60%',
          data: Object.entries(estados).map(([name, value]) => ({ name, value }))
        }
      ]
    }
  } catch (error) {
    console.error('Error cargando mantenimientos:', error)
  }
})
</script>
