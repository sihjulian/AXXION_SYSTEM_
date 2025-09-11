import axios from "axios";

const API_BASE_URL = 'http://localhost:8000/api';

class CategoryService {
    constructor() {
        this.api = axios.create({
            baseURL: API_BASE_URL,
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        });
    }
  // Obtener todos los categoria
    async getCategory() {
  try {
    const response = await this.api.get('/categoria');
    return response.data.categoria;
  } catch (error) {
    console.error('Error al obtener categoria:', error);
    throw error;
  }
}

  // Crear un nuevo categoria
    async createCategory(categoriaData) {
        try {
        const response = await this.api.post('/categoria', categoriaData);
        return response.data;
    } catch (error) {
        console.error('Error al crear categoria:', error);
        throw error;
    }
    }

  // Actualizar un categoria
  async updateCategory(id, categoriaData) {
    try {
      const response = await this.api.put(`/categoria/${id}`, categoriaData);
      return response.data;
    } catch (error) {
      console.error('Error al actualizar categoria:', error);
      throw error;
    }
  }

  // Eliminar un categoria
  async deleteCategory(id) {
    try {
      const response = await this.api.delete(`/categoria/${id}`);
      return response.data;
    } catch (error) {
      console.error('Error al eliminar categoria:', error);
      throw error;
    }
  }
}

export default new CategoryService();
