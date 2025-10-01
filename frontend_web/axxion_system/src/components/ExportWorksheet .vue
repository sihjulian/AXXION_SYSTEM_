<template>
    <section>
        <div class="flex justify-end mb-4 font-bold">
            <fwb-button
                gradient="green"
                @click="exportInventarioExcel"
                class="px-4 py-2 "
            >
            <font-awesome-icon icon="fa-solid fa-file-export" style="color: #ffffff;" class="mr-2"/>
            Exportar a Excel
            </fwb-button>
        </div>
    </section>
</template>

<script setup>
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import InventarioService from "@/services/InventoryService"; 
import { ref, onMounted } from 'vue'
import { FwbButton } from 'flowbite-vue'

const inventario = ref([]);

const loadInventario = async () => {
    try {
        const data = await InventarioService.getProducts(); 
        inventario.value = Array.isArray(data) ? data : data.data || [];
    } catch (err) {
        console.error("Error cargando inventario:", err);
    }
};

const exportInventarioExcel = () => {
    if (!inventario.value.length) {
        alert("No hay datos en inventario");
        return;
    }

const exportData = inventario.value.map(item => ({
    ID: item.id,
    Nombre: item.nombre,
    Marca: item.marca,
    Modelo: item.modelo,
    "Precio Compra": item.precio_compra,
    "Valor Actual": item.valor_actual,
    "Fecha Compra": item.fecha_compra,
    Estado: item.estado,
    Ubicación: item.ubicacion,
    SKU: item.sku,
    "Número Serie": item.numero_serie,
    Notas: item.notas
}));

const worksheet = XLSX.utils.json_to_sheet(exportData);

const workbook = XLSX.utils.book_new();
XLSX.utils.book_append_sheet(workbook, worksheet, "Inventario");

const excelBuffer = XLSX.write(workbook, { bookType: "xlsx", type: "array" });
const blob = new Blob([excelBuffer], { type: "application/octet-stream" });

saveAs(blob, "reporte_inventario.xlsx");
};

onMounted(() => {
    loadInventario();
});
</script>
