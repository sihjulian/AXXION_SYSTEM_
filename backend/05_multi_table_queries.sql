-- =====================================================
-- CONSULTAS MULTITABLA - SISTEMA DE RENTA
-- =====================================================
-- Descripción: Consultas complejas con JOINs y subconsultas
-- Autor: Sistema AXXION
-- Fecha: 2025-09-18
-- =====================================================

USE sistemarenta;

-- =====================================================
-- CONSULTAS CON JOINS COMPLEJOS
-- =====================================================

-- 1. ¿Cuáles son los equipos más rentados y sus ingresos totales?
SELECT 
    p.nombre as producto,
    p.marca,
    p.modelo,
    COUNT(rii.inventario_item_id) as veces_rentado,
    SUM(rii.precio_renta_item) as ingresos_totales,
    AVG(rii.precio_renta_item) as precio_promedio
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
INNER JOIN renta r ON rii.renta_id = r.id
WHERE r.estado_renta IN ('Finalizada', 'EnCurso')
GROUP BY p.id, p.nombre, p.marca, p.modelo
ORDER BY veces_rentado DESC, ingresos_totales DESC;

-- 2. ¿Qué clientes han generado más ingresos y cuántas rentas han realizado?
SELECT 
    CONCAT(c.nombre, ' ', c.apellido1, ' ', c.apellido2) as cliente,
    c.tipo_cliente,
    c.correo_electronico,
    COUNT(DISTINCT r.id) as total_rentas,
    SUM(r.monto_total_renta) as ingresos_generados,
    AVG(r.monto_total_renta) as promedio_por_renta,
    MAX(r.fecha_inicio) as ultima_renta
FROM cliente c
INNER JOIN renta r ON c.id = r.cliente_id
WHERE r.estado_renta IN ('Finalizada', 'EnCurso')
GROUP BY c.id
ORDER BY ingresos_generados DESC;

-- 3. ¿Cuáles son los productos por categoría con mayor demanda?
SELECT 
    cat.nombre as categoria,
    sub.nombre as subcategoria,
    p.nombre as producto,
    p.marca,
    COUNT(rii.inventario_item_id) as veces_rentado,
    SUM(rii.precio_renta_item) as ingresos
FROM categoria cat
INNER JOIN categoria_subcategoria cs ON cat.id = cs.categoria_id
INNER JOIN subcategoria sub ON cs.subcategoria_id = sub.id
INNER JOIN producto_subcategoria ps ON sub.id = ps.subcategoria_id
INNER JOIN producto p ON ps.producto_id = p.id
INNER JOIN inventario_item ii ON p.id = ii.producto_id
INNER JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
INNER JOIN renta r ON rii.renta_id = r.id
WHERE r.estado_renta IN ('Finalizada', 'EnCurso')
GROUP BY cat.id, sub.id, p.id
ORDER BY cat.nombre, veces_rentado DESC;

-- 4. ¿Cuáles son las rentas con sus detalles completos de cliente y equipos?
SELECT 
    r.id as renta_id,
    CONCAT(c.nombre, ' ', c.apellido1) as cliente,
    c.telefono_principal,
    r.fecha_inicio,
    r.fecha_fin_prevista,
    r.estado_renta,
    p.nombre as producto,
    ii.numero_serie,
    rii.precio_renta_item,
    rii.condicion_salida,
    DATEDIFF(r.fecha_fin_prevista, r.fecha_inicio) as dias_renta
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
INNER JOIN renta_inventario_item rii ON r.id = rii.renta_id
INNER JOIN inventario_item ii ON rii.inventario_item_id = ii.id
INNER JOIN producto p ON ii.producto_id = p.id
ORDER BY r.fecha_inicio DESC, r.id;

-- =====================================================
-- SUBCONSULTAS CORRELACIONADAS
-- =====================================================

-- 5. ¿Cuáles son los clientes que han rentado más equipos que el promedio?
SELECT 
    CONCAT(c.nombre, ' ', c.apellido1) as cliente,
    c.correo_electronico,
    (SELECT COUNT(*) 
     FROM renta r2 
     WHERE r2.cliente_id = c.id 
     AND r2.estado_renta IN ('Finalizada', 'EnCurso')) as total_rentas
FROM cliente c
WHERE (SELECT COUNT(*) 
        FROM renta r 
        WHERE r.cliente_id = c.id 
        AND r.estado_renta IN ('Finalizada', 'EnCurso')) > 
      (SELECT AVG(renta_count) 
       FROM (SELECT COUNT(*) as renta_count 
             FROM renta r3 
             WHERE r3.estado_renta IN ('Finalizada', 'EnCurso') 
             GROUP BY r3.cliente_id) as avg_table)
