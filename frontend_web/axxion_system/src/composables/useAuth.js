import { computed } from 'vue';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';

export function useAuth() {
  const authStore = useAuthStore();
  const router = useRouter();

  // Getters reactivos
  const isAuthenticated = computed(() => authStore.isAuthenticated);
  const user = computed(() => authStore.user);
  const token = computed(() => authStore.token);

  // Métodos de autenticación
  const login = async (credentials) => {
    try {
      const success = await authStore.login(credentials);
      if (success) {
        router.push('/Home');
        return { success: true };
      } else {
        return { 
          success: false, 
          error: authStore.error || 'Error de autenticación' 
        };
      }
    } catch (error) {
      return { 
        success: false, 
        error: error.message || 'Error de conexión' 
      };
    }
  };

  const logout = () => {
    authStore.logout();
    router.push('/login');
  };

  // Métodos de verificación de roles
  const hasRole = (roleName) => {
    return authStore.hasRole(roleName);
  };

  const hasAnyRole = (roleNames) => {
    return authStore.hasAnyRole(roleNames);
  };

  // Verificar si el usuario puede acceder a una ruta específica
  const canAccessRoute = (routeName) => {
    const route = router.getRoutes().find(r => r.name === routeName);
    if (!route || !route.meta.roles) return true;
    
    return hasAnyRole(route.meta.roles);
  };

  // Método para verificar permisos específicos
  const hasPermission = (permission) => {
    if (!user.value) return false;
    
    // Lógica de permisos basada en roles
    const rolePermissions = {
      'ADMIN': ['*'], // Admin tiene todos los permisos
      'TECNICO': ['read_products', 'update_products', 'read_maintenance'],
      'AUXILIAR': ['read_products', 'read_clients']
    };

    const userRoles = user.value.roles || [];
    
    return userRoles.some(role => {
      const permissions = rolePermissions[role.codigo] || [];
      return permissions.includes('*') || permissions.includes(permission);
    });
  };

  return {
    // Estado
    isAuthenticated,
    user,
    token,
    
    // Métodos
    login,
    logout,
    hasRole,
    hasAnyRole,
    canAccessRoute,
    hasPermission,
    
    // Utilidades
    checkAuth: () => authStore.checkAuth()
  };
}
