-- =====================================================
-- SISTEMA DE RENTAS - CONSULTAS DE UNA SOLA TABLA
-- =====================================================
-- Este archivo contiene consultas SELECT que operan sobre
-- una sola tabla del sistema de rentas de equipos tecnológicos
-- =====================================================

USE sistemarenta;

-- Consultas para la tabla `categoria`
SELECT * FROM `categoria`;

-- Consultas para la tabla `categoria_subcategoria`
SELECT * FROM `categoria_subcategoria`;

-- Consultas para la tabla `cliente`
SELECT * FROM `cliente`;

-- Consultas para la tabla `cliente_direccion`
SELECT * FROM `cliente_direccion`;

-- Consultas para la tabla `cotizacion`
SELECT * FROM `cotizacion`;

-- Consultas para la tabla `detalle_cotizacion`
SELECT * FROM `detalle_cotizacion`;

-- Consultas para la tabla `devolucion`
SELECT * FROM `devolucion`;

-- Consultas para la tabla `direccion`
SELECT * FROM `direccion`;

-- Consultas para la tabla `entrega`
SELECT * FROM `entrega`;

-- Consultas para la tabla `inventario_item`
SELECT * FROM `inventario_item`;

-- Consultas para la tabla `mantenimiento`
SELECT * FROM `mantenimiento`;

-- Consultas para la tabla `producto`
SELECT * FROM `producto`;

-- Consultas para la tabla `producto_subcategoria`
SELECT * FROM `producto_subcategoria`;

-- Consultas para la tabla `proveedor`
SELECT * FROM `proveedor`;

-- Consultas para la tabla `proveedor_direccion`
SELECT * FROM `proveedor_direccion`;

-- Consultas para la tabla `renta`
SELECT * FROM `renta`;

-- Consultas para la tabla `rent-inventario_item`
SELECT * FROM `rent-inventario_item`;

-- Consultas para la tabla `rol`
SELECT * FROM `rol`;

-- Consultas para la tabla `solicitud`
SELECT * FROM `solicitud`;

-- Consultas para la tabla `solicitud_producto`
SELECT * FROM `solicitud_producto`;

-- Consultas para la tabla `subcategoria`
SELECT * FROM `subcategoria`;

-- Consultas para la tabla `usuario`
SELECT * FROM `usuario`;

-- Consultas para la tabla `usuario_rol`
SELECT * FROM `usuario_rol`;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA CLIENTE
-- =====================================================

-- 1. ¿Cuáles son todos los nombres de los clientes?
SELECT CONCAT(nombre, ' ', nombre2, ' ', apellido1, ' ', apellido2) as nombre_completo
FROM cliente;

-- 2. ¿Cuáles son los nombres y teléfonos de todos los clientes?
SELECT CONCAT(nombre, ' ', apellido1) as nombre_cliente, telefono_principal
FROM cliente;

-- 3. ¿Cuáles son los clientes activos?
SELECT *
FROM cliente
WHERE estado_cliente = 'Activo';

-- 4. ¿Cuáles son los clientes de tipo empresa?
SELECT nombre, rfc, correo_electronico
FROM cliente
WHERE tipo_cliente = 'Empresa';

-- 5. ¿Cuáles son los clientes prospectos ordenados por fecha de creación?
SELECT nombre, correo_electronico, created_at
FROM cliente
WHERE estado_cliente = 'Prospecto'
ORDER BY created_at DESC;

-- 6. ¿Cuántos clientes hay en total?
SELECT COUNT(*) as total_clientes
FROM cliente;

-- 7. ¿Cuántos clientes activos hay?
SELECT COUNT(*) as clientes_activos
FROM cliente
WHERE estado_cliente = 'Activo';

-- 8. ¿Cuáles son los clientes sin RFC registrado?
SELECT nombre, correo_electronico
FROM cliente
WHERE rfc IS NULL;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA PRODUCTO
-- =====================================================

-- 9. ¿Cuáles son todos los productos disponibles?
SELECT nombre, marca, modelo, precio_referencia_renta
FROM producto;

-- 10. ¿Cuáles son los productos de QSC?
SELECT nombre, modelo, precio_referencia_renta
FROM producto
WHERE nombre like '%altavoz%';
-- invoque
-- patrones de busqueda

-- 11. ¿Cuáles son los productos ordenados por precio de mayor a menor?
SELECT nombre, marca, precio_referencia_renta
FROM producto
ORDER BY precio_referencia_renta DESC;

