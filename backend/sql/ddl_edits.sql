-- =====================================================
-- SISTEMA DE RENTAS - MODIFICACIONES DDL
-- =====================================================
-- Este archivo contiene sentencias DDL para modificar
-- la estructura de la base de datos después de su creación
-- =====================================================

USE sistemarenta;

-- =====================================================
-- AGREGAR NUEVAS COLUMNAS A TABLAS EXISTENTES
-- =====================================================

-- Agregar columna para teléfono secundario en cliente
ALTER TABLE cliente
ADD COLUMN telefono_secundario VARCHAR(20) NULL AFTER telefono_principal,
ADD COLUMN fecha_nacimiento DATE NULL AFTER apellido2,
ADD COLUMN genero ENUM('Masculino', 'Femenino', 'Otro') NULL AFTER fecha_nacimiento;

-- Agregar columna para código QR en inventario_item
ALTER TABLE inventario_item
ADD COLUMN codigo_qr VARCHAR(100) NULL UNIQUE AFTER numero_serie,
ADD COLUMN peso_kg DECIMAL(5,2) NULL AFTER costo_adquisicion,
ADD COLUMN dimensiones_cm VARCHAR(50) NULL AFTER peso_kg;

-- Agregar columna para prioridad en solicitud
ALTER TABLE solicitud
ADD COLUMN prioridad ENUM('Baja', 'Media', 'Alta', 'Urgente') DEFAULT 'Media' AFTER estado_solicitud,
ADD COLUMN fecha_requerida DATE NULL AFTER prioridad;

-- Agregar columna para método de pago en renta
ALTER TABLE renta
ADD COLUMN metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'Cheque') DEFAULT 'Efectivo' AFTER deposito_garantia,
ADD COLUMN numero_factura VARCHAR(50) NULL AFTER metodo_pago,
ADD COLUMN notas_pago TEXT NULL AFTER numero_factura;

-- Agregar columna para calificación en devolucion
ALTER TABLE devolucion
ADD COLUMN calificacion_servicio TINYINT NULL CHECK (calificacion_servicio BETWEEN 1 AND 5) AFTER notas_generales,
ADD COLUMN comentarios_cliente TEXT NULL AFTER calificacion_servicio;

-- =====================================================
-- MODIFICAR COLUMNAS EXISTENTES
-- =====================================================

-- Aumentar el tamaño del campo descripcion en producto
ALTER TABLE producto
MODIFY COLUMN descripcion TEXT NULL;

-- Cambiar el tipo de dato de precio_referencia_renta para mayor precisión
ALTER TABLE producto
MODIFY COLUMN precio_referencia_renta DECIMAL(12,4) DEFAULT NULL;

-- Aumentar el tamaño del campo notas en varias tablas
ALTER TABLE inventario_item
MODIFY COLUMN notas TEXT NULL;

ALTER TABLE renta
MODIFY COLUMN notas TEXT NULL;

ALTER TABLE mantenimiento
MODIFY COLUMN descripcion_problema TEXT NULL,
MODIFY COLUMN descripcion_trabajo_realizado TEXT NULL;

-- Cambiar el tipo de enum para estado_cliente agregando más opciones
ALTER TABLE cliente
MODIFY COLUMN estado_cliente ENUM('Activo','Inactivo','Prospecto','Suspendido','VIP') DEFAULT 'Prospecto';

-- =====================================================
-- AGREGAR ÍNDICES PARA MEJORAR PERFORMANCE
-- =====================================================

-- Índices para búsquedas frecuentes en cliente
CREATE INDEX idx_cliente_estado ON cliente(estado_cliente);
CREATE INDEX idx_cliente_tipo ON cliente(tipo_cliente);
CREATE INDEX idx_cliente_email ON cliente(correo_electronico);
CREATE INDEX idx_cliente_rfc ON cliente(rfc);

-- Índices para búsquedas en producto
CREATE INDEX idx_producto_marca ON producto(marca);
CREATE INDEX idx_producto_precio ON producto(precio_referencia_renta);
CREATE INDEX idx_producto_sku ON producto(sku);

-- Índices para inventario_item
CREATE INDEX idx_inventario_estado ON inventario_item(estado_item);
CREATE INDEX idx_inventario_ubicacion ON inventario_item(ubicacion_fisica);
CREATE INDEX idx_inventario_fecha_adquisicion ON inventario_item(fecha_adquisicion);

