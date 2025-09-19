-- =====================================================
-- SISTEMA DE RENTAS - CONSULTAS MULTITABLA Y SUBCONSULTAS
-- =====================================================
-- Este archivo contiene consultas SELECT que operan sobre
-- múltiples tablas usando JOINs y subconsultas
-- =====================================================

USE sistemarenta;

-- =====================================================
-- CONSULTAS CON INNER JOIN
-- =====================================================

-- 1. ¿Cuáles son los nombres de todos los clientes y sus direcciones?
SELECT c.nombre, c.apellido1, c.correo_electronico,
       d.calle, d.ciudad, d.estado_provincia
FROM cliente c
INNER JOIN cliente_direccion cd ON c.id = cd.cliente_id
INNER JOIN direccion d ON cd.direccion_id = d.id;

-- 2. ¿Cuáles son los productos y sus subcategorías?
SELECT p.nombre as producto, p.marca, p.modelo,
       s.nombre as subcategoria, cat.nombre as categoria
FROM producto p
INNER JOIN producto_subcategoria ps ON p.id = ps.producto_id
INNER JOIN subcategoria s ON ps.subcategoria_id = s.id
INNER JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
INNER JOIN categoria cat ON cs.categoria_id = cat.id;

-- 3. ¿Cuáles son las rentas activas con información del cliente?
SELECT r.id, r.fecha_inicio, r.fecha_fin_prevista, r.monto_total_renta,
       c.nombre, c.apellido1, c.telefono_principal
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
WHERE r.estado_renta = 'EnCurso';

-- 4. ¿Cuáles son los items de inventario con información de producto?
SELECT ii.numero_serie, ii.estado_item, ii.ubicacion_fisica,
       p.nombre, p.marca, p.modelo, p.precio_referencia_renta
FROM inventario_item ii
INNER JOIN producto p ON ii.producto_id = p.id;

-- =====================================================
-- CONSULTAS CON LEFT JOIN
-- =====================================================

-- 5. ¿Cuáles son todos los clientes y sus rentas (incluyendo clientes sin rentas)?
SELECT c.nombre, c.apellido1, c.estado_cliente,
       r.id as renta_id, r.fecha_inicio, r.estado_renta
FROM cliente c
LEFT JOIN renta r ON c.id = r.cliente_id;

-- 6. ¿Cuáles son todos los productos y sus items en inventario?
SELECT p.nombre, p.marca, p.sku,
       ii.numero_serie, ii.estado_item, ii.fecha_adquisicion
FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id;

-- 7. ¿Cuáles son todas las solicitudes y sus cotizaciones?
SELECT s.id, s.fecha_solicitud, s.estado_solicitud,
       c.id as cotizacion_id, c.fecha_cotizacion, c.estado_cotizacion, c.monto_total
FROM solicitud s
LEFT JOIN cotizacion c ON s.id = c.solicitud_id;

-- =====================================================
-- CONSULTAS CON RIGHT JOIN
-- =====================================================

-- 8. ¿Cuáles son todas las direcciones y los clientes asociados?
SELECT d.calle, d.ciudad, d.pais,
       c.nombre, c.apellido1, c.tipo_cliente
FROM direccion d
RIGHT JOIN cliente_direccion cd ON d.id = cd.direccion_id
RIGHT JOIN cliente c ON cd.cliente_id = c.id;

-- =====================================================
-- SUBCONSULTAS EN WHERE
-- =====================================================

-- 9. ¿Cuáles son los clientes que han hecho al menos una renta?
SELECT nombre, apellido1, correo_electronico
FROM cliente
WHERE id IN (SELECT DISTINCT cliente_id FROM renta);

-- 10. ¿Cuáles son los productos que están en inventario?
SELECT nombre, marca, precio_referencia_renta
FROM producto
WHERE id IN (SELECT DISTINCT producto_id FROM inventario_item);

-- 11. ¿Cuáles son los productos que nunca se han rentado?
SELECT nombre, marca, modelo
FROM producto
WHERE id NOT IN (
    SELECT DISTINCT p.id
    FROM producto p
    INNER JOIN inventario_item ii ON p.id = ii.producto_id
    INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
);

-- 12. ¿Cuáles son los clientes con rentas en el último mes?
SELECT nombre, apellido1, telefono_principal
FROM cliente
WHERE id IN (
    SELECT DISTINCT cliente_id
    FROM renta
    WHERE fecha_inicio >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
);

-- =====================================================
-- SUBCONSULTAS EN SELECT
-- =====================================================

