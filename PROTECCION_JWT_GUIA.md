# 🔐 Guía Completa de Protección JWT - Sistema AXXION

## 📋 Resumen de Implementación

He implementado un sistema completo de autenticación y autorización JWT que protege tanto el backend como el frontend del sistema AXXION. Esta guía explica todo lo implementado y cómo extenderlo.

---

## 🚀 Lo que se Implementó

### 1. **Backend - Protección de APIs**

#### **Rutas Reorganizadas (`routes/api.php`)**
```php
// RUTAS PÚBLICAS (sin autenticación)
Route::post('/login', [UsuarioController::class, 'login']);
Route::post('/usuarios', [UsuarioController::class, 'store']); // Registro

// RUTAS PROTEGIDAS (requieren autenticación)
Route::middleware(['jwt.auth'])->group(function () {
    // Gestión básica (todos los usuarios autenticados)
    Route::get('/usuarios', [UsuarioController::class, 'index']);
    Route::get('/categoria', [categoriaController::class, 'index']);
    
    // Solo administradores
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/usuario/{id}', [UsuarioController::class, 'destroy']);
        Route::get('/rol', [rolController::class, 'index']);
    });
});
```

#### **Niveles de Protección Implementados:**
- **Públicas**: Login y registro
- **Autenticadas**: Lectura de datos, operaciones básicas
- **Solo Admin**: Eliminaciones, gestión de roles y usuarios

#### **Respuesta de Login Mejorada (`UsuarioController.php`)**
```php
return response()->json([
    'token' => $token,
    'user' => [
        'id' => $user->id,
        'nombre' => $user->nombre,
        'nombre_usuario' => $user->nombre_usuario,
        'email' => $user->email,
        'roles' => $user->roles->map(function($role) {
            return [
                'id' => $role->id,
                'codigo' => $role->codigo,
                'nombre' => $role->nombre,
                'descripcion' => $role->descripcion ?? ''
            ];
        })->toArray()
    ]
], 200);
```

### 2. **Frontend - Protección Automática**

#### **Interceptor de Axios (`services/axiosConfig.js`)**
```javascript
// Interceptor de REQUEST - Agrega token automáticamente
apiClient.interceptors.request.use((config) => {
    const authStore = useAuthStore();
    const token = authStore.token || localStorage.getItem('token');
    
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

// Interceptor de RESPONSE - Maneja errores
apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        // 401: Token inválido/expirado -> Logout automático
        // 403: Sin permisos -> Mensaje de error
        // 422: Errores de validación -> Detalles específicos
        // 500+: Error del servidor -> Mensaje genérico
    }
);
```

#### **Guards de Ruta (`router/index.js`)**
```javascript
const routes = [
    {
        path: '/User',
        name: 'usuarios',
        component: User,
        meta: { 
            requiresAuth: true,
            title: 'Gestión de Usuarios',
            roles: ['ADMIN'] // Solo administradores
        },
    },
    // Más rutas...
];

// Guard global
router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStore();
    authStore.checkAuth();
    
    const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
    const requiredRoles = to.meta.roles;
    
    if (requiresAuth && !authStore.isAuthenticated) {
        return next('/login');
    }
    
    if (requiredRoles && !authStore.hasAnyRole(requiredRoles)) {
        return next({
            path: '/Home',
            query: { error: 'No tienes permisos para acceder a esta sección' }
        });
    }
    
    next();
});
```

#### **Store de Autenticación Mejorado (`stores/auth.js`)**
```javascript
export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || null,
        user: JSON.parse(localStorage.getItem('user')) || null,
        error: null,
    }),
    
    actions: {
        // Verificación de roles flexible
        hasRole(roleName) {
            if (!this.user?.roles) return false;
            
            // Maneja tanto arrays de strings como objetos
            if (typeof this.user.roles[0] === 'string') {
                return this.user.roles.includes(roleName);
            }
            
            return this.user.roles.some(role => 
                role.codigo === roleName || 
                role.name === roleName ||
                role.nombre === roleName
            );
        },
        
        hasAnyRole(roleNames) {
            return roleNames.some(roleName => this.hasRole(roleName));
        }
    }
});
```

