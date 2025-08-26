-- DML: Data Manipulation Language para sistemarenta

-- Operaciones básicas para la tabla usuario
-- Actualizar estado de usuario
UPDATE usuario 
SET estado = 'Bloqueado',
    updated_at = CURRENT_TIMESTAMP
WHERE nombre_usuario = 'usuario_ejemplo'
AND estado = 'Activo';

-- Actualizar rol de usuario
INSERT INTO usuario_rol (usuario_id, rol_id)
SELECT u.id, r.id
FROM usuario u, rol r
WHERE u.nombre_usuario = 'usuario_ejemplo'
AND r.codigo = 'ADMIN';

-- Operaciones para inventario
-- Marcar items como en mantenimiento
UPDATE inventario_item
SET estado_item = 'EnMantenimiento',
    updated_at = CURRENT_TIMESTAMP
WHERE estado_item = 'Disponible'
AND id IN (SELECT inventario_item_id 
          FROM mantenimiento 
          WHERE estado_mantenimiento = 'Programado');

-- Actualizar precios de renta
UPDATE producto
SET precio_referencia_renta = precio_referencia_renta * 1.10
WHERE id IN (
    SELECT DISTINCT producto_id 
    FROM inventario_item 
    WHERE estado_item = 'Rentado'
);

-- Gestión de rentas
-- Marcar rentas como retrasadas
UPDATE renta
SET estado_renta = 'Retrasada',
    updated_at = CURRENT_TIMESTAMP
WHERE fecha_fin_prevista < CURRENT_TIMESTAMP
AND estado_renta = 'EnCurso';

-- Cancelar solicitudes antiguas
DELETE FROM solicitud
WHERE estado_solicitud = 'Nueva'
AND fecha_solicitud < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

-- Actualizar estado de cotizaciones
UPDATE cotizacion
SET estado_cotizacion = 'Vencida',
    updated_at = CURRENT_TIMESTAMP
WHERE estado_cotizacion = 'Enviada'
AND fecha_validez < CURRENT_DATE;

-- Gestión de mantenimientos
-- Cerrar mantenimientos completados
UPDATE mantenimiento
SET estado_mantenimiento = 'Finalizado',
    fecha_fin_real = CURRENT_DATE,
    updated_at = CURRENT_TIMESTAMP
WHERE estado_mantenimiento = 'EnProceso'
AND fecha_fin_prevista <= CURRENT_DATE;

-- Actualizar estado de items después del mantenimiento
UPDATE inventario_item i
INNER JOIN mantenimiento m ON i.id = m.inventario_item_id
SET i.estado_item = 'Disponible',
    i.updated_at = CURRENT_TIMESTAMP
WHERE m.estado_mantenimiento = 'Finalizado'
AND i.estado_item = 'EnMantenimiento';

-- Gestión de clientes
-- Actualizar estado de clientes inactivos
UPDATE cliente
SET estado_cliente = 'Inactivo',
    updated_at = CURRENT_TIMESTAMP
WHERE id NOT IN (
    SELECT DISTINCT cliente_id 
    FROM renta 
    WHERE fecha_inicio > DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
)
AND estado_cliente = 'Activo';
