-- =====================================================
-- VIEWS, TRIGGERS Y STORED PROCEDURES - SISTEMA DE RENTA
-- =====================================================
-- Descripción: Objetos avanzados de base de datos
-- Autor: Sistema AXXION
-- Fecha: 2025-09-18
-- =====================================================

USE sistemarenta;

-- =====================================================
-- VISTAS (VIEWS) PARA REPORTES DE NEGOCIO
-- =====================================================

-- Vista: Resumen de clientes con sus rentas
CREATE OR REPLACE VIEW vista_clientes_resumen AS
SELECT 
    c.id,
    CONCAT(c.nombre, ' ', c.apellido1, ' ', c.apellido2) as nombre_completo,
    c.tipo_cliente,
    c.estado_cliente,
    c.correo_electronico,
    c.telefono_principal,
    COUNT(DISTINCT r.id) as total_rentas,
    COALESCE(SUM(r.monto_total_renta), 0) as ingresos_generados,
    COALESCE(AVG(r.monto_total_renta), 0) as promedio_por_renta,
    MAX(r.fecha_inicio) as ultima_renta,
    DATEDIFF(CURDATE(), MAX(r.fecha_inicio)) as dias_desde_ultima_renta
FROM cliente c
LEFT JOIN renta r ON c.id = r.cliente_id AND r.estado_renta IN ('Finalizada', 'EnCurso')
GROUP BY c.id;

-- Vista: Inventario disponible con detalles
CREATE OR REPLACE VIEW vista_inventario_disponible AS
SELECT 
    p.id as producto_id,
    p.nombre as producto,
    p.marca,
    p.modelo,
    p.precio_referencia_renta,
    ii.id as item_id,
    ii.numero_serie,
    ii.estado_item,
    ii.ubicacion_fisica,
    ii.fecha_adquisicion,
    cat.nombre as categoria,
    sub.nombre as subcategoria,
    DATEDIFF(CURDATE(), ii.fecha_adquisicion) as dias_desde_adquisicion
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN producto_subcategoria ps ON p.id = ps.producto_id
LEFT JOIN subcategoria sub ON ps.subcategoria_id = sub.id
LEFT JOIN categoria_subcategoria cs ON sub.id = cs.subcategoria_id
LEFT JOIN categoria cat ON cs.categoria_id = cat.id
WHERE ii.estado_item = 'Disponible'
ORDER BY p.nombre, ii.numero_serie;

-- Vista: Rentas activas con detalles completos
CREATE OR REPLACE VIEW vista_rentas_activas AS
SELECT 
    r.id as renta_id,
    CONCAT(c.nombre, ' ', c.apellido1) as cliente,
    c.telefono_principal,
    c.correo_electronico,
    r.fecha_inicio,
    r.fecha_fin_prevista,
    r.estado_renta,
    r.monto_total_renta,
    r.deposito_garantia,
    DATEDIFF(r.fecha_fin_prevista, CURDATE()) as dias_para_devolucion,
    GROUP_CONCAT(
        CONCAT(p.nombre, ' (', ii.numero_serie, ')')
        SEPARATOR ', '
    ) as equipos_rentados,
    COUNT(rii.inventario_item_id) as cantidad_equipos
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
INNER JOIN renta_inventario_item rii ON r.id = rii.renta_id
INNER JOIN inventario_item ii ON rii.inventario_item_id = ii.id
INNER JOIN producto p ON ii.producto_id = p.id
WHERE r.estado_renta IN ('EnCurso', 'Programada')
GROUP BY r.id
ORDER BY r.fecha_fin_prevista;

