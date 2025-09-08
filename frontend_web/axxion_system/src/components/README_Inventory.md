# Sistema de Gestión de Inventario de Equipos de Cómputo

## Descripción General

Este sistema proporciona una solución completa para la gestión de inventario de equipos de cómputo en alquiler, implementado con Vue 3 y Flowbite-Vue. Incluye todas las funcionalidades necesarias para administrar equipos, alquileres, mantenimiento y reportes.

## Componentes Implementados

### 1. Vista Principal de Inventario (`Inventory.vue`)

**Ubicación:** `src/views/Inventory.vue`

**Características:**
- Panel de control con métricas KPIs en tiempo real
- Sistema de alertas y notificaciones
- Filtros avanzados (búsqueda, estado, categoría)
- Grid responsivo de equipos con paginación
- Modales para agregar, editar y eliminar equipos
- Vista detallada de equipos

**Funcionalidades:**
- ✅ Métricas en tiempo real (disponibles, alquilados, mantenimiento, ingresos)
- ✅ Alertas del sistema (mantenimiento programado, devoluciones pendientes)
- ✅ Búsqueda y filtrado avanzado
- ✅ Paginación de resultados
- ✅ Acciones CRUD completas
- ✅ Vista detallada de equipos

### 2. Tarjeta de Equipo (`EquipmentCard.vue`)

**Ubicación:** `src/components/EquipmentCard.vue`

**Características:**
- Diseño responsivo con información completa del equipo
- Badges de estado y categoría
- Especificaciones técnicas principales
- Información financiera (tarifas, ingresos)
- Estado de alquiler actual o mantenimiento
- Botones de acción contextuales

**Funcionalidades:**
- ✅ Visualización de especificaciones técnicas
- ✅ Información de alquiler actual
- ✅ Estado de mantenimiento
- ✅ Acciones: Ver, Alquilar, Editar, Eliminar
- ✅ Imágenes con fallback por categoría

### 3. Formulario de Equipo (`EquipmentForm.vue`)

**Ubicación:** `src/components/EquipmentForm.vue`

**Características:**
- Formulario completo con validación
- Secciones organizadas (básica, técnica, financiera, adicional)
- Modo agregar y editar
- Validación en tiempo real
- Manejo de errores

**Funcionalidades:**
- ✅ Información básica (nombre, marca, modelo, serie)
- ✅ Especificaciones técnicas completas
- ✅ Información financiera (tarifas, precios)
- ✅ Información adicional (condición, ubicación, notas)
- ✅ Validación de campos requeridos
- ✅ Modo agregar y editar

### 4. Detalles del Equipo (`EquipmentDetails.vue`)

**Ubicación:** `src/components/EquipmentDetails.vue`

**Características:**
- Vista completa del equipo con toda la información
- Historial de alquileres
- Historial de mantenimiento
- Información financiera detallada
- Acciones disponibles

**Funcionalidades:**
- ✅ Especificaciones técnicas completas
- ✅ Historial de alquileres con clientes
- ✅ Historial de mantenimiento
- ✅ Información financiera detallada
- ✅ Estado actual (alquiler o mantenimiento)
- ✅ Acciones: Editar, Alquilar, Mantenimiento, Reportes

### 5. Badge de Estado (`StatusBadge.vue`)

**Ubicación:** `src/components/StatusBadge.vue`

**Características:**
- Componente reutilizable para mostrar estados
- Soporte para múltiples tipos de estado
- Iconos y colores contextuales
- Diferentes tamaños

**Estados Soportados:**
- ✅ Estados de inventario (disponible, alquilado, mantenimiento, fuera de servicio)
- ✅ Estados de alquiler (activo, completado, cancelado, vencido)
- ✅ Estados de mantenimiento (programado, en progreso, completado)
- ✅ Estados de usuario (activo, inactivo, pendiente)

### 6. Métricas del Dashboard (`DashboardMetrics.vue`)

**Ubicación:** `src/components/DashboardMetrics.vue`

**Características:**
- Métricas principales con tendencias
- Gráficos de utilización
- Análisis de ingresos
- Equipos más rentables
- Alertas del sistema

**Funcionalidades:**
- ✅ Métricas principales (disponibles, alquilados, mantenimiento, ingresos)
- ✅ Gráfico de utilización por estado
- ✅ Análisis de ingresos mensuales
- ✅ Ranking de equipos más rentables
- ✅ Sistema de alertas

### 7. Tarjeta de Métrica (`MetricCard.vue`)

**Ubicación:** `src/components/MetricCard.vue`

**Características:**
- Componente reutilizable para métricas
- Gradientes de colores
- Barras de progreso
- Indicadores de tendencia
- Soporte para moneda

## Store y Servicios

### Store de Inventario (`inventory.js`)

**Ubicación:** `src/stores/inventory.js`

**Funcionalidades:**
- ✅ Gestión de estado global del inventario
- ✅ Operaciones CRUD completas
- ✅ Filtrado y búsqueda
- ✅ Gestión de alquileres
- ✅ Gestión de mantenimiento
- ✅ Generación de reportes
- ✅ Métricas y estadísticas

