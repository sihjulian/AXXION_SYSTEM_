import { useAuthStore } from '@/stores/auth';
import apiClient from '@/services/axiosConfig';

/**
 * Valida si el token actual es válido haciendo una petición al backend
 */
export async function validateToken() {
  const authStore = useAuthStore();
  
  if (!authStore.token) {
    return false;
  }

  try {
    // Hacer una petición simple para verificar si el token es válido
    const response = await apiClient.get('/usuarios');
    return response.status === 200;
  } catch (error) {
    console.error('Token validation failed:', error);
    
    // Si el token es inválido, limpiar la autenticación
    if (error.response?.status === 401) {
      authStore.logout();
      return false;
    }
    
    // Para otros errores, asumir que el token es válido
    return true;
  }
}

/**
 * Decodifica un JWT token (sin verificar la firma)
 * Útil para obtener información del payload
 */
export function decodeJWT(token) {
  try {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split('')
        .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    );
    
    return JSON.parse(jsonPayload);
  } catch (error) {
    console.error('Error decoding JWT:', error);
    return null;
  }
}

/**
 * Verifica si un token JWT ha expirado
 */
export function isTokenExpired(token) {
  const decoded = decodeJWT(token);
  if (!decoded || !decoded.exp) {
    return true;
  }
  
  const currentTime = Date.now() / 1000;
  return decoded.exp < currentTime;
}

/**
 * Obtiene el tiempo restante antes de que expire el token (en segundos)
 */
export function getTokenTimeRemaining(token) {
  const decoded = decodeJWT(token);
  if (!decoded || !decoded.exp) {
    return 0;
  }
  
  const currentTime = Date.now() / 1000;
  const timeRemaining = decoded.exp - currentTime;
  
  return Math.max(0, timeRemaining);
}

/**
 * Configura un timer para renovar el token antes de que expire
 */
export function setupTokenRefresh() {
  const authStore = useAuthStore();
  
  if (!authStore.token) {
    return;
  }
  
  const timeRemaining = getTokenTimeRemaining(authStore.token);
  
  // Renovar el token cuando queden 5 minutos (300 segundos)
  const refreshTime = Math.max(0, (timeRemaining - 300) * 1000);
  
  if (refreshTime > 0) {
    setTimeout(async () => {
      console.log('Attempting to refresh token...');
      
      // Aquí podrías implementar la lógica de renovación del token
      // Por ahora, solo validamos si el token sigue siendo válido
      const isValid = await validateToken();
      
      if (!isValid) {
        console.log('Token is no longer valid, logging out...');
        authStore.logout();
      } else {
        // Configurar el próximo refresh
        setupTokenRefresh();
      }
    }, refreshTime);
    
    console.log(`Token refresh scheduled in ${refreshTime / 1000} seconds`);
  } else {
    console.log('Token will expire soon, validating immediately...');
    validateToken();
  }
}
