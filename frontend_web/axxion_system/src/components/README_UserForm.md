# Formulario de Usuario

## Descripción
Este componente proporciona un formulario completo para crear nuevos usuarios en el sistema AXION.

## Características
- ✅ Formulario responsivo con validación
- ✅ Integración con Flowbite Vue
- ✅ Manejo de estado con Pinia
- ✅ Consumo de API REST
- ✅ Validación de campos requeridos
- ✅ Selección múltiple de roles
- ✅ Manejo de errores y mensajes de éxito

## Campos del Formulario
- **Nombre** (requerido)
- **Segundo Nombre** (opcional)
- **Primer Apellido** (requerido)
- **Segundo Apellido** (opcional)
- **Nombre de Usuario** (requerido)
- **Email** (requerido, validación de formato)
- **Teléfono** (requerido)
- **Departamento** (requerido, select)
- **Estado** (requerido: activo/inactivo)
- **Contraseña** (requerido)
- **Roles** (requerido, selección múltiple)

## Roles Disponibles
1. **Administrador** (ID: 1)
2. **Auxiliar** (ID: 2)
3. **Técnico** (ID: 3)

## API Endpoint
- **POST** `http://localhost:8000/api/usuarios`

## Estructura de Datos Enviados
```json
{
  "nombre_usuario": "carlos_admin",
  "nombre": "Carlos",
  "nombre2": "Antonio",
  "apellido1": "Rodríguez",
  "apellido2": "Martínez",
  "email": "c.rodriguez@empresa.com",
  "telefono": "555-0456",
  "departamento": "Tecnología",
  "estado": "activo",
  "password": "SecurePass123",
  "roles": [1]
}
```

## Uso
El formulario se integra automáticamente en el modal de la vista de usuarios. Al hacer clic en "Agregar Usuario", se abre el modal con el formulario completo.

## Eventos
- `@success`: Se emite cuando el usuario se crea exitosamente
- `@cancel`: Se emite cuando se cancela la operación
