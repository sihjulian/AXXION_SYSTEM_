<template>
    <div>
        <section class="flex flex-wrap gap-6">
            <fwb-card class="w-sm flex-1 min-w-[300px] bg-linear-to-br from-[#00c54e] to-[#01a93f]">
                <div class="p-5">
                    <h5 class="mb-2 text-lg font-bold tracking-tight text-gray-900  dark:text-white">
                        Items Totales
                    </h5>
                    <p class="text-4xl font-extrabold text-white flex justify-between">
                        <a>
                            {{ itemsTotales }}
                        </a>
                        <a class="bg-[#32c36a] rounded-full p-2">
                            <font-awesome-icon icon="fa-solid fa-cubes" />
                        </a>
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
        <h4>Selecciona un gráfico</h4>
        <select v-model="selected" class="bg-gray-800  rounded-xl text-amber-50 container">
                <option class="rounded-xl text-amber-50 container" disabled value="">Selecciona un gráfico</option>
                <option>Lineal</option>
                <option>Barra</option>
                <option>Pastel</option>
            </select>
        <br><br>
        <div v-if="selected === 'Lineal'">
            <section class="flex flex-wrap gap-6">
                <!-- Gráfico por Categoría -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Equipos por Categoría</h2>
                    <v-chart :option="chartByCategory" style="height: 300px;" autoresize />
                </article>
                <!-- Gráfico por Valor -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md pl-4 p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Valor Total por Categoría</h2>
                    <v-chart :option="chartByValue" style="height: 300px;" autoresize />
                </article>
                <!-- Gráfico por Condicion -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Equipos por Condición</h2>
                    <v-chart :option="chartByCondition" style="height: 300px;" autoresize />
                </article>    
            </section>
        </div>
        <div v-else-if="selected === 'Barra'">
            <section class="flex flex-wrap gap-6">
                <!-- Gráfico por Categoría -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Equipos por Categoría</h2>
                    <v-chart :option="chartByCategoryB" style="height: 300px;" autoresize />
                </article>
                <!-- Gráfico por Valor -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md pl-4 p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Valor Total por Categoría</h2>
                    <v-chart :option="chartByValueB" style="height: 300px;" autoresize />
                </article>
                <!-- Gráfico por Condicion -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Equipos por Condición</h2>
                    <v-chart :option="chartByConditionB" style="height: 300px;" autoresize />
                </article>    
            </section>
        </div>
        <div v-else-if="selected === 'Pastel'">
            <section class="flex flex-wrap gap-6">
                <!-- Gráfico por Categoría -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Equipos por Categoría</h2>
                    <v-chart :option="chartByCategoryP" style="height: 300px;" autoresize />
                </article>
                <!-- Gráfico por Valor -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md pl-4 p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Valor Total por Categoría</h2>
                    <v-chart :option="chartByValueP" style="height: 300px;" autoresize />
                </article>
                <!-- Gráfico por Condicion -->
                <article class="bg-gray-800 shadow-xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                    <h2 class="font-bold text-2xl mb-4">Equipos por Condición</h2>
                    <v-chart :option="chartByConditionP" style="height: 300px;" autoresize />
                </article>    
            </section>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import InventoryService from '@/services/InventoryService'
import ReportService from '@/services/ReportService'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart, BarChart, LineChart } from 'echarts/charts'
import { FwbCard } from 'flowbite-vue'
import {
    TitleComponent,
    TooltipComponent,
    LegendComponent,
    GridComponent
} from 'echarts/components'

use([
    CanvasRenderer,
    PieChart,
    BarChart,
    LineChart,
    TitleComponent,
    TooltipComponent,
    LegendComponent,
    GridComponent
])