-- Índices para renta
CREATE INDEX idx_renta_estado ON renta(estado_renta);
CREATE INDEX idx_renta_fechas ON renta(fecha_inicio, fecha_fin_prevista);
CREATE INDEX idx_renta_cliente_fecha ON renta(cliente_id, fecha_inicio);

-- Índices para mantenimiento
CREATE INDEX idx_mantenimiento_estado ON mantenimiento(estado_mantenimiento);
CREATE INDEX idx_mantenimiento_tipo ON mantenimiento(tipo_mantenimiento);
CREATE INDEX idx_mantenimiento_fechas ON mantenimiento(fecha_inicio, fecha_fin_real);

-- Índices para solicitud
CREATE INDEX idx_solicitud_estado ON solicitud(estado_solicitud);
CREATE INDEX idx_solicitud_fecha ON solicitud(fecha_solicitud);

-- Índices para cotizacion
CREATE INDEX idx_cotizacion_estado ON cotizacion(estado_cotizacion);
CREATE INDEX idx_cotizacion_fecha ON cotizacion(fecha_cotizacion);
CREATE INDEX idx_cotizacion_cliente_fecha ON cotizacion(cliente_id, fecha_cotizacion);

-- =====================================================
-- AGREGAR CONSTRAINTS ADICIONALES
-- =====================================================

-- Agregar constraint de unicidad para código QR
ALTER TABLE inventario_item
ADD CONSTRAINT uk_codigo_qr UNIQUE (codigo_qr);

-- Agregar constraint de verificación para fechas en renta
ALTER TABLE renta
ADD CONSTRAINT chk_fechas_renta CHECK (fecha_fin_prevista > fecha_inicio);

-- Agregar constraint de verificación para fechas en mantenimiento
ALTER TABLE mantenimiento
ADD CONSTRAINT chk_fechas_mantenimiento CHECK (fecha_fin_real >= fecha_inicio);

-- Agregar constraint de verificación para precios positivos
ALTER TABLE producto
ADD CONSTRAINT chk_precio_positivo CHECK (precio_referencia_renta > 0);

ALTER TABLE inventario_item
ADD CONSTRAINT chk_costo_positivo CHECK (costo_adquisicion > 0);

-- =====================================================
-- MODIFICAR TABLAS PARA AGREGAR COLUMNAS DE AUDITORÍA
-- =====================================================

-- Agregar columnas de auditoría a tablas críticas
ALTER TABLE cliente
ADD COLUMN created_by INT NULL AFTER updated_at,
ADD COLUMN updated_by INT NULL AFTER created_by,
ADD CONSTRAINT fk_cliente_created_by FOREIGN KEY (created_by) REFERENCES usuario(id),
ADD CONSTRAINT fk_cliente_updated_by FOREIGN KEY (updated_by) REFERENCES usuario(id);

ALTER TABLE producto
ADD COLUMN created_by INT NULL AFTER updated_at,
ADD COLUMN updated_by INT NULL AFTER created_by,
ADD CONSTRAINT fk_producto_created_by FOREIGN KEY (created_by) REFERENCES usuario(id),
ADD CONSTRAINT fk_producto_updated_by FOREIGN KEY (updated_by) REFERENCES usuario(id);

ALTER TABLE renta
ADD COLUMN created_by INT NULL AFTER updated_at,
ADD COLUMN updated_by INT NULL AFTER created_by,
ADD CONSTRAINT fk_renta_created_by FOREIGN KEY (created_by) REFERENCES usuario(id),
ADD CONSTRAINT fk_renta_updated_by FOREIGN KEY (updated_by) REFERENCES usuario(id);

-- =====================================================
-- CREAR NUEVAS TABLAS PARA EXTENDER FUNCIONALIDAD
-- =====================================================

-- Tabla para almacenar configuraciones del sistema
CREATE TABLE configuracion_sistema (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT NULL,
    descripcion TEXT NULL,
    tipo_dato ENUM('string', 'integer', 'decimal', 'boolean', 'json') DEFAULT 'string',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla para categorías de documentos
CREATE TABLE categoria_documento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_categoria_documento_nombre (nombre)
);

