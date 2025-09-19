-- =====================================================
-- SISTEMA DE RENTAS - OPERACIONES DML (UPDATE/DELETE)
-- =====================================================
-- Este archivo contiene ejemplos de operaciones UPDATE y DELETE
-- para el sistema de rentas de equipos tecnológicos
-- =====================================================

USE sistemarenta;

-- =====================================================
-- EJEMPLOS DE UPDATE
-- =====================================================

-- 1. ACTUALIZAR ESTADO DE UN CLIENTE
-- Cambiar el estado de un cliente prospecto a activo
UPDATE cliente
SET estado_cliente = 'Activo',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1 AND estado_cliente = 'Prospecto';

-- 2. ACTUALIZAR INFORMACIÓN DE CONTACTO DE UN CLIENTE
-- Actualizar teléfono y correo de un cliente
UPDATE cliente
SET telefono_principal = '+52-55-9999-8888',
    correo_electronico = 'juan.perez.nuevo@email.com',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- 3. ACTUALIZAR PRECIO DE RENTA DE UN PRODUCTO
-- Incrementar el precio de referencia de las laptops Dell en un 10%
UPDATE producto
SET precio_referencia_renta = precio_referencia_renta * 1.10,
    updated_at = CURRENT_TIMESTAMP
WHERE marca = 'Dell' AND nombre LIKE '%laptop%';

-- 4. ACTUALIZAR ESTADO DE UN ITEM DE INVENTARIO
-- Cambiar estado de un equipo de "Disponible" a "Rentado"
UPDATE inventario_item
SET estado_item = 'Rentado',
    ubicacion_fisica = 'Cliente: Juan Pérez',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- 5. ACTUALIZAR FECHA DE DEVOLUCIÓN REAL DE UNA RENTA
-- Registrar la devolución de un equipo alquilado
UPDATE renta
SET fecha_devolucion_real = '2024-09-20 14:30:00',
    estado_renta = 'Finalizada',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- 6. ACTUALIZAR ESTADO DE UNA SOLICITUD
-- Cambiar estado de solicitud de "Nueva" a "EnProceso"
UPDATE solicitud
SET estado_solicitud = 'EnProceso',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- 7. ACTUALIZAR INFORMACIÓN DE UN USUARIO
-- Actualizar departamento y teléfono de un usuario
UPDATE usuario
SET departamento = 'Soporte Técnico',
    telefono = '+52-55-7777-6666',
    updated_at = CURRENT_TIMESTAMP
WHERE nombre_usuario = 'jperez';

-- 8. ACTUALIZAR COSTO DE ADQUISICIÓN DE ITEMS
-- Aplicar un ajuste de inventario a todos los monitores
UPDATE inventario_item
SET costo_adquisicion = costo_adquisicion * 1.05,
    updated_at = CURRENT_TIMESTAMP
WHERE producto_id IN (
    SELECT id FROM producto WHERE nombre LIKE '%Monitor%'
);

-- 9. ACTUALIZAR ESTADO DE MANTENIMIENTO
-- Marcar un mantenimiento como finalizado
UPDATE mantenimiento
SET estado_mantenimiento = 'Finalizado',
    fecha_fin_real = CURRENT_DATE,
    costo_real = 75.00,
    descripcion_trabajo_realizado = 'Mantenimiento preventivo completado: limpieza, lubricación y verificación de componentes',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- 10. ACTUALIZAR DIRECCIÓN DE UN CLIENTE
-- Actualizar la dirección principal de un cliente
UPDATE direccion
SET calle = 'Av. Insurgentes Sur 1234',
    numero_exterior = '1234',
    colonia = 'Condesa',
    codigo_postal = '06140',
    referencias = 'Edificio Corporativo, Piso 15',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- =====================================================
-- EJEMPLOS DE DELETE
-- =====================================================

-- 11. ELIMINAR UNA SOLICITUD CANCELADA
-- Eliminar solicitudes que han sido canceladas y no tienen cotización asociada
DELETE FROM solicitud
WHERE estado_solicitud = 'Cancelada'
  AND id NOT IN (SELECT solicitud_id FROM cotizacion WHERE solicitud_id IS NOT NULL);

