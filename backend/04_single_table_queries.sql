-- Consultas a una sola tabla

-- 1. Listar todos los usuarios activos
SELECT 
    nombre_usuario,
    CONCAT(nombre, ' ', nombre2, ' ', apellido1, ' ', apellido2) as nombre_completo,
    email,
    departamento,
    estado
FROM usuario
WHERE estado = 'Activo'
ORDER BY nombre_usuario;

-- 2. Productos disponibles para renta ordenados por precio
SELECT 
    nombre,
    marca,
    modelo,
    precio_referencia_renta,
    sku
FROM producto
WHERE precio_referencia_renta IS NOT NULL
ORDER BY precio_referencia_renta DESC;

-- 3. Inventario de items en mantenimiento
SELECT 
    numero_serie,
    estado_item,
    fecha_adquisicion,
    ubicacion_fisica,
    notas
FROM inventario_item
WHERE estado_item = 'EnMantenimiento'
ORDER BY fecha_adquisicion;

-- 4. Clientes empresariales activos
SELECT 
    nombre,
    rfc,
    telefono_principal,
    correo_electronico
FROM cliente
WHERE tipo_cliente = 'Empresa'
AND estado_cliente = 'Activo';

-- 5. Rentas programadas para el próximo mes
SELECT 
    id,
    fecha_inicio,
    fecha_fin_prevista,
    monto_total_renta,
    estado_renta
FROM renta
WHERE estado_renta = 'Programada'
AND fecha_inicio BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 1 MONTH);

-- 6. Categorías y su tipo
SELECT 
    nombre,
    tipo_categoria,
    descripcion
FROM categoria
ORDER BY tipo_categoria, nombre;

-- 7. Cotizaciones pendientes por vencer
SELECT 
    id,
    fecha_cotizacion,
    fecha_validez,
    monto_total,
    estado_cotizacion
FROM cotizacion
WHERE estado_cotizacion = 'Enviada'
AND fecha_validez BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY);

-- 8. Mantenimientos en proceso
SELECT 
    fecha_inicio,
    fecha_fin_prevista,
    tipo_mantenimiento,
    descripcion_problema,
    responsable
FROM mantenimiento
WHERE estado_mantenimiento = 'EnProceso'
ORDER BY fecha_inicio;

-- 9. Solicitudes nuevas del último mes
SELECT 
    id,
    fecha_solicitud,
    nombre_producto_alternativo,
    cantidad_solicitada,
    estado_solicitud
FROM solicitud
WHERE estado_solicitud = 'Nueva'
AND fecha_solicitud >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- 10. Direcciones en Ciudad de México
SELECT 
    calle,
    numero_exterior,
    numero_interior,
    colonia,
    codigo_postal
FROM direccion
WHERE ciudad = 'Ciudad de México'
ORDER BY colonia, calle;
