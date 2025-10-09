-- =====================================================
-- SISTEMA DE RENTAS - PROCEDIMIENTOS ALMACENADOS
-- =====================================================
-- Este archivo contiene procedimientos almacenados para
-- operaciones complejas del sistema de rentas
-- =====================================================

USE sistemarenta;

-- =====================================================
-- PROCEDIMIENTOS PARA GESTIÓN DE RENTAS
-- =====================================================

-- Procedimiento para crear una nueva renta completa
DELIMITER //
CREATE PROCEDURE sp_crear_renta_completa(
    IN p_cliente_id INT,
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin_prevista DATETIME,
    IN p_items JSON, -- Array de objetos con item_id y precio_renta_item
    IN p_deposito_garantia DECIMAL(10,2),
    IN p_notas TEXT,
    OUT p_renta_id INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_monto_total DECIMAL(12,2) DEFAULT 0;
    DECLARE v_item_count INT DEFAULT 0;
    DECLARE v_item_id INT;
    DECLARE v_precio_item DECIMAL(10,2);
    DECLARE i INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_mensaje = 'Error al crear la renta';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Validar que el cliente existe y está activo
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id = p_cliente_id AND estado_cliente = 'Activo') THEN
        SET p_mensaje = 'Cliente no encontrado o inactivo';
        ROLLBACK;
    ELSE
        -- Calcular monto total
        WHILE i < JSON_LENGTH(p_items) DO
            SET v_item_id = JSON_EXTRACT(p_items, CONCAT('$[', i, '].item_id'));
            SET v_precio_item = JSON_EXTRACT(p_items, CONCAT('$[', i, '].precio_renta_item'));
            SET v_monto_total = v_monto_total + v_precio_item;
            SET i = i + 1;
        END WHILE;

        -- Insertar la renta
        INSERT INTO renta (
            cliente_id,
            fecha_inicio,
            fecha_fin_prevista,
            monto_total_renta,
            deposito_garantia,
            notas
        ) VALUES (
            p_cliente_id,
            p_fecha_inicio,
            p_fecha_fin_prevista,
            v_monto_total,
            p_deposito_garantia,
            p_notas
        );

        SET p_renta_id = LAST_INSERT_ID();

        -- Insertar items de la renta
        SET i = 0;
        WHILE i < JSON_LENGTH(p_items) DO
            SET v_item_id = JSON_EXTRACT(p_items, CONCAT('$[', i, '].item_id'));
            SET v_precio_item = JSON_EXTRACT(p_items, CONCAT('$[', i, '].precio_renta_item'));

            INSERT INTO renta_inventario_item (
                renta_id,
                inventario_item_id,
                precio_renta_item
            ) VALUES (
                p_renta_id,
                v_item_id,
                v_precio_item
            );

            SET i = i + 1;
        END WHILE;

        SET p_mensaje = 'Renta creada exitosamente';
        COMMIT;
    END IF;
END//
DELIMITER ;

call sp_crear_renta_completa;

