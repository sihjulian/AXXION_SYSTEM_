# API AXXION SYSTEM - Documentación de Uso

## Autenticación

### 1. Login
**Endpoint:** `POST /api/login`
**Sin autenticación requerida**

```json
{
    "email": "usuario@ejemplo.com",
    "password": "contraseña123"
}
```

**Respuesta exitosa:**
```json
{
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "user": {
        "id": 1,
        "email": "usuario@ejemplo.com",
        "roles": ["ADMIN", "TECNICO"]
    }
}
```

## Uso del Token

Para todas las APIs protegidas, incluye el token en el header:
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
```

## APIs Protegidas

### 2. Crear Usuario (Solo ADMIN)
**Endpoint:** `POST /api/usuarios`
**Autenticación:** JWT Token
**Roles requeridos:** ADMIN

```json
{
    "nombre_usuario": "nuevo_usuario",
    "nombre": "Juan",
    "nombre2": "Carlos",
    "apellido1": "Pérez",
    "apellido2": "García",
    "password": "contraseña123",
    "email": "juan@ejemplo.com",
    "telefono": "123456789",
    "departamento": "IT",
    "estado": "ACTIVO",
    "roles": [1, 2]
}
```

### 3. Listar Usuarios
**Endpoint:** `GET /api/usuarios`
**Autenticación:** JWT Token
**Roles requeridos:** Cualquier rol autenticado

### 4. Ver Usuario Específico
**Endpoint:** `GET /api/usuario/{id}`
**Autenticación:** JWT Token
**Roles requeridos:** Cualquier rol autenticado

### 5. Eliminar Usuario (Solo ADMIN)
**Endpoint:** `DELETE /api/usuario/{id}`
**Autenticación:** JWT Token
**Roles requeridos:** ADMIN

### 6. Logout
**Endpoint:** `POST /api/logout`
**Autenticación:** JWT Token
**Roles requeridos:** Cualquier rol autenticado

## Códigos de Error

- **401 Unauthorized:** Token inválido, expirado o no proporcionado
- **403 Forbidden:** Usuario autenticado pero sin permisos suficientes
- **422 Unprocessable Entity:** Datos de validación incorrectos
- **500 Internal Server Error:** Error del servidor

## Ejemplo de Uso con cURL

```bash
# Login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@ejemplo.com","password":"admin123"}'

# Usar el token para crear usuario
curl -X POST http://localhost:8000/api/usuarios \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{"nombre_usuario":"test","nombre":"Test","nombre2":"","apellido1":"User","apellido2":"","password":"123456","email":"test@ejemplo.com","telefono":"123456","departamento":"IT","estado":"ACTIVO","roles":[1]}'
```

## Roles Disponibles

- **ADMIN:** Acceso completo a todas las funcionalidades
- **TECNICO:** Acceso a operaciones técnicas
- **AUXILIAR:** Acceso limitado a consultas

## Notas Importantes

1. El token JWT expira según la configuración en `config/jwt.php`
2. Siempre incluye el header `Authorization: Bearer [token]` en las APIs protegidas
3. Los roles se verifican usando el código del rol (ej: "ADMIN", "TECNICO")
4. El logout invalida el token actual
