
-- Inserciones para la tabla `rol`
INSERT INTO `rol` (`codigo`, `nombre`, `descripcion`) VALUES
('ADMIN', 'Administrador', 'Rol con todos los permisos en el sistema.'),
('OPER', 'Operador', 'Rol para la gestión de inventario y rentas.'),
('VENT', 'Ventas', 'Rol para la gestión de clientes y cotizaciones.'),
('CLI', 'Cliente', 'Rol para clientes que acceden al portal.');

-- Inserciones para la tabla `usuario`
INSERT INTO `usuario` (`nombre_usuario`, `nombre`, `nombre2`, `apellido1`, `apellido2`, `password_hash`, `email`, `telefono`, `departamento`, `estado`) VALUES
('admin', 'Admin', 'Principal', 'del Sistema', '', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@axxion.com', '1234567890', 'Administración', 'Activo'),
('operador1', 'Juan', 'Carlos', 'Perez', 'Gomez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'juan.perez@axxion.com', '0987654321', 'Operaciones', 'Activo'),
('vendedor1', 'Ana', 'Maria', 'Lopez', 'Fernandez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ana.lopez@axxion.com', '1122334455', 'Ventas', 'Activo'),
('tecnico1', 'Roberto', 'Carlos', 'Martinez', 'Silva', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'roberto.martinez@axxion.com', '5566778899', 'Técnico', 'Activo');

-- Inserciones para la tabla `usuario_rol`
INSERT INTO `usuario_rol` (`usuario_id`, `rol_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 2);

-- Inserciones para la tabla `categoria`
INSERT INTO `categoria` (`nombre`, `descripcion`, `tipo_categoria`) VALUES
('Equipos de Sonido', 'Altavoces, consolas, micrófonos y más.', 'Equipos'),
('Iluminación', 'Luces para eventos, escenarios y fiestas.', 'Equipos'),
('Video', 'Pantallas, proyectores y equipo de video.', 'Equipos'),
('Mobiliario', 'Sillas, mesas, carpas y decoración.', 'Mobiliario');

-- Inserciones para la tabla `subcategoria`
INSERT INTO `subcategoria` (`nombre`, `descripcion`) VALUES
('Altavoces Activos', 'Altavoces con amplificador integrado.'),
('Consolas Digitales', 'Mesas de mezcla de audio digitales.'),
('Micrófonos Inalámbricos', 'Micrófonos sin cables para mayor movilidad.'),
('Luces LED', 'Sistemas de iluminación base LED.'),
('Proyectores HD', 'Proyectores de alta definición.'),
('Sillas Plegables', 'Sillas para todo tipo de evento.'),
('Mesas Redondas', 'Mesas para banquetes y eventos.'),
('Pantallas LED', 'Pantallas modulares para video en gran formato.');

-- Inserciones para la tabla `categoria_subcategoria`
INSERT INTO `categoria_subcategoria` (`categoria_id`, `subcategoria_id`) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4),
(3, 5), (3, 8),
(4, 6), (4, 7);

-- Inserciones para la tabla `cliente`
INSERT INTO `cliente` (`nombre`, `nombre2`, `apellido1`, `apellido2`, `rfc`, `telefono_principal`, `correo_electronico`, `tipo_cliente`, `estado_cliente`) VALUES
('Carlos', 'Alberto', 'Sanchez', 'Ruiz', 'SARC850312XYZ', '5512345678', 'carlos.sanchez@email.com', 'Particular', 'Activo'),
('Eventos', 'Grandes', 'SA de CV', '', 'EGR990115ABC', '5587654321', 'contacto@eventosgrandes.com', 'Empresa', 'Activo'),
('Maria', 'Elena', 'García', 'Pérez', 'GAPM780520DEF', '5555667788', 'maria.garcia@email.com', 'Particular', 'Prospecto');

-- Inserciones para la tabla `direccion`
INSERT INTO `direccion` (`calle`, `numero_exterior`, `colonia`, `ciudad`, `estado_provincia`, `codigo_postal`, `pais`, `referencias`) VALUES
('Av. Siempre Viva', '742', 'Springfield', 'Ciudad de México', 'CDMX', '01234', 'México', 'Frente al Kwik-E-Mart'),
('Calle Falsa', '123', 'Centro', 'Guadalajara', 'Jalisco', '44100', 'México', 'Edificio de ladrillo rojo'),
('Blvd. de los Sueños Rotos', '45', 'Zona Hotelera', 'Cancún', 'Quintana Roo', '77500', 'México', 'Cerca de la playa');

-- Inserciones para la tabla `cliente_direccion`
INSERT INTO `cliente_direccion` (`cliente_id`, `direccion_id`, `es_principal`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1);

-- Inserciones para la tabla `proveedor`
INSERT INTO `proveedor` (`nombre_empresa`, `rfc`, `nombre_contacto`, `telefono_contacto`, `correo_contacto`, `estado_proveedor`) VALUES
('Audio Pro México', 'APM010203XYZ', 'Pedro Ramirez', '3312345678', 'pedro@audiopro.mx', 'Activo'),
('Iluminación Espectacular', 'IES050607ABC', 'Laura Juarez', '8187654321', 'laura@iluminacion.com', 'Activo');

-- Inserciones para la tabla `proveedor_direccion`
INSERT INTO `proveedor_direccion` (`proveedor_id`, `direccion_id`, `es_principal`) VALUES
(1, 2, 1),
(2, 1, 1);

-- Inserciones para la tabla `producto`
INSERT INTO `producto` (`nombre`, `descripcion`, `marca`, `modelo`, `precio_alquiler_dia`, `precio_alquiler_semanal`, `precio_alquiler_mensual`, `precio_compra`, `valor_actual`, `fecha_compra`, `condicion`, `ubicacion`, `sku`, `numero_serie`, `categoria`, `especificaciones`, `estado`) VALUES
('Altavoz autoamplificado 15"', 'Altavoz de 15 pulgadas con 1000W de potencia.', 'QSC', 'K12.2', 800.00, 4800.00, 18000.00, 25000.00, 22000.00, '2024-01-15', 'Excelente', 'Bodega A-1', 'QSC-K122-001', 'QSCK122001', 'Audio', '{"potencia": "1000W", "pulgadas": 15, "tipo": "Activo", "peso": "22kg"}', 'disponible'),
('Consola de mezclas digital', 'Consola de 32 canales con preamplificadores Midas.', 'Behringer', 'X32', 1500.00, 9000.00, 33000.00, 60000.00, 55000.00, '2023-11-20', 'Excelente', 'Bodega B-2', 'BEH-X32-001', 'BEHX32001', 'Audio', '{"canales": 32, "efectos": "Sí", "interfaz_audio": "Sí", "preamplificadores": "Midas"}', 'disponible'),
('Micrófono inalámbrico de mano', 'Sistema inalámbrico digital de alta calidad.', 'Shure', 'QLX-D', 600.00, 3600.00, 13500.00, 18000.00, 16000.00, '2024-03-10', 'Bueno', 'Taller', 'SHU-QLXD-001', 'SHUQLXD001', 'Audio', '{"tipo": "Mano", "frecuencia": "Digital", "alcance": "100m"}', 'en_mantenimiento'),
('Proyector 5000 Lúmenes', 'Proyector láser de alta luminosidad.', 'Epson', 'PowerLite L510U', 2000.00, 12000.00, 45000.00, 85000.00, 80000.00, '2024-02-01', 'Excelente', 'Bodega C-1', 'EPS-L510U-001', 'EPSL510U001', 'Video', '{"lumenes": 5000, "resolucion": "WUXGA", "tecnologia": "Láser", "vida_util": "20000h"}', 'disponible'),
('Luz LED Par 64', 'Reflector LED RGBW de 180W.', 'Chauvet', 'SlimPAR Pro H USB', 300.00, 1800.00, 6750.00, 8500.00, 7500.00, '2024-01-20', 'Excelente', 'Bodega D-1', 'CHA-SLIMPAR-001', 'CHASLIM001', 'Iluminación', '{"potencia": "180W", "colores": "RGBW", "control": "DMX512"}', 'disponible'),
('Mesa redonda 1.8m', 'Mesa redonda para 10 personas.', 'Eventos Pro', 'MR-180', 150.00, 900.00, 3375.00, 3500.00, 3000.00, '2023-12-15', 'Bueno', 'Bodega E-1', 'EVP-MR180-001', 'EVPMR180001', 'Mobiliario', '{"diametro": "1.8m", "capacidad": "10 personas", "material": "Madera"}', 'disponible'),
('Silla Tiffany dorada', 'Silla elegante para eventos.', 'Eventos Pro', 'ST-DORADA', 50.00, 300.00, 1125.00, 1200.00, 1000.00, '2023-10-10', 'Bueno', 'Bodega E-2', 'EVP-STDOR-001', 'EVPSTDOR001', 'Mobiliario', '{"material": "Resina", "color": "Dorado", "apilable": "Sí"}', 'disponible'),
('Pantalla de proyección 2x3m', 'Pantalla frontal para proyector.', 'Da-Lite', 'Fast-Fold Deluxe', 500.00, 3000.00, 11250.00, 15000.00, 13500.00, '2024-01-25', 'Excelente', 'Bodega C-2', 'DAL-FFD23-001', 'DALFFD23001', 'Video', '{"tamaño": "2x3m", "tipo": "Frontal", "superficie": "Matte White"}', 'disponible'),
('Carpa 6x6m', 'Carpa blanca para eventos exteriores.', 'Tent Pro', 'TP-66', 1200.00, 7200.00, 27000.00, 35000.00, 32000.00, '2023-09-05', 'Bueno', 'Patio exterior', 'TNT-TP66-001', 'TNTTP66001', 'Mobiliario', '{"tamaño": "6x6m", "color": "Blanco", "resistente_agua": "Sí"}', 'disponible'),
('Altavoz subwoofer 18"', 'Subwoofer activo de 18 pulgadas.', 'QSC', 'KS118', 1000.00, 6000.00, 22500.00, 35000.00, 32000.00, '2024-02-10', 'Excelente', 'Bodega A-2', 'QSC-KS118-001', 'QSCKS118001', 'Audio', '{"potencia": "3600W", "pulgadas": 18, "tipo": "Subwoofer activo"}', 'disponible');

-- Inserciones para la tabla `producto_subcategoria`
INSERT INTO `producto_subcategoria` (`producto_id`, `subcategoria_id`) VALUES
(1, 1), -- Altavoz -> Altavoces Activos
(2, 2), -- Consola -> Consolas Digitales
(3, 3), -- Micrófono -> Micrófonos Inalámbricos
(4, 5), -- Proyector -> Proyectores HD
(5, 4), -- Luz LED -> Luces LED
(6, 7), -- Mesa redonda -> Mesas Redondas
(7, 6), -- Silla -> Sillas Plegables
(8, 8), -- Pantalla -> Pantallas LED
(9, 7), -- Carpa -> Mesas Redondas (mobiliario general)
(10, 1); -- Subwoofer -> Altavoces Activos

-- Inserciones para la tabla `inventario_item`
INSERT INTO `inventario_item` (`producto_id`, `numero_serie`, `estado_item`, `fecha_adquisicion`, `costo_adquisicion`, `ubicacion_fisica`, `notas`) VALUES
(1, 'QSCK122-001', 'Disponible', '2024-01-15', 25000.00, 'Bodega A-1', 'En excelente estado'),
(1, 'QSCK122-002', 'Rentado', '2024-01-15', 25000.00, 'Bodega A-1', 'Actualmente en renta'),
(1, 'QSCK122-003', 'Disponible', '2024-01-15', 25000.00, 'Bodega A-1', 'Recién adquirido'),
(2, 'BEHX32-001', 'Disponible', '2023-11-20', 60000.00, 'Bodega B-2', 'Incluye flight case'),
(3, 'SHUQLXD-001', 'EnMantenimiento', '2024-03-10', 18000.00, 'Taller', 'Reparación de interferencia'),
(3, 'SHUQLXD-002', 'Disponible', '2024-03-10', 18000.00, 'Bodega A-3', 'Sistema completo con receptor'),
(4, 'EPSL510U-001', 'Disponible', '2024-02-01', 85000.00, 'Bodega C-1', 'Con lentes intercambiables'),
(5, 'CHASLIM-001', 'Disponible', '2024-01-20', 8500.00, 'Bodega D-1', 'Set de 4 unidades'),
(5, 'CHASLIM-002', 'Disponible', '2024-01-20', 8500.00, 'Bodega D-1', 'Set de 4 unidades'),
(6, 'EVPMR180-001', 'Disponible', '2023-12-15', 3500.00, 'Bodega E-1', 'Con mantel incluido'),
(6, 'EVPMR180-002', 'Disponible', '2023-12-15', 3500.00, 'Bodega E-1', 'Con mantel incluido'),
(6, 'EVPMR180-003', 'Disponible', '2023-12-15', 3500.00, 'Bodega E-1', 'Con mantel incluido'),
(7, 'EVPSTDOR-001', 'Disponible', '2023-10-10', 1200.00, 'Bodega E-2', 'Set de 10 sillas'),
(7, 'EVPSTDOR-002', 'Disponible', '2023-10-10', 1200.00, 'Bodega E-2', 'Set de 10 sillas'),
(8, 'DALFFD23-001', 'Disponible', '2024-01-25', 15000.00, 'Bodega C-2', 'Con trípodes incluidos'),
(9, 'TNTTP66-001', 'Disponible', '2023-09-05', 35000.00, 'Patio exterior', 'Con anclajes y cuerdas'),
(10, 'QSCKS118-001', 'Disponible', '2024-02-10', 35000.00, 'Bodega A-2', 'Con ruedas de transporte'),
(10, 'QSCKS118-002', 'Disponible', '2024-02-10', 35000.00, 'Bodega A-2', 'Con ruedas de transporte');

-- Inserciones para la tabla `solicitud`
INSERT INTO `solicitud` (`cliente_id`, `descripcion_necesidad`, `estado_solicitud`) VALUES
(1, 'Necesito cotización para un sistema de sonido para una fiesta de 100 personas.', 'Nueva'),
(2, 'Requiero equipo de video para una conferencia, incluyendo pantalla y proyector.', 'EnProceso');

-- Inserciones para la tabla `solicitud_producto`
INSERT INTO `solicitud_producto` (`solicitud_id`, `producto_id`) VALUES
(1, 1),
(2, 4);

-- Inserciones para la tabla `cotizacion`
INSERT INTO `cotizacion` (`cliente_id`, `solicitud_id`, `fecha_validez`, `monto_total`, `estado_cotizacion`, `terminos_condiciones`) VALUES
(1, 1, '2025-10-19', 1600.00, 'Enviada', 'Pago del 50% para reservar. No incluye IVA.'),
(2, 2, '2025-10-15', 2500.00, 'Borrador', 'Sujeto a disponibilidad de equipo.');

-- Inserciones para la tabla `detalle_cotizacion`
INSERT INTO `detalle_cotizacion` (`cotizacion_id`, `producto_id`, `descripcion_item`, `cantidad`, `precio_unitario`, `descuento_porcentaje`, `notas`) VALUES
(1, 1, 'Altavoz autoamplificado 15" QSC K12.2', 2, 800.00, 0.00, 'Para evento de 100 personas'),
(1, 3, 'Micrófono inalámbrico Shure QLX-D', 2, 600.00, 5.00, 'Descuento por cantidad'),
(2, 4, 'Proyector 5000 Lúmenes Epson PowerLite L510U', 1, 2000.00, 0.00, 'Para conferencia empresarial'),
(2, 8, 'Pantalla de proyección frontal 2x3m', 1, 500.00, 0.00, 'Incluye trípodes de soporte');

-- Inserciones para la tabla `renta`
INSERT INTO `renta` (`cliente_id`, `cotizacion_id`, `fecha_inicio`, `fecha_fin_prevista`, `estado_renta`, `monto_total_renta`, `deposito_garantia`) VALUES
(2, NULL, '2025-09-20 10:00:00', '2025-09-22 18:00:00', 'Programada', 5000.00, 1000.00);

-- Inserciones para la tabla `renta_inventario_item`
INSERT INTO `renta_inventario_item` (`renta_id`, `inventario_item_id`, `precio_renta_item`, `condicion_salida`) VALUES
(1, 2, 1500.00, 'En buen estado, con estuche y cables.'),
(1, 5, 2000.00, 'En buen estado, con maletín y control remoto.');

-- Inserciones para la tabla `entrega`
INSERT INTO `entrega` (`renta_id`, `direccion_id`, `fecha_envio`, `estado_entrega`) VALUES
(1, 2, '2025-09-20 08:00:00', 'Programada');

-- Inserciones para la tabla `devolucion`
INSERT INTO `devolucion` (`renta_id`, `fecha_devolucion_programada`, `estado_devolucion`) VALUES
(1, '2025-09-22', 'Pendiente');

-- Inserciones para la tabla `mantenimiento`
INSERT INTO `mantenimiento` (`inventario_item_id`, `fecha_inicio`, `fecha_fin_prevista`, `tipo_mantenimiento`, `descripcion_problema`, `descripcion_trabajo_realizado`, `costo_estimado`, `costo_real`, `estado_mantenimiento`, `responsable`) VALUES
(5, '2025-09-15 09:00:00', '2025-09-20', 'Correctivo', 'El micrófono presenta interferencia y cortes de señal.', 'Reemplazo de antena receptora y calibración de frecuencias', 2500.00, 2200.00, 'EnProceso', 'Roberto Martinez'),
(2, '2025-08-01 10:00:00', '2025-08-03', 'Preventivo', 'Mantenimiento preventivo programado', 'Limpieza general, actualización de firmware, calibración de canales', 1500.00, 1200.00, 'Finalizado', 'Roberto Martinez'),
(11, '2025-09-10 14:00:00', '2025-09-25', 'Correctivo', 'Altavoz presenta distorsión en frecuencias altas', NULL, 3000.00, NULL, 'Programado', 'Roberto Martinez');

-- Inserciones adicionales para más clientes
INSERT INTO `cliente` (`nombre`, `nombre2`, `apellido1`, `apellido2`, `rfc`, `telefono_principal`, `correo_electronico`, `tipo_cliente`, `estado_cliente`) VALUES
('Producciones', 'Audiovisuales', 'SA de CV', '', 'PAV120815GHI', '5544332211', 'contacto@prodav.com', 'Empresa', 'Activo'),
('Luis', 'Fernando', 'Rodriguez', 'Morales', 'ROML850720JKL', '5599887766', 'luis.rodriguez@email.com', 'Particular', 'Activo'),
('Eventos', 'Corporativos', 'Plus SA', '', 'ECP030910MNO', '5533445566', 'ventas@eventoscorp.com', 'Empresa', 'Prospecto');

-- Inserciones adicionales para direcciones
INSERT INTO `direccion` (`calle`, `numero_exterior`, `numero_interior`, `colonia`, `ciudad`, `estado_provincia`, `codigo_postal`, `pais`, `referencias`) VALUES
('Av. Insurgentes Sur', '1234', 'Piso 5', 'Del Valle', 'Ciudad de México', 'CDMX', '03100', 'México', 'Torre empresarial, entrada por estacionamiento'),
('Calle Morelos', '567', NULL, 'Centro Histórico', 'Puebla', 'Puebla', '72000', 'México', 'Edificio colonial, portón verde'),
('Blvd. Kukulcán', '89', 'Local 12', 'Zona Hotelera', 'Cancún', 'Quintana Roo', '77500', 'México', 'Plaza comercial, segundo nivel');

-- Relaciones cliente-direccion adicionales
INSERT INTO `cliente_direccion` (`cliente_id`, `direccion_id`, `es_principal`) VALUES
(4, 4, 1),
(5, 5, 1),
(6, 6, 1);

-- Inserciones adicionales para proveedores
INSERT INTO `proveedor` (`nombre_empresa`, `rfc`, `nombre_contacto`, `telefono_contacto`, `correo_contacto`, `estado_proveedor`) VALUES
('Mobiliario Eventos MX', 'MEM080912PQR', 'Carmen Vega', '5577889900', 'carmen@mobiliariomx.com', 'Activo'),
('Tech Video Solutions', 'TVS151218STU', 'Miguel Torres', '8199001122', 'miguel@techvideo.com', 'Activo');

-- Relaciones proveedor-direccion adicionales
INSERT INTO `proveedor_direccion` (`proveedor_id`, `direccion_id`, `es_principal`) VALUES
(3, 4, 1),
(4, 5, 1);

-- Inserciones adicionales para solicitudes
INSERT INTO `solicitud` (`cliente_id`, `fecha_solicitud`, `nombre_producto_alternativo`, `cantidad_solicitada`, `descripcion_necesidad`, `estado_solicitud`) VALUES
(4, '2025-09-18 14:30:00', 'Sistema de sonido completo', 1, 'Necesito un sistema completo para una presentación de producto con 200 asistentes', 'Nueva'),
(5, '2025-09-17 10:15:00', 'Mobiliario para boda', 50, 'Requiero mesas y sillas para una boda de 150 personas en jardín', 'EnProceso'),
(1, '2025-09-16 16:45:00', 'Iluminación LED', 20, 'Luces de colores para fiesta de cumpleaños en casa', 'Atendida');

-- Relaciones solicitud-producto adicionales
INSERT INTO `solicitud_producto` (`solicitud_id`, `producto_id`) VALUES
(3, 1), (3, 2), (3, 10),
(4, 6), (4, 7),
(5, 5);

-- Inserciones adicionales para cotizaciones
INSERT INTO `cotizacion` (`cliente_id`, `solicitud_id`, `fecha_cotizacion`, `fecha_validez`, `monto_total`, `estado_cotizacion`, `terminos_condiciones`, `notas_internas`) VALUES
(4, 3, '2025-09-18 15:00:00', '2025-10-18', 8500.00, 'Enviada', 'Pago 50% anticipo, 50% contra entrega. Incluye instalación y operador.', 'Cliente corporativo, descuento aplicado'),
(5, 4, '2025-09-17 11:00:00', '2025-10-17', 12000.00, 'Borrador', 'Precios sujetos a confirmación de fechas. Incluye montaje.', 'Evento en exterior, considerar carpa adicional'),
(1, 5, '2025-09-16 17:00:00', '2025-10-16', 2400.00, 'Aceptada', 'Pago de contado con 10% descuento.', 'Cliente frecuente');

-- Inserciones adicionales para detalles de cotización
INSERT INTO `detalle_cotizacion` (`cotizacion_id`, `producto_id`, `descripcion_item`, `cantidad`, `precio_unitario`, `descuento_porcentaje`, `notas`) VALUES
(3, 1, 'Altavoz autoamplificado 15" QSC K12.2', 4, 800.00, 10.00, 'Descuento por volumen'),
(3, 2, 'Consola de mezclas digital Behringer X32', 1, 1500.00, 10.00, 'Incluye operador técnico'),
(3, 10, 'Subwoofer QSC KS118', 2, 1000.00, 10.00, 'Para refuerzo de graves'),
(4, 6, 'Mesa redonda 1.8m', 15, 150.00, 5.00, 'Con manteles blancos'),
(4, 7, 'Silla Tiffany dorada', 150, 50.00, 8.00, 'Descuento por cantidad'),
(5, 5, 'Luz LED Par 64', 8, 300.00, 0.00, 'Colores personalizables');

-- Inserciones adicionales para rentas
INSERT INTO `renta` (`cliente_id`, `cotizacion_id`, `fecha_inicio`, `fecha_fin_prevista`, `estado_renta`, `monto_total_renta`, `deposito_garantia`, `notas`) VALUES
(1, 2, '2025-09-25 18:00:00', '2025-09-26 02:00:00', 'Programada', 2400.00, 500.00, 'Fiesta privada en casa, instalación incluida'),
(2, 1, '2025-10-05 08:00:00', '2025-10-05 20:00:00', 'Programada', 8500.00, 2000.00, 'Presentación corporativa, requiere técnico especializado');

-- Inserciones adicionales para renta_inventario_item
INSERT INTO `renta_inventario_item` (`renta_id`, `inventario_item_id`, `precio_renta_item`, `condicion_salida`, `notas`) VALUES
(2, 11, 300.00, 'Excelente estado, con controlador DMX', 'Set de 8 luces LED'),
(2, 12, 300.00, 'Excelente estado, con controlador DMX', 'Set de 8 luces LED'),
(3, 1, 800.00, 'Excelente estado, con cables XLR', 'Altavoz principal izquierdo'),
(3, 3, 800.00, 'Excelente estado, con cables XLR', 'Altavoz principal derecho'),
(3, 4, 1500.00, 'Excelente estado, con flight case', 'Consola principal con técnico'),
(3, 17, 1000.00, 'Excelente estado, con cables de potencia', 'Subwoofer 1'),
(3, 18, 1000.00, 'Excelente estado, con cables de potencia', 'Subwoofer 2');

-- Inserciones adicionales para entregas
INSERT INTO `entrega` (`renta_id`, `direccion_id`, `fecha_envio`, `compania_envio`, `numero_guia`, `estado_entrega`, `notas`) VALUES
(2, 1, '2025-09-25 16:00:00', 'Transporte Axxion', 'AXX-2025-001', 'Programada', 'Instalación incluida, llegada 2 horas antes del evento'),
(3, 4, '2025-10-05 06:00:00', 'Transporte Axxion', 'AXX-2025-002', 'Programada', 'Montaje temprano, evento corporativo');

-- Inserciones adicionales para devoluciones
INSERT INTO `devolucion` (`renta_id`, `fecha_devolucion_programada`, `estado_devolucion`, `notas_generales`) VALUES
(2, '2025-09-26', 'Pendiente', 'Recolección programada al día siguiente del evento'),
(3, '2025-10-05', 'Pendiente', 'Desmontaje inmediato al finalizar presentación');

-- ============================================================================
-- RESUMEN DE DATOS INSERTADOS
-- ============================================================================
-- 
-- USUARIOS Y ROLES:
-- - 4 usuarios (admin, operador, vendedor, técnico)
-- - 4 roles (Administrador, Operador, Ventas, Cliente)
-- 
-- CATÁLOGO:
-- - 4 categorías principales (Audio, Iluminación, Video, Mobiliario)
-- - 8 subcategorías específicas
-- - 10 productos diversos con precios completos
-- - 18 items de inventario con números de serie únicos
-- 
-- CLIENTES Y PROVEEDORES:
-- - 6 clientes (3 particulares, 3 empresas)
-- - 4 proveedores especializados
-- - 6 direcciones completas con referencias
-- 
-- OPERACIONES COMERCIALES:
-- - 5 solicitudes de clientes
-- - 6 cotizaciones (borrador, enviada, aceptada)
-- - 3 rentas programadas
-- - 3 entregas programadas
-- - 3 devoluciones pendientes
-- 
-- MANTENIMIENTO:
-- - 3 registros de mantenimiento (preventivo y correctivo)
-- 
-- TOTAL: Más de 100 registros distribuidos en todas las tablas del sistema
-- ============================================================================
