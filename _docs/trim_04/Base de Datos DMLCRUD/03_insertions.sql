-- Inserciones de datos de prueba para sistemarenta

-- Inserción de roles
INSERT INTO rol (codigo, nombre, descripcion) VALUES
('ADMIN', 'Administrador', 'Control total del sistema'),
('OPER', 'Operador', 'Gestión de rentas y mantenimiento'),
('VEND', 'Vendedor', 'Gestión de cotizaciones y clientes'),
('INVE', 'Inventario', 'Control de inventario y productos'),
('CLIE', 'Cliente', 'Usuario cliente del sistema');

-- Inserción de usuarios
INSERT INTO usuario (nombre_usuario, nombre, nombre2, apellido1, apellido2, password_hash, email, telefono, departamento, estado) VALUES
('admin1', 'Juan', 'Carlos', 'Pérez', 'García', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@example.com', '5551234567', 'Administración', 'Activo'),
('operador1', 'María', 'Elena', 'López', 'Martínez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'operador@example.com', '5559876543', 'Operaciones', 'Activo'),
('vendedor1', 'Roberto', 'José', 'González', 'Ramírez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'vendedor@example.com', '5552345678', 'Ventas', 'Activo');

-- Asignación de roles a usuarios
INSERT INTO usuario_rol (usuario_id, rol_id) 
SELECT u.id, r.id FROM usuario u, rol r WHERE u.nombre_usuario = 'admin1' AND r.codigo = 'ADMIN';
INSERT INTO usuario_rol (usuario_id, rol_id) 
SELECT u.id, r.id FROM usuario u, rol r WHERE u.nombre_usuario = 'operador1' AND r.codigo = 'OPER';
INSERT INTO usuario_rol (usuario_id, rol_id) 
SELECT u.id, r.id FROM usuario u, rol r WHERE u.nombre_usuario = 'vendedor1' AND r.codigo = 'VEND';

-- Inserción de categorías
INSERT INTO categoria (nombre, descripcion, tipo_categoria) VALUES
('Maquinaria Pesada', 'Equipos de construcción y obra pesada', 'Equipos'),
('Herramientas Eléctricas', 'Herramientas con motor eléctrico', 'Herramientas'),
('Andamios y Escaleras', 'Equipos de acceso y trabajo en altura', 'Estructuras'),
('Equipo de Jardinería', 'Herramientas y máquinas para jardín', 'Equipos'),
('Generadores', 'Equipos de generación eléctrica', 'Energía');

-- Inserción de subcategorías
INSERT INTO subcategoria (nombre, descripcion) VALUES
('Excavadoras', 'Máquinas para excavación'),
('Taladros', 'Herramientas de perforación'),
('Andamios Móviles', 'Andamios con ruedas'),
('Podadoras', 'Equipos de corte para jardín'),
('Generadores Portátiles', 'Generadores pequeños y móviles');

-- Relación categorías-subcategorías
INSERT INTO categoria_subcategoria (categoria_id, subcategoria_id)
SELECT c.id, s.id FROM categoria c, subcategoria s WHERE c.nombre = 'Maquinaria Pesada' AND s.nombre = 'Excavadoras';
INSERT INTO categoria_subcategoria (categoria_id, subcategoria_id)
SELECT c.id, s.id FROM categoria c, subcategoria s WHERE c.nombre = 'Herramientas Eléctricas' AND s.nombre = 'Taladros';

-- Inserción de productos
INSERT INTO producto (nombre, descripcion, marca, modelo, precio_referencia_renta, sku) VALUES
('Excavadora Compacta', 'Excavadora pequeña para espacios reducidos', 'CAT', 'EC200', 1500.00, 'EXC-001'),
('Taladro Industrial', 'Taladro de alto rendimiento', 'BOSCH', 'TI500', 150.00, 'TAL-001'),
('Andamio Móvil', 'Andamio con ruedas de 6 metros', 'WERNER', 'AM600', 300.00, 'AND-001'),
('Podadora Profesional', 'Podadora de césped industrial', 'HONDA', 'PP200', 200.00, 'POD-001'),
('Generador 5000W', 'Generador eléctrico portátil', 'YAMAHA', 'GE5000', 400.00, 'GEN-001');

-- Inserción de items de inventario
INSERT INTO inventario_item (producto_id, numero_serie, estado_item, fecha_adquisicion, costo_adquisicion, ubicacion_fisica) 
SELECT id, CONCAT(sku, '-001'), 'Disponible', CURRENT_DATE, precio_referencia_renta * 10, 'Almacén Principal' 
FROM producto;

-- Inserción de clientes
INSERT INTO cliente (nombre, nombre2, apellido1, apellido2, rfc, telefono_principal, correo_electronico, tipo_cliente, estado_cliente) VALUES
('Pedro', 'Antonio', 'Ramírez', 'Silva', 'RASP800101XX1', '5551234567', 'pedro@example.com', 'Particular', 'Activo'),
('Ana', 'María', 'García', 'López', 'GALA850215XX2', '5559876543', 'ana@example.com', 'Particular', 'Activo'),
('Constructora', 'XYZ', 'SA', 'CV', 'CXY960320XX3', '5552345678', 'contacto@xyz.com', 'Empresa', 'Activo');

-- Inserción de direcciones
INSERT INTO direccion (calle, numero_exterior, colonia, ciudad, estado_provincia, codigo_postal, pais) VALUES
('Av. Reforma', '123', 'Centro', 'Ciudad de México', 'CDMX', '06000', 'México'),
('Calle Juárez', '456', 'San Ángel', 'Ciudad de México', 'CDMX', '01000', 'México'),
('Av. Insurgentes', '789', 'Del Valle', 'Ciudad de México', 'CDMX', '03100', 'México');

-- Relación clientes-direcciones
INSERT INTO cliente_direccion (cliente_id, direccion_id, es_principal)
SELECT c.id, d.id, 1 
FROM cliente c, direccion d 
WHERE c.nombre = 'Pedro' AND d.calle = 'Av. Reforma';

-- Inserción de solicitudes
INSERT INTO solicitud (cliente_id, nombre_producto_alternativo, cantidad_solicitada, descripcion_necesidad, estado_solicitud)
SELECT c.id, 'Excavadora Pequeña', 1, 'Necesito una excavadora para proyecto pequeño', 'Nueva'
FROM cliente c WHERE c.nombre = 'Pedro';

-- Inserción de cotizaciones
INSERT INTO cotizacion (cliente_id, solicitud_id, fecha_validez, monto_total, estado_cotizacion)
SELECT s.cliente_id, s.id, DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), 1500.00, 'Borrador'
FROM solicitud s
WHERE s.estado_solicitud = 'Nueva';