-- Tabla para documentos adjuntos
CREATE TABLE documento_adjunto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    tipo_archivo VARCHAR(10) NULL,
    tamano_bytes INT NULL,
    tabla_referencia VARCHAR(50) NOT NULL,
    registro_id INT NOT NULL,
    categoria_documento_id INT NULL,
    descripcion TEXT NULL,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_documento_tabla_registro (tabla_referencia, registro_id),
    KEY idx_documento_categoria (categoria_documento_id),
    CONSTRAINT fk_documento_categoria FOREIGN KEY (categoria_documento_id) REFERENCES categoria_documento(id),
    CONSTRAINT fk_documento_created_by FOREIGN KEY (created_by) REFERENCES usuario(id)
);

-- Tabla para historial de precios de productos
CREATE TABLE historial_precio_producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    precio_anterior DECIMAL(12,4) NULL,
    precio_nuevo DECIMAL(12,4) NOT NULL,
    motivo_cambio TEXT NULL,
    changed_by INT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_historial_producto (producto_id),
    KEY idx_historial_fecha (changed_at),
    CONSTRAINT fk_historial_precio_producto FOREIGN KEY (producto_id) REFERENCES producto(id),
    CONSTRAINT fk_historial_precio_changed_by FOREIGN KEY (changed_by) REFERENCES usuario(id)
);

-- Tabla para promociones y descuentos
CREATE TABLE promocion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT NULL,
    tipo_promocion ENUM('Descuento_Porcentaje', 'Descuento_Fijo', 'Precio_Fijo') DEFAULT 'Descuento_Porcentaje',
    valor_promocion DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('Activa', 'Inactiva', 'Expirada') DEFAULT 'Activa',
    condiciones_aplicacion TEXT NULL,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_promocion_fechas (fecha_inicio, fecha_fin),
    KEY idx_promocion_estado (estado),
    CONSTRAINT fk_promocion_created_by FOREIGN KEY (created_by) REFERENCES usuario(id),
    CONSTRAINT chk_promocion_fechas CHECK (fecha_fin >= fecha_inicio)
);

-- Tabla para relacionar promociones con productos
CREATE TABLE promocion_producto (
    promocion_id INT NOT NULL,
    producto_id INT NOT NULL,
    PRIMARY KEY (promocion_id, producto_id),
    KEY idx_promocion_prod (producto_id),
    CONSTRAINT fk_pp_promocion FOREIGN KEY (promocion_id) REFERENCES promocion(id) ON DELETE CASCADE,
    CONSTRAINT fk_pp_producto FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE CASCADE
);

-- =====================================================
-- AGREGAR COLUMNAS PARA SOPORTE MULTILINGÜE
-- =====================================================

-- Agregar soporte para nombres en inglés
ALTER TABLE categoria
ADD COLUMN nombre_ingles VARCHAR(100) NULL AFTER nombre;

ALTER TABLE subcategoria
ADD COLUMN nombre_ingles VARCHAR(100) NULL AFTER nombre;

ALTER TABLE producto
ADD COLUMN nombre_ingles VARCHAR(150) NULL AFTER nombre,
ADD COLUMN descripcion_ingles TEXT NULL AFTER descripcion;

-- =====================================================
-- MODIFICACIONES PARA SOPORTE DE MÚLTIPLES MONEDAS
-- =====================================================

-- Agregar columna para moneda en cotizaciones y rentas
ALTER TABLE cotizacion
ADD COLUMN moneda ENUM('MXN', 'USD', 'EUR', 'COP') DEFAULT 'MXN' AFTER monto_total,
ADD COLUMN tipo_cambio DECIMAL(8,4) DEFAULT 1.0000 AFTER moneda;

ALTER TABLE renta
ADD COLUMN moneda ENUM('MXN', 'USD', 'EUR', 'COP') DEFAULT 'MXN' AFTER monto_total_renta,
ADD COLUMN tipo_cambio DECIMAL(8,4) DEFAULT 1.0000 AFTER moneda;

-- =====================================================
-- AGREGAR ÍNDICES COMPUESTOS PARA CONSULTAS COMPLEJAS
-- =====================================================

-- Índice compuesto para búsquedas de rentas por cliente y período
CREATE INDEX idx_renta_cliente_periodo ON renta(cliente_id, YEAR(fecha_inicio), MONTH(fecha_inicio));

-- Índice compuesto para productos por subcategoría y precio
CREATE INDEX idx_producto_subcat_precio ON producto_subcategoria(subcategoria_id, producto_id);

-- Índice compuesto para mantenimiento por item y fechas
CREATE INDEX idx_mantenimiento_item_fechas ON mantenimiento(inventario_item_id, fecha_inicio, fecha_fin_real);

