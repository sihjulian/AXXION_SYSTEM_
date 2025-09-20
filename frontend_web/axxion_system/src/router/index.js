//create web sirve para un histoial de las vistas mas visitadas
import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Home from '/src/views/Home.vue'
import User from '@/views/User.vue'
import Login from '@/views/login.vue'
import Inventory from '@/views/Inventory.vue'
import Maintenace from '@/views/Maintenace.vue'
import Category from '@/views/Category.vue'
import SubCategory from '@/views/SubCategory.vue'



const routes = [
  // Ruta raíz - redirige al login si no está autenticado, al home si está autenticado
  {
    path: '/',
    redirect: () => {
      const authStore = useAuthStore();
      return authStore.isAuthenticated ? '/Home' : '/login';
    }
  },
  // Rutas públicas (no requieren autenticación)
  {
    path: '/login',
    name: 'login',
    component: Login,
    meta: { 
      requiresAuth: false,
      hideForAuthenticated: true // Ocultar si ya está logueado
    },
  },
  // Rutas protegidas (requieren autenticación)
  {
    path: '/Home',
    name: 'Home',
    component: Home,
    meta: { 
      requiresAuth: true,
      title: 'Inicio'
    },
  },
  {
    path: '/User',
    name: 'usuarios',
    component: User,
    meta: { 
      requiresAuth: true,
      title: 'Gestión de Usuarios',
      roles: ['ADMIN'] // Solo administradores pueden gestionar usuarios
    },
  },
  {
    path: '/Inventory',
    name: 'Inventory',
    component: Inventory,
    meta: { 
      requiresAuth: true,
      title: 'Inventario'
    },
  },
  {
    path: '/Mantenace',
    name: 'Mantenimiento',
    component: Maintenace,
    meta: { 
      requiresAuth: true,
      title: 'Mantenimiento',
      roles: ['ADMIN', 'TECNICO'] // Solo admin y técnicos
    },
  },
  {
    path: '/Category',
    name: 'Category',
    component: Category,
    meta: { 
      requiresAuth: true,
      title: 'Categorías'
    },
  },
  {
    path: '/SubCategory',
    name: 'SubCategory',
    component: SubCategory,
    meta: { 
      requiresAuth: true,
      title: 'Subcategorías'
    },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// Guard de navegación global
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore();
  
  // Verificar autenticación desde localStorage al iniciar
  authStore.checkAuth();
  
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth);
  const hideForAuthenticated = to.matched.some((record) => record.meta.hideForAuthenticated);
  const requiredRoles = to.meta.roles;
  
  console.log('Router Guard:', {
    to: to.path,
    requiresAuth,
    isAuthenticated: authStore.isAuthenticated,
    user: authStore.user,
    requiredRoles
  });

  // Si la ruta debe ocultarse para usuarios autenticados (como login)
  if (hideForAuthenticated && authStore.isAuthenticated) {
    console.log('Usuario ya autenticado, redirigiendo al home');
    return next('/Home');
  }

  // Si la ruta requiere autenticación
  if (requiresAuth) {
    if (!authStore.isAuthenticated) {
      console.log('Usuario no autenticado, redirigiendo al login');
      return next('/login');
    }

    // Verificar roles si están especificados
    if (requiredRoles && requiredRoles.length > 0) {
      const userRoles = authStore.user?.roles || [];
      
      console.log('Verificando roles:', {
        userRoles: userRoles,
        requiredRoles: requiredRoles,
        userRolesType: typeof userRoles[0]
      });
      
      // Usar el método hasAnyRole del store que ya maneja ambos formatos
      const hasRequiredRole = authStore.hasAnyRole(requiredRoles);

      if (!hasRequiredRole) {
        console.log('Usuario sin permisos suficientes:', {
          userRoles: userRoles,
          requiredRoles: requiredRoles,
          hasRequiredRole: hasRequiredRole
        });
        
        // Redirigir al home con mensaje de error
        return next({
          path: '/Home',
          query: { 
            error: 'No tienes permisos para acceder a esta sección' 
          }
        });
      }
      
      console.log('Permisos verificados correctamente, acceso permitido');
    }
  }

  // Establecer título de la página
  if (to.meta.title) {
    document.title = `AXXION - ${to.meta.title}`;
  }

  next();
});

export default router
