<template>
    <div>
        <section class="flex flex-wrap justify-center gap-12">
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
            <fwb-card class="w-sm flex-1 min-w-[300px] bg-linear-to-br from-[#9914fb] to-[#ac45ff]">
                <div class="p-5">
                    <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900  dark:text-white">
                        Valor Total del Inventario
                    </h5>
                    <p class="text-3xl font-extrabold text-white flex justify-between">
                        <b>
                            ${{ valorTotal.toLocaleString() }}
                        </b>
                        <b class="bg-[#b254ff] rounded-full p-2">
                            <font-awesome-icon icon="fa-solid fa-dollar-sign" />
                        </b>
                    </p>
                </div>
            </fwb-card>
        </section>
        <br>
        <section>
            <select v-model="selected" class="bg-gray-800  rounded-xl text-amber-50 container">
                <option disabled value="">Selecciona un gráfico</option>
                <option>Lineal</option>
                <option>Barra</option>
                <option>Pastel</option>
            </select>
        </section>
        <br>
        <section class="flex flex-wrap gap-6">
            <article class="bg-gray-800 shadow-2xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                <h2 class="font-bold text-2xl mb-4">Alquileres Totales</h2>
                <div v-if="isLoading" class="justify-items-center"><span class="loader"></span></div>
                <div v-else-if="error" class="text-red-500">{{ error }}</div>
                <v-chart :option="chartOptionByAlq" style="height: 300px;" autoresize/>
            </article>
            <article class="bg-gray-800 shadow-2xl/30 text-white rounded-md p-4 flex-1 min-w-[450px]">
                <h2 class="font-bold text-2xl mb-4">Valor total de los Alquileres</h2>
                <div v-if="isLoading" class="justify-items-center"><span class="loader"></span></div>
                <div v-else-if="error" class="text-red-500">{{ error }}</div>
                <v-chart :option="chartOptionByValues" style="height: 300px;" autoresize/>
            </article>
        </section>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { FwbCard } from 'flowbite-vue'
import ReportService from '@/services/ReportService';
import RentalService from '@/services/RentalService';
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart, BarChart, LineChart } from 'echarts/charts'
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

const itemsTotales = ref(0)
const valorTotal = ref(0)
const selected = ref('')
const isLoading = ref(true);
const error = ref(null);
const chartOptionByAlq = ref({})
const chartOptionByValues = ref({})

onMounted(async () => {
    try {
        isLoading.value = true;
        const data = await ReportService.getMetricsAlq()
        itemsTotales.value = data.items_totales
        valorTotal.value = data.valor_total
        const alqs = await RentalService.getRental()
        console.log('Alquiler (renta):', alqs);

        // const alquileres = {}
        // const valores = {}

        (alqs || []).array.forEach(alq => {
            const alquiler = alq.alquiler || 'Sin alquiler';
            alquileres[alquiler] = (alquileres[alquiler] || 0) + 1;
            valores[alquiler] = (valores[alquiler] || 0) + parseFloat(alq.monto_total_renta || 0);
        });

        


    } catch(error) {
        console.error('Error cargando métricas:', error)
    } finally{
        isLoading.value = false;
    }
})
</script>

<style scoped>

</style>
