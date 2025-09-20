import apiClient from './axiosConfig';

export default {
  async getAll() {
    const res = await apiClient.get('/categoria');
    return res.data?.categoria ?? res.data;
  },
  async createCategory(payload) {
    const res = await apiClient.post('/categoria', payload);
    return res.data;
  },
  async updateCategory(id, payload) {
    const res = await apiClient.put(`/categoria/${id}`, payload);
    return res.data;
  },
  async deleteCategory(id) {
    const res = await apiClient.delete(`/categoria/${id}`);
    return res.data;
  }
};

// const API_BASE_URL = 'http://localhost:8000/api';

// class CategoryService {
//   constructor() {
//     this.api = axios.create({
//       baseURL: API_BASE_URL,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json'
//       }
//     });

//     // Interceptor para agregar token de autenticación
//     this.api.interceptors.request.use(
//       (config) => {
//         const token = localStorage.getItem('auth_token');
//         if (token) {
//           config.headers.Authorization = `Bearer ${token}`;
//         }
//         return config;
//       },
//       (error) => {
//         return Promise.reject(error);
//       }
//     );

//     // Interceptor para manejar respuestas
//     this.api.interceptors.response.use(
//       (response) => {
//         return response;
//       },
//       (error) => {
//         if (error.response?.status === 401) {
//           localStorage.removeItem('auth_token');
//           window.location.href = '/login';
//         }
//         return Promise.reject(error);
//       }
//     );
//   }

//   // ===== GESTIÓN DE CATEGORÍAS =====
  
//   /**
//    * Obtener todas las categorías
//    */
//   async getCategories() {
//     try {
//       const response = await this.api.get('/categoria');
//       console.log('Categories API response:', response.data);
//       return response.data;
//     } catch (error) {
//       console.error('Error al obtener categorías:', error);
//       throw error;
//     }
//   }

//   /**
//    * Obtener una categoría por ID
//    */
//   async getCategoryById(id) {
//     try {
//       const response = await this.api.get(`/categoria/${id}`);
//       return response.data;
//     } catch (error) {
//       console.error('Error al obtener categoría:', error);
//       throw error;
//     }
//   }

//   /**
//    * Crear nueva categoría
//    */
//   async createCategory(categoryData) {
//     try {
//       const response = await this.api.post('/categoria', categoryData);
//       return response.data;
//     } catch (error) {
//       console.error('Error al crear categoría:', error);
//       throw error;
//     }
//   }

//   /**
//    * Actualizar categoría existente
//    */
//   async updateCategory(id, categoryData) {
//     try {
//       const response = await this.api.put(`/categoria/${id}`, categoryData);
//       return response.data;
//     } catch (error) {
//       console.error('Error al actualizar categoría:', error);
//       throw error;
//     }
//   }

//   /**
//    * Eliminar categoría
//    */
//   async deleteCategory(id) {
//     try {
//       const response = await this.api.delete(`/categoria/${id}`);
//       return response.data;
//     } catch (error) {
//       console.error('Error al eliminar categoría:', error);
//       throw error;
//     }
//   }
// }

// export default new CategoryService();