-- Procedimiento para finalizar una renta
DELIMITER //
CREATE PROCEDURE sp_finalizar_renta(
    IN p_renta_id INT,
    IN p_fecha_devolucion_real DATETIME,
    IN p_estado_devolucion ENUM('Pendiente','EnProcesoInspeccion','Completa','IncompletaConProblemas'),
    IN p_persona_recibe VARCHAR(150),
    IN p_notas_devolucion TEXT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_estado_actual ENUM('Programada','EnCurso','Finalizada','Retrasada','Cancelada');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_mensaje = 'Error al finalizar la renta';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Obtener estado actual
    SELECT estado_renta INTO v_estado_actual
    FROM renta
    WHERE id = p_renta_id;

    IF v_estado_actual IS NULL THEN
        SET p_mensaje = 'Renta no encontrada';
    ELSEIF v_estado_actual = 'Finalizada' THEN
        SET p_mensaje = 'La renta ya está finalizada';
    ELSE
        -- Actualizar la renta
        UPDATE renta
        SET estado_renta = 'Finalizada',
            fecha_devolucion_real = p_fecha_devolucion_real,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_renta_id;

        -- Insertar registro de devolución
        INSERT INTO devolucion (
            renta_id,
            fecha_devolucion_programada,
            fecha_devolucion_real,
            estado_devolucion,
            persona_recibe,
            notas_generales
        ) VALUES (
            p_renta_id,
            (SELECT fecha_fin_prevista FROM renta WHERE id = p_renta_id),
            p_fecha_devolucion_real,
            p_estado_devolucion,
            p_persona_recibe,
            p_notas_devolucion
        );

        SET p_mensaje = 'Renta finalizada exitosamente';
        COMMIT;
    END IF;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA REPORTES
-- =====================================================

-- Procedimiento para obtener reporte de ingresos por período
DELIMITER //
CREATE PROCEDURE sp_reporte_ingresos_periodo(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_agrupar_por ENUM('dia', 'semana', 'mes', 'anio')
)
BEGIN
    SET @sql = CONCAT('
        SELECT
            CASE
                WHEN ? = "dia" THEN DATE(r.fecha_inicio)
                WHEN ? = "semana" THEN DATE_SUB(r.fecha_inicio, INTERVAL WEEKDAY(r.fecha_inicio) DAY)
                WHEN ? = "mes" THEN DATE_FORMAT(r.fecha_inicio, "%Y-%m-01")
                WHEN ? = "anio" THEN DATE_FORMAT(r.fecha_inicio, "%Y-01-01")
            END as periodo,
            COUNT(*) as cantidad_rentas,
            SUM(r.monto_total_renta) as ingresos_rentas,
            SUM(r.deposito_garantia) as ingresos_garantias,
            SUM(r.monto_total_renta + r.deposito_garantia) as ingresos_totales,
            AVG(r.monto_total_renta) as renta_promedio,
            COUNT(DISTINCT r.cliente_id) as clientes_unicos
        FROM renta r
        WHERE r.estado_renta = "Finalizada"
        AND r.fecha_inicio BETWEEN ? AND ?
        GROUP BY periodo
        ORDER BY periodo DESC
    ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING p_agrupar_por, p_agrupar_por, p_agrupar_por, p_agrupar_por, p_fecha_inicio, p_fecha_fin;
    DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

-- Procedimiento para obtener productos más rentados
DELIMITER //
CREATE PROCEDURE sp_productos_mas_rentados(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_limite INT
)
BEGIN
    SELECT p.nombre, p.marca, p.modelo,
           COUNT(rii.inventario_item_id) as veces_rentado,
           COUNT(DISTINCT r.cliente_id) as clientes_distintos,
           SUM(r.monto_total_renta) as ingresos_generados,
           AVG(r.monto_total_renta) as renta_promedio,
           MAX(r.fecha_inicio) as ultima_renta,
           MIN(r.fecha_inicio) as primera_renta
    FROM producto p
    INNER JOIN inventario_item ii ON p.id = ii.producto_id
    INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
    INNER JOIN renta r ON rii.renta_id = r.id
    WHERE r.estado_renta = 'Finalizada'
    AND r.fecha_inicio BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY p.id, p.nombre, p.marca, p.modelo
    ORDER BY veces_rentado DESC
    LIMIT p_limite;
END//
DELIMITER ;

-- Procedimiento para obtener clientes más activos
DELIMITER //
CREATE PROCEDURE sp_clientes_mas_activos(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_limite INT
)
BEGIN
    SELECT c.nombre, c.apellido1, c.correo_electronico,
           c.tipo_cliente, c.estado_cliente,
           COUNT(DISTINCT r.id) as total_rentas,
           COUNT(DISTINCT s.id) as total_solicitudes,
           COUNT(DISTINCT cot.id) as total_cotizaciones,
           SUM(r.monto_total_renta) as monto_total_gastado,
           MAX(r.fecha_inicio) as ultima_renta,
           AVG(r.monto_total_renta) as gasto_promedio_por_renta
    FROM cliente c
    LEFT JOIN renta r ON c.id = r.cliente_id AND r.fecha_inicio BETWEEN p_fecha_inicio AND p_fecha_fin
    LEFT JOIN solicitud s ON c.id = s.cliente_id AND s.fecha_solicitud BETWEEN p_fecha_inicio AND p_fecha_fin
    LEFT JOIN cotizacion cot ON c.id = cot.cliente_id AND cot.fecha_cotizacion BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY c.id, c.nombre, c.apellido1, c.correo_electronico, c.tipo_cliente, c.estado_cliente
    ORDER BY total_rentas DESC, monto_total_gastado DESC
    LIMIT p_limite;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA GESTIÓN DE INVENTARIO
-- =====================================================

-- Procedimiento para actualizar estado de items masivamente
DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_inventario(
    IN p_estado_nuevo ENUM('Disponible','Rentado','EnMantenimiento','DeBaja'),
    IN p_ubicacion_nueva VARCHAR(100),
    IN p_ids JSON, -- Array de IDs de items
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE v_item_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_mensaje = 'Error al actualizar inventario';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Actualizar cada item
    WHILE i < JSON_LENGTH(p_ids) DO
        SET v_item_id = JSON_EXTRACT(p_ids, CONCAT('$[', i, ']'));

        UPDATE inventario_item
        SET estado_item = p_estado_nuevo,
            ubicacion_fisica = p_ubicacion_nueva,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = v_item_id;

        SET v_count = v_count + ROW_COUNT();
        SET i = i + 1;
    END WHILE;

    SET p_mensaje = CONCAT('Se actualizaron ', v_count, ' items de inventario');
    COMMIT;
END//
DELIMITER ;

-- Procedimiento para obtener items que requieren mantenimiento
DELIMITER //
CREATE PROCEDURE sp_items_requieren_mantenimiento(
    IN p_dias_sin_mantenimiento INT
)
BEGIN
    SELECT ii.id, ii.numero_serie,
           p.nombre as producto, p.marca, p.modelo,
           ii.fecha_adquisicion, ii.ubicacion_fisica,
           m.fecha_inicio as ultimo_mantenimiento,
           DATEDIFF(CURRENT_DATE, m.fecha_inicio) as dias_sin_mantenimiento,
           CASE
               WHEN m.fecha_inicio IS NULL THEN 'Nunca mantenido'
               WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 180 THEN 'Mantenimiento urgente'
               WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 90 THEN 'Mantenimiento recomendado'
               ELSE 'Mantenimiento al día'
           END as estado_mantenimiento
    FROM inventario_item ii
    INNER JOIN producto p ON ii.producto_id = p.id
    LEFT JOIN mantenimiento m ON ii.id = m.inventario_item_id
        AND m.id = (SELECT MAX(id) FROM mantenimiento WHERE inventario_item_id = ii.id)
    WHERE ii.estado_item != 'DeBaja'
    AND (m.fecha_inicio IS NULL OR DATEDIFF(CURRENT_DATE, m.fecha_inicio) > p_dias_sin_mantenimiento)
    ORDER BY
        CASE
            WHEN m.fecha_inicio IS NULL THEN 1
            WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 180 THEN 2
            WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 90 THEN 3
            ELSE 4
        END,
        ii.fecha_adquisicion;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA GESTIÓN DE CLIENTES
-- =====================================================

-- Procedimiento para crear cliente completo con dirección
DELIMITER //
CREATE PROCEDURE sp_crear_cliente_completo(
    IN p_nombre VARCHAR(200),
    IN p_nombre2 VARCHAR(100),
    IN p_apellido1 VARCHAR(100),
    IN p_apellido2 VARCHAR(100),
    IN p_rfc VARCHAR(13),
    IN p_telefono_principal VARCHAR(20),
    IN p_correo_electronico VARCHAR(100),
    IN p_tipo_cliente ENUM('Particular','Empresa'),
    IN p_calle VARCHAR(255),
    IN p_numero_exterior VARCHAR(20),
    IN p_numero_interior VARCHAR(20),
    IN p_colonia VARCHAR(100),
    IN p_ciudad VARCHAR(100),
    IN p_estado_provincia VARCHAR(100),
    IN p_codigo_postal VARCHAR(10),
    IN p_pais VARCHAR(100),
    IN p_referencias TEXT,
    OUT p_cliente_id INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_direccion_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_mensaje = 'Error al crear el cliente';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar si el RFC o email ya existen
    IF EXISTS (SELECT 1 FROM cliente WHERE rfc = p_rfc AND p_rfc IS NOT NULL) THEN
        SET p_mensaje = 'El RFC ya está registrado';
    ELSEIF EXISTS (SELECT 1 FROM cliente WHERE correo_electronico = p_correo_electronico) THEN
        SET p_mensaje = 'El correo electrónico ya está registrado';
    ELSE
        -- Insertar dirección
        INSERT INTO direccion (
            calle, numero_exterior, numero_interior, colonia,
            ciudad, estado_provincia, codigo_postal, pais, referencias
        ) VALUES (
            p_calle, p_numero_exterior, p_numero_interior, p_colonia,
            p_ciudad, p_estado_provincia, p_codigo_postal, p_pais, p_referencias
        );

        SET v_direccion_id = LAST_INSERT_ID();

        -- Insertar cliente
        INSERT INTO cliente (
            nombre, nombre2, apellido1, apellido2, rfc,
            telefono_principal, correo_electronico, tipo_cliente
        ) VALUES (
            p_nombre, p_nombre2, p_apellido1, p_apellido2, p_rfc,
            p_telefono_principal, p_correo_electronico, p_tipo_cliente
        );

        SET p_cliente_id = LAST_INSERT_ID();

        -- Relacionar cliente con dirección
        INSERT INTO cliente_direccion (cliente_id, direccion_id, es_principal)
        VALUES (p_cliente_id, v_direccion_id, 1);

        SET p_mensaje = 'Cliente creado exitosamente';
        COMMIT;
    END IF;
END//
DELIMITER ;

-- Procedimiento para obtener historial completo de un cliente
DELIMITER //
CREATE PROCEDURE sp_historial_cliente(
    IN p_cliente_id INT
)
BEGIN
    -- Información básica del cliente
    SELECT 'INFORMACIÓN BÁSICA' as seccion, c.* FROM cliente c WHERE c.id = p_cliente_id
    UNION ALL
    -- Direcciones del cliente
    SELECT 'DIRECCIONES' as seccion, cd.* FROM cliente_direccion cd WHERE cd.cliente_id = p_cliente_id
    UNION ALL
    -- Solicitudes del cliente
    SELECT 'SOLICITUDES' as seccion, s.* FROM solicitud s WHERE s.cliente_id = p_cliente_id
    UNION ALL
    -- Cotizaciones del cliente
    SELECT 'COTIZACIONES' as seccion, cot.* FROM cotizacion cot WHERE cot.cliente_id = p_cliente_id
    UNION ALL
    -- Rentas del cliente
    SELECT 'RENTAS' as seccion, r.* FROM renta r WHERE r.cliente_id = p_cliente_id;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA GESTIÓN DE COTIZACIONES
-- =====================================================

-- Procedimiento para crear cotización completa
DELIMITER //
CREATE PROCEDURE sp_crear_cotizacion_completa(
    IN p_cliente_id INT,
    IN p_solicitud_id INT,
    IN p_fecha_validez DATE,
    IN p_terminos_condiciones TEXT,
    IN p_notas_internas TEXT,
    IN p_detalles JSON, -- Array de objetos con producto_id, cantidad, precio_unitario, descuento
    OUT p_cotizacion_id INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_monto_total DECIMAL(12,2) DEFAULT 0;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_precio_unitario DECIMAL(10,2);
    DECLARE v_descuento DECIMAL(5,2);
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE i INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_mensaje = 'Error al crear la cotización';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Insertar cotización
    INSERT INTO cotizacion (
        cliente_id,
        solicitud_id,
        fecha_validez,
        terminos_condiciones,
        notas_internas
    ) VALUES (
        p_cliente_id,
        p_solicitud_id,
        p_fecha_validez,
        p_terminos_condiciones,
        p_notas_internas
    );

    SET p_cotizacion_id = LAST_INSERT_ID();

    -- Insertar detalles
    WHILE i < JSON_LENGTH(p_detalles) DO
        SET v_producto_id = JSON_EXTRACT(p_detalles, CONCAT('$[', i, '].producto_id'));
        SET v_cantidad = JSON_EXTRACT(p_detalles, CONCAT('$[', i, '].cantidad'));
        SET v_precio_unitario = JSON_EXTRACT(p_detalles, CONCAT('$[', i, '].precio_unitario'));
        SET v_descuento = JSON_EXTRACT(p_detalles, CONCAT('$[', i, '].descuento'));

        SET v_subtotal = v_cantidad * v_precio_unitario * (1 - v_descuento / 100);
        SET v_monto_total = v_monto_total + v_subtotal;

        INSERT INTO detalle_cotizacion (
            cotizacion_id,
            producto_id,
            cantidad,
            precio_unitario,
            descuento_porcentaje
        ) VALUES (
            p_cotizacion_id,
            v_producto_id,
            v_cantidad,
            v_precio_unitario,
            v_descuento
        );

        SET i = i + 1;
    END WHILE;

    -- Actualizar monto total
    UPDATE cotizacion
    SET monto_total = v_monto_total
    WHERE id = p_cotizacion_id;

    SET p_mensaje = 'Cotización creada exitosamente';
    COMMIT;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA ESTADÍSTICAS Y MÉTRICAS
-- =====================================================

-- Procedimiento para obtener métricas generales del sistema
DELIMITER //
CREATE PROCEDURE sp_metricas_generales()
BEGIN
    SELECT
        (SELECT COUNT(*) FROM cliente WHERE estado_cliente = 'Activo') as clientes_activos,
        (SELECT COUNT(*) FROM producto) as total_productos,
        (SELECT COUNT(*) FROM inventario_item WHERE estado_item = 'Disponible') as items_disponibles,
        (SELECT COUNT(*) FROM inventario_item WHERE estado_item = 'Rentado') as items_rentados,
        (SELECT COUNT(*) FROM renta WHERE estado_renta = 'EnCurso') as rentas_activas,
        (SELECT COUNT(*) FROM solicitud WHERE estado_solicitud IN ('Nueva', 'EnProceso')) as solicitudes_pendientes,
        (SELECT COUNT(*) FROM cotizacion WHERE estado_cotizacion = 'Borrador') as cotizaciones_borrador,
        (SELECT SUM(monto_total_renta) FROM renta WHERE estado_renta = 'Finalizada' AND YEAR(fecha_inicio) = YEAR(CURRENT_DATE)) as ingresos_anio_actual,
        (SELECT AVG(monto_total_renta) FROM renta WHERE estado_renta = 'Finalizada') as renta_promedio,
        (SELECT COUNT(*) FROM mantenimiento WHERE estado_mantenimiento = 'Programado') as mantenimientos_pendientes;
END//
DELIMITER ;

-- Procedimiento para obtener alertas del sistema
DELIMITER //
CREATE PROCEDURE sp_obtener_alertas()
BEGIN
    -- Rentas próximas a vencer
    SELECT 'Renta por vencer' as tipo_alerta,
           COUNT(*) as cantidad,
           CONCAT('Hay ', COUNT(*), ' rentas que vencen en los próximos 3 días') as mensaje,
           'warning' as severidad,
           'renta' as tabla_afectada
    FROM renta
    WHERE estado_renta = 'EnCurso'
    AND fecha_fin_prevista BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)

    UNION ALL

    -- Items sin mantenimiento reciente
    SELECT 'Mantenimiento requerido' as tipo_alerta,
           COUNT(*) as cantidad,
           CONCAT('Hay ', COUNT(*), ' items que no han recibido mantenimiento en más de 6 meses') as mensaje,
           'error' as severidad,
           'inventario_item' as tabla_afectada
    FROM inventario_item ii
    LEFT JOIN mantenimiento m ON ii.id = m.inventario_item_id
    WHERE ii.estado_item != 'DeBaja'
    AND (m.fecha_inicio IS NULL OR m.fecha_inicio < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH))
    GROUP BY ii.id
    HAVING COUNT(*) > 0

    UNION ALL

    -- Cotizaciones por vencer
    SELECT 'Cotización por vencer' as tipo_alerta,
           COUNT(*) as cantidad,
           CONCAT('Hay ', COUNT(*), ' cotizaciones que vencen en los próximos 7 días') as mensaje,
           'info' as severidad,
           'cotizacion' as tabla_afectada
    FROM cotizacion
    WHERE estado_cotizacion = 'Enviada'
    AND fecha_validez BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)

    ORDER BY severidad DESC, tipo_alerta;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA LIMPIEZA Y MANTENIMIENTO
-- =====================================================

-- Procedimiento para limpiar datos antiguos
DELIMITER //
CREATE PROCEDURE sp_limpiar_datos_antiguos(
    IN p_dias_rentas_finalizadas INT,
    IN p_dias_auditorias INT,
    OUT p_registros_eliminados INT
)
BEGIN
    DECLARE v_eliminados INT DEFAULT 0;

    START TRANSACTION;

    -- Eliminar rentas finalizadas antiguas
    DELETE FROM renta
    WHERE estado_renta = 'Finalizada'
    AND fecha_devolucion_real < DATE_SUB(CURRENT_DATE, INTERVAL p_dias_rentas_finalizadas DAY);

    SET v_eliminados = v_eliminados + ROW_COUNT();

    -- Eliminar auditorías antiguas
    DELETE FROM auditoria_cliente
    WHERE fecha_cambio < DATE_SUB(CURRENT_DATE, INTERVAL p_dias_auditorias DAY);

    SET v_eliminados = v_eliminados + ROW_COUNT();

    DELETE FROM auditoria_renta
    WHERE fecha_cambio < DATE_SUB(CURRENT_DATE, INTERVAL p_dias_auditorias DAY);

    SET v_eliminados = v_eliminados + ROW_COUNT();

    DELETE FROM auditoria_inventario
    WHERE fecha_cambio < DATE_SUB(CURRENT_DATE, INTERVAL p_dias_auditorias DAY);

    SET v_eliminados = v_eliminados + ROW_COUNT();

    SET p_registros_eliminados = v_eliminados;
    COMMIT;
END//
DELIMITER ;

-- Procedimiento para backup de datos críticos
DELIMITER //
CREATE PROCEDURE sp_backup_datos_criticos()
BEGIN
    -- Crear tabla temporal con backup de clientes activos
    CREATE TEMPORARY TABLE backup_clientes_activos AS
    SELECT * FROM cliente WHERE estado_cliente = 'Activo';

    -- Crear tabla temporal con backup de rentas activas
    CREATE TEMPORARY TABLE backup_rentas_activas AS
    SELECT * FROM renta WHERE estado_renta IN ('Programada', 'EnCurso');

    -- Crear tabla temporal con backup de inventario
    CREATE TEMPORARY TABLE backup_inventario AS
    SELECT * FROM inventario_item WHERE estado_item != 'DeBaja';

    -- Mostrar resumen del backup
    SELECT
        (SELECT COUNT(*) FROM backup_clientes_activos) as clientes_activos,
        (SELECT COUNT(*) FROM backup_rentas_activas) as rentas_activas,
        (SELECT COUNT(*) FROM backup_inventario) as items_inventario,
        CURRENT_TIMESTAMP as fecha_backup;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA BÚSQUEDA AVANZADA
-- =====================================================

-- Procedimiento para búsqueda avanzada de productos
DELIMITER //
CREATE PROCEDURE sp_busqueda_avanzada_productos(
    IN p_texto_busqueda VARCHAR(255),
    IN p_categoria_id INT,
    IN p_marca VARCHAR(100),
    IN p_precio_min DECIMAL(10,2),
    IN p_precio_max DECIMAL(10,2),
    IN p_estado_disponibilidad ENUM('Disponible','Rentado','EnMantenimiento','DeBaja'),
    IN p_limite INT
)
BEGIN
    SET @sql = '
        SELECT DISTINCT p.id, p.nombre, p.marca, p.modelo, p.precio_referencia_renta,
               p.sku, s.nombre as subcategoria, cat.nombre as categoria,
               COUNT(ii.id) as total_items,
               SUM(CASE WHEN ii.estado_item = "Disponible" THEN 1 ELSE 0 END) as disponibles
        FROM producto p
        LEFT JOIN producto_subcategoria ps ON p.id = ps.producto_id
        LEFT JOIN subcategoria s ON ps.subcategoria_id = s.id
        LEFT JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
        LEFT JOIN categoria cat ON cs.categoria_id = cat.id
        LEFT JOIN inventario_item ii ON p.id = ii.producto_id
        WHERE 1=1
    ';

    IF p_texto_busqueda IS NOT NULL AND p_texto_busqueda != '' THEN
        SET @sql = CONCAT(@sql, ' AND (p.nombre LIKE "%', p_texto_busqueda, '%" OR p.descripcion LIKE "%', p_texto_busqueda, '%")');
    END IF;

    IF p_categoria_id IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND cat.id = ', p_categoria_id);
    END IF;

    IF p_marca IS NOT NULL AND p_marca != '' THEN
        SET @sql = CONCAT(@sql, ' AND p.marca = "', p_marca, '"');
    END IF;

    IF p_precio_min IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.precio_referencia_renta >= ', p_precio_min);
    END IF;

    IF p_precio_max IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.precio_referencia_renta <= ', p_precio_max);
    END IF;

    IF p_estado_disponibilidad IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND ii.estado_item = "', p_estado_disponibilidad, '"');
    END IF;

    SET @sql = CONCAT(@sql, ' GROUP BY p.id, p.nombre, p.marca, p.modelo, p.precio_referencia_renta, p.sku, s.nombre, cat.nombre');

    IF p_limite IS NOT NULL AND p_limite > 0 THEN
        SET @sql = CONCAT(@sql, ' LIMIT ', p_limite);
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTO PARA INICIALIZACIÓN DEL SISTEMA
-- =====================================================

-- Procedimiento para inicializar datos básicos del sistema
DELIMITER //
CREATE PROCEDURE sp_inicializar_sistema()
BEGIN
    DECLARE v_count INT;

    START TRANSACTION;

    -- Verificar si ya hay datos
    SELECT COUNT(*) INTO v_count FROM usuario;

    IF v_count = 0 THEN
        -- Insertar usuario administrador por defecto
        INSERT INTO usuario (nombre_usuario, nombre, nombre2, apellido1, apellido2, password_hash, email, estado)
        VALUES ('admin', 'Administrador', 'Sistema', 'Principal', '', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@sistemarenta.com', 'Activo');

        -- Insertar rol administrador
        INSERT INTO rol (codigo, nombre, descripcion) VALUES ('ADMIN', 'Administrador', 'Acceso completo al sistema');

        -- Asignar rol al administrador
        INSERT INTO usuario_rol (usuario_id, rol_id) VALUES (1, 1);

        SELECT 'Sistema inicializado correctamente' as mensaje;
    ELSE
        SELECT 'El sistema ya ha sido inicializado' as mensaje;
    END IF;

    COMMIT;
END//
DELIMITER ;