-- 12. ELIMINAR ITEMS DE INVENTARIO DADOS DE BAJA
-- Eliminar items marcados como "DeBaja" que no están en mantenimiento
DELETE FROM inventario_item
WHERE estado_item = 'DeBaja'
  AND id NOT IN (SELECT inventario_item_id FROM mantenimiento WHERE estado_mantenimiento = 'EnProceso');

-- 13. ELIMINAR COTIZACIONES VENCIDAS
-- Eliminar cotizaciones vencidas que no han sido aceptadas
DELETE FROM cotizacion
WHERE estado_cotizacion = 'Vencida'
  AND fecha_validez < CURRENT_DATE;

-- 14. ELIMINAR REGISTROS DE MANTENIMIENTO ANTIGUOS
-- Eliminar registros de mantenimiento finalizados con más de 2 años de antigüedad
DELETE FROM mantenimiento
WHERE estado_mantenimiento = 'Finalizado'
  AND fecha_fin_real < DATE_SUB(CURRENT_DATE, INTERVAL 2 YEAR);

-- 15. ELIMINAR CLIENTES INACTIVOS SIN ACTIVIDAD RECIENTE
-- Eliminar clientes inactivos que no han tenido rentas en el último año
DELETE FROM cliente
WHERE estado_cliente = 'Inactivo'
  AND id NOT IN (
      SELECT DISTINCT cliente_id
      FROM renta
      WHERE fecha_inicio >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
  );

-- 16. ELIMINAR DETALLES DE COTIZACIÓN DE COTIZACIONES ELIMINADAS
-- Limpiar detalles de cotización huérfanos (esta operación se haría automáticamente con CASCADE)
DELETE FROM detalle_cotizacion
WHERE cotizacion_id NOT IN (SELECT id FROM cotizacion);

-- 17. ELIMINAR PROVEEDORES INACTIVOS
-- Eliminar proveedores marcados como inactivos
DELETE FROM proveedor
WHERE estado_proveedor = 'Inactivo'
  AND id NOT IN (SELECT DISTINCT proveedor_id FROM inventario_item WHERE proveedor_id IS NOT NULL);

-- 18. ELIMINAR DIRECCIONES NO UTILIZADAS
-- Eliminar direcciones que no están asociadas a ningún cliente o proveedor
DELETE FROM direccion
WHERE id NOT IN (SELECT direccion_id FROM cliente_direccion)
  AND id NOT IN (SELECT direccion_id FROM proveedor_direccion);

-- 19. ELIMINAR USUARIOS BLOQUEADOS ANTIGUOS
-- Eliminar usuarios bloqueados con más de 6 meses de antigüedad
DELETE FROM usuario
WHERE estado = 'Bloqueado'
  AND updated_at < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- 20. ELIMINAR PRODUCTOS SIN INVENTARIO
-- Eliminar productos que no tienen items en inventario
DELETE FROM producto
WHERE id NOT IN (SELECT DISTINCT producto_id FROM inventario_item);

-- =====================================================
-- OPERACIONES DE MANTENIMIENTO DE DATOS
-- =====================================================

-- 21. LIMPIAR REGISTROS TEMPORALES
-- Eliminar todas las rentas finalizadas con más de 3 años
DELETE FROM renta
WHERE estado_renta = 'Finalizada'
  AND fecha_devolucion_real < DATE_SUB(CURRENT_DATE, INTERVAL 3 YEAR);

-- 22. ACTUALIZAR ESTADO MASIVO DE ITEMS
-- Marcar como disponibles todos los items que deberían estar disponibles
UPDATE inventario_item
SET estado_item = 'Disponible',
    ubicacion_fisica = 'Almacén Central',
    updated_at = CURRENT_TIMESTAMP
WHERE estado_item = 'Rentado'
  AND id NOT IN (SELECT inventario_item_id FROM renta_inventario_item WHERE renta_id IN (SELECT id FROM renta WHERE estado_renta = 'EnCurso'));

-- 23. CORRECCIÓN DE DATOS INCONSISTENTES
-- Actualizar estado de rentas retrasadas
UPDATE renta
SET estado_renta = 'Retrasada',
    updated_at = CURRENT_TIMESTAMP
WHERE estado_renta = 'EnCurso'
  AND fecha_fin_prevista < CURRENT_DATE;