const chartByCategory = ref({})
const chartByCategoryP = ref({})
const chartByCategoryB = ref({})
const chartByValue = ref({})
const chartByValueB = ref({})
const chartByValueP = ref({})
const chartByCondition = ref({})
const chartByConditionB = ref({})
const chartByConditionP = ref({})
const itemsTotales = ref(0)
const valorTotal = ref(0)
const equiposDisponibles = ref(0)
const selected = ref('Lineal')



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

    // GRAFICOS LINEALES

    // EQUIPOS POR CATEGORIA

    chartByCategory.value = {
        tooltip: { 
            trigger: 'axis', 
            axisPointer: {
                type: 'cross',
                label: {
                    backgroundColor: '#6a7985'
                }
            } 
        },
        legend: { 
            top: '5%', 
            left: 'center',
            textStyle: {
                color: "rgba(255, 255, 255)"
            }
        },
        xAxis: {  
            boundaryGap: false,
            type: 'category', data: Object.keys(categorias), 
            axisLine: {
                lineStyle: {
                    color: "rgba(255, 255, 255)"
            }
    }
        },
        yAxis: { 
            type: 'value',
            splitLine: {
                lineStyle: {
                    color: "rgba(255, 255, 255)"
                }
            }
        },
        axisLabel: {
            color: "rgba(255, 255, 255)"
        },
        series: [
            {
            name: 'Equipos',
            type: 'line',
            stack: 'Total',
            areaStyle: {
                color: "rgba(99, 23, 250)"
            },
            emphasis: {
                focus: 'series'
            },
            data: Object.values(categorias),
            colorBy: "series"
            }
        ]
        
    }

    // VALOR TOTAL

    chartByValue.value = {
        tooltip: { 
            trigger: 'axis', 
            axisPointer: {
                type: 'cross',
                label: {
                    backgroundColor: '#6a7985'
                }
            } 
        },
        legend: { 
            top: '5%', 
            left: 'center',
            textStyle: {
                color: "rgba(255, 255, 255)"
            }
        },
        xAxis: {  
            boundaryGap: false,
            type: 'category', data: Object.keys(valores), 
            axisLine: {
                lineStyle: {
                    color: "rgba(255, 255, 255)"
            }
    }
        },
        yAxis: { 
            type: 'value',
            splitLine: {
                lineStyle: {
                    color: "rgba(255, 255, 255)"
                }
            }
        },
        axisLabel: {
            color: "rgba(255, 255, 255)"
        },
        series: [
            {
            name: 'Equipos',
            type: 'line',
            stack: 'Total',
            areaStyle: {
                color: "rgba(250, 212, 23)"
            },
            emphasis: {
                focus: 'series'
            },
            data: Object.values(valores),
            colorBy: "series"
            }
        ]
    }

    // EQUIPOS POR CONDICION

    chartByCondition.value = {
        tooltip: { 
            trigger: 'axis', 
            axisPointer: {
                type: 'cross',
                label: {
                    backgroundColor: '#6a7985'
                }
            } 
        },
        legend: { 
            top: '5%', 
            left: 'center',
            textStyle: {
                color: "rgba(255, 255, 255)"
            }
        },
        xAxis: {  
            boundaryGap: false,
            type: 'category', data: Object.keys(condiciones), 
            axisLine: {
                lineStyle: {
                    color: "rgba(255, 255, 255)"
            }
    }
        },
        yAxis: { 
            type: 'value',
            splitLine: {
                lineStyle: {
                    color: "rgba(255, 255, 255)"
                }
            }
        },
        axisLabel: {
            color: "rgba(255, 255, 255)"
        },
        series: [
            {
            name: 'Equipos',
            type: 'line',
            stack: 'Total',
            areaStyle: {
                color: "rgba(61, 250, 23)"
            },
            emphasis: {
                focus: 'series'
            },
            data: Object.values(condiciones),
            colorBy: "series"
            }
        ]
    }

    // GRAFICO DE BARRAS

    chartByCategoryB.value = {
        tooltip: { 
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        xAxis: { type: 'category', data: Object.keys(categorias) },
        yAxis: { type: 'value' },
        series: [
            {
                data: Object.values(categorias),
                type: 'bar',
                itemStyle: { color: '#FA15DF' }
            }
        ]
    }
    chartByValueB.value = {
        tooltip: { 
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        xAxis: { type: 'category', data: Object.keys(valores) },
        yAxis: { type: 'value' },
        series: [
            {
                data: Object.values(valores),
                type: 'bar',
                itemStyle: { color: '#6317FA' }
            }
        ]
    }
    chartByConditionB.value = {
        tooltip: { 
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        xAxis: { type: 'category', data: Object.keys(condiciones) },
        yAxis: { type: 'value' },
        series: [
            {
                data: Object.values(condiciones),
                type: 'bar',
                itemStyle: { color: '#3DFA17' }
            }
        ]
    }

    // GRAFICOS DE PASTEL

    chartByCategoryP.value = {
        tooltip: { trigger: 'item' },
        legend: { 
            top: '5%', 
            left: 'center',
            textStyle: {
                color: "rgba(255, 255, 255)"
            }
        },
        series: [
            {
            name: 'Equipos',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            padAngle: 5,
            itemStyle: {
                borderRadius: 10,
                borderColor: '#121212',
                borderWidth: 1
            },
            label: {
                show: false,
                position: 'center'
            },
            emphasis: {
                label: {
                    show: true,
                    fontSize: 20,
                    fontWeight: 'bold'
                }
            },
            labelLine: {
                show: false
            },
            data: Object.entries(categorias).map(([name, value]) => ({ name, value }))
            }
        ]
        
    }
    chartByValueP.value = {
        tooltip: { trigger: 'item' },
        legend: { 
            top: '5%', 
            left: 'center',
            textStyle: {
                color: "rgba(255, 255, 255)"
            }
        },
        series: [
            {
            name: 'Equipos',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            padAngle: 5,
            itemStyle: {
                borderRadius: 10,
                borderColor: '#121212',
                borderWidth: 1
            },
            label: {
                show: false,
                position: 'center'
            },
            emphasis: {
                label: {
                    show: true,
                    fontSize: 20,
                    fontWeight: 'bold'
                }
            },
            labelLine: {
                show: false
            },
            data: Object.entries(valores).map(([name, value]) => ({ name, value }))
            }
        ]
        
    }
    chartByConditionP.value = {
        tooltip: { trigger: 'item' },
        legend: { 
            top: '5%', 
            left: 'center',
            textStyle: {
                color: "rgba(255, 255, 255)"
            }
        },
        series: [
            {
            name: 'Equipos',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            padAngle: 5,
            itemStyle: {
                borderRadius: 10,
                borderColor: '#121212',
                borderWidth: 1
            },
            label: {
                show: false,
                position: 'center'
            },
            emphasis: {
                label: {
                    show: true,
                    fontSize: 20,
                    fontWeight: 'bold'
                }
            },
            labelLine: {
                show: false
            },
            data: Object.entries(condiciones).map(([name, value]) => ({ name, value }))
            }
        ]
        
    }

} catch (error) {
    console.error('Error cargando inventario:', error)
}
})

</script>