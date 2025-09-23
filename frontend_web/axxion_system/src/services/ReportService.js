import apiClient from './axiosConfig';

class ReportService {
  async getMaintenances() {
    return await apiClient.get('/mantenimiento');
  }

  async getMetrics() {
    try {
      const response = await apiClient.get('/reportes/metrics')
      return response.data
    } catch (error) {
      console.error('Error al obtener métricas:', error)
      throw error
    }
  }
  async getUsers() {
    const response = await apiClient.get('/usuarios')
  return response.data
}
}

export default new ReportService();
