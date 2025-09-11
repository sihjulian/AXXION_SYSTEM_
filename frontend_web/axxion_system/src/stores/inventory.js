import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { inventoryService } from '@/services/InventoryService.js';

export const useInventoryStore = defineStore('inventory', () => {
  // Estado
  const equipment = ref([]);
  const isLoading = ref(false);
  const error = ref(null);
  const selectedEquipment = ref(null);

  // Getters computados
  const availableEquipment = computed(() => 
    equipment.value.filter(item => item.status === 'available')
  );

  const rentedEquipment = computed(() => 
    equipment.value.filter(item => item.status === 'rented')
  );

  const maintenanceEquipment = computed(() => 
    equipment.value.filter(item => item.status === 'maintenance')
  );

  const outOfServiceEquipment = computed(() => 
    equipment.value.filter(item => item.status === 'out_of_service')
  );

  const equipmentByCategory = computed(() => {
    const categories = {};
    equipment.value.forEach(item => {
      if (!categories[item.category]) {
        categories[item.category] = [];
      }
      categories[item.category].push(item);
    });
    return categories;
  });

  const totalEquipment = computed(() => equipment.value.length);

  const utilizationRate = computed(() => {
    if (totalEquipment.value === 0) return 0;
    return Math.round((rentedEquipment.value.length / totalEquipment.value) * 100);
  });

  const monthlyRevenue = computed(() => {
    return rentedEquipment.value.reduce((total, item) => {
      return total + (item.dailyRate * 30); // Estimación mensual
    }, 0);
  });

  // Acciones
  const fetchEquipment = async () => {
    isLoading.value = true;
    error.value = null;
    
    try {
      const data = await inventoryService.getEquipment();
      equipment.value = data;
    } catch (err) {
      error.value = err.message;
      console.error('Error al cargar equipos:', err);
    } finally {
      isLoading.value = false;
    }
  };

  const addEquipment = async (equipmentData) => {
    isLoading.value = true;
    error.value = null;
    
    try {
      const newEquipment = await inventoryService.createEquipment(equipmentData);
      equipment.value.push(newEquipment);
      return newEquipment;
    } catch (err) {
      error.value = err.message;
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const updateEquipment = async (id, equipmentData) => {
    isLoading.value = true;
    error.value = null;
    
    try {
      const updatedEquipment = await inventoryService.updateEquipment(id, equipmentData);
      const index = equipment.value.findIndex(item => item.id === id);
      if (index !== -1) {
        equipment.value[index] = updatedEquipment;
      }
      return updatedEquipment;
    } catch (err) {
      error.value = err.message;
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const deleteEquipment = async (id) => {
    isLoading.value = true;
    error.value = null;
    
    try {
      await inventoryService.deleteEquipment(id);
      equipment.value = equipment.value.filter(item => item.id !== id);
    } catch (err) {
      error.value = err.message;
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const getEquipmentById = (id) => {
    return equipment.value.find(item => item.id === id);
  };

  const getEquipmentByStatus = (status) => {
    return equipment.value.filter(item => item.status === status);
  };

  const getEquipmentByCategory = (category) => {
    return equipment.value.filter(item => item.category === category);
  };

  const searchEquipment = (query) => {
    const searchTerm = query.toLowerCase();
    return equipment.value.filter(item => 
      item.name.toLowerCase().includes(searchTerm) ||
      item.model.toLowerCase().includes(searchTerm) ||
      item.serialNumber.toLowerCase().includes(searchTerm) ||
      item.brand.toLowerCase().includes(searchTerm)
    );
  };

  const rentEquipment = async (equipmentId, rentalData) => {
    isLoading.value = true;
    error.value = null;
    
    try {
      const rental = await inventoryService.rentEquipment(equipmentId, rentalData);
      // Actualizar el estado del equipo
      const index = equipment.value.findIndex(item => item.id === equipmentId);
      if (index !== -1) {
        equipment.value[index].status = 'rented';
        equipment.value[index].currentRental = rental;
      }
      return rental;
    } catch (err) {
      error.value = err.message;
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const returnEquipment = async (equipmentId) => {
    isLoading.value = true;
    error.value = null;
    
    try {
      await inventoryService.returnEquipment(equipmentId);
      // Actualizar el estado del equipo
      const index = equipment.value.findIndex(item => item.id === equipmentId);
      if (index !== -1) {
        equipment.value[index].status = 'available';
        equipment.value[index].currentRental = null;
      }
    } catch (err) {
      error.value = err.message;
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const scheduleMaintenance = async (equipmentId, maintenanceData) => {
    isLoading.value = true;
    error.value = null;
    
    try {
      const maintenance = await inventoryService.scheduleMaintenance(equipmentId, maintenanceData);
      // Actualizar el estado del equipo
      const index = equipment.value.findIndex(item => item.id === equipmentId);
      if (index !== -1) {
        equipment.value[index].status = 'maintenance';
        equipment.value[index].maintenanceSchedule = maintenance;
      }
      return maintenance;
    } catch (err) {
      error.value = err.message;
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const completeMaintenance = async (equipmentId) => {
    isLoading.value = true;
    error.value = null;
    
    try {
      await inventoryService.completeMaintenance(equipmentId);
      // Actualizar el estado del equipo
      const index = equipment.value.findIndex(item => item.id === equipmentId);
      if (index !== -1) {
        equipment.value[index].status = 'available';
        equipment.value[index].maintenanceSchedule = null;
      }
    } catch (err) {
      error.value = err.message;
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const getMaintenanceSchedule = async () => {
    try {
      return await inventoryService.getMaintenanceSchedule();
    } catch (err) {
      error.value = err.message;
      throw err;
    }
  };

  const getRentalHistory = async (equipmentId) => {
    try {
      return await inventoryService.getRentalHistory(equipmentId);
    } catch (err) {
      error.value = err.message;
      throw err;
    }
  };

  const generateReport = async (reportType, filters = {}) => {
    try {
      return await inventoryService.generateReport(reportType, filters);
    } catch (err) {
      error.value = err.message;
      throw err;
    }
  };

  const clearError = () => {
    error.value = null;
  };

  const setSelectedEquipment = (equipment) => {
    selectedEquipment.value = equipment;
  };

  const clearSelectedEquipment = () => {
    selectedEquipment.value = null;
  };

  return {
    // Estado
    equipment,
    isLoading,
    error,
    selectedEquipment,
    
    // Getters
    availableEquipment,
    rentedEquipment,
    maintenanceEquipment,
    outOfServiceEquipment,
    equipmentByCategory,
    totalEquipment,
    utilizationRate,
    monthlyRevenue,
    
    // Acciones
    fetchEquipment,
    addEquipment,
    updateEquipment,
    deleteEquipment,
    getEquipmentById,
    getEquipmentByStatus,
    getEquipmentByCategory,
    searchEquipment,
    rentEquipment,
    returnEquipment,
    scheduleMaintenance,
    completeMaintenance,
    getMaintenanceSchedule,
    getRentalHistory,
    generateReport,
    clearError,
    setSelectedEquipment,
    clearSelectedEquipment
  };
});

