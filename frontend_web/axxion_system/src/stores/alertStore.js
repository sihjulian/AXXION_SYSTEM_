import { defineStore } from 'pinia';
import AlertService from '@/services/AlertService';

export const useAlertStore = defineStore('alerts', {
    state: () => ({
        alertas: [],
        filtros: ["Todas", "Inventario", "Mantenimiento", "Alquiler"],
        filtroActivo: "Todas",
        isLoading: false, 
        error: null,   
    }),
    getters: {
        alertasFiltradas: (state) => {
            if (state.filtroActivo === "Todas") {
                return state.alertas;
            }
            return state.alertas.filter((alerta) => alerta.tipo === state.filtroActivo);
        },
    },
    actions: {
        async fetchAlerts() {
            this.isLoading = true;
            this.error = null;
            try {
                const data = await AlertService.getAlerts();
                this.alertas = data;
            } catch (e) {
                console.error("Error cargando alertas:", e);
                this.error = "No se pudieron cargar las alertas.";
            } finally {
                this.isLoading = false;
            }
        },
        setFiltroActivo(filtro) {
            if (this.filtros.includes(filtro)) {
                this.filtroActivo = filtro;
            }
        },
    },
});