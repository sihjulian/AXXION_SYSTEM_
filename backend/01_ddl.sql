-- DDL: Data Definition Language para sistemarenta
-- Creación de la base de datos
DROP DATABASE IF EXISTS sistemarenta;
CREATE DATABASE sistemarenta;
USE sistemarenta;

-- Tabla categoria
CREATE TABLE categoria (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT DEFAULT NULL,
    tipo_categoria VARCHAR(50) DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla subcategoria
CREATE TABLE subcategoria (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla categoria_subcategoria (Relación N:M)
CREATE TABLE categoria_subcategoria (
    categoria_id INT(11) NOT NULL,
    subcategoria_id INT(11) NOT NULL,
    PRIMARY KEY (categoria_id, subcategoria_id),
    CONSTRAINT fk_categoria_subcategoria_categoria FOREIGN KEY (categoria_id) REFERENCES categoria (id) ON DELETE CASCADE,
    CONSTRAINT fk_categoria_subcategoria_subcategoria FOREIGN KEY (subcategoria_id) REFERENCES subcategoria (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla direccion
CREATE TABLE direccion (
    id INT(11) NOT NULL AUTO_INCREMENT,
    calle VARCHAR(255) NOT NULL,
    numero_exterior VARCHAR(20) DEFAULT NULL,
    numero_interior VARCHAR(20) DEFAULT NULL,
    colonia VARCHAR(100) DEFAULT NULL,
    ciudad VARCHAR(100) NOT NULL,
    estado_provincia VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    referencias TEXT DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla cliente
CREATE TABLE cliente (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nombre2 VARCHAR(100) NOT NULL,
    apellido1 VARCHAR(100) NOT NULL,
    apellido2 VARCHAR(100) NOT NULL,
    rfc VARCHAR(13) DEFAULT NULL,
    telefono_principal VARCHAR(20) DEFAULT NULL,
    correo_electronico VARCHAR(100) DEFAULT NULL,
    tipo_cliente ENUM('Particular','Empresa') DEFAULT 'Particular',
    estado_cliente ENUM('Activo','Inactivo','Prospecto') DEFAULT 'Prospecto',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY rfc (rfc),
    UNIQUE KEY correo_electronico (correo_electronico)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Resto de las tablas principales...
-- (Por brevedad, se muestran solo las principales. El script completo incluye todas las tablas)

-- Índices y restricciones adicionales
ALTER TABLE cliente_direccion ADD CONSTRAINT fk_cliente_direccion_cliente 
    FOREIGN KEY (cliente_id) REFERENCES cliente (id) ON DELETE CASCADE;
ALTER TABLE cliente_direccion ADD CONSTRAINT fk_cliente_direccion_direccion 
    FOREIGN KEY (direccion_id) REFERENCES direccion (id) ON DELETE CASCADE;

-- Vistas útiles
CREATE VIEW v_clientes_activos AS
    SELECT * FROM cliente WHERE estado_cliente = 'Activo';

CREATE VIEW v_productos_disponibles AS
    SELECT p.*, COUNT(i.id) as stock_disponible
    FROM producto p
    LEFT JOIN inventario_item i ON p.id = i.producto_id
    WHERE i.estado_item = 'Disponible'
    GROUP BY p.id;
