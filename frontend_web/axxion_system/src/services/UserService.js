import axios from 'axios';

const API_BASE_URL = 'http://localhost:8000/api';

class UserService {
  constructor() {
    this.api = axios.create({
      baseURL: API_BASE_URL,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    });
  }

  // Obtener todos los usuarios
  async getUsers() {
    try {
      const response = await this.api.get('/usuarios');
      return response.data;
    } catch (error) {
      console.error('Error al obtener usuarios:', error);
      throw error;
    }
  }

  // Crear un nuevo usuario
  async createUser(userData) {
    try {
      const response = await this.api.post('/usuarios', userData);
      return response.data;
    } catch (error) {
      console.error('Error al crear usuario:', error);
      throw error;
    }
  }

  // Actualizar un usuario
  async updateUser(id, userData) {
    try {
      const response = await this.api.put(`/usuarios/${id}`, userData);
      return response.data;
    } catch (error) {
      console.error('Error al actualizar usuario:', error);
      throw error;
    }
  }

  // Eliminar un usuario
  async deleteUser(id) {
    try {
      const response = await this.api.delete(`/usuario/${id}`);
      return response.data;
    } catch (error) {
      console.error('Error al eliminar usuario:', error);
      throw error;
    }
  }

  // Obtener roles disponibles
  async getRoles() {
    try {
      const response = await this.api.get('/roles');
      return response.data;
    } catch (error) {
      console.error('Error al obtener roles:', error);
      // Retornar roles por defecto si la API no está disponible
      return {
        data: [
          { id: 1, nombre: 'Administrador' },
          { id: 2, nombre: 'Auxiliar' },
          { id: 3, nombre: 'Técnico' }
        ]
      };
    }
  }
}

export default new UserService();
