-- =====================================================
-- SCRIPT DE INSERCIÓN DE DATOS - SISTEMA DE RENTA
-- =====================================================
-- Descripción: Datos de ejemplo para el sistema de renta de equipos
-- Autor: Sistema AXXION
-- Fecha: 2025-09-18
-- =====================================================

USE sistemarenta;

-- =====================================================
-- INSERCIÓN DE DATOS MAESTROS
-- =====================================================

-- Insertar roles del sistema
INSERT INTO rol (codigo, nombre, descripcion) VALUES
('ADMIN', 'Administrador', 'Acceso completo al sistema'),
('VENDEDOR', 'Vendedor', 'Gestión de clientes y rentas'),
('INVENTARIO', 'Encargado de Inventario', 'Gestión de productos e inventario'),
('SOPORTE', 'Soporte Técnico', 'Mantenimiento y soporte técnico');

-- Insertar usuarios del sistema
INSERT INTO usuario (nombre_usuario, nombre, nombre2, apellido1, apellido2, password, email, telefono, departamento, estado) VALUES
('admin', 'Carlos', 'Alberto', 'González', 'Pérez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@sistemarenta.com', '555-0001', 'Administración', 'Activo'),
('vendedor', 'María', 'Elena', 'Rodríguez', 'López', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'maria.rodriguez@sistemarenta.com', '555-0002', 'Ventas', 'Activo'),
('inventario1', 'José', 'Luis', 'Martínez', 'García', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'jose.martinez@sistemarenta.com', '555-0003', 'Inventario', 'Activo'),
('soporte1', 'Ana', 'Patricia', 'Hernández', 'Silva', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ana.hernandez@sistemarenta.com', '555-0004', 'Soporte', 'Activo');

-- Asignar roles a usuarios
INSERT INTO usuario_rol (usuario_id, rol_id) VALUES
(1, 1), -- Admin tiene rol de Administrador
(2, 2), -- María tiene rol de Vendedor
(3, 3), -- José tiene rol de Inventario
(4, 4); -- Ana tiene rol de Soporte

-- Insertar categorías
-- Inserción de usuarios
INSERT INTO usuario (nombre_usuario, nombre, nombre2, apellido1, apellido2, password, email, telefono, departamento, estado) VALUES
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
('Computadoras', 'Equipos de cómputo y laptops', 'Tecnología'),
('Audio y Video', 'Equipos de sonido y video profesional', 'Multimedia'),
('Proyección', 'Proyectores y pantallas', 'Presentación'),
('Redes', 'Equipos de networking y comunicaciones', 'Infraestructura'),
('Gaming', 'Consolas y equipos para videojuegos', 'Entretenimiento');

-- Insertar subcategorías
INSERT INTO subcategoria (nombre, descripcion) VALUES
('Laptops Ejecutivas', 'Laptops para uso empresarial'),
('Laptops Gaming', 'Laptops de alto rendimiento para gaming'),
('Desktops', 'Computadoras de escritorio'),
('Servidores', 'Servidores y equipos de red'),
('Proyectores HD', 'Proyectores de alta definición'),
('Pantallas LED', 'Pantallas y monitores LED'),
('Sistemas de Audio', 'Equipos de sonido profesional'),
('Consolas', 'Consolas de videojuegos'),
('Switches', 'Switches de red'),
('Routers', 'Routers y access points');

-- Relacionar categorías con subcategorías
INSERT INTO categoria_subcategoria (categoria_id, subcategoria_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), -- Computadoras
(2, 6), (2, 7), -- Audio y Video
(3, 5), (3, 6), -- Proyección
(4, 4), (4, 9), (4, 10), -- Redes
(5, 2), (5, 8); -- Gaming

-- Insertar productos
INSERT INTO producto (nombre, descripcion, marca, modelo, precio_referencia_renta, sku) VALUES
('Laptop Dell Latitude 7420', 'Laptop empresarial con procesador Intel i7', 'Dell', 'Latitude 7420', 150.00, 'DELL-LAT-7420'),
('Laptop Gaming ASUS ROG', 'Laptop gaming con RTX 3070', 'ASUS', 'ROG Strix G15', 300.00, 'ASUS-ROG-G15'),
('Proyector Epson PowerLite', 'Proyector 4K para presentaciones', 'Epson', 'PowerLite 5050UB', 200.00, 'EPSON-PL-5050'),
('Console PlayStation 5', 'Consola de videojuegos de última generación', 'Sony', 'PS5', 80.00, 'SONY-PS5-STD'),
('Switch Cisco Catalyst', 'Switch de 24 puertos gigabit', 'Cisco', 'Catalyst 2960-X', 100.00, 'CISCO-CAT-2960X');
describe producto;
-- Relacionar productos con subcategorías
INSERT INTO producto_subcategoria (producto_id, subcategoria_id) VALUES
(1, 1), -- Laptop Dell con Laptops Ejecutivas
(2, 2), -- Laptop ASUS con Laptops Gaming
(3, 5), -- Proyector con Proyectores HD
(4, 8), -- PS5 con Consolas
(5, 9); -- Switch con Switches

-- Insertar items de inventario
INSERT INTO inventario_item (producto_id, numero_serie, estado_item, fecha_adquisicion, costo_adquisicion, ubicacion_fisica) VALUES
(1, 'DELL001', 'Disponible', '2024-01-15', 1200.00, 'Almacén A-01'),
(1, 'DELL002', 'Disponible', '2024-01-15', 1200.00, 'Almacén A-02'),
(1, 'DELL003', 'Rentado', '2024-01-15', 1200.00, 'En cliente'),
(2, 'ASUS001', 'Disponible', '2024-02-01', 2500.00, 'Almacén B-01'),
(2, 'ASUS002', 'EnMantenimiento', '2024-02-01', 2500.00, 'Taller técnico'),
(3, 'EPSON001', 'Disponible', '2024-01-10', 3000.00, 'Almacén C-01'),
(4, 'SONY001', 'Disponible', '2024-03-01', 500.00, 'Almacén D-01'),
(4, 'SONY002', 'Rentado', '2024-03-01', 500.00, 'En cliente'),
(5, 'CISCO001', 'Disponible', '2024-01-20', 800.00, 'Almacén E-01');

-- =====================================================
-- INSERCIÓN DE CLIENTES Y DIRECCIONES
-- =====================================================

-- Insertar direcciones
INSERT INTO direccion (calle, numero_exterior, colonia, ciudad, estado_provincia, codigo_postal, pais) VALUES
('Av. Reforma', '123', 'Centro', 'Bogotá', 'Cundinamarca', '110111', 'Colombia'),
('Calle 72', '45-67', 'Chapinero', 'Bogotá', 'Cundinamarca', '110221', 'Colombia'),
('Carrera 15', '89-12', 'Zona Rosa', 'Bogotá', 'Cundinamarca', '110010', 'Colombia'),
('Av. El Dorado', '234', 'Fontibón', 'Bogotá', 'Cundinamarca', '111411', 'Colombia'),
('Calle 100', '56-78', 'Chicó', 'Bogotá', 'Cundinamarca', '110221', 'Colombia');

-- Insertar clientes
INSERT INTO cliente (nombre, nombre2, apellido1, apellido2, rfc, telefono_principal, correo_electronico, tipo_cliente, estado_cliente, fecha_nacimiento, genero) VALUES
('Juan', 'Carlos', 'Pérez', 'González', 'PEGJ850315ABC', '300-555-0101', 'juan.perez@email.com', 'Particular', 'Activo', '1985-03-15', 'M'),
('María', 'Elena', 'García', 'López', 'GALM900720DEF', '300-555-0102', 'maria.garcia@email.com', 'Particular', 'Activo', '1990-07-20', 'F'),
('TechCorp', 'S.A.S.', 'Empresa', 'Tecnológica', 'TCO201201GHI', '601-555-0103', 'contacto@techcorp.com', 'Empresa', 'Activo', NULL, NULL),
('Ana', 'Patricia', 'Rodríguez', 'Martínez', 'ROMA950412JKL', '300-555-0104', 'ana.rodriguez@email.com', 'Particular', 'Prospecto', '1995-04-12', 'F'),
('Carlos', 'Alberto', 'Hernández', 'Silva', 'HESC880925MNO', '300-555-0105', 'carlos.hernandez@email.com', 'Particular', 'Activo', '1988-09-25', 'M');

-- Relacionar clientes con direcciones
INSERT INTO cliente_direccion (cliente_id, direccion_id, es_principal) VALUES
(1, 1, 1), (2, 2, 1), (3, 3, 1), (4, 4, 1), (5, 5, 1);

-- =====================================================
-- INSERCIÓN DE RENTAS Y COTIZACIONES
-- =====================================================

-- Insertar cotizaciones
INSERT INTO cotizacion (cliente_id, fecha_cotizacion, fecha_validez, monto_total, estado_cotizacion, terminos_condiciones) VALUES
(1, '2024-09-01 10:00:00', '2024-09-30', 450.00, 'Aceptada', 'Renta por 3 días, incluye seguro'),
(2, '2024-09-05 14:30:00', '2024-10-05', 240.00, 'Enviada', 'Renta por 3 días'),
(3, '2024-09-10 09:15:00', '2024-10-10', 800.00, 'Aceptada', 'Renta corporativa por 1 semana'),
(4, '2024-08-15 16:45:00', '2024-09-15', 300.00, 'Vencida', 'Cotización para evento'),
(5, '2024-09-12 11:20:00', '2024-10-12', 160.00, 'Borrador', 'Renta para gaming');

-- Insertar detalles de cotización
INSERT INTO detalle_cotizacion (cotizacion_id, producto_id, descripcion_item, cantidad, precio_unitario, descuento_porcentaje) VALUES
(1, 1, 'Laptop Dell para presentaciones', 2, 150.00, 0.00),
(1, 3, 'Proyector para evento', 1, 200.00, 5.00),
(2, 4, 'PS5 para evento familiar', 1, 80.00, 0.00),
(3, 2, 'Laptop gaming para desarrollo', 2, 300.00, 10.00),
(3, 5, 'Switch para red corporativa', 1, 100.00, 0.00),
(5, 4, 'Consola para fin de semana', 2, 80.00, 0.00);

-- Insertar rentas
INSERT INTO renta (cliente_id, cotizacion_id, fecha_inicio, fecha_fin_prevista, estado_renta, monto_total_renta, deposito_garantia, metodo_pago) VALUES
(1, 1, '2024-09-15 09:00:00', '2024-09-18 18:00:00', 'Finalizada', 450.00, 200.00, 'Tarjeta'),
(3, 3, '2024-09-16 08:00:00', '2024-09-23 17:00:00', 'EnCurso', 700.00, 500.00, 'Transferencia'),
(2, NULL, '2024-09-17 10:00:00', '2024-09-19 20:00:00', 'Programada', 160.00, 100.00, 'Efectivo');

-- Relacionar rentas con items de inventario
INSERT INTO renta_inventario_item (renta_id, inventario_item_id, precio_renta_item, condicion_salida) VALUES
(1, 1, 150.00, 'Excelente estado, sin rayones'),
(1, 6, 200.00, 'Funcionando perfectamente'),
(2, 2, 300.00, 'Buen estado general'),
(2, 9, 100.00, 'Nuevo, en caja original'),
(3, 8, 80.00, 'Incluye 2 controles');

-- =====================================================
-- INSERCIÓN DE DATOS COMPLEMENTARIOS
-- =====================================================

-- Insertar proveedores
INSERT INTO proveedor (nombre_empresa, rfc, nombre_contacto, telefono_contacto, correo_contacto) VALUES
('Distribuidora Tech S.A.S.', 'DTE202101PQR', 'Roberto Gómez', '601-555-0201', 'roberto@distritech.com'),
('Importadora Digital Ltda.', 'IDL202102STU', 'Laura Jiménez', '601-555-0202', 'laura@impdigital.com'),
('Soluciones IT Colombia', 'SIC202103VWX', 'Miguel Torres', '601-555-0203', 'miguel@solucionesit.com');

-- Insertar mantenimientos
INSERT INTO mantenimiento (inventario_item_id, fecha_inicio, fecha_fin_prevista, tipo_mantenimiento, descripcion_problema, costo_estimado, estado_mantenimiento, responsable) VALUES
(5, '2024-09-10 08:00:00', '2024-09-12', 'Correctivo', 'Pantalla con pixeles muertos', 250.00, 'EnProceso', 'Ana Hernández'),
(2, '2024-09-01 09:00:00', '2024-09-03', 'Preventivo', 'Limpieza general y actualización', 50.00, 'Finalizado', 'Ana Hernández');

-- Insertar configuraciones del sistema
INSERT INTO configuracion_sistema (clave, valor, descripcion, tipo_dato, categoria) VALUES
('DIAS_MAXIMOS_RENTA', '30', 'Máximo número de días para una renta', 'INTEGER', 'RENTAS'),
('PORCENTAJE_DEPOSITO', '50', 'Porcentaje del valor como depósito de garantía', 'INTEGER', 'FINANZAS'),
('EMAIL_NOTIFICACIONES', 'notificaciones@sistemarenta.com', 'Email para envío de notificaciones', 'STRING', 'SISTEMA'),
('MONEDA_SISTEMA', 'COP', 'Moneda del sistema', 'STRING', 'FINANZAS'),
('DIAS_RECORDATORIO_DEVOLUCION', '1', 'Días antes del vencimiento para recordatorio', 'INTEGER', 'NOTIFICACIONES');

-- Insertar notificaciones de ejemplo
INSERT INTO notificacion (usuario_id, titulo, mensaje, tipo, leida) VALUES
(2, 'Nueva renta programada', 'Se ha programado una nueva renta para el cliente Juan Pérez', 'INFO', FALSE),
(3, 'Item requiere mantenimiento', 'El item ASUS002 necesita mantenimiento correctivo', 'WARNING', FALSE),
(1, 'Reporte mensual disponible', 'El reporte de rentas del mes está listo para revisión', 'SUCCESS', TRUE),
(4, 'Mantenimiento completado', 'Se completó el mantenimiento del item ASUS002', 'SUCCESS', FALSE);

-- =====================================================
-- FIN DEL SCRIPT DE INSERCIÓN
-- =====================================================