-- 24. ACTUALIZACIÓN MASIVA DE PRECIOS
-- Aplicar incremento del 5% a todos los productos de una categoría
UPDATE producto p
JOIN producto_subcategoria ps ON p.id = ps.producto_id
JOIN subcategoria s ON ps.subcategoria_id = s.id
SET p.precio_referencia_renta = p.precio_referencia_renta * 1.05,
    p.updated_at = CURRENT_TIMESTAMP
WHERE s.nombre = 'Laptops';

-- 25. LIMPIEZA DE NOTAS VACÍAS
-- Reemplazar notas vacías con valor por defecto
UPDATE inventario_item
SET notas = 'Sin observaciones especiales'
WHERE notas IS NULL OR notas = '';

-- =====================================================
-- OPERACIONES CONDICIONALES AVANZADAS
-- =====================================================

-- 26. ACTUALIZAR CON SUBCONSULTA
-- Actualizar el precio de productos basado en el promedio de su categoría
UPDATE producto
SET precio_referencia_renta = (
    SELECT AVG(p2.precio_referencia_renta) * 1.2
    FROM producto p2
    JOIN producto_subcategoria ps2 ON p2.id = ps2.producto_id
    WHERE ps2.subcategoria_id IN (
        SELECT subcategoria_id
        FROM producto_subcategoria
        WHERE producto_id = producto.id
    )
)
WHERE id IN (
    SELECT producto_id
    FROM inventario_item
    GROUP BY producto_id
    HAVING COUNT(*) > 1
);

-- 27. DELETE CON MÚLTIPLES CONDICIONES
-- Eliminar rentas completadas que no tienen entregas registradas
DELETE r FROM renta r
LEFT JOIN entrega e ON r.id = e.renta_id
WHERE r.estado_renta = 'Finalizada'
  AND e.id IS NULL;