-- 12. ¿Cuáles son los productos con precio mayor a $100?
SELECT nombre, marca, precio_referencia_renta
FROM producto
WHERE precio_referencia_renta > 100;

-- 13. ¿Cuál es el producto más caro?
SELECT nombre, marca, precio_referencia_renta
FROM producto
ORDER BY precio_referencia_renta DESC
LIMIT 1;

-- 14. ¿Cuáles son los productos sin SKU?
SELECT nombre, marca, modelo
FROM producto
WHERE sku IS NULL;

-- 15. ¿Cuántos productos hay por marca?
SELECT marca, COUNT(*) as cantidad_productos
FROM producto
GROUP BY marca;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA INVENTARIO_ITEM
-- =====================================================

-- 16. ¿Cuáles son todos los items disponibles?
SELECT numero_serie, estado_item, ubicacion_fisica
FROM inventario_item
WHERE estado_item = 'Disponible';

-- 17. ¿Cuáles son los items en mantenimiento?
SELECT numero_serie, ubicacion_fisica, notas
FROM inventario_item
WHERE estado_item = 'EnMantenimiento';

-- 18. ¿Cuáles son los items rentados?
SELECT numero_serie, ubicacion_fisica
FROM inventario_item
WHERE estado_item = 'Rentado';

-- 19. ¿Cuántos items hay por estado?
SELECT estado_item, COUNT(*) as cantidad
FROM inventario_item
GROUP BY estado_item;

-- 20. ¿Cuáles son los items adquiridos en el último mes?
SELECT numero_serie, fecha_adquisicion, costo_adquisicion
FROM inventario_item
WHERE fecha_adquisicion >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- 21. ¿Cuál es el item más costoso?
SELECT numero_serie, costo_adquisicion, ubicacion_fisica
FROM inventario_item
ORDER BY costo_adquisicion DESC
LIMIT 1;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA RENTA
-- =====================================================

-- 22. ¿Cuáles son todas las rentas programadas?
SELECT id, fecha_inicio, fecha_fin_prevista, estado_renta
FROM renta
WHERE estado_renta = 'Programada';

-- 23. ¿Cuáles son las rentas en curso?
SELECT id, fecha_inicio, fecha_fin_prevista
FROM renta
WHERE estado_renta = 'EnCurso';

-- 24. ¿Cuáles son las rentas finalizadas?
SELECT id, fecha_inicio, fecha_devolucion_real, monto_total_renta
FROM renta
WHERE estado_renta = 'Finalizada';

-- 25. ¿Cuántas rentas hay por estado?
SELECT estado_renta, COUNT(*) as cantidad
FROM renta
GROUP BY estado_renta;

-- 26. ¿Cuáles son las rentas con depósito de garantía?
SELECT id, monto_total_renta, deposito_garantia
FROM renta
WHERE deposito_garantia > 0;

-- 27. ¿Cuál es la renta con mayor monto?
SELECT id, monto_total_renta, deposito_garantia
FROM renta
ORDER BY monto_total_renta DESC
LIMIT 1;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA USUARIO
-- =====================================================

-- 28. ¿Cuáles son todos los usuarios activos?
SELECT nombre_usuario, CONCAT(nombre, ' ', nombre2, ' ', apellido1, ' ', apellido2) as nombre_completo, email, departamento
FROM usuario
WHERE estado = 'Activo';

-- 29. ¿Cuáles son los usuarios por departamento?
SELECT departamento, COUNT(*) as cantidad_usuarios
FROM usuario
GROUP BY departamento;

-- 30. ¿Cuáles son los usuarios sin teléfono registrado?
SELECT nombre_usuario, CONCAT(nombre, ' ', apellido1) as nombre_completo, email
FROM usuario
WHERE telefono IS NULL;

-- 31. ¿Cuáles son los usuarios ordenados por fecha de creación?
SELECT nombre_usuario, CONCAT(nombre, ' ', apellido1) as nombre_completo, created_at
FROM usuario
ORDER BY created_at DESC;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA CATEGORIA
-- =====================================================

-- 32. ¿Cuáles son todas las categorías?
SELECT nombre, descripcion, tipo_categoria
FROM categoria;

-- 33. ¿Cuántas categorías hay por tipo?
SELECT tipo_categoria, COUNT(*) as cantidad
FROM categoria
GROUP BY tipo_categoria;