-- Vista: Dashboard de métricas del negocio
CREATE OR REPLACE VIEW vista_dashboard_metricas AS
SELECT 
    (SELECT COUNT(*) FROM cliente WHERE estado_cliente = 'Activo') as clientes_activos,
    (SELECT COUNT(*) FROM inventario_item WHERE estado_item = 'Disponible') as equipos_disponibles,
    (SELECT COUNT(*) FROM inventario_item WHERE estado_item = 'Rentado') as equipos_rentados,
    (SELECT COUNT(*) FROM renta WHERE estado_renta = 'EnCurso') as rentas_activas,
    (SELECT COUNT(*) FROM renta WHERE estado_renta = 'Retrasada') as rentas_retrasadas,
    (SELECT COALESCE(SUM(monto_total_renta), 0) 
     FROM renta 
     WHERE MONTH(fecha_inicio) = MONTH(CURDATE()) 
     AND YEAR(fecha_inicio) = YEAR(CURDATE())) as ingresos_mes_actual,
    (SELECT COUNT(*) 
     FROM renta 
     WHERE MONTH(fecha_inicio) = MONTH(CURDATE()) 
     AND YEAR(fecha_inicio) = YEAR(CURDATE())) as rentas_mes_actual;

-- Vista: Productos más rentables
CREATE OR REPLACE VIEW vista_productos_rentables AS
SELECT 
    p.id,
    p.nombre as producto,
    p.marca,
    p.modelo,
    COUNT(DISTINCT ii.id) as items_inventario,
    COUNT(rii.inventario_item_id) as veces_rentado,
    COALESCE(SUM(rii.precio_renta_item), 0) as ingresos_totales,
    COALESCE(AVG(rii.precio_renta_item), 0) as precio_promedio,
    ROUND(COUNT(rii.inventario_item_id) / COUNT(DISTINCT ii.id), 2) as rotacion_promedio,
    COALESCE(SUM(ii.costo_adquisicion), 0) as inversion_total,
    CASE 
        WHEN SUM(ii.costo_adquisicion) > 0 THEN 
            ROUND((SUM(rii.precio_renta_item) / SUM(ii.costo_adquisicion)) * 100, 2)
        ELSE 0 
    END as roi_porcentaje
FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
LEFT JOIN renta r ON rii.renta_id = r.id AND r.estado_renta IN ('Finalizada', 'EnCurso')
GROUP BY p.id
ORDER BY ingresos_totales DESC;

-- =====================================================
-- TRIGGERS PARA AUTOMATIZACIÓN DE LÓGICA DE NEGOCIO
-- =====================================================

-- Trigger: Actualizar estado de inventario cuando se crea una renta
DELIMITER //
CREATE TRIGGER tr_renta_inventario_insert
AFTER INSERT ON renta_inventario_item
FOR EACH ROW
BEGIN
    UPDATE inventario_item 
    SET estado_item = 'Rentado',
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.inventario_item_id;
END//
DELIMITER ;

-- Trigger: Restaurar estado de inventario cuando se finaliza una renta
DELIMITER //
CREATE TRIGGER tr_renta_finalizada
AFTER UPDATE ON renta
FOR EACH ROW
BEGIN
    IF NEW.estado_renta = 'Finalizada' AND OLD.estado_renta != 'Finalizada' THEN
        UPDATE inventario_item ii
        INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
        SET ii.estado_item = 'Disponible',
            ii.updated_at = CURRENT_TIMESTAMP
        WHERE rii.renta_id = NEW.id;
    END IF;
END//
DELIMITER ;

-- Trigger: Auditoría automática para cambios en clientes
DELIMITER //
CREATE TRIGGER tr_cliente_auditoria_update
AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (
        tabla_afectada, operacion, id_registro, 
        valores_anteriores, valores_nuevos, fecha_operacion
    ) VALUES (
        'cliente', 'UPDATE', NEW.id,
        JSON_OBJECT(
            'nombre', OLD.nombre,
            'apellido1', OLD.apellido1,
            'telefono_principal', OLD.telefono_principal,
            'correo_electronico', OLD.correo_electronico,
            'estado_cliente', OLD.estado_cliente
        ),
        JSON_OBJECT(
            'nombre', NEW.nombre,
            'apellido1', NEW.apellido1,
            'telefono_principal', NEW.telefono_principal,
            'correo_electronico', NEW.correo_electronico,
            'estado_cliente', NEW.estado_cliente
        ),
        CURRENT_TIMESTAMP
    );
