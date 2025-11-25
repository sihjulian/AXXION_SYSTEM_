// plugins/axios.js
import axios from 'axios'
import { useAuth } from '@/composables/useAuth'
import { useAuthStore } from '@/stores/auth';

// Configuración base
axios.defaults.baseURL = import.meta.env.VITE_API_URL || 'http://localhost:8000'
axios.defaults.withCredentials = true // Permite envío de cookies
axios.defaults.headers.common['Accept'] = 'application/json'
axios.defaults.headers.common['Content-Type'] = 'application/json'

// Variable para controlar reintentos
let isRetrying = false

/**
 * Interceptor de Request - Añade el Access Token
 */
axios.interceptors.request.use(
  (config) => {
    const authStore = useAuthStore();
    if (authStore.accessToken) {
      config.headers.Authorization = `Bearer ${authStore.accessToken}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

/**
 * Interceptor de Response - Maneja errores 401 y refresca el token
 */
axios.interceptors.response.use(
  (response) => response, // Si la respuesta es exitosa, no hagas nada
  async (error) => {
    const originalRequest = error.config;
    const authStore = useAuthStore();

    // Comprueba si el error es 401 y si NO es una petición que ya se está reintentando
    if (error.response.status === 401 && !originalRequest._retry) {
      
      // ¡LA CONDICIÓN CLAVE!
      // Ignora los errores 401 de las rutas de login y refresh para evitar bucles.
      if (originalRequest.url.includes('/auth/login') || originalRequest.url.includes('/auth/refresh')) {
        return Promise.reject(error); // Simplemente rechaza la promesa sin hacer nada más.
      }
      
      originalRequest._retry = true;

      try {
        console.log('Interceptor: Access token expirado. Intentando refrescar...');
        // Llama a la acción del store directamente
        await authStore.refreshAccessToken(); 
        
        // Vuelve a establecer la cabecera de autorización con el nuevo token
        originalRequest.headers.Authorization = `Bearer ${authStore.accessToken}`;
        
        // Reintenta la petición original que había fallado
        return apiClient(originalRequest);

      } catch (refreshError) {
        console.log('Interceptor: Refresh token inválido. Deslogueando...');
        // Si el refresh falla, el refresh token es inválido. Desloguear.
        await authStore.logout();
        
        // Redirigir a la página de login
        window.location.href = '/login'; 
        return Promise.reject(refreshError);
      }
    }
    
    return Promise.reject(error);
  }
);

export default axios