ORDER BY total_rentas DESC;

-- 6. ¿Qué productos nunca han sido rentados?
SELECT 
    p.nombre,
    p.marca,
    p.modelo,
    p.precio_referencia_renta,
    COUNT(ii.id) as items_en_inventario
FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
WHERE p.id NOT IN (
    SELECT DISTINCT ii2.producto_id
    FROM inventario_item ii2
    INNER JOIN renta_inventario_item rii ON ii2.id = rii.inventario_item_id
)
GROUP BY p.id
ORDER BY p.precio_referencia_renta DESC;

-- 7. ¿Cuáles son los equipos que han generado más ingresos que su costo de adquisición?
SELECT 
    p.nombre as producto,
    ii.numero_serie,
    ii.costo_adquisicion,
    (SELECT COALESCE(SUM(rii2.precio_renta_item), 0)
     FROM renta_inventario_item rii2
     INNER JOIN renta r2 ON rii2.renta_id = r2.id
     WHERE rii2.inventario_item_id = ii.id
     AND r2.estado_renta IN ('Finalizada', 'EnCurso')) as ingresos_generados,
    ROUND(((SELECT COALESCE(SUM(rii2.precio_renta_item), 0)
            FROM renta_inventario_item rii2
            INNER JOIN renta r2 ON rii2.renta_id = r2.id
            WHERE rii2.inventario_item_id = ii.id
            AND r2.estado_renta IN ('Finalizada', 'EnCurso')) / ii.costo_adquisicion * 100), 2) as roi_porcentaje
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
WHERE ii.costo_adquisicion > 0
HAVING ingresos_generados > ii.costo_adquisicion
ORDER BY roi_porcentaje DESC;

-- =====================================================
-- CONSULTAS CON FUNCIONES DE VENTANA
-- =====================================================

-- 8. ¿Cuál es el ranking de clientes por ingresos generados?
SELECT 
    CONCAT(c.nombre, ' ', c.apellido1) as cliente,
    SUM(r.monto_total_renta) as ingresos_totales,
    COUNT(r.id) as total_rentas,
    ROW_NUMBER() OVER (ORDER BY SUM(r.monto_total_renta) DESC) as ranking,
    DENSE_RANK() OVER (ORDER BY SUM(r.monto_total_renta) DESC) as ranking_denso
FROM cliente c
INNER JOIN renta r ON c.id = r.cliente_id
WHERE r.estado_renta IN ('Finalizada', 'EnCurso')
GROUP BY c.id
ORDER BY ingresos_totales DESC;

-- 9. ¿Cuáles son las rentas con mayor duración por mes?
SELECT 
    YEAR(r.fecha_inicio) as año,
    MONTH(r.fecha_inicio) as mes,
    CONCAT(c.nombre, ' ', c.apellido1) as cliente,
    p.nombre as producto,
    DATEDIFF(COALESCE(r.fecha_devolucion_real, r.fecha_fin_prevista), r.fecha_inicio) as dias_renta,
    ROW_NUMBER() OVER (
        PARTITION BY YEAR(r.fecha_inicio), MONTH(r.fecha_inicio) 
        ORDER BY DATEDIFF(COALESCE(r.fecha_devolucion_real, r.fecha_fin_prevista), r.fecha_inicio) DESC
    ) as ranking_mes
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
INNER JOIN renta_inventario_item rii ON r.id = rii.renta_id
INNER JOIN inventario_item ii ON rii.inventario_item_id = ii.id
INNER JOIN producto p ON ii.producto_id = p.id
WHERE r.estado_renta IN ('Finalizada', 'EnCurso')
ORDER BY año DESC, mes DESC, dias_renta DESC;

-- =====================================================
-- CONSULTAS DE ANÁLISIS DE NEGOCIO
-- =====================================================

-- 10. ¿Cuál es la tendencia de rentas por mes en el último año?
SELECT 
    YEAR(r.fecha_inicio) as año,
    MONTH(r.fecha_inicio) as mes,
    MONTHNAME(r.fecha_inicio) as nombre_mes,
    COUNT(*) as total_rentas,
    SUM(r.monto_total_renta) as ingresos_mes,
    AVG(r.monto_total_renta) as promedio_renta,
    COUNT(DISTINCT r.cliente_id) as clientes_unicos
FROM renta r
WHERE r.fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
AND r.estado_renta IN ('Finalizada', 'EnCurso', 'Programada')
GROUP BY YEAR(r.fecha_inicio), MONTH(r.fecha_inicio)
ORDER BY año DESC, mes DESC;