-- =====================================================
-- MODIFICACIONES PARA MEJORAR LA INTEGRIDAD REFERENCIAL
-- =====================================================

-- Agregar CASCADE a algunas foreign keys existentes
ALTER TABLE detalle_cotizacion
DROP FOREIGN KEY fk_detalle_cotizacion_cotizacion,
ADD CONSTRAINT fk_detalle_cotizacion_cotizacion FOREIGN KEY (cotizacion_id) REFERENCES cotizacion(id) ON DELETE CASCADE;

-- =====================================================
-- CREAR TABLAS PARA LOGGING AVANZADO
-- =====================================================

-- Tabla para log de accesos de usuarios
CREATE TABLE log_acceso_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo_acceso ENUM('Login', 'Logout', 'Failed_Login') NOT NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    fecha_acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_log_usuario (usuario_id),
    KEY idx_log_fecha (fecha_acceso),
    KEY idx_log_tipo (tipo_acceso),
    CONSTRAINT fk_log_acceso_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- Tabla para log de operaciones críticas
CREATE TABLE log_operacion_critica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    registro_id INT NOT NULL,
    datos_anteriores JSON NULL,
    datos_nuevos JSON NULL,
    ip_address VARCHAR(45) NULL,
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_log_critica_tabla (tabla_afectada),
    KEY idx_log_critica_usuario (usuario_id),
    KEY idx_log_critica_fecha (fecha_operacion),
    CONSTRAINT fk_log_critica_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- =====================================================
-- AGREGAR DATOS INICIALES PARA LAS NUEVAS TABLAS
-- =====================================================

-- Insertar configuraciones básicas del sistema
INSERT INTO configuracion_sistema (clave, valor, descripcion, tipo_dato) VALUES
('moneda_principal', 'MXN', 'Moneda principal del sistema', 'string'),
('iva_default', '16.00', 'Porcentaje de IVA por defecto', 'decimal'),
('dias_gracia_devolucion', '3', 'Días de gracia para devoluciones', 'integer'),
('email_notificaciones', 'true', 'Habilitar envío de notificaciones por email', 'boolean'),
('backup_automatico', 'true', 'Habilitar backups automáticos', 'boolean');

-- Insertar categorías de documentos
INSERT INTO categoria_documento (nombre, descripcion) VALUES
('Contrato', 'Documentos contractuales y acuerdos'),
('Factura', 'Facturas y comprobantes de pago'),
('Identificación', 'Documentos de identificación'),
('Certificado', 'Certificados y diplomas'),
('Manual', 'Manuales de usuario y técnico'),
('Otro', 'Otros tipos de documentos');

-- =====================================================
-- CREAR VISTAS PARA LAS NUEVAS FUNCIONALIDADES
-- =====================================================

-- Vista para configuración del sistema
CREATE OR REPLACE VIEW vista_configuracion_sistema AS
SELECT clave, valor, descripcion, tipo_dato, updated_at
FROM configuracion_sistema
ORDER BY clave;

-- Vista para documentos por tabla y registro
CREATE OR REPLACE VIEW vista_documentos_por_entidad AS
SELECT da.id, da.nombre_archivo, da.ruta_archivo, da.tipo_archivo,
       da.tamano_bytes, da.tabla_referencia, da.registro_id,
       cd.nombre as categoria_documento,
       u.nombre_completo as subido_por,
       da.created_at
FROM documento_adjunto da
LEFT JOIN categoria_documento cd ON da.categoria_documento_id = cd.id
LEFT JOIN usuario u ON da.created_by = u.id
ORDER BY da.created_at DESC;

-- Vista para historial de precios
CREATE OR REPLACE VIEW vista_historial_precios AS
SELECT hpp.id, p.nombre as producto, p.marca, p.modelo,
       hpp.precio_anterior, hpp.precio_nuevo,
       (hpp.precio_nuevo - hpp.precio_anterior) as diferencia,
       ((hpp.precio_nuevo - hpp.precio_anterior) / hpp.precio_anterior * 100) as porcentaje_cambio,
       hpp.motivo_cambio, u.nombre_completo as modificado_por,
       hpp.changed_at
FROM historial_precio_producto hpp
INNER JOIN producto p ON hpp.producto_id = p.id
LEFT JOIN usuario u ON hpp.changed_by = u.id
ORDER BY hpp.changed_at DESC;