END//
DELIMITER ;

-- Trigger: Validar fechas de renta antes de insertar
DELIMITER //
CREATE TRIGGER tr_validar_fechas_renta
BEFORE INSERT ON renta
FOR EACH ROW
BEGIN
    IF NEW.fecha_fin_prevista <= NEW.fecha_inicio THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La fecha de fin debe ser posterior a la fecha de inicio';
    END IF;
    
    IF NEW.fecha_inicio < CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se pueden crear rentas con fecha de inicio en el pasado';
    END IF;
END//
DELIMITER ;

-- Trigger: Notificación automática para rentas próximas a vencer
DELIMITER //
CREATE TRIGGER tr_notificar_vencimiento_renta
AFTER INSERT ON renta
FOR EACH ROW
BEGIN
    DECLARE dias_recordatorio INT DEFAULT 1;
    
    SELECT valor INTO dias_recordatorio 
    FROM configuracion_sistema 
    WHERE clave = 'DIAS_RECORDATORIO_DEVOLUCION';
    
    IF DATEDIFF(NEW.fecha_fin_prevista, CURDATE()) <= dias_recordatorio THEN
        INSERT INTO notificacion (
            usuario_id, titulo, mensaje, tipo, fecha_envio
        ) VALUES (
            (SELECT id FROM usuario WHERE nombre_usuario = 'admin' LIMIT 1),
            'Renta próxima a vencer',
            CONCAT('La renta #', NEW.id, ' vence el ', DATE_FORMAT(NEW.fecha_fin_prevista, '%d/%m/%Y')),
            'WARNING',
            CURRENT_TIMESTAMP
        );
    END IF;
END//
DELIMITER ;

-- =====================================================
-- STORED PROCEDURES PARA OPERACIONES COMPLEJAS
-- =====================================================

-- Procedimiento: Crear renta completa con validaciones
DELIMITER //
CREATE PROCEDURE sp_crear_renta_completa(
    IN p_cliente_id INT,
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin_prevista DATETIME,
    IN p_deposito_garantia DECIMAL(10,2),
    IN p_metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'Cheque'),
    IN p_items_inventario JSON,
    OUT p_renta_id INT,
    OUT p_mensaje VARCHAR(500)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_item_id INT;
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_items_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensaje = 'Error al crear la renta. Transacción cancelada.';
        SET p_renta_id = 0;
    END;

    START TRANSACTION;
    
    -- Validar que el cliente existe y está activo
    SELECT COUNT(*) INTO v_count 
    FROM cliente 
    WHERE id = p_cliente_id AND estado_cliente = 'Activo';
    
    IF v_count = 0 THEN
        SET p_mensaje = 'Cliente no encontrado o inactivo';
        SET p_renta_id = 0;
        ROLLBACK;
    ELSE
        -- Validar disponibilidad de items
        SET v_items_count = JSON_LENGTH(p_items_inventario);
        
        WHILE v_i < v_items_count DO
            SET v_item_id = JSON_UNQUOTE(JSON_EXTRACT(p_items_inventario, CONCAT('$[', v_i, '].item_id')));
            
            SELECT COUNT(*) INTO v_count 
            FROM inventario_item 
            WHERE id = v_item_id AND estado_item = 'Disponible';
            
            IF v_count = 0 THEN
                SET p_mensaje = CONCAT('Item de inventario ', v_item_id, ' no disponible');
                SET p_renta_id = 0;
                ROLLBACK;
            END IF;
            
            SET v_i = v_i + 1;
        END WHILE;
        
        -- Crear la renta
        INSERT INTO renta (
            cliente_id, fecha_inicio, fecha_fin_prevista, 
            estado_renta, deposito_garantia, metodo_pago
        ) VALUES (
            p_cliente_id, p_fecha_inicio, p_fecha_fin_prevista,
            'Programada', p_deposito_garantia, p_metodo_pago
        );
        
        SET p_renta_id = LAST_INSERT_ID();
        
        -- Agregar items a la renta
        SET v_i = 0;
        WHILE v_i < v_items_count DO
            SET v_item_id = JSON_UNQUOTE(JSON_EXTRACT(p_items_inventario, CONCAT('$[', v_i, '].item_id')));
            SET v_precio = JSON_UNQUOTE(JSON_EXTRACT(p_items_inventario, CONCAT('$[', v_i, '].precio')));
            
            INSERT INTO renta_inventario_item (
                renta_id, inventario_item_id, precio_renta_item
            ) VALUES (
                p_renta_id, v_item_id, v_precio
            );
            
            SET v_total = v_total + v_precio;
            SET v_i = v_i + 1;
        END WHILE;
        
        -- Actualizar monto total de la renta
        UPDATE renta 
        SET monto_total_renta = v_total 
        WHERE id = p_renta_id;
        
        COMMIT;
        SET p_mensaje = 'Renta creada exitosamente';
    END IF;