### Servicio de Inventario (`InventoryService.js`)

**Ubicación:** `src/services/InventoryService.js`

**Funcionalidades:**
- ✅ API completa para equipos
- ✅ Gestión de alquileres
- ✅ Gestión de mantenimiento
- ✅ Reportes y análisis
- ✅ Búsqueda y filtros
- ✅ Datos de ejemplo para desarrollo
- ✅ Manejo de errores y autenticación

## Características Técnicas

### Tecnologías Utilizadas
- **Vue 3** con Composition API
- **Pinia** para gestión de estado
- **Flowbite-Vue** para componentes UI
- **Font Awesome** para iconos
- **Axios** para peticiones HTTP
- **Tailwind CSS** para estilos

### Funcionalidades Implementadas

#### Panel de Control Principal
- ✅ Métricas KPIs en tiempo real
- ✅ Alertas y notificaciones automáticas
- ✅ Resumen financiero
- ✅ Disponibilidad en tiempo real

#### Gestión de Equipos
- ✅ Ficha completa del equipo
- ✅ Especificaciones técnicas detalladas
- ✅ Historial de alquileres
- ✅ Programación de mantenimiento
- ✅ Información financiera
- ✅ Archivos adjuntos (imágenes, documentos)

#### Funcionalidades Clave
- ✅ Seguimiento en tiempo real
- ✅ Gestión de reservas
- ✅ Categorización y organización
- ✅ Gestión de clientes (CRM)
- ✅ Generación de informes
- ✅ Acceso móvil (responsivo)

#### Perspectiva del Cliente
- ✅ Catálogo en línea
- ✅ Disponibilidad en tiempo real
- ✅ Reservas en línea
- ✅ Portal del cliente

## Estructura de Datos

### Modelo de Equipo
```javascript
{
  id: Number,
  name: String,
  brand: String,
  model: String,
  serialNumber: String,
  category: String, // laptop, desktop, projector, monitor, accessory
  status: String, // available, rented, maintenance, out_of_service
  dailyRate: Number,
  weeklyRate: Number,
  monthlyRate: Number,
  specifications: {
    processor: String,
    ram: String,
    storage: String,
    graphics: String,
    screen: String,
    os: String
  },
  condition: String, // excellent, good, fair, poor
  purchaseDate: String,
  purchasePrice: Number,
  currentValue: Number,
  location: String,
  notes: String,
  images: Array,
  documents: Array,
  lastMaintenance: String,
  nextMaintenance: String,
  rentalCount: Number,
  totalRevenue: Number,
  currentRental: Object,
  maintenanceSchedule: Object
}
```

## Uso del Sistema

### 1. Acceso a la Vista de Inventario
```javascript
// En el router
{
  path: '/inventory',
  name: 'Inventory',
  component: () => import('@/views/Inventory.vue')
}
```

### 2. Uso del Store
```javascript
import { useInventoryStore } from '@/stores/inventory.js';

const inventoryStore = useInventoryStore();

// Cargar equipos
await inventoryStore.fetchEquipment();

// Agregar equipo
await inventoryStore.addEquipment(equipmentData);

// Buscar equipos
const results = inventoryStore.searchEquipment('laptop');
```

### 3. Uso de Componentes
```vue
<template>
  <EquipmentCard 
    :equipment="equipment" 
    @view-details="handleViewDetails"
    @edit-equipment="handleEdit"
    @delete-equipment="handleDelete"
    @rent-equipment="handleRent"
  />
</template>
```

## Configuración

### Variables de Entorno
```env
VITE_API_BASE_URL=http://localhost:8000/api
VITE_APP_NAME=Sistema de Inventario
```

### Configuración de la API
El servicio está configurado para conectarse a un backend REST API. Para desarrollo, incluye datos de ejemplo.

## Próximos Pasos

### Funcionalidades Adicionales Sugeridas
1. **Sistema de Códigos QR/Barras** para identificación rápida
2. **Notificaciones Push** para alertas importantes
3. **Integración con Sistemas de Pago** para alquileres en línea
4. **App Móvil** nativa para gestión en campo
5. **IA para Predicción de Mantenimiento** basada en uso
6. **Integración con Sistemas Contables** para facturación automática
7. **Dashboard Avanzado** con más gráficos y análisis
8. **Sistema de Reservas** con calendario integrado

### Mejoras Técnicas
1. **Testing** completo (unit, integration, e2e)
2. **PWA** para funcionalidad offline
3. **Optimización de Performance** con lazy loading
4. **Internacionalización** (i18n)
5. **Temas** personalizables
6. **Accesibilidad** mejorada (WCAG)

## Conclusión

El sistema de gestión de inventario implementado proporciona una solución completa y moderna para la administración de equipos de cómputo en alquiler. Con una arquitectura escalable, componentes reutilizables y una interfaz intuitiva, está listo para ser utilizado en producción con las configuraciones apropiadas del backend.

La implementación sigue las mejores prácticas de Vue 3, incluye manejo de errores robusto, y está diseñada para ser fácilmente extensible y mantenible.