-- 28. UPDATE CON JOIN
-- Actualizar información de contacto de clientes basada en su dirección principal
UPDATE cliente c
JOIN cliente_direccion cd ON c.id = cd.cliente_id
JOIN direccion d ON cd.direccion_id = d.id
SET c.telefono_principal = CONCAT('+52-55-', LPAD(FLOOR(RAND() * 10000), 4, '0'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0'))
WHERE cd.es_principal = 1
  AND c.telefono_principal IS NULL;

-- =====================================================
-- OPERACIONES DE ACTUALIZACIÓN MASIVA
-- =====================================================

-- 29. ACTUALIZAR PRECIOS POR MARCA
-- Incrementar precios de productos Apple en un 8%
UPDATE producto
SET precio_referencia_renta = precio_referencia_renta * 1.08,
    updated_at = CURRENT_TIMESTAMP
WHERE marca = 'Apple';

-- 30. ACTUALIZAR ESTADO DE MÚLTIPLES ITEMS
-- Marcar como en mantenimiento todos los items de una marca específica
UPDATE inventario_item
SET estado_item = 'EnMantenimiento',
    ubicacion_fisica = 'Taller de Mantenimiento',
    updated_at = CURRENT_TIMESTAMP
WHERE producto_id IN (
    SELECT id FROM producto WHERE marca = 'Dell'
) AND estado_item = 'Disponible';

-- 31. ACTUALIZAR FECHAS DE VALIDEZ DE COTIZACIONES
-- Extender validez de cotizaciones activas por 15 días
UPDATE cotizacion
SET fecha_validez = DATE_ADD(fecha_validez, INTERVAL 15 DAY),
    updated_at = CURRENT_TIMESTAMP
WHERE estado_cotizacion IN ('Borrador', 'Enviada')
  AND fecha_validez > CURRENT_DATE;

-- 32. ACTUALIZAR COSTOS DE MANTENIMIENTO
-- Incrementar costos estimados de mantenimientos programados en un 10%
UPDATE mantenimiento
SET costo_estimado = costo_estimado * 1.10,
    updated_at = CURRENT_TIMESTAMP
WHERE estado_mantenimiento = 'Programado';

-- =====================================================
-- OPERACIONES DE LIMPIEZA AVANZADA
-- =====================================================

-- 33. ELIMINAR REGISTROS HUÉRFANOS
-- Eliminar direcciones sin referencia
DELETE FROM direccion
WHERE id NOT IN (
    SELECT DISTINCT direccion_id FROM cliente_direccion
    UNION
    SELECT DISTINCT direccion_id FROM proveedor_direccion
);

-- 34. ELIMINAR PRODUCTOS SIN MOVIMIENTO
-- Eliminar productos sin rentas en el último año
DELETE FROM producto
WHERE id NOT IN (
    SELECT DISTINCT p.id
    FROM producto p
    JOIN inventario_item ii ON p.id = ii.producto_id
    JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
    JOIN renta r ON rii.renta_id = r.id
    WHERE r.fecha_inicio >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
);

-- 35. ELIMINAR SOLICITUDES EXPIRADAS
-- Eliminar solicitudes sin actividad por más de 6 meses
DELETE FROM solicitud
WHERE estado_solicitud = 'Nueva'
  AND fecha_solicitud < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- =====================================================
-- OPERACIONES DE CORRECCIÓN DE DATOS
-- =====================================================

-- 36. CORREGIR ESTADOS INCONSISTENTES
-- Marcar rentas como finalizadas si tienen fecha de devolución
UPDATE renta
SET estado_renta = 'Finalizada',
    updated_at = CURRENT_TIMESTAMP
WHERE estado_renta != 'Finalizada'
  AND fecha_devolucion_real IS NOT NULL;

-- 37. CORREGIR ITEMS SIN UBICACIÓN
-- Asignar ubicación por defecto a items sin ubicación
UPDATE inventario_item
SET ubicacion_fisica = 'Almacén Central - Pendiente de Ubicación',
    updated_at = CURRENT_TIMESTAMP
WHERE ubicacion_fisica IS NULL OR ubicacion_fisica = '';

-- 38. CORREGIR PRECIOS NEGATIVOS O CERO
-- Establecer precio mínimo para productos sin precio
UPDATE producto
SET precio_referencia_renta = 10.00,
    updated_at = CURRENT_TIMESTAMP
WHERE precio_referencia_renta IS NULL OR precio_referencia_renta <= 0;

-- =====================================================
-- OPERACIONES DE ACTUALIZACIÓN CONDICIONAL
-- =====================================================

-- 39. ACTUALIZAR PRECIOS SEGÚN DEMANDA
-- Incrementar precios de productos más rentados
UPDATE producto
SET precio_referencia_renta = precio_referencia_renta * 1.15,
    updated_at = CURRENT_TIMESTAMP
WHERE id IN (
    SELECT p.id
    FROM producto p
    JOIN inventario_item ii ON p.id = ii.producto_id
    JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
    GROUP BY p.id
    HAVING COUNT(rii.id) > 5
);

-- 40. ACTUALIZAR ESTADO DE CLIENTES VIP
-- Marcar como VIP clientes con más de 10 rentas
UPDATE cliente
SET estado_cliente = 'VIP',
    updated_at = CURRENT_TIMESTAMP
WHERE id IN (
    SELECT cliente_id
    FROM renta
    GROUP BY cliente_id
    HAVING COUNT(*) > 10
);

-- =====================================================
-- OPERACIONES DE ELIMINACIÓN SEGURA
-- =====================================================

-- 41. ELIMINAR CON BACKUP LÓGICO
-- Marcar como inactivos en lugar de eliminar
UPDATE cliente
SET estado_cliente = 'Inactivo',
    updated_at = CURRENT_TIMESTAMP
WHERE id NOT IN (
    SELECT DISTINCT cliente_id FROM renta
    WHERE fecha_inicio >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
) AND estado_cliente = 'Activo';

-- 42. ELIMINAR REGISTROS TEMPORALES
-- Eliminar entregas completadas con más de 1 año
DELETE FROM entrega
WHERE estado_entrega = 'Entregada'
  AND fecha_entrega_real < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

-- 43. ELIMINAR DEVOLUCIONES ANTIGUAS
-- Eliminar registros de devolución con más de 2 años
DELETE FROM devolucion
WHERE fecha_devolucion_real < DATE_SUB(CURRENT_DATE, INTERVAL 2 YEAR);

-- =====================================================
-- OPERACIONES DE MANTENIMIENTO PROGRAMADO
-- =====================================================

-- 44. ACTUALIZAR ESTADÍSTICAS DIARIAS
-- Limpiar estadísticas antiguas (mantener solo último mes)
DELETE FROM estadisticas_diarias
WHERE fecha < DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- 45. LIMPIAR LOGS ANTIGUOS
-- Eliminar logs de auditoría con más de 6 meses
DELETE FROM auditoria_cliente
WHERE fecha_cambio < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

DELETE FROM auditoria_renta
WHERE fecha_cambio < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

DELETE FROM auditoria_inventario
WHERE fecha_cambio < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- =====================================================
-- OPERACIONES DE OPTIMIZACIÓN
-- =====================================================

-- 46. ACTUALIZAR ÍNDICES DE BÚSQUEDA
-- Actualizar campos de búsqueda fulltext si existen
-- UPDATE producto SET nombre = nombre WHERE id > 0; -- Trigger para actualizar índices

-- 47. RECALCULAR TOTALES
-- Recalcular totales de cotizaciones si hay inconsistencias
UPDATE cotizacion c
SET monto_total = (
    SELECT COALESCE(SUM(dc.subtotal), 0)
    FROM detalle_cotizacion dc
    WHERE dc.cotizacion_id = c.id
)
WHERE id IN (
    SELECT cotizacion_id
    FROM detalle_cotizacion
    GROUP BY cotizacion_id
    HAVING COUNT(*) > 0
);

-- =====================================================
-- NOTAS IMPORTANTES
-- =====================================================
/*
IMPORTANTE: Estas operaciones de DELETE son destructivas y deben
ejecutarse con precaución en un entorno de producción.

Siempre se recomienda:
1. Hacer backup antes de ejecutar DELETE
2. Probar las consultas en un entorno de desarrollo
3. Usar transacciones para operaciones críticas
4. Verificar las restricciones de integridad referencial

Ejemplo de uso seguro con transacciones:
START TRANSACTION;
-- Ejecutar DELETE
-- Verificar resultados
-- COMMIT o ROLLBACK según corresponda
COMMIT;
*/

-- =====================================================
-- EJEMPLOS DE OPERACIONES CON TRANSACCIONES
-- =====================================================

-- 48. OPERACIÓN ATÓMICA: ACTUALIZAR RENTA COMPLETA
START TRANSACTION;
    -- Actualizar estado de la renta
    UPDATE renta
    SET estado_renta = 'Finalizada',
        fecha_devolucion_real = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = 1;

    -- Actualizar estado del item
    UPDATE inventario_item
    SET estado_item = 'Disponible',
        ubicacion_fisica = 'Almacén Central',
        updated_at = CURRENT_TIMESTAMP
    WHERE id IN (
        SELECT inventario_item_id
        FROM renta_inventario_item
        WHERE renta_id = 1
    );

    -- Insertar registro de devolución
    INSERT INTO devolucion (
        renta_id,
        fecha_devolucion_programada,
        fecha_devolucion_real,
        estado_devolucion,
        persona_recibe,
        notas_generales
    ) VALUES (
        1,
        (SELECT fecha_fin_prevista FROM renta WHERE id = 1),
        CURRENT_TIMESTAMP,
        'Completa',
        'Juan Pérez',
        'Devolución automática por sistema'
    );
COMMIT;

-- 49. OPERACIÓN ATÓMICA: CREAR COTIZACIÓN COMPLETA
START TRANSACTION;
    -- Insertar cotización
    INSERT INTO cotizacion (
        cliente_id,
        fecha_cotizacion,
        fecha_validez,
        estado_cotizacion,
        terminos_condiciones
    ) VALUES (
        1,
        CURRENT_DATE,
        DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY),
        'Borrador',
        'Pago por adelantado, entrega en 24 horas'
    );

    SET @cotizacion_id = LAST_INSERT_ID();

    -- Insertar detalles
    INSERT INTO detalle_cotizacion (
        cotizacion_id,
        producto_id,
        cantidad,
        precio_unitario,
        descuento_porcentaje
    ) SELECT
        @cotizacion_id,
        id,
        1,
        precio_referencia_renta,
        0
    FROM producto
    WHERE marca = 'Dell'
    LIMIT 2;

    -- Actualizar total
    UPDATE cotizacion
    SET monto_total = (
        SELECT SUM(subtotal)
        FROM detalle_cotizacion
        WHERE cotizacion_id = @cotizacion_id
    )
    WHERE id = @cotizacion_id;
COMMIT;

-- =====================================================
-- MENSAJE FINAL
-- =====================================================

SELECT 'Operaciones DML (UPDATE/DELETE) completadas exitosamente' as mensaje_final;