-- 11. ¿Cuáles son los equipos con mayor rotación (más veces rentados vs disponibles)?
SELECT 
    p.nombre as producto,
    p.marca,
    COUNT(ii.id) as total_items,
    COUNT(CASE WHEN ii.estado_item = 'Disponible' THEN 1 END) as disponibles,
    COUNT(CASE WHEN ii.estado_item = 'Rentado' THEN 1 END) as actualmente_rentados,
    COALESCE(rental_stats.total_rentas, 0) as veces_rentado,
    ROUND(COALESCE(rental_stats.total_rentas, 0) / COUNT(ii.id), 2) as rotacion_promedio
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN (
    SELECT 
        ii2.producto_id,
        COUNT(*) as total_rentas
    FROM inventario_item ii2
    INNER JOIN renta_inventario_item rii ON ii2.id = rii.inventario_item_id
    INNER JOIN renta r ON rii.renta_id = r.id
    WHERE r.estado_renta IN ('Finalizada', 'EnCurso')
    GROUP BY ii2.producto_id
) rental_stats ON p.id = rental_stats.producto_id
GROUP BY p.id
ORDER BY rotacion_promedio DESC;

-- 12. ¿Cuáles son las cotizaciones que se convirtieron en rentas vs las que no?
SELECT 
    'Convertidas' as tipo_cotizacion,
    COUNT(*) as cantidad,
    AVG(c.monto_total) as monto_promedio,
    SUM(c.monto_total) as monto_total
FROM cotizacion c
INNER JOIN renta r ON c.id = r.cotizacion_id
WHERE c.estado_cotizacion = 'Aceptada'

UNION ALL

SELECT 
    'No Convertidas' as tipo_cotizacion,
    COUNT(*) as cantidad,
    AVG(c.monto_total) as monto_promedio,
    SUM(c.monto_total) as monto_total
FROM cotizacion c
LEFT JOIN renta r ON c.id = r.cotizacion_id
WHERE r.cotizacion_id IS NULL
AND c.estado_cotizacion IN ('Rechazada', 'Vencida');

-- =====================================================
-- CONSULTAS CON SUBCONSULTAS COMPLEJAS
-- =====================================================

-- 13. ¿Cuáles son los clientes con rentas pendientes de devolución?
SELECT 
    c.id,
    CONCAT(c.nombre, ' ', c.apellido1) as cliente,
    c.telefono_principal,
    c.correo_electronico,
    COUNT(r.id) as rentas_pendientes,
    GROUP_CONCAT(
        CONCAT(p.nombre, ' (', ii.numero_serie, ')') 
        SEPARATOR ', '
    ) as equipos_pendientes,
    MIN(r.fecha_fin_prevista) as fecha_devolucion_mas_proxima
FROM cliente c
INNER JOIN renta r ON c.id = r.cliente_id
INNER JOIN renta_inventario_item rii ON r.id = rii.renta_id
INNER JOIN inventario_item ii ON rii.inventario_item_id = ii.id
INNER JOIN producto p ON ii.producto_id = p.id
WHERE r.estado_renta IN ('EnCurso', 'Retrasada')
AND r.fecha_devolucion_real IS NULL
GROUP BY c.id
ORDER BY fecha_devolucion_mas_proxima;

-- 14. ¿Cuál es el análisis de mantenimientos por producto?
SELECT 
    p.nombre as producto,
    p.marca,
    COUNT(ii.id) as total_items,
    COUNT(m.id) as total_mantenimientos,
    ROUND(COUNT(m.id) / COUNT(ii.id), 2) as mantenimientos_por_item,
    AVG(m.costo_real) as costo_promedio_mantenimiento,
    SUM(m.costo_real) as costo_total_mantenimiento
FROM producto p
INNER JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN mantenimiento m ON ii.id = m.inventario_item_id
WHERE m.estado_mantenimiento = 'Finalizado'
GROUP BY p.id
HAVING COUNT(m.id) > 0
ORDER BY mantenimientos_por_item DESC;

-- 15. ¿Cuáles son las direcciones más utilizadas para entregas?
SELECT 
    CONCAT(d.calle, ' ', d.numero_exterior) as direccion,
    d.colonia,
    d.ciudad,
    d.estado_provincia,
    COUNT(DISTINCT e.id) as entregas_realizadas,
    COUNT(DISTINCT r.cliente_id) as clientes_diferentes,
    AVG(r.monto_total_renta) as monto_promedio_renta
FROM direccion d
INNER JOIN entrega e ON d.id = e.direccion_id
INNER JOIN renta r ON e.renta_id = r.id
WHERE e.estado_entrega = 'Entregada'
GROUP BY d.id
ORDER BY entregas_realizadas DESC;

-- =====================================================
-- FIN DE CONSULTAS MULTITABLA
-- =====================================================