-- 13. ¿Cuántas rentas ha hecho cada cliente?
SELECT c.nombre, c.apellido1,
       (SELECT COUNT(*) FROM renta r WHERE r.cliente_id = c.id) as total_rentas
FROM cliente c;

-- 14. ¿Cuál es el precio promedio de renta de los productos de cada cliente?
SELECT c.nombre, c.apellido1,
       (SELECT AVG(p.precio_referencia_renta)
        FROM producto p
        INNER JOIN inventario_item ii ON p.id = ii.producto_id
        INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
        INNER JOIN renta r ON rii.renta_id = r.id
        WHERE r.cliente_id = c.id) as precio_promedio_rentas
FROM cliente c;

-- =====================================================
-- CONSULTAS CON GROUP BY Y HAVING
-- =====================================================

-- 15. ¿Cuántos productos hay por categoría?
SELECT cat.nombre as categoria, COUNT(p.id) as cantidad_productos
FROM categoria cat
INNER JOIN categoria_subcategoria cs ON cat.id = cs.categoria_id
INNER JOIN subcategoria s ON cs.subcategoria_id = s.id
INNER JOIN producto_subcategoria ps ON s.id = ps.subcategoria_id
INNER JOIN producto p ON ps.producto_id = p.id
GROUP BY cat.id, cat.nombre;

-- 16. ¿Cuáles son las categorías con más de 2 productos?
SELECT cat.nombre as categoria, COUNT(p.id) as cantidad_productos
FROM categoria cat
INNER JOIN categoria_subcategoria cs ON cat.id = cs.categoria_id
INNER JOIN subcategoria s ON cs.subcategoria_id = s.id
INNER JOIN producto_subcategoria ps ON s.id = ps.subcategoria_id
INNER JOIN producto p ON ps.producto_id = p.id
GROUP BY cat.id, cat.nombre
HAVING COUNT(p.id) > 2;

-- 17. ¿Cuántas rentas hay por cliente?
SELECT c.nombre, c.apellido1, COUNT(r.id) as cantidad_rentas
FROM cliente c
LEFT JOIN renta r ON c.id = r.cliente_id
GROUP BY c.id, c.nombre, c.apellido1;

-- 18. ¿Cuáles son los clientes con más de una renta?
SELECT c.nombre, c.apellido1, COUNT(r.id) as cantidad_rentas
FROM cliente c
INNER JOIN renta r ON c.id = r.cliente_id
GROUP BY c.id, c.nombre, c.apellido1
HAVING COUNT(r.id) > 1;

-- =====================================================
-- CONSULTAS CON MÚLTIPLES JOINS
-- =====================================================

-- 19. ¿Cuáles son las rentas con detalle completo (cliente, productos, direcciones)?
SELECT r.id, r.fecha_inicio, r.fecha_fin_prevista, r.monto_total_renta,
       c.nombre, c.apellido1, c.correo_electronico,
       p.nombre as producto, p.marca, p.modelo,
       d.calle, d.ciudad, d.estado_provincia,
       ii.numero_serie
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
INNER JOIN renta_inventario_item rii ON r.id = rii.renta_id
INNER JOIN inventario_item ii ON rii.inventario_item_id = ii.id
INNER JOIN producto p ON ii.producto_id = p.id
INNER JOIN entrega e ON r.id = e.renta_id
INNER JOIN direccion d ON e.direccion_id = d.id;

-- 20. ¿Cuáles son las cotizaciones con detalle de productos?
SELECT cot.id, cot.fecha_cotizacion, cot.monto_total, cot.estado_cotizacion,
       c.nombre as cliente, c.apellido1,
       p.nombre as producto, p.marca,
       dc.cantidad, dc.precio_unitario, dc.subtotal
FROM cotizacion cot
INNER JOIN cliente c ON cot.cliente_id = c.id
INNER JOIN detalle_cotizacion dc ON cot.id = dc.cotizacion_id
INNER JOIN producto p ON dc.producto_id = p.id;

-- =====================================================
-- CONSULTAS CON UNION
-- =====================================================

-- 21. ¿Cuáles son todos los contactos (clientes y proveedores)?
SELECT nombre, apellido1, telefono_principal as telefono, correo_electronico, 'Cliente' as tipo
FROM cliente
WHERE telefono_principal IS NOT NULL
UNION
SELECT nombre_empresa, NULL, telefono_contacto, correo_contacto, 'Proveedor'
FROM proveedor
WHERE telefono_contacto IS NOT NULL;

-- =====================================================
-- SUBCONSULTAS CORRELACIONADAS
-- =====================================================

