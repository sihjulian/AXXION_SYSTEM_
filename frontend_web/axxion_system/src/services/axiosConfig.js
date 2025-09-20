import axios from 'axios';
import { useAuthStore } from '@/stores/auth';
import router from '@/router';

// Configuración base de Axios
const API_BASE_URL = 'http://localhost:8000/api';

// Crear instancia de Axios
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

// Interceptor de request - Agregar token automáticamente
apiClient.interceptors.request.use(
  (config) => {
    const authStore = useAuthStore();
    const token = authStore.token || localStorage.getItem('token');
    
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    
    console.log('Request interceptor:', {
      url: config.url,
      method: config.method,
      hasToken: !!token
    });
    
    return config;
  },
  (error) => {
    console.error('Request interceptor error:', error);
    return Promise.reject(error);
  }
);

// Interceptor de response - Manejar errores de autenticación
apiClient.interceptors.response.use(
  (response) => {
    console.log('Response interceptor success:', {
      url: response.config.url,
      status: response.status
    });
    return response;
  },
  (error) => {
    console.error('Response interceptor error:', {
      url: error.config?.url,
      status: error.response?.status,
      message: error.response?.data?.message || error.message,
      data: error.response?.data
    });

    const authStore = useAuthStore();
    
    // Si el token es inválido o expiró
    if (error.response?.status === 401) {
      const errorMessage = error.response.data?.error || error.response.data?.message;
      
      if (errorMessage === 'Token expirado' || 
          errorMessage === 'Token inválido' || 
          errorMessage === 'Token no encontrado' ||
          errorMessage === 'Usuario no autenticado' ||
          errorMessage === 'Unauthenticated.') {
        
        console.log('Token inválido detectado, cerrando sesión...');
        
        // Limpiar el store de autenticación
        authStore.logout();
        
        // Redirigir al login solo si no estamos ya en la página de login
        if (router.currentRoute.value.path !== '/login') {
          router.push({
            path: '/login',
            query: { 
              error: 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.',
              redirect: router.currentRoute.value.fullPath
            }
          });
        }
        
        // Mostrar mensaje de error
        return Promise.reject({
          ...error,
          message: 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.',
          isAuthError: true
        });
      }
    }
    
    // Si no hay permisos suficientes
    if (error.response?.status === 403) {
      const errorMessage = error.response.data?.error || 'No tienes permisos para realizar esta acción.';
      
      return Promise.reject({
        ...error,
        message: errorMessage,
        isPermissionError: true
      });
    }
    
    // Errores de validación del servidor
    if (error.response?.status === 422) {
      const validationErrors = error.response.data?.errors || {};
      const errorMessage = error.response.data?.message || 'Error de validación';
      
      return Promise.reject({
        ...error,
        message: errorMessage,
        validationErrors,
        isValidationError: true
      });
    }
    
    // Errores del servidor
    if (error.response?.status >= 500) {
      return Promise.reject({
        ...error,
        message: 'Error interno del servidor. Por favor, inténtalo más tarde.',
        isServerError: true
      });
    }
    
    return Promise.reject(error);
  }
);

export default apiClient;