-- =====================================================
-- TRIGGERS PARA LAS NUEVAS FUNCIONALIDADES
-- =====================================================

-- Trigger para auditar cambios de precio en productos
DELIMITER //
CREATE TRIGGER trg_historial_precio_producto
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    IF OLD.precio_referencia_renta != NEW.precio_referencia_renta THEN
        INSERT INTO historial_precio_producto (
            producto_id,
            precio_anterior,
            precio_nuevo,
            motivo_cambio,
            changed_by
        ) VALUES (
            NEW.id,
            OLD.precio_referencia_renta,
            NEW.precio_referencia_renta,
            'Actualización manual',
            NEW.updated_by
        );
    END IF;
END//
DELIMITER ;

-- Trigger para log de operaciones críticas
DELIMITER //
CREATE TRIGGER trg_log_operacion_critica_renta
AFTER UPDATE ON renta
FOR EACH ROW
BEGIN
    IF OLD.estado_renta != NEW.estado_renta THEN
        INSERT INTO log_operacion_critica (
            usuario_id,
            tabla_afectada,
            operacion,
            registro_id,
            datos_anteriores,
            datos_nuevos
        ) VALUES (
            NEW.updated_by,
            'renta',
            'UPDATE',
            NEW.id,
            JSON_OBJECT('estado_renta', OLD.estado_renta),
            JSON_OBJECT('estado_renta', NEW.estado_renta)
        );
    END IF;
END//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS PARA LAS NUEVAS FUNCIONALIDADES
-- =====================================================