#### **Composable para Componentes (`composables/useAuth.js`)**
```javascript
export function useAuth() {
    const authStore = useAuthStore();
    const router = useRouter();

    return {
        // Estado reactivo
        isAuthenticated: computed(() => authStore.isAuthenticated),
        user: computed(() => authStore.user),
        
        // Métodos
        login: async (credentials) => { /* ... */ },
        logout: () => { /* ... */ },
        hasRole: (roleName) => authStore.hasRole(roleName),
        hasAnyRole: (roleNames) => authStore.hasAnyRole(roleNames),
        hasPermission: (permission) => { /* Lógica de permisos */ }
    };
}
```

#### **Servicios Actualizados**
Todos los servicios ahora usan `axiosConfig.js`:
```javascript
// Antes
import axios from 'axios';
const api = axios.create({ baseURL: '...' });

// Después
import apiClient from './axiosConfig';
// El token se incluye automáticamente
```

---

## 🛡️ Cómo Proteger Nuevos Componentes y Rutas

### **1. Agregar Nueva Ruta Protegida**

```javascript
// En router/index.js
const routes = [
    {
        path: '/nueva-seccion',
        name: 'NuevaSeccion',
        component: () => import('@/views/NuevaSeccion.vue'),
        meta: { 
            requiresAuth: true,           // Requiere estar logueado
            title: 'Nueva Sección',       // Título de la página
            roles: ['ADMIN', 'TECNICO']   // Roles permitidos (opcional)
        },
    }
];
```

### **2. Proteger Rutas del Backend**

```php
// En routes/api.php

// Para todos los usuarios autenticados
Route::middleware(['jwt.auth'])->group(function () {
    Route::get('/nueva-ruta', [Controller::class, 'index']);
});

// Solo para administradores
Route::middleware(['jwt.auth', 'check.role:ADMIN'])->group(function () {
    Route::delete('/nueva-ruta/{id}', [Controller::class, 'destroy']);
});

// Para múltiples roles
Route::middleware(['jwt.auth', 'check.role:ADMIN,TECNICO'])->group(function () {
    Route::post('/nueva-ruta', [Controller::class, 'store']);
});
```

### **3. Proteger Componentes Vue**

#### **Opción A: Usar el Composable**
```vue
<template>
    <div v-if="canAccess">
        <!-- Contenido solo para usuarios autorizados -->
        <button v-if="hasRole('ADMIN')" @click="deleteItem">
            Eliminar
        </button>
    </div>
    <div v-else>
        <p>No tienes permisos para ver esta sección</p>
    </div>
</template>

<script setup>
import { useAuth } from '@/composables/useAuth';

const { isAuthenticated, hasRole, hasAnyRole } = useAuth();

const canAccess = computed(() => {
    return isAuthenticated.value && hasAnyRole(['ADMIN', 'TECNICO']);
});
</script>
```

#### **Opción B: Usar el Store Directamente**
```vue
<script setup>
import { useAuthStore } from '@/stores/auth';

const authStore = useAuthStore();

const showAdminFeatures = computed(() => {
    return authStore.hasRole('ADMIN');
});
</script>
```

### **4. Crear Nuevo Servicio Protegido**

```javascript
// services/NuevoService.js
import apiClient from './axiosConfig'; // ¡Importante usar este!

class NuevoService {
    async getData() {
        // El token se incluye automáticamente
        const response = await apiClient.get('/nueva-ruta');
        return response.data;
    }
    
    async createData(data) {
        const response = await apiClient.post('/nueva-ruta', data);
        return response.data;
    }
}

export default new NuevoService();
```

### **5. Manejar Errores de Permisos**

```vue
<script setup>
import { ref } from 'vue';
import NuevoService from '@/services/NuevoService';

const error = ref('');

const handleAction = async () => {
    try {
        await NuevoService.createData(formData);
        // Éxito
    } catch (err) {
        if (err.isPermissionError) {
            error.value = 'No tienes permisos para esta acción';
        } else if (err.isAuthError) {
            // El interceptor ya manejó el logout
            error.value = 'Sesión expirada';
        } else {
            error.value = 'Error inesperado';
        }
    }
};
</script>
```

---

## 🎯 Niveles de Protección Recomendados

### **Por Tipo de Operación:**

| Operación | Nivel Requerido | Ejemplo |
|-----------|----------------|---------|
| **Lectura básica** | Autenticado | Ver productos, categorías |
| **Creación/Edición** | Autenticado | Crear productos, editar perfil |
| **Eliminación** | Admin/Supervisor | Eliminar registros |
| **Configuración** | Solo Admin | Gestión de usuarios, roles |
| **Reportes críticos** | Admin/Gerente | Reportes financieros |

### **Por Sección del Sistema:**

