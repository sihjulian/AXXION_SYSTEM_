-- Consultas multitabla

-- 1. Usuarios con sus roles
SELECT 
    u.nombre_usuario,
    CONCAT(u.nombre, ' ', u.nombre2, ' ', u.apellido1, ' ', u.apellido2) as nombre_completo,
    GROUP_CONCAT(r.nombre SEPARATOR ', ') as roles
FROM usuario u
LEFT JOIN usuario_rol ur ON u.id = ur.usuario_id
LEFT JOIN rol r ON ur.rol_id = r.id
GROUP BY u.id
ORDER BY u.nombre_usuario;

-- 2. Productos con su categoría y subcategoría
SELECT 
    p.nombre as producto,
    p.marca,
    p.modelo,
    c.nombre as categoria,
    s.nombre as subcategoria
FROM producto p
JOIN producto_subcategoria ps ON p.id = ps.producto_id
JOIN subcategoria s ON ps.subcategoria_id = s.id
JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
JOIN categoria c ON cs.categoria_id = c.id
ORDER BY c.nombre, s.nombre, p.nombre;

-- 3. Estado actual del inventario por producto
SELECT 
    p.nombre as producto,
    p.sku,
    COUNT(i.id) as total_items,
    SUM(CASE WHEN i.estado_item = 'Disponible' THEN 1 ELSE 0 END) as disponibles,
    SUM(CASE WHEN i.estado_item = 'Rentado' THEN 1 ELSE 0 END) as rentados,
    SUM(CASE WHEN i.estado_item = 'EnMantenimiento' THEN 1 ELSE 0 END) as en_mantenimiento
FROM producto p
LEFT JOIN inventario_item i ON p.id = i.producto_id
GROUP BY p.id
ORDER BY p.nombre;

-- 4. Historial de rentas por cliente
SELECT 
    CONCAT(c.nombre, ' ', c.nombre2, ' ', c.apellido1, ' ', c.apellido2) as cliente,
    c.tipo_cliente,
    COUNT(r.id) as total_rentas,
    SUM(r.monto_total_renta) as monto_total,
    MIN(r.fecha_inicio) as primera_renta,
    MAX(r.fecha_inicio) as ultima_renta
FROM cliente c
LEFT JOIN renta r ON c.id = r.cliente_id
GROUP BY c.id
HAVING COUNT(r.id) > 0
ORDER BY monto_total DESC;

-- 5. Items más rentados
SELECT 
    p.nombre as producto,
    i.numero_serie,
    COUNT(ri.renta_id) as veces_rentado,
    SUM(ri.precio_renta_item) as ingresos_totales
FROM inventario_item i
JOIN producto p ON i.producto_id = p.id
LEFT JOIN renta_inventario_item ri ON i.id = ri.inventario_item_id
GROUP BY i.id
ORDER BY veces_rentado DESC;

-- 6. Resumen de mantenimientos por producto
SELECT 
    p.nombre as producto,
    i.numero_serie,
    COUNT(m.id) as total_mantenimientos,
    SUM(m.costo_real) as costo_total_mantenimiento,
    MAX(m.fecha_inicio) as ultimo_mantenimiento
FROM producto p
JOIN inventario_item i ON p.id = i.producto_id
LEFT JOIN mantenimiento m ON i.id = m.inventario_item_id
GROUP BY i.id
HAVING COUNT(m.id) > 0
ORDER BY costo_total_mantenimiento DESC;

-- 7. Clientes con sus direcciones
SELECT 
    CONCAT(c.nombre, ' ', c.nombre2, ' ', c.apellido1, ' ', c.apellido2) as cliente,
    c.telefono_principal,
    d.calle,
    d.numero_exterior,
    d.colonia,
    d.ciudad,
    d.estado_provincia,
    cd.es_principal
FROM cliente c
JOIN cliente_direccion cd ON c.id = cd.cliente_id
JOIN direccion d ON cd.direccion_id = d.id
ORDER BY c.nombre, cd.es_principal DESC;

-- 8. Cotizaciones con sus detalles
SELECT 
    cot.id as cotizacion_id,
    CONCAT(c.nombre, ' ', c.nombre2, ' ', c.apellido1, ' ', c.apellido2) as cliente,
    cot.fecha_cotizacion,
    p.nombre as producto,
    dc.cantidad,
    dc.precio_unitario,
    dc.subtotal,
    cot.monto_total
FROM cotizacion cot
JOIN cliente c ON cot.cliente_id = c.id
JOIN detalle_cotizacion dc ON cot.id = dc.cotizacion_id
JOIN producto p ON dc.producto_id = p.id
ORDER BY cot.fecha_cotizacion DESC;

-- 9. Entregas pendientes con dirección
SELECT 
    r.id as renta_id,
    CONCAT(c.nombre, ' ', c.nombre2, ' ', c.apellido1, ' ', c.apellido2) as cliente,
    e.fecha_envio,
    e.estado_entrega,
    d.calle,
    d.numero_exterior,
    d.colonia,
    d.ciudad
FROM renta r
JOIN cliente c ON r.cliente_id = c.id
JOIN entrega e ON r.id = e.renta_id
JOIN direccion d ON e.direccion_id = d.id
WHERE e.estado_entrega IN ('Programada', 'EnTransito')
ORDER BY e.fecha_envio;

-- 10. Resumen de devoluciones por renta
SELECT 
    r.id as renta_id,
    CONCAT(c.nombre, ' ', c.nombre2, ' ', c.apellido1, ' ', c.apellido2) as cliente,
    r.fecha_inicio,
    r.fecha_fin_prevista,
    d.fecha_devolucion_real,
    d.estado_devolucion,
    COUNT(ri.inventario_item_id) as items_rentados,
    GROUP_CONCAT(p.nombre SEPARATOR ', ') as productos
FROM renta r
JOIN cliente c ON r.cliente_id = c.id
JOIN renta_inventario_item ri ON r.id = ri.renta_id
JOIN inventario_item i ON ri.inventario_item_id = i.id
JOIN producto p ON i.producto_id = p.id
LEFT JOIN devolucion d ON r.id = d.renta_id
GROUP BY r.id
ORDER BY r.fecha_inicio DESC;