-- Procedimiento para actualizar configuración del sistema
DELIMITER //
CREATE PROCEDURE sp_actualizar_configuracion(
    IN p_clave VARCHAR(100),
    IN p_valor TEXT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM configuracion_sistema
    WHERE clave = p_clave;

    IF v_count > 0 THEN
        UPDATE configuracion_sistema
        SET valor = p_valor,
            updated_at = CURRENT_TIMESTAMP
        WHERE clave = p_clave;

        SET p_mensaje = 'Configuración actualizada exitosamente';
    ELSE
        INSERT INTO configuracion_sistema (clave, valor)
        VALUES (p_clave, p_valor);

        SET p_mensaje = 'Nueva configuración creada exitosamente';
    END IF;
END//
DELIMITER ;

-- Procedimiento para subir documento adjunto
DELIMITER //
CREATE PROCEDURE sp_subir_documento(
    IN p_nombre_archivo VARCHAR(255),
    IN p_ruta_archivo VARCHAR(500),
    IN p_tipo_archivo VARCHAR(10),
    IN p_tamano_bytes INT,
    IN p_tabla_referencia VARCHAR(50),
    IN p_registro_id INT,
    IN p_categoria_documento_id INT,
    IN p_descripcion TEXT,
    IN p_created_by INT,
    OUT p_documento_id INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    INSERT INTO documento_adjunto (
        nombre_archivo,
        ruta_archivo,
        tipo_archivo,
        tamano_bytes,
        tabla_referencia,
        registro_id,
        categoria_documento_id,
        descripcion,
        created_by
    ) VALUES (
        p_nombre_archivo,
        p_ruta_archivo,
        p_tipo_archivo,
        p_tamano_bytes,
        p_tabla_referencia,
        p_registro_id,
        p_categoria_documento_id,
        p_descripcion,
        p_created_by
    );

    SET p_documento_id = LAST_INSERT_ID();
    SET p_mensaje = 'Documento subido exitosamente';
END//
DELIMITER ;

-- =====================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para las nuevas tablas
CREATE INDEX idx_configuracion_clave ON configuracion_sistema(clave);
CREATE INDEX idx_documento_fecha ON documento_adjunto(created_at);
CREATE INDEX idx_historial_fecha ON historial_precio_producto(changed_at);
CREATE INDEX idx_promocion_fechas ON promocion(fecha_inicio, fecha_fin);
CREATE INDEX idx_log_acceso_fecha ON log_acceso_usuario(fecha_acceso);
CREATE INDEX idx_log_critica_fecha ON log_operacion_critica(fecha_operacion);

-- =====================================================
-- OPTIMIZACIONES DE PERFORMANCE
-- =====================================================

-- Crear índices fulltext para búsquedas de texto
ALTER TABLE producto ADD FULLTEXT idx_texto_producto (nombre, descripcion, marca, modelo);
ALTER TABLE cliente ADD FULLTEXT idx_texto_cliente (nombre, nombre2, apellido1, apellido2);

-- Crear índices espaciales si fuera necesario (para futuras versiones)
-- ALTER TABLE direccion ADD COLUMN coordenadas POINT NULL;
-- CREATE SPATIAL INDEX idx_direccion_coordenadas ON direccion(coordenadas);

-- =====================================================
-- COMENTARIOS EN TABLAS Y COLUMNAS
-- =====================================================

-- Agregar comentarios descriptivos a las tablas principales
ALTER TABLE cliente COMMENT = 'Tabla que almacena información de los clientes del sistema de rentas';
ALTER TABLE producto COMMENT = 'Tabla que almacena información de los productos disponibles para renta';
ALTER TABLE renta COMMENT = 'Tabla que almacena las transacciones de renta de equipos';
ALTER TABLE inventario_item COMMENT = 'Tabla que almacena los items físicos del inventario';

-- Agregar comentarios a columnas importantes
ALTER TABLE cliente MODIFY COLUMN rfc VARCHAR(13) NULL COMMENT 'Registro Federal de Contribuyentes (México)';
ALTER TABLE producto MODIFY COLUMN sku VARCHAR(50) NULL COMMENT 'Stock Keeping Unit - Código único del producto';
ALTER TABLE inventario_item MODIFY COLUMN numero_serie VARCHAR(100) NULL COMMENT 'Número de serie único del equipo';

-- =====================================================
-- PARTITIONING PARA TABLAS CON MUCHOS DATOS
-- =====================================================

-- Crear particiones para la tabla de auditoría (si crece mucho)
-- ALTER TABLE auditoria_renta
-- PARTITION BY RANGE (YEAR(fecha_cambio)) (
--     PARTITION p2024 VALUES LESS THAN (2025),
--     PARTITION p2025 VALUES LESS THAN (2026),
--     PARTITION p2026 VALUES LESS THAN (2027),
--     PARTITION p_future VALUES LESS THAN MAXVALUE
-- );

-- =====================================================
-- CONSTRAINTS DE INTEGRIDAD ADICIONALES
-- =====================================================

-- Agregar constraints de verificación adicionales
ALTER TABLE promocion
ADD CONSTRAINT chk_promocion_valor_positivo CHECK (valor_promocion > 0);

ALTER TABLE historial_precio_producto
ADD CONSTRAINT chk_precio_nuevo_positivo CHECK (precio_nuevo > 0);

-- =====================================================
-- VISTAS MATERIALIZADAS (SIMULADAS CON TRIGGERS)
-- =====================================================

-- Crear tabla para estadísticas calculadas automáticamente
CREATE TABLE estadisticas_calculadas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_estadistica VARCHAR(50) NOT NULL,
    valor DECIMAL(15,2) NULL,
    valor_texto TEXT NULL,
    fecha_calculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_tipo_estadistica (tipo_estadistica)
);

-- Trigger para mantener estadísticas actualizadas
DELIMITER //
CREATE TRIGGER trg_actualizar_estadisticas
AFTER INSERT ON renta
FOR EACH ROW
BEGIN
    -- Actualizar total de rentas
    INSERT INTO estadisticas_calculadas (tipo_estadistica, valor)
    VALUES ('total_rentas', (SELECT COUNT(*) FROM renta))
    ON DUPLICATE KEY UPDATE
        valor = (SELECT COUNT(*) FROM renta),
        fecha_calculo = CURRENT_TIMESTAMP;

    -- Actualizar ingresos totales
    INSERT INTO estadisticas_calculadas (tipo_estadistica, valor)
    VALUES ('ingresos_totales', (SELECT SUM(monto_total_renta) FROM renta WHERE estado_renta = 'Finalizada'))
    ON DUPLICATE KEY UPDATE
        valor = (SELECT SUM(monto_total_renta) FROM renta WHERE estado_renta = 'Finalizada'),
        fecha_calculo = CURRENT_TIMESTAMP;
END//
DELIMITER ;

-- =====================================================
-- FINALIZACIÓN DE LAS MODIFICACIONES DDL
-- =====================================================

-- Mostrar mensaje de finalización
SELECT 'Modificaciones DDL completadas exitosamente. El esquema de la base de datos ha sido extendido con nuevas funcionalidades.' as mensaje_final;