```javascript
const protectionLevels = {
    // Acceso general
    '/dashboard': { requiresAuth: true },
    '/inventory': { requiresAuth: true },
    '/categories': { requiresAuth: true },
    
    // Gestión administrativa
    '/users': { requiresAuth: true, roles: ['ADMIN'] },
    '/roles': { requiresAuth: true, roles: ['ADMIN'] },
    '/settings': { requiresAuth: true, roles: ['ADMIN'] },
    
    // Operaciones técnicas
    '/maintenance': { requiresAuth: true, roles: ['ADMIN', 'TECNICO'] },
    '/reports': { requiresAuth: true, roles: ['ADMIN', 'GERENTE'] },
    
    // Solo lectura
    '/help': { requiresAuth: true },
    '/profile': { requiresAuth: true }
};
```

---

## 🔧 Herramientas de Debug

### **Componente de Debug Temporal**
Ya incluido en `components/DebugUserInfo.vue` - úsalo para:
- Ver información del usuario actual
- Verificar roles y permisos
- Probar verificaciones de acceso
- Limpiar/refrescar autenticación

### **Logs en Consola**
El sistema incluye logs detallados:
```javascript
// En router guard
console.log('Router Guard:', {
    to: to.path,
    requiresAuth,
    isAuthenticated: authStore.isAuthenticated,
    userRoles: userRoles,
    requiredRoles: requiredRoles
});

// En interceptor de Axios
console.log('Request interceptor:', {
    url: config.url,
    method: config.method,
    hasToken: !!token
});
```

---

## 📚 Ejemplos Prácticos

### **Ejemplo 1: Nueva Sección de Reportes**

1. **Backend** (`routes/api.php`):
```php
Route::middleware(['jwt.auth', 'check.role:ADMIN,GERENTE'])->group(function () {
    Route::get('/reportes', [ReporteController::class, 'index']);
    Route::get('/reportes/{id}', [ReporteController::class, 'show']);
});
```

2. **Frontend** (`router/index.js`):
```javascript
{
    path: '/reportes',
    name: 'Reportes',
    component: () => import('@/views/Reportes.vue'),
    meta: { 
        requiresAuth: true,
        title: 'Reportes',
        roles: ['ADMIN', 'GERENTE']
    },
}
```

3. **Servicio**:
```javascript
// services/ReporteService.js
import apiClient from './axiosConfig';

export default {
    async getReportes() {
        const response = await apiClient.get('/reportes');
        return response.data;
    }
};
```

### **Ejemplo 2: Botón Condicional en Componente**

```vue
<template>
    <div class="product-card">
        <h3>{{ product.name }}</h3>
        
        <!-- Solo técnicos y admins pueden editar -->
        <button 
            v-if="canEdit" 
            @click="editProduct"
            class="btn-edit">
            Editar
        </button>
        
        <!-- Solo admins pueden eliminar -->
        <button 
            v-if="canDelete" 
            @click="deleteProduct"
            class="btn-delete">
            Eliminar
        </button>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useAuth } from '@/composables/useAuth';

const { hasRole, hasAnyRole } = useAuth();

const canEdit = computed(() => hasAnyRole(['ADMIN', 'TECNICO']));
const canDelete = computed(() => hasRole('ADMIN'));
</script>
```

---

## ⚡ Características del Sistema

### **✅ Funcionalidades Implementadas:**
- 🔐 Autenticación automática con JWT
- 🛡️ Protección de rutas por roles
- 🔄 Renovación automática de sesión
- 🚪 Logout automático al expirar token
- 📱 Interceptores de Axios configurados
- 🎯 Guards de navegación inteligentes
- 🔍 Herramientas de debugging
- 📋 Manejo robusto de errores
- 🎨 Notificaciones de usuario amigables

### **🎯 Beneficios:**
- **Seguridad**: Todas las rutas están protegidas automáticamente
- **Facilidad**: No necesitas manejar tokens manualmente
- **Flexibilidad**: Sistema de roles extensible
- **UX**: Redirecciones y mensajes intuitivos
- **Mantenibilidad**: Código organizado y reutilizable

---

## 🚀 Próximos Pasos Recomendados

1. **Probar el sistema actual** con el componente de debug
2. **Definir roles específicos** para tu organización
3. **Crear permisos granulares** si es necesario
4. **Implementar refresh token** para sesiones más largas
5. **Agregar logs de auditoría** para acciones críticas

---

¡El sistema está listo para usar y es fácilmente extensible! 🎉