-- 34. ¿Cuáles son las categorías ordenadas alfabéticamente?
SELECT nombre, descripcion
FROM categoria
ORDER BY nombre ASC;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA SUBCATEGORIA
-- =====================================================

-- 35. ¿Cuáles son todas las subcategorías?
SELECT nombre, descripcion
FROM subcategoria;

-- 36. ¿Cuántas subcategorías hay?
SELECT COUNT(*) as total_subcategorias
FROM subcategoria;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA PROVEEDOR
-- =====================================================

-- 37. ¿Cuáles son todos los proveedores activos?
SELECT nombre_empresa, nombre_contacto, telefono_contacto
FROM proveedor
WHERE estado_proveedor = 'Activo';

-- 38. ¿Cuáles son los proveedores ordenados por nombre?
SELECT nombre_empresa, rfc, correo_contacto
FROM proveedor
ORDER BY nombre_empresa ASC;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA DIRECCION
-- =====================================================

-- 39. ¿Cuáles son todas las direcciones en México?
SELECT calle, ciudad, estado_provincia, codigo_postal
FROM direccion
WHERE pais = 'México';

-- 40. ¿Cuántas direcciones hay por país?
SELECT pais, COUNT(*) as cantidad_direcciones
FROM direccion
GROUP BY pais;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA SOLICITUD
-- =====================================================

-- 41. ¿Cuáles son todas las solicitudes nuevas?
SELECT id, fecha_solicitud, cantidad_solicitada, estado_solicitud
FROM solicitud
WHERE estado_solicitud = 'Nueva';

-- 42. ¿Cuántas solicitudes hay por estado?
SELECT estado_solicitud, COUNT(*) as cantidad
FROM solicitud
GROUP BY estado_solicitud;

-- 43. ¿Cuáles son las solicitudes del último mes?
SELECT id, fecha_solicitud, descripcion_necesidad
FROM solicitud
WHERE fecha_solicitud >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- =====================================================
-- CONSULTAS SOBRE LA TABLA COTIZACION
-- =====================================================

-- 44. ¿Cuáles son todas las cotizaciones en borrador?
SELECT id, fecha_cotizacion, monto_total, estado_cotizacion
FROM cotizacion
WHERE estado_cotizacion = 'Borrador';

-- 45. ¿Cuáles son las cotizaciones aceptadas?
SELECT id, fecha_cotizacion, monto_total
FROM cotizacion
WHERE estado_cotizacion = 'Aceptada';

-- 46. ¿Cuántas cotizaciones hay por estado?
SELECT estado_cotizacion, COUNT(*) as cantidad
FROM cotizacion
GROUP BY estado_cotizacion;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA MANTENIMIENTO
-- =====================================================

-- 47. ¿Cuáles son todos los mantenimientos programados?
SELECT id, fecha_inicio, tipo_mantenimiento, estado_mantenimiento
FROM mantenimiento
WHERE estado_mantenimiento = 'Programado';

-- 48. ¿Cuántos mantenimientos hay por tipo?
SELECT tipo_mantenimiento, COUNT(*) as cantidad
FROM mantenimiento
GROUP BY tipo_mantenimiento;

-- 49. ¿Cuáles son los mantenimientos finalizados?
SELECT id, fecha_inicio, fecha_fin_real, costo_real
FROM mantenimiento
WHERE estado_mantenimiento = 'Finalizado';

-- =====================================================
-- CONSULTAS SOBRE LA TABLA ENTREGA
-- =====================================================

-- 50. ¿Cuáles son todas las entregas programadas?
SELECT id, fecha_envio, compania_envio, estado_entrega
FROM entrega
WHERE estado_entrega = 'Programada';

-- 51. ¿Cuántas entregas hay por compañía?
SELECT compania_envio, COUNT(*) as cantidad_entregas
FROM entrega
GROUP BY compania_envio;

-- =====================================================
-- CONSULTAS SOBRE LA TABLA DEVOLUCION
-- =====================================================

-- 52. ¿Cuáles son todas las devoluciones completas?
SELECT id, fecha_devolucion_real, persona_recibe
FROM devolucion
WHERE estado_devolucion = 'Completa';

-- 53. ¿Cuántas devoluciones hay por estado?
SELECT estado_devolucion, COUNT(*) as cantidad
FROM devolucion
GROUP BY estado_devolucion;

