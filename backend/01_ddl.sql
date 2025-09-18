-- =====================================================
-- SCRIPT DDL - SISTEMA DE RENTA DE EQUIPOS TECNOLÓGICOS
-- =====================================================
-- Descripción: Definición de estructura de datos y modificaciones DDL
-- Autor: Sistema AXXION
-- Fecha: 2025-09-18
-- =====================================================

USE sistemarenta;

-- =====================================================
-- MODIFICACIONES A LA ESTRUCTURA DE TABLAS (ALTER TABLE)
-- =====================================================

-- Agregar índices adicionales para mejorar rendimiento
ALTER TABLE cliente ADD INDEX idx_tipo_cliente (tipo_cliente);
ALTER TABLE cliente ADD INDEX idx_estado_cliente (estado_cliente);
ALTER TABLE cliente ADD INDEX idx_nombre_completo (nombre, apellido1);

-- Agregar índices para inventario
ALTER TABLE inventario_item ADD INDEX idx_estado_item (estado_item);
ALTER TABLE inventario_item ADD INDEX idx_fecha_adquisicion (fecha_adquisicion);

-- Agregar índices para rentas
ALTER TABLE renta ADD INDEX idx_fecha_inicio (fecha_inicio);
ALTER TABLE renta ADD INDEX idx_fecha_fin_prevista (fecha_fin_prevista);
ALTER TABLE renta ADD INDEX idx_estado_renta (estado_renta);

-- Agregar índices para cotizaciones
ALTER TABLE cotizacion ADD INDEX idx_fecha_cotizacion (fecha_cotizacion);
ALTER TABLE cotizacion ADD INDEX idx_estado_cotizacion (estado_cotizacion);

-- =====================================================
-- NUEVAS TABLAS COMPLEMENTARIAS
-- =====================================================

-- Tabla para auditoría de cambios
CREATE TABLE IF NOT EXISTS auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(100) NOT NULL,
    operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    id_registro INT NOT NULL,
    usuario_id INT,
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valores_anteriores JSON,
    valores_nuevos JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    INDEX idx_tabla_fecha (tabla_afectada, fecha_operacion),
    INDEX idx_usuario_fecha (usuario_id, fecha_operacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para configuraciones del sistema
CREATE TABLE IF NOT EXISTS configuracion_sistema (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT NOT NULL,
    descripcion TEXT,
    tipo_dato ENUM('STRING', 'INTEGER', 'DECIMAL', 'BOOLEAN', 'JSON') DEFAULT 'STRING',
    categoria VARCHAR(50) DEFAULT 'GENERAL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para notificaciones
CREATE TABLE IF NOT EXISTS notificacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    titulo VARCHAR(200) NOT NULL,
    mensaje TEXT NOT NULL,
    tipo ENUM('INFO', 'WARNING', 'ERROR', 'SUCCESS') DEFAULT 'INFO',
    leida BOOLEAN DEFAULT FALSE,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_leida TIMESTAMP NULL,
    url_accion VARCHAR(255),
    INDEX idx_usuario_fecha (usuario_id, fecha_envio),
    INDEX idx_leida (leida),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- MODIFICACIONES DE COLUMNAS EXISTENTES
-- =====================================================

-- Agregar columnas faltantes a tabla cliente
ALTER TABLE cliente 
ADD COLUMN IF NOT EXISTS fecha_nacimiento DATE,
ADD COLUMN IF NOT EXISTS genero ENUM('M', 'F', 'Otro') DEFAULT NULL,
ADD COLUMN IF NOT EXISTS telefono_secundario VARCHAR(20),
ADD COLUMN IF NOT EXISTS observaciones TEXT;

-- Agregar columnas a tabla producto
ALTER TABLE producto 
ADD COLUMN IF NOT EXISTS peso_kg DECIMAL(8,3),
ADD COLUMN IF NOT EXISTS dimensiones VARCHAR(100),
ADD COLUMN IF NOT EXISTS garantia_meses INT DEFAULT 12,
ADD COLUMN IF NOT EXISTS estado_producto ENUM('Activo', 'Descontinuado', 'Agotado') DEFAULT 'Activo';

-- Agregar columnas a tabla renta
ALTER TABLE renta 
ADD COLUMN IF NOT EXISTS direccion_entrega_id INT,
ADD COLUMN IF NOT EXISTS direccion_devolucion_id INT,
ADD COLUMN IF NOT EXISTS metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'Cheque') DEFAULT 'Efectivo',
ADD COLUMN IF NOT EXISTS descuento_aplicado DECIMAL(10,2) DEFAULT 0.00;

-- Agregar foreign keys para las nuevas columnas
ALTER TABLE renta 
ADD CONSTRAINT fk_renta_direccion_entrega 
FOREIGN KEY (direccion_entrega_id) REFERENCES direccion(id),
ADD CONSTRAINT fk_renta_direccion_devolucion 
FOREIGN KEY (direccion_devolucion_id) REFERENCES direccion(id);

-- =====================================================
-- CONSTRAINTS ADICIONALES
-- =====================================================

-- Constraint para validar fechas en renta
ALTER TABLE renta 
ADD CONSTRAINT chk_fechas_renta 
CHECK (fecha_fin_prevista > fecha_inicio);

-- Constraint para validar precios positivos
ALTER TABLE producto 
ADD CONSTRAINT chk_precio_positivo 
CHECK (precio_referencia_renta >= 0);

-- Constraint para validar cantidad en cotización
ALTER TABLE detalle_cotizacion 
ADD CONSTRAINT chk_cantidad_positiva 
CHECK (cantidad > 0);

-- =====================================================
-- COMENTARIOS EN TABLAS
-- =====================================================

ALTER TABLE cliente COMMENT = 'Tabla que almacena información de clientes del sistema de renta';
ALTER TABLE producto COMMENT = 'Catálogo de productos/equipos disponibles para renta';
ALTER TABLE renta COMMENT = 'Registro de todas las rentas realizadas';
ALTER TABLE inventario_item COMMENT = 'Items individuales del inventario con número de serie';
ALTER TABLE cotizacion COMMENT = 'Cotizaciones generadas para clientes';

-- =====================================================
-- FIN DEL SCRIPT DDL
-- =====================================================