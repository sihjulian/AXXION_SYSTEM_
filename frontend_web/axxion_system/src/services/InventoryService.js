import axios from 'axios';

// Configuración base de la API
const API_BASE_URL = 'http://localhost:8000/api'; // Ajustar según tu backend

// Configuración de axios
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

// Interceptor para agregar token de autenticación
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor para manejar respuestas
apiClient.interceptors.response.use(
  (response) => {
    return response.data;
  },
  (error) => {
    if (error.response?.status === 401) {
      // Token expirado o inválido
      localStorage.removeItem('auth_token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export const inventoryService = {
  // ===== GESTIÓN DE EQUIPOS =====
  
  /**
   * Obtener todos los equipos
   */
  async getEquipment() {
    try {
      const response = await apiClient.get('/equipment');
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener equipos:', error);
      // Datos de ejemplo para desarrollo
      return this.getMockEquipment();
    }
  },

  /**
   * Obtener un equipo por ID
   */
  async getEquipmentById(id) {
    try {
      const response = await apiClient.get(`/equipment/${id}`);
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener equipo:', error);
      throw error;
    }
  },

  /**
   * Crear nuevo equipo
   */
  async createEquipment(equipmentData) {
    try {
      const response = await apiClient.post('/equipment', equipmentData);
      return response.data || response;
    } catch (error) {
      console.error('Error al crear equipo:', error);
      throw error;
    }
  },

  /**
   * Actualizar equipo existente
   */
  async updateEquipment(id, equipmentData) {
    try {
      const response = await apiClient.put(`/equipment/${id}`, equipmentData);
      return response.data || response;
    } catch (error) {
      console.error('Error al actualizar equipo:', error);
      throw error;
    }
  },

  /**
   * Eliminar equipo
   */
  async deleteEquipment(id) {
    try {
      await apiClient.delete(`/equipment/${id}`);
      return true;
    } catch (error) {
      console.error('Error al eliminar equipo:', error);
      throw error;
    }
  },

  // ===== GESTIÓN DE ALQUILERES =====

  /**
   * Alquilar equipo
   */
  async rentEquipment(equipmentId, rentalData) {
    try {
      const response = await apiClient.post(`/equipment/${equipmentId}/rent`, rentalData);
      return response.data || response;
    } catch (error) {
      console.error('Error al alquilar equipo:', error);
      throw error;
    }
  },

  /**
   * Devolver equipo
   */
  async returnEquipment(equipmentId) {
    try {
      const response = await apiClient.post(`/equipment/${equipmentId}/return`);
      return response.data || response;
    } catch (error) {
      console.error('Error al devolver equipo:', error);
      throw error;
    }
  },

  /**
   * Obtener historial de alquileres de un equipo
   */
  async getRentalHistory(equipmentId) {
    try {
      const response = await apiClient.get(`/equipment/${equipmentId}/rentals`);
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener historial de alquileres:', error);
      throw error;
    }
  },

  /**
   * Obtener alquileres activos
   */
  async getActiveRentals() {
    try {
      const response = await apiClient.get('/rentals/active');
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener alquileres activos:', error);
      throw error;
    }
  },

  // ===== GESTIÓN DE MANTENIMIENTO =====

  /**
   * Programar mantenimiento
   */
  async scheduleMaintenance(equipmentId, maintenanceData) {
    try {
      const response = await apiClient.post(`/equipment/${equipmentId}/maintenance`, maintenanceData);
      return response.data || response;
    } catch (error) {
      console.error('Error al programar mantenimiento:', error);
      throw error;
    }
  },

  /**
   * Completar mantenimiento
   */
  async completeMaintenance(equipmentId) {
    try {
      const response = await apiClient.put(`/equipment/${equipmentId}/maintenance/complete`);
      return response.data || response;
    } catch (error) {
      console.error('Error al completar mantenimiento:', error);
      throw error;
    }
  },

  /**
   * Obtener programación de mantenimiento
   */
  async getMaintenanceSchedule() {
    try {
      const response = await apiClient.get('/maintenance/schedule');
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener programación de mantenimiento:', error);
      throw error;
    }
  },

  /**
   * Obtener historial de mantenimiento de un equipo
   */
  async getMaintenanceHistory(equipmentId) {
    try {
      const response = await apiClient.get(`/equipment/${equipmentId}/maintenance`);
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener historial de mantenimiento:', error);
      throw error;
    }
  },

  // ===== REPORTES Y ANÁLISIS =====

  /**
   * Generar reporte
   */
  async generateReport(reportType, filters = {}) {
    try {
      const response = await apiClient.post('/reports/generate', {
        type: reportType,
        filters
      });
      return response.data || response;
    } catch (error) {
      console.error('Error al generar reporte:', error);
      throw error;
    }
  },

  /**
   * Obtener métricas del dashboard
   */
  async getDashboardMetrics() {
    try {
      const response = await apiClient.get('/dashboard/metrics');
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener métricas:', error);
      throw error;
    }
  },

  /**
   * Obtener estadísticas de utilización
   */
  async getUtilizationStats() {
    try {
      const response = await apiClient.get('/analytics/utilization');
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener estadísticas de utilización:', error);
      throw error;
    }
  },

  // ===== BÚSQUEDA Y FILTROS =====

  /**
   * Buscar equipos
   */
  async searchEquipment(query, filters = {}) {
    try {
      const response = await apiClient.get('/equipment/search', {
        params: { q: query, ...filters }
      });
      return response.data || response;
    } catch (error) {
      console.error('Error al buscar equipos:', error);
      throw error;
    }
  },

  /**
   * Obtener equipos por categoría
   */
  async getEquipmentByCategory(category) {
    try {
      const response = await apiClient.get(`/equipment/category/${category}`);
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener equipos por categoría:', error);
      throw error;
    }
  },

  /**
   * Obtener equipos por estado
   */
  async getEquipmentByStatus(status) {
    try {
      const response = await apiClient.get(`/equipment/status/${status}`);
      return response.data || response;
    } catch (error) {
      console.error('Error al obtener equipos por estado:', error);
      throw error;
    }
  },

  // ===== DATOS DE EJEMPLO PARA DESARROLLO =====

  /**
   * Obtener datos de ejemplo para desarrollo
   */
  getMockEquipment() {
    return [
      {
        id: 1,
        name: 'Laptop Dell Inspiron 15',
        brand: 'Dell',
        model: 'Inspiron 15 3000',
        serialNumber: 'DL001234567',
        category: 'laptop',
        status: 'available',
        dailyRate: 25.00,
        weeklyRate: 150.00,
        monthlyRate: 500.00,
        specifications: {
          processor: 'Intel Core i5-1135G7',
          ram: '8GB DDR4',
          storage: '256GB SSD',
          graphics: 'Intel Iris Xe',
          screen: '15.6" FHD',
          os: 'Windows 11 Home'
        },
        condition: 'excellent',
        purchaseDate: '2023-01-15',
        purchasePrice: 899.99,
        currentValue: 650.00,
        location: 'Almacén Principal',
        notes: 'Equipo en excelente estado, ideal para trabajo de oficina',
        images: ['/images/equipment/dell-inspiron-15-1.jpg'],
        documents: ['/docs/warranty/dell-inspiron-15.pdf'],
        lastMaintenance: '2024-01-10',
        nextMaintenance: '2024-04-10',
        rentalCount: 12,
        totalRevenue: 1800.00
      },
      {
        id: 2,
        name: 'MacBook Pro 13"',
        brand: 'Apple',
        model: 'MacBook Pro 13" M2',
        serialNumber: 'AP002345678',
        category: 'laptop',
        status: 'rented',
        dailyRate: 45.00,
        weeklyRate: 280.00,
        monthlyRate: 950.00,
        specifications: {
          processor: 'Apple M2',
          ram: '8GB Unified Memory',
          storage: '256GB SSD',
          graphics: 'Apple M2 GPU',
          screen: '13.3" Retina',
          os: 'macOS Ventura'
        },
        condition: 'excellent',
        purchaseDate: '2023-03-20',
        purchasePrice: 1299.99,
        currentValue: 1100.00,
        location: 'Almacén Principal',
        notes: 'Equipo premium, perfecto para desarrollo y diseño',
        images: ['/images/equipment/macbook-pro-13-1.jpg'],
        documents: ['/docs/warranty/macbook-pro-13.pdf'],
        lastMaintenance: '2023-12-15',
        nextMaintenance: '2024-03-15',
        rentalCount: 8,
        totalRevenue: 2100.00,
        currentRental: {
          id: 1,
          clientName: 'Juan Pérez',
          startDate: '2024-01-20',
          endDate: '2024-02-20',
          totalAmount: 950.00
        }
      },
      {
        id: 3,
        name: 'Proyector Epson PowerLite',
        brand: 'Epson',
        model: 'PowerLite 1781W',
        serialNumber: 'EP003456789',
        category: 'projector',
        status: 'maintenance',
        dailyRate: 35.00,
        weeklyRate: 200.00,
        monthlyRate: 650.00,
        specifications: {
          resolution: 'WXGA (1280x800)',
          brightness: '3200 lumens',
          contrast: '15000:1',
          lamp: 'E-TORL 200W',
          connectivity: 'HDMI, VGA, USB, WiFi',
          weight: '2.6 kg'
        },
        condition: 'good',
        purchaseDate: '2022-11-10',
        purchasePrice: 599.99,
        currentValue: 400.00,
        location: 'Taller de Mantenimiento',
        notes: 'Requiere limpieza de lente y calibración',
        images: ['/images/equipment/epson-powerlite-1.jpg'],
        documents: ['/docs/manual/epson-powerlite.pdf'],
        lastMaintenance: '2024-01-05',
        nextMaintenance: '2024-01-25',
        rentalCount: 25,
        totalRevenue: 3200.00,
        maintenanceSchedule: {
          id: 1,
          type: 'preventive',
          scheduledDate: '2024-01-25',
          description: 'Limpieza de lente y calibración de colores',
          technician: 'Carlos Mendoza'
        }
      },
      {
        id: 4,
        name: 'Monitor Samsung 24"',
        brand: 'Samsung',
        model: 'S24F350FH',
        serialNumber: 'SM004567890',
        category: 'monitor',
        status: 'available',
        dailyRate: 15.00,
        weeklyRate: 80.00,
        monthlyRate: 250.00,
        specifications: {
          size: '24"',
          resolution: '1920x1080 FHD',
          panel: 'PLS',
          refreshRate: '60Hz',
          connectivity: 'HDMI, VGA',
          features: 'Eye Saver Mode, Flicker Free'
        },
        condition: 'excellent',
        purchaseDate: '2023-06-15',
        purchasePrice: 199.99,
        currentValue: 150.00,
        location: 'Almacén Principal',
        notes: 'Monitor básico ideal para oficina',
        images: ['/images/equipment/samsung-24-1.jpg'],
        documents: ['/docs/warranty/samsung-24.pdf'],
        lastMaintenance: '2023-12-01',
        nextMaintenance: '2024-06-01',
        rentalCount: 18,
        totalRevenue: 1200.00
      },
      {
        id: 5,
        name: 'Desktop HP Pavilion',
        brand: 'HP',
        model: 'Pavilion Desktop TP01-2000',
        serialNumber: 'HP005678901',
        category: 'desktop',
        status: 'out_of_service',
        dailyRate: 30.00,
        weeklyRate: 180.00,
        monthlyRate: 600.00,
        specifications: {
          processor: 'AMD Ryzen 5 5600G',
          ram: '8GB DDR4',
          storage: '256GB SSD + 1TB HDD',
          graphics: 'AMD Radeon Graphics',
          os: 'Windows 11 Home',
          formFactor: 'Mini Tower'
        },
        condition: 'poor',
        purchaseDate: '2022-08-20',
        purchasePrice: 699.99,
        currentValue: 300.00,
        location: 'Taller de Reparación',
        notes: 'Problema con la fuente de poder, requiere reparación',
        images: ['/images/equipment/hp-pavilion-1.jpg'],
        documents: ['/docs/warranty/hp-pavilion.pdf'],
        lastMaintenance: '2023-10-15',
        nextMaintenance: 'N/A',
        rentalCount: 22,
        totalRevenue: 2800.00,
        issues: [
          {
            id: 1,
            date: '2024-01-18',
            description: 'Fuente de poder no funciona correctamente',
            severity: 'high',
            status: 'pending'
          }
        ]
      }
    ];
  }
};