END//
DELIMITER ;

-- Procedimiento: Finalizar renta y calcular penalizaciones
DELIMITER //
CREATE PROCEDURE sp_finalizar_renta(
    IN p_renta_id INT,
    IN p_fecha_devolucion_real DATETIME,
    IN p_condiciones_regreso JSON,
    OUT p_penalizacion DECIMAL(10,2),
    OUT p_mensaje VARCHAR(500)
)
BEGIN
    DECLARE v_fecha_fin_prevista DATETIME;
    DECLARE v_dias_retraso INT DEFAULT 0;
    DECLARE v_monto_renta DECIMAL(10,2);
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensaje = 'Error al finalizar la renta';
        SET p_penalizacion = 0;
    END;

    START TRANSACTION;
    
    -- Validar que la renta existe
    SELECT COUNT(*), fecha_fin_prevista, monto_total_renta
    INTO v_count, v_fecha_fin_prevista, v_monto_renta
    FROM renta 
    WHERE id = p_renta_id AND estado_renta IN ('EnCurso', 'Retrasada');
    
    IF v_count = 0 THEN
        SET p_mensaje = 'Renta no encontrada o ya finalizada';
        SET p_penalizacion = 0;
        ROLLBACK;
    ELSE
        -- Calcular días de retraso
        SET v_dias_retraso = GREATEST(0, DATEDIFF(p_fecha_devolucion_real, v_fecha_fin_prevista));
        
        -- Calcular penalización (10% del monto por día de retraso)
        SET p_penalizacion = v_dias_retraso * (v_monto_renta * 0.10);
        
        -- Actualizar la renta
        UPDATE renta 
        SET estado_renta = 'Finalizada',
            fecha_devolucion_real = p_fecha_devolucion_real,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_renta_id;
        
        -- Actualizar condiciones de regreso si se proporcionaron
        IF p_condiciones_regreso IS NOT NULL THEN
            UPDATE renta_inventario_item rii
            INNER JOIN inventario_item ii ON rii.inventario_item_id = ii.id
            SET rii.condicion_regreso = JSON_UNQUOTE(JSON_EXTRACT(p_condiciones_regreso, CONCAT('$.', ii.numero_serie)))
            WHERE rii.renta_id = p_renta_id;
        END IF;
        
        COMMIT;
        
        IF v_dias_retraso > 0 THEN
            SET p_mensaje = CONCAT('Renta finalizada con ', v_dias_retraso, ' días de retraso. Penalización: $', p_penalizacion);
        ELSE
            SET p_mensaje = 'Renta finalizada exitosamente sin penalizaciones';
        END IF;
    END IF;
END//
DELIMITER ;

