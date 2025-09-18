-- =====================================================
-- CONSULTAS DE UNA SOLA TABLA - SISTEMA DE RENTA
-- =====================================================
-- Descripción: Consultas enfocadas en el negocio de renta de equipos
-- Autor: Sistema AXXION
-- Fecha: 2025-09-18
-- =====================================================

USE sistemarenta;

-- =====================================================
-- CONSULTAS SOBRE CLIENTES
-- =====================================================

-- 1. ¿Cuáles son los nombres de todos los clientes y los números de teléfono de la ciudad de Bogotá?
SELECT 
    CONCAT(nombre, ' ', apellido1, ' ', apellido2) AS nombre_completo,
    telefono_principal
FROM cliente c
INNER JOIN cliente_direccion cd ON c.id = cd.cliente_id
INNER JOIN direccion d ON cd.direccion_id = d.id
WHERE d.ciudad = 'Bogotá';

-- 2. ¿Cuántos clientes activos tiene el sistema?
SELECT COUNT(*) as total_clientes_activos
FROM cliente 
WHERE estado_cliente = 'Activo';

-- 3. ¿Cuáles son los clientes empresariales registrados en el sistema?
SELECT 
    nombre,
    nombre2,
    rfc,
    correo_electronico,
    telefono_principal,
    estado_cliente
FROM cliente 
WHERE tipo_cliente = 'Empresa'
ORDER BY nombre;

-- 4. ¿Qué clientes tienen correos electrónicos con dominio gmail?
SELECT 
    CONCAT(nombre, ' ', apellido1) AS nombre_completo,
    correo_electronico,
    telefono_principal
FROM cliente 
WHERE correo_electronico LIKE '%@gmail.com'
ORDER BY nombre;

-- 5. ¿Cuáles son los clientes prospectos que aún no han realizado rentas?
SELECT 
    CONCAT(nombre, ' ', apellido1, ' ', apellido2) AS nombre_completo,
    correo_electronico,
    telefono_principal,
    created_at as fecha_registro
FROM cliente 
WHERE estado_cliente = 'Prospecto'
ORDER BY created_at DESC;

-- =====================================================
-- CONSULTAS SOBRE PRODUCTOS E INVENTARIO
-- =====================================================

-- 6. ¿Cuántos equipos están disponibles para renta actualmente?
SELECT COUNT(*) as equipos_disponibles
FROM inventario_item 
WHERE estado_item = 'Disponible';

-- 7. ¿Cuáles son los productos más caros del catálogo?
SELECT 
    nombre,
    marca,
    modelo,
    precio_referencia_renta,
    sku
FROM producto 
WHERE precio_referencia_renta IS NOT NULL
ORDER BY precio_referencia_renta DESC
LIMIT 5;

-- 8. ¿Qué equipos están actualmente rentados?
SELECT 
    numero_serie,
    ubicacion_fisica,
    fecha_adquisicion,
    costo_adquisicion
FROM inventario_item 
WHERE estado_item = 'Rentado'
ORDER BY fecha_adquisicion;

-- 9. ¿Cuántos productos tiene cada marca en el inventario?
SELECT 
    marca,
    COUNT(*) as total_productos
FROM producto 
WHERE marca IS NOT NULL
GROUP BY marca
ORDER BY total_productos DESC;

-- 10. ¿Cuáles son los equipos que requieren mantenimiento?
SELECT 
    numero_serie,
    ubicacion_fisica,
    estado_item,
    notas
FROM inventario_item 
WHERE estado_item = 'EnMantenimiento'
ORDER BY updated_at DESC;

-- =====================================================
-- CONSULTAS SOBRE RENTAS
-- =====================================================

-- 11. ¿Cuántas rentas se realizaron en la última semana?
SELECT COUNT(*) as rentas_ultima_semana
FROM renta 
WHERE fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 12. ¿Cuáles son las rentas que están actualmente en curso?
SELECT 
    id,
    fecha_inicio,
    fecha_fin_prevista,
    monto_total_renta,
    deposito_garantia,
    metodo_pago
FROM renta 
WHERE estado_renta = 'EnCurso'
ORDER BY fecha_inicio;

-- 13. ¿Qué rentas están retrasadas en su devolución?
SELECT 
    id,
    fecha_inicio,
    fecha_fin_prevista,
    monto_total_renta,
    DATEDIFF(CURDATE(), fecha_fin_prevista) as dias_retraso