-- 22. ¿Cuáles son los productos más caros que el promedio de su subcategoría?
SELECT p.nombre, p.marca, p.precio_referencia_renta, s.nombre as subcategoria
FROM producto p
INNER JOIN producto_subcategoria ps ON p.id = ps.producto_id
INNER JOIN subcategoria s ON ps.subcategoria_id = s.id
WHERE p.precio_referencia_renta > (
    SELECT AVG(p2.precio_referencia_renta)
    FROM producto p2
    INNER JOIN producto_subcategoria ps2 ON p2.id = ps2.producto_id
    WHERE ps2.subcategoria_id = ps.subcategoria_id
);

-- 23. ¿Cuáles son los clientes que han rentado más que el promedio?
SELECT c.nombre, c.apellido1,
       COUNT(r.id) as total_rentas
FROM cliente c
INNER JOIN renta r ON c.id = r.cliente_id
GROUP BY c.id, c.nombre, c.apellido1
HAVING COUNT(r.id) > (
    SELECT AVG(rentas_por_cliente.cantidad)
    FROM (
        SELECT COUNT(r2.id) as cantidad
        FROM cliente c2
        LEFT JOIN renta r2 ON c2.id = r2.cliente_id
        GROUP BY c2.id
    ) as rentas_por_cliente
);

-- =====================================================
-- CONSULTAS CON EXISTS
-- =====================================================

-- 24. ¿Cuáles son los clientes que tienen solicitudes pendientes?
SELECT nombre, apellido1, correo_electronico
FROM cliente c
WHERE EXISTS (
    SELECT 1 FROM solicitud s
    WHERE s.cliente_id = c.id
    AND s.estado_solicitud IN ('Nueva', 'EnProceso')
);

-- 25. ¿Cuáles son los productos que están en mantenimiento?
SELECT nombre, marca, modelo
FROM producto p
WHERE EXISTS (
    SELECT 1 FROM inventario_item ii
    WHERE ii.producto_id = p.id
    AND ii.estado_item = 'EnMantenimiento'
);

-- =====================================================
-- CONSULTAS AVANZADAS CON SUBCONSULTAS
-- =====================================================

-- 26. ¿Cuáles son los equipos rentados en la última semana?
SELECT DISTINCT p.nombre, p.marca, p.modelo,
                ii.numero_serie, r.fecha_inicio
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
INNER JOIN renta r ON rii.renta_id = r.id
WHERE r.fecha_inicio >= DATE_SUB(CURRENT_DATE, INTERVAL 1 WEEK)
ORDER BY r.fecha_inicio DESC;

-- 27. ¿Cuál es el cliente que más ha gastado en rentas?
SELECT c.nombre, c.apellido1, c.correo_electronico,
       SUM(r.monto_total_renta) as total_gastado
FROM cliente c
INNER JOIN renta r ON c.id = r.cliente_id
WHERE r.estado_renta = 'Finalizada'
GROUP BY c.id, c.nombre, c.apellido1, c.correo_electronico
ORDER BY total_gastado DESC
LIMIT 1;

-- 28. ¿Cuáles son los productos más rentados?
SELECT p.nombre, p.marca, p.modelo,
       COUNT(rii.inventario_item_id) as veces_rentado
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
INNER JOIN renta r ON rii.renta_id = r.id
GROUP BY p.id, p.nombre, p.marca, p.modelo
ORDER BY veces_rentado DESC;

-- 29. ¿Cuál es el ingreso mensual por rentas?
SELECT YEAR(fecha_inicio) as año,
       MONTH(fecha_inicio) as mes,
       SUM(monto_total_renta) as ingreso_mensual,
       COUNT(*) as cantidad_rentas
FROM renta
WHERE estado_renta = 'Finalizada'
GROUP BY YEAR(fecha_inicio), MONTH(fecha_inicio)
ORDER BY año DESC, mes DESC;

-- 30. ¿Cuáles son los proveedores con productos en inventario?
SELECT DISTINCT prov.nombre_empresa, prov.nombre_contacto,
                COUNT(ii.id) as productos_en_inventario
FROM proveedor prov
INNER JOIN inventario_item ii ON prov.id = ii.proveedor_id
GROUP BY prov.id, prov.nombre_empresa, prov.nombre_contacto
ORDER BY productos_en_inventario DESC;

-- =====================================================
-- CONSULTAS CON CASE Y JOINS
-- =====================================================

