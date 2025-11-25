// composables/useAuth.js
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia';
import axios from '@/plugins/axios';
import { useAuthStore } from '@/stores/auth';


// Estado global compartido
const accessToken = ref(null)
const user = ref(null)
const isRefreshing = ref(false)
let refreshSubscribers = []

export function useAuth() {


  const authStore = useAuthStore();

  

  // Computed
  const isAuthenticated = computed(() => !!accessToken.value)
  

  /**
   * Login del usuario
   */
  const login = async (email, password, deviceName = 'Web Browser') => {
    try {
      const response = await axios.post('/api/auth/login', {
        email,
        password,
        device_name: deviceName,
      }, {
        withCredentials: true, // IMPORTANTE: envía y recibe cookies
      })

      if (response.data.success) {
        accessToken.value = response.data.data.access_token
        user.value = response.data.data.user
        
        return {
          success: true,
          user: user.value,
        }
      }

      return {
        success: false,
        message: 'Error en el login',
      }
    } catch (error) {
      return {
        success: false,
        message: error.response?.data?.message || 'Error de conexión',
      }
    }
  }

  /**
   * Refresca el Access Token usando el Refresh Token de la cookie
   */
  const refreshAccessToken = async () => {
    if (isRefreshing.value) {
      // Si ya estamos refrescando, esperar a que termine
      return new Promise((resolve) => {
        refreshSubscribers.push((token) => {
          resolve(token)
        })
      })
    }

    isRefreshing.value = true

    try {
      const response = await axios.post('/api/auth/refresh', {}, {
        withCredentials: true,
      })

      if (response.data.success) {
        accessToken.value = response.data.data.access_token
        
        // Notificar a todos los suscriptores
        refreshSubscribers.forEach(callback => callback(accessToken.value))
        refreshSubscribers = []
        
        return accessToken.value
      }

      throw new Error('No se pudo refrescar el token')
    } catch (error) {
      // Si falla el refresh, hacer logout
      await logout()
      router.push('/login')
      throw error
    } finally {
      isRefreshing.value = false
    }
  }

  /**
   * Logout del usuario
   */
  const logout = async () => {
    try {
      await axios.post('/api/auth/logout', {}, {
        withCredentials: true,
      })
    } catch (error) {
      console.error('Error al cerrar sesión:', error)
    } finally {
      accessToken.value = null
      user.value = null
      router.push('/login')
    }
  }

  /**
   * Obtiene el usuario actual
   */
  const getUser = async () => {
    try {
      const response = await axios.get('/api/auth/me')
      
      if (response.data.success) {
        user.value = response.data.data
        return user.value
      }
    } catch (error) {
      console.error('Error al obtener usuario:', error)
    }
  }

  /**
   * Verifica si hay sesión activa (intenta refrescar el token)
   */
  const checkAuth = async () => {
    if (accessToken.value) {
      return true
    }

    try {
      await refreshAccessToken()
      return true
    } catch (error) {
      return false
    }
  }

  return {
    // Estado
    accessToken: computed(() => accessToken.value),
    user: computed(() => user.value),
    isAuthenticated,
    
    // Métodos
    login,
    logout,
    refreshAccessToken,
    getUser,
    checkAuth,
  }
}
