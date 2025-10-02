<template>
    <section>
        <div class="flex justify-end mb-4 font-bold">
            <fwb-button
                gradient="green"
                @click="showModal"
                class="px-4 py-2"
            >
                <font-awesome-icon icon="fa-solid fa-file-export" style="color: #ffffff;" class="mr-2"/>
                Exportar a Excel
            </fwb-button>
        </div>
        <fwb-modal v-if="isShowModal" @close="closeModal">
            <template #header>
                <div class="flex items-center text-lg font-bold text-white">
                    Exportar Datos a Excel
                </div>
            </template>
            <template #body>
                <h3 class="mb-3 font-semibold text-amber-50">Seleccione columnas a exportar:</h3>
                <div class="flex items-center gap-2 mb-2 text-amber-50">
                    <input type="checkbox" v-model="selectAll" @change="toggleSelectAll" />
                    <label class="font-semibold">Seleccionar todos</label>
                </div>
                <div v-for="col in columnasDisponibles" :key="col.value" class="flex items-center gap-2 mb-1 text-amber-50">
                    <input type="checkbox" v-model="columnasSeleccionadas" :value="col.value" />
                    <label>{{ col.label }}</label>
                </div>
            </template>
            <template #footer>
                <div class="flex justify-between w-full">
                    <fwb-button @click="closeModal" color="red">
                        Cancelar
                    </fwb-button>
                    <fwb-button @click="confirmExport" color="green">
                        Aceptar
                    </fwb-button>
                </div>
            </template>
        </fwb-modal>
    </section>
</template>

<script setup>
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import InventarioService from "@/services/InventoryService"; 
import { ref, onMounted } from 'vue'
import { FwbButton, FwbModal } from 'flowbite-vue'

const isShowModal = ref(false)
const inventario = ref([])


const columnasDisponibles = ref([
    { value: "id", label: "ID"},
    { value: "nombre", label: "Nombre"},
    { value: "descripcion", label: "Descripción"},
    { value: "marca", label: "Marca"},
    { value: "modelo", label: "Modelo"},
    { value: "precio_referencia_renta", label: "Precio Referencia Renta"},
    { value: "precio_alquiler_dia", label: "Precio Alquiler Día"},
    { value: "precio_alquiler_semanal", label: "Precio Alquiler Semanal"},
    { value: "precio_alquiler_mensual", label: "Precio Alquiler Mensual"},
    { value: "precio_compra", label: "Precio Compra"},
    { value: "valor_actual", label: "Valor Actual"},
    { value: "fecha_compra", label: "Fecha Compra"},
    { value: "condicion", label: "Condición"},
    { value: "ubicacion", label: "Ubicación"},
    { value: "notas", label: "Notas"},
    { value: "sku", label: "SKU"},
    { value: "numero_serie", label: "Número de Serie"},
    { value: "categoria", label: "Categoría"},
    { value: "especificaciones", label: "Especificaciones"},
    { value: "estado", label: "Estado"}
])

const columnasSeleccionadas = ref([])

const selectAll = ref(false)

const showModal = () => { isShowModal.value = true }
const closeModal = () => { isShowModal.value = false }

const loadInventario = async () => {
    try {
        const data = await InventarioService.getProducts(); 
        inventario.value = Array.isArray(data) ? data : data.data || [];
    } catch (err) {
    console.error("Error cargando inventario:", err);
    }
};
onMounted(() => loadInventario())

const toggleSelectAll = () => {
    if (selectAll.value) {
        columnasSeleccionadas.value = columnasDisponibles.value.map(c => c.value)
    } else {
        columnasSeleccionadas.value = []
    }
}

const confirmExport = () => {
    if (!columnasSeleccionadas.value.length) {
        alert("Seleccione al menos una columna");
        return;
    }

const exportData = inventario.value.map(item => {
    let obj = {};
    columnasSeleccionadas.value.forEach(col => {
        obj[col] = item[col] ?? "";
    });
    return obj;
});

const worksheet = XLSX.utils.json_to_sheet(exportData, { header: columnasSeleccionadas.value });
const workbook = XLSX.utils.book_new();
XLSX.utils.book_append_sheet(workbook, worksheet, "Inventario");

const excelBuffer = XLSX.write(workbook, { bookType: "xlsx", type: "array" });
const blob = new Blob([excelBuffer], { type: "application/octet-stream" });
saveAs(blob, "inventario_filtrado.xlsx");

closeModal(); 
};
</script>