-- 31. ¿Cuáles son las rentas clasificadas por duración?
SELECT r.id, r.fecha_inicio, r.fecha_fin_prevista,
       DATEDIFF(r.fecha_fin_prevista, r.fecha_inicio) as dias_renta,
       CASE
           WHEN DATEDIFF(r.fecha_fin_prevista, r.fecha_inicio) <= 7 THEN 'Corta'
           WHEN DATEDIFF(r.fecha_fin_prevista, r.fecha_inicio) <= 30 THEN 'Mediana'
           ELSE 'Larga'
       END as clasificacion_duracion,
       c.nombre, c.apellido1
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id;

-- 32. ¿Cuáles son los productos con estado de disponibilidad?
SELECT p.nombre, p.marca,
       COUNT(CASE WHEN ii.estado_item = 'Disponible' THEN 1 END) as disponibles,
       COUNT(CASE WHEN ii.estado_item = 'Rentado' THEN 1 END) as rentados,
       COUNT(CASE WHEN ii.estado_item = 'EnMantenimiento' THEN 1 END) as en_mantenimiento,
       COUNT(ii.id) as total_items
FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
GROUP BY p.id, p.nombre, p.marca;

-- =====================================================
-- CONSULTAS CON SUBCONSULTAS ANIDADAS
-- =====================================================

-- 33. ¿Cuáles son los clientes que han rentado productos de precio superior al promedio?
SELECT DISTINCT c.nombre, c.apellido1, c.correo_electronico
FROM cliente c
INNER JOIN renta r ON c.id = r.cliente_id
INNER JOIN renta_inventario_item rii ON r.id = rii.renta_id
INNER JOIN inventario_item ii ON rii.inventario_item_id = ii.id
INNER JOIN producto p ON ii.producto_id = p.id
WHERE p.precio_referencia_renta > (
    SELECT AVG(precio_referencia_renta)
    FROM producto
    WHERE precio_referencia_renta > 0
);

-- 34. ¿Cuáles son las subcategorías que tienen productos rentados?
SELECT DISTINCT s.nombre as subcategoria, cat.nombre as categoria
FROM subcategoria s
INNER JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
INNER JOIN categoria cat ON cs.categoria_id = cat.id
WHERE EXISTS (
    SELECT 1
    FROM producto_subcategoria ps
    INNER JOIN producto p ON ps.producto_id = p.id
    INNER JOIN inventario_item ii ON p.id = ii.producto_id
    INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
    WHERE ps.subcategoria_id = s.id
);

-- =====================================================
-- CONSULTAS DE REPORTE AVANZADAS
-- =====================================================

-- 35. ¿Cuál es el resumen de rentas por cliente y mes?
SELECT c.nombre, c.apellido1,
       YEAR(r.fecha_inicio) as año,
       MONTH(r.fecha_inicio) as mes,
       COUNT(r.id) as cantidad_rentas,
       SUM(r.monto_total_renta) as monto_total,
       AVG(r.monto_total_renta) as monto_promedio
FROM cliente c
LEFT JOIN renta r ON c.id = r.cliente_id
GROUP BY c.id, c.nombre, c.apellido1, YEAR(r.fecha_inicio), MONTH(r.fecha_inicio)
ORDER BY c.nombre, año DESC, mes DESC;

-- 36. ¿Cuáles son los productos con su historial de mantenimiento?
SELECT p.nombre, p.marca, p.modelo,
       ii.numero_serie,
       m.fecha_inicio, m.tipo_mantenimiento, m.estado_mantenimiento,
       m.descripcion_problema, m.costo_real
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN mantenimiento m ON ii.id = m.inventario_item_id
ORDER BY p.nombre, ii.numero_serie, m.fecha_inicio DESC;

-- 37. ¿Cuál es el estado actual del inventario por categoría?
SELECT cat.nombre as categoria,
       COUNT(DISTINCT p.id) as productos_distintos,
       COUNT(ii.id) as total_items,
       SUM(CASE WHEN ii.estado_item = 'Disponible' THEN 1 ELSE 0 END) as disponibles,
       SUM(CASE WHEN ii.estado_item = 'Rentado' THEN 1 ELSE 0 END) as rentados,
       SUM(CASE WHEN ii.estado_item = 'EnMantenimiento' THEN 1 ELSE 0 END) as en_mantenimiento,
       ROUND(AVG(p.precio_referencia_renta), 2) as precio_promedio
FROM categoria cat
INNER JOIN categoria_subcategoria cs ON cat.id = cs.categoria_id
INNER JOIN subcategoria s ON cs.subcategoria_id = s.id
INNER JOIN producto_subcategoria ps ON s.id = ps.subcategoria_id
INNER JOIN producto p ON ps.producto_id = p.id
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
GROUP BY cat.id, cat.nombre
ORDER BY total_items DESC;