-- =====================================================
-- CONSULTAS AVANZADAS DE UNA TABLA
-- =====================================================

-- 54. ¿Cuáles son los productos con precio entre $50 y $200?
SELECT nombre, marca, precio_referencia_renta
FROM producto
WHERE precio_referencia_renta BETWEEN 50 AND 200;

-- 55. ¿Cuáles son los clientes con nombres que empiezan con 'M'?
SELECT nombre, apellido1, correo_electronico
FROM cliente
WHERE nombre LIKE 'M%';

-- 56. ¿Cuáles son los items con número de serie que contiene 'DELL'?
SELECT numero_serie, estado_item
FROM inventario_item
WHERE numero_serie LIKE '%DELL%';

-- 57. ¿Cuáles son las rentas del mes actual?
SELECT id, fecha_inicio, monto_total_renta
FROM renta
WHERE MONTH(fecha_inicio) = MONTH(CURRENT_DATE)
  AND YEAR(fecha_inicio) = YEAR(CURRENT_DATE);

-- 58. ¿Cuáles son los usuarios con correos de gmail?
SELECT nombre_usuario, CONCAT(nombre, ' ', apellido1) as nombre_completo, email
FROM usuario
WHERE email LIKE '%@gmail.com';

-- 59. ¿Cuál es el promedio de precios de renta de productos?
SELECT AVG(precio_referencia_renta) as precio_promedio
FROM producto;

-- 60. ¿Cuál es el total de montos de rentas finalizadas?
SELECT SUM(monto_total_renta) as total_montos_finalizados
FROM renta
WHERE estado_renta = 'Finalizada';

-- =====================================================
-- CONSULTAS CON FUNCIONES DE FECHA
-- =====================================================

-- 61. ¿Cuáles son las rentas de la semana pasada?
SELECT id, fecha_inicio, fecha_fin_prevista
FROM renta
WHERE fecha_inicio BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 WEEK) AND CURRENT_DATE;

-- 62. ¿Cuáles son los productos creados en el último trimestre?
SELECT nombre, created_at
FROM producto
WHERE created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH);

-- 63. ¿Cuántas solicitudes hay por mes del año actual?
SELECT MONTH(fecha_solicitud) as mes, COUNT(*) as cantidad_solicitudes
FROM solicitud
WHERE YEAR(fecha_solicitud) = YEAR(CURRENT_DATE)
GROUP BY MONTH(fecha_solicitud)
ORDER BY mes;

-- =====================================================
-- CONSULTAS CON LIMIT Y OFFSET
-- =====================================================

-- 64. ¿Cuáles son los primeros 5 productos más caros?
SELECT nombre, marca, precio_referencia_renta
FROM producto
ORDER BY precio_referencia_renta DESC
LIMIT 5;

-- 65. ¿Cuáles son los siguientes 5 productos más caros?
SELECT nombre, marca, precio_referencia_renta
FROM producto
ORDER BY precio_referencia_renta DESC
LIMIT 5 OFFSET 5;

-- =====================================================
-- CONSULTAS CON DISTINCT
-- =====================================================

-- 66. ¿Cuáles son las marcas distintas de productos?
SELECT DISTINCT marca
FROM producto
WHERE marca IS NOT NULL;

-- 67. ¿Cuáles son los tipos de cliente distintos?
SELECT DISTINCT tipo_cliente
FROM cliente;

-- 68. ¿Cuáles son los departamentos distintos de usuarios?
SELECT DISTINCT departamento
FROM usuario
WHERE departamento IS NOT NULL;

-- =====================================================
-- CONSULTAS CON CASE (CONDICIONALES)
-- =====================================================

-- 69. ¿Cuáles son los productos clasificados por rango de precio?
SELECT nombre,
       precio_referencia_renta,
       CASE
           WHEN precio_referencia_renta < 50 THEN 'Económico'
           WHEN precio_referencia_renta BETWEEN 50 AND 150 THEN 'Medio'
           ELSE 'Premium'
       END as rango_precio
FROM producto;

-- 70. ¿Cuáles son los estados de items con descripción?
SELECT numero_serie,
       estado_item,
       CASE estado_item
           WHEN 'Disponible' THEN 'Listo para renta'
           WHEN 'Rentado' THEN 'En uso por cliente'
           WHEN 'EnMantenimiento' THEN 'En reparación'
           ELSE 'Otro estado'
       END as descripcion_estado
FROM inventario_item;