-- Procedimiento: Reporte de ingresos por período
DELIMITER //
CREATE PROCEDURE sp_reporte_ingresos(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_tipo_reporte ENUM('DIARIO', 'SEMANAL', 'MENSUAL')
)
BEGIN
    IF p_tipo_reporte = 'DIARIO' THEN
        SELECT 
            DATE(r.fecha_inicio) as fecha,
            COUNT(*) as total_rentas,
            SUM(r.monto_total_renta) as ingresos_totales,
            AVG(r.monto_total_renta) as promedio_renta,
            COUNT(DISTINCT r.cliente_id) as clientes_unicos
        FROM renta r
        WHERE DATE(r.fecha_inicio) BETWEEN p_fecha_inicio AND p_fecha_fin
        AND r.estado_renta IN ('Finalizada', 'EnCurso')
        GROUP BY DATE(r.fecha_inicio)
        ORDER BY fecha;
        
    ELSEIF p_tipo_reporte = 'SEMANAL' THEN
        SELECT 
            YEARWEEK(r.fecha_inicio) as semana,
            MIN(DATE(r.fecha_inicio)) as fecha_inicio_semana,
            MAX(DATE(r.fecha_inicio)) as fecha_fin_semana,
            COUNT(*) as total_rentas,
            SUM(r.monto_total_renta) as ingresos_totales
        FROM renta r
        WHERE DATE(r.fecha_inicio) BETWEEN p_fecha_inicio AND p_fecha_fin
        AND r.estado_renta IN ('Finalizada', 'EnCurso')
        GROUP BY YEARWEEK(r.fecha_inicio)
        ORDER BY semana;
        
    ELSEIF p_tipo_reporte = 'MENSUAL' THEN
        SELECT 
            YEAR(r.fecha_inicio) as año,
            MONTH(r.fecha_inicio) as mes,
            MONTHNAME(r.fecha_inicio) as nombre_mes,
            COUNT(*) as total_rentas,
            SUM(r.monto_total_renta) as ingresos_totales,
            COUNT(DISTINCT r.cliente_id) as clientes_unicos
        FROM renta r
        WHERE DATE(r.fecha_inicio) BETWEEN p_fecha_inicio AND p_fecha_fin
        AND r.estado_renta IN ('Finalizada', 'EnCurso')
        GROUP BY YEAR(r.fecha_inicio), MONTH(r.fecha_inicio)
        ORDER BY año, mes;
    END IF;
END//
DELIMITER ;

-- Procedimiento: Mantenimiento automático de datos
DELIMITER //
CREATE PROCEDURE sp_mantenimiento_automatico()
BEGIN
    DECLARE v_registros_eliminados INT DEFAULT 0;
    
    -- Limpiar notificaciones leídas antiguas
    DELETE FROM notificacion 
    WHERE leida = TRUE 
    AND fecha_leida < DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
    
    SET v_registros_eliminados = ROW_COUNT();
    
    -- Limpiar auditoría antigua
    DELETE FROM auditoria 
    WHERE fecha_operacion < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
    
    SET v_registros_eliminados = v_registros_eliminados + ROW_COUNT();
    
    -- Marcar cotizaciones vencidas
    UPDATE cotizacion 
    SET estado_cotizacion = 'Vencida',
        updated_at = CURRENT_TIMESTAMP
    WHERE fecha_validez < CURDATE() 
    AND estado_cotizacion IN ('Borrador', 'Enviada');
    
    -- Marcar rentas retrasadas
    UPDATE renta 
    SET estado_renta = 'Retrasada',
        updated_at = CURRENT_TIMESTAMP
    WHERE fecha_fin_prevista < NOW() 
    AND fecha_devolucion_real IS NULL 
    AND estado_renta = 'EnCurso';
    
    SELECT CONCAT('Mantenimiento completado. Registros eliminados: ', v_registros_eliminados) as resultado;
END//
DELIMITER ;

-- =====================================================
-- FIN DE VIEWS, TRIGGERS Y STORED PROCEDURES
-- =====================================================
