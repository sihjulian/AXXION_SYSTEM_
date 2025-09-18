-- =====================================================
-- SCRIPT DML - UPDATES Y DELETES
-- =====================================================
-- Descripción: Operaciones de actualización y eliminación de datos
-- Autor: Sistema AXXION
-- Fecha: 2025-09-18
-- =====================================================

USE sistemarenta;

-- =====================================================
-- OPERACIONES UPDATE
-- =====================================================

-- 1. Actualizar estado de cliente de Prospecto a Activo cuando realiza su primera renta
UPDATE cliente 
SET estado_cliente = 'Activo', 
    updated_at = CURRENT_TIMESTAMP
WHERE id IN (
    SELECT DISTINCT cliente_id 
    FROM renta 
    WHERE estado_renta IN ('EnCurso', 'Finalizada')
) AND estado_cliente = 'Prospecto';

-- 2. Actualizar precios de productos por categoría (incremento del 10%)
UPDATE producto p
INNER JOIN producto_subcategoria ps ON p.id = ps.producto_id
INNER JOIN subcategoria s ON ps.subcategoria_id = s.id
INNER JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
INNER JOIN categoria c ON cs.categoria_id = c.id
SET p.precio_referencia_renta = p.precio_referencia_renta * 1.10
WHERE c.nombre = 'Computadoras';

-- 3. Actualizar estado de items de inventario cuando son devueltos
UPDATE inventario_item ii
INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
INNER JOIN renta r ON rii.renta_id = r.id
SET ii.estado_item = 'Disponible',
    ii.updated_at = CURRENT_TIMESTAMP
WHERE r.estado_renta = 'Finalizada' 
AND ii.estado_item = 'Rentado';

-- 4. Actualizar información de contacto de clientes
UPDATE cliente 
SET telefono_principal = '555-0123',
    correo_electronico = CONCAT(LOWER(nombre), '.', LOWER(apellido1), '@email.com'),
    updated_at = CURRENT_TIMESTAMP
WHERE telefono_principal IS NULL 
AND id BETWEEN 1 AND 5;

-- 5. Marcar cotizaciones como vencidas
UPDATE cotizacion 
SET estado_cotizacion = 'Vencida',
    updated_at = CURRENT_TIMESTAMP
WHERE fecha_validez < CURDATE() 
AND estado_cotizacion IN ('Borrador', 'Enviada');

-- 6. Actualizar estado de rentas retrasadas
UPDATE renta 
SET estado_renta = 'Retrasada',
    updated_at = CURRENT_TIMESTAMP
WHERE fecha_fin_prevista < NOW() 
AND fecha_devolucion_real IS NULL 
AND estado_renta = 'EnCurso';

-- 7. Actualizar dirección principal de clientes
UPDATE cliente_direccion 
SET es_principal = 0
WHERE cliente_id = 1;

UPDATE cliente_direccion 
SET es_principal = 1
WHERE cliente_id = 1 AND direccion_id = 2;

-- 8. Actualizar costos reales de mantenimiento
UPDATE mantenimiento 
SET costo_real = costo_estimado * 1.15,
    estado_mantenimiento = 'Finalizado',
    fecha_fin_real = CURDATE(),
    updated_at = CURRENT_TIMESTAMP
WHERE estado_mantenimiento = 'EnProceso' 
AND fecha_fin_prevista <= CURDATE();

-- =====================================================
-- OPERACIONES DELETE
-- =====================================================

-- 1. Eliminar cotizaciones vencidas sin actividad (más de 6 meses)
DELETE FROM cotizacion 
WHERE estado_cotizacion = 'Vencida' 
AND fecha_cotizacion < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
AND id NOT IN (SELECT DISTINCT cotizacion_id FROM renta WHERE cotizacion_id IS NOT NULL);

-- 2. Eliminar solicitudes canceladas antiguas
DELETE FROM solicitud 
WHERE estado_solicitud = 'Cancelada' 
AND fecha_solicitud < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- 3. Eliminar direcciones no utilizadas (sin clientes ni proveedores asociados)
DELETE d FROM direccion d
LEFT JOIN cliente_direccion cd ON d.id = cd.direccion_id
LEFT JOIN proveedor_direccion pd ON d.id = pd.direccion_id
LEFT JOIN entrega e ON d.id = e.direccion_id
WHERE cd.direccion_id IS NULL 
AND pd.direccion_id IS NULL 
AND e.direccion_id IS NULL;

-- 4. Eliminar productos descontinuados sin inventario
DELETE p FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
WHERE p.estado_producto = 'Descontinuado'
AND ii.producto_id IS NULL;

-- 5. Eliminar mantenimientos cancelados antiguos
DELETE FROM mantenimiento 
WHERE estado_mantenimiento = 'Cancelado' 
AND created_at < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- 6. Eliminar subcategorías sin productos asociados
DELETE s FROM subcategoria s
LEFT JOIN producto_subcategoria ps ON s.id = ps.subcategoria_id
WHERE ps.subcategoria_id IS NULL
AND s.created_at < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 7. Eliminar notificaciones leídas antiguas
DELETE FROM notificacion 
WHERE leida = TRUE 
AND fecha_leida < DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- 8. Eliminar registros de auditoría antiguos (más de 2 años)
DELETE FROM auditoria 
WHERE fecha_operacion < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- =====================================================
-- OPERACIONES DE LIMPIEZA Y MANTENIMIENTO
-- =====================================================

-- Eliminar duplicados en tabla cliente (por RFC)
DELETE c1 FROM cliente c1
INNER JOIN cliente c2 
WHERE c1.id > c2.id 
AND c1.rfc = c2.rfc 
AND c1.rfc IS NOT NULL;

-- Actualizar campos calculados en renta
UPDATE renta r
SET monto_total_renta = (
    SELECT SUM(rii.precio_renta_item)
    FROM renta_inventario_item rii
    WHERE rii.renta_id = r.id
) - r.descuento_aplicado
WHERE r.monto_total_renta IS NULL;

-- Normalizar datos de texto (convertir a formato apropiado)
UPDATE cliente 
SET nombre = CONCAT(UPPER(LEFT(nombre, 1)), LOWER(SUBSTRING(nombre, 2))),
    apellido1 = CONCAT(UPPER(LEFT(apellido1, 1)), LOWER(SUBSTRING(apellido1, 2))),
    apellido2 = CONCAT(UPPER(LEFT(apellido2, 1)), LOWER(SUBSTRING(apellido2, 2)))
WHERE LENGTH(nombre) > 1;

-- =====================================================
-- FIN DEL SCRIPT DML
-- =====================================================