FROM renta 
WHERE estado_renta = 'Retrasada'
ORDER BY dias_retraso DESC;

-- 14. ¿Cuál es el promedio de duración de las rentas finalizadas?
SELECT 
    AVG(DATEDIFF(fecha_devolucion_real, fecha_inicio)) as promedio_dias_renta
FROM renta 
WHERE estado_renta = 'Finalizada' 
AND fecha_devolucion_real IS NOT NULL;

-- 15. ¿Cuáles son las rentas programadas para los próximos 7 días?
SELECT 
    id,
    fecha_inicio,
    fecha_fin_prevista,
    monto_total_renta,
    estado_renta
FROM renta 
WHERE fecha_inicio BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
AND estado_renta = 'Programada'
ORDER BY fecha_inicio;

-- =====================================================
-- CONSULTAS SOBRE COTIZACIONES
-- =====================================================

-- 16. ¿Cuántas cotizaciones se han enviado este mes?
SELECT COUNT(*) as cotizaciones_mes_actual
FROM cotizacion 
WHERE MONTH(fecha_cotizacion) = MONTH(CURDATE())
AND YEAR(fecha_cotizacion) = YEAR(CURDATE())
AND estado_cotizacion = 'Enviada';

-- 17. ¿Cuáles son las cotizaciones con mayor valor?
SELECT 
    id,
    fecha_cotizacion,
    monto_total,
    estado_cotizacion,
    fecha_validez
FROM cotizacion 
WHERE monto_total IS NOT NULL
ORDER BY monto_total DESC
LIMIT 10;

-- 18. ¿Qué cotizaciones están próximas a vencer?
SELECT 
    id,
    fecha_cotizacion,
    fecha_validez,
    monto_total,
    estado_cotizacion,
    DATEDIFF(fecha_validez, CURDATE()) as dias_para_vencer
FROM cotizacion 
WHERE fecha_validez BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
AND estado_cotizacion IN ('Borrador', 'Enviada')
ORDER BY fecha_validez;

-- =====================================================
-- CONSULTAS SOBRE MANTENIMIENTOS
-- =====================================================

-- 19. ¿Cuántos mantenimientos se han realizado este año?
SELECT COUNT(*) as mantenimientos_año_actual
FROM mantenimiento 
WHERE YEAR(fecha_inicio) = YEAR(CURDATE());

-- 20. ¿Cuáles son los mantenimientos más costosos?
SELECT 
    descripcion_problema,
    costo_estimado,
    costo_real,
    tipo_mantenimiento,
    estado_mantenimiento,
    responsable
FROM mantenimiento 
WHERE costo_real IS NOT NULL
ORDER BY costo_real DESC
LIMIT 5;

-- 21. ¿Qué mantenimientos están actualmente en proceso?
SELECT 
    descripcion_problema,
    fecha_inicio,
    fecha_fin_prevista,
    tipo_mantenimiento,
    costo_estimado,
    responsable
FROM mantenimiento 
WHERE estado_mantenimiento = 'EnProceso'
ORDER BY fecha_inicio;

-- =====================================================
-- CONSULTAS ESTADÍSTICAS GENERALES
-- =====================================================

-- 22. ¿Cuál es la distribución de clientes por tipo?
SELECT 
    tipo_cliente,
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cliente), 2) as porcentaje
FROM cliente 
GROUP BY tipo_cliente
ORDER BY cantidad DESC;

-- 23. ¿Cuál es la distribución de equipos por estado?
SELECT 
    estado_item,
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM inventario_item), 2) as porcentaje
FROM inventario_item 
GROUP BY estado_item
ORDER BY cantidad DESC;

-- 24. ¿Cuáles son los métodos de pago más utilizados?
SELECT 
    metodo_pago,
    COUNT(*) as veces_utilizado,
    ROUND(AVG(monto_total_renta), 2) as monto_promedio
FROM renta 
WHERE metodo_pago IS NOT NULL
GROUP BY metodo_pago
ORDER BY veces_utilizado DESC;

-- 25. ¿Cuál es el valor total del inventario por estado?
SELECT 
    estado_item,
    COUNT(*) as cantidad_items,
    SUM(costo_adquisicion) as valor_total,
    AVG(costo_adquisicion) as valor_promedio
FROM inventario_item 
WHERE costo_adquisicion IS NOT NULL
GROUP BY estado_item
ORDER BY valor_total DESC;

-- =====================================================
-- FIN DE CONSULTAS DE UNA SOLA TABLA
-- =====================================================