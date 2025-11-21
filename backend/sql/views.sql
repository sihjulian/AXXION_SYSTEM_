-- =====================================================
-- SISTEMA DE RENTAS - VISTAS DE BASE DE DATOS
-- =====================================================
-- Este archivo contiene vistas útiles para el sistema
-- de rentas de equipos tecnológicos
-- =====================================================

USE sistemarenta;

-- =====================================================
-- VISTAS BÁSICAS DE INFORMACIÓN
-- =====================================================

-- 1. Vista de clientes con información completa
vista_clientes_completaCREATE OR REPLACE VIEW vista_clientes_completa AS
SELECT c.id, c.nombre, c.nombre2, c.apellido1, c.apellido2,
       c.rfc, c.telefono_principal, c.correo_electronico,
       c.tipo_cliente, c.estado_cliente,
       d.calle, d.numero_exterior, d.numero_interior,
       d.colonia, d.ciudad, d.estado_provincia,
       d.codigo_postal, d.pais, d.referencias,
       c.created_at, c.updated_at
FROM cliente c
LEFT JOIN cliente_direccion cd ON c.id = cd.cliente_id AND cd.es_principal = 1
LEFT JOIN direccion d ON cd.direccion_id = d.id;

-- 2. Vista de productos con subcategorías y categorías
CREATE OR REPLACE VIEW vista_productos_completa AS
SELECT p.id, p.nombre, p.descripcion, p.marca, p.modelo,
       p.precio_referencia_renta, p.sku,
       s.nombre as subcategoria, s.descripcion as desc_subcategoria,
       cat.nombre as categoria, cat.descripcion as desc_categoria,
       cat.tipo_categoria,
       p.created_at, p.updated_at
FROM producto p
INNER JOIN producto_subcategoria ps ON p.id = ps.producto_id
INNER JOIN subcategoria s ON ps.subcategoria_id = s.id
INNER JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
INNER JOIN categoria cat ON cs.categoria_id = cat.id;

-- 3. Vista de inventario completo
CREATE OR REPLACE VIEW vista_inventario_completo AS
SELECT ii.id, ii.numero_serie, ii.estado_item,
       ii.fecha_adquisicion, ii.costo_adquisicion,
       ii.ubicacion_fisica, ii.notas,
       p.nombre as producto, p.marca, p.modelo,
       p.precio_referencia_renta, p.sku,
       s.nombre as subcategoria,
       cat.nombre as categoria,
       ii.created_at, ii.updated_at
FROM inventario_item ii
INNER JOIN producto p ON ii.producto_id = p.id
LEFT JOIN producto_subcategoria ps ON p.id = ps.producto_id
LEFT JOIN subcategoria s ON ps.subcategoria_id = s.id
LEFT JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
LEFT JOIN categoria cat ON cs.categoria_id = cat.id;

-- =====================================================
-- VISTAS DE RENTAS Y OPERACIONES
-- =====================================================

-- 4. Vista de rentas activas con detalle de cliente y productos
CREATE OR REPLACE VIEW vista_rentas_activas AS
SELECT r.id, r.fecha_inicio, r.fecha_fin_prevista,
       r.fecha_devolucion_real, r.estado_renta,
       r.monto_total_renta, r.deposito_garantia, r.notas,
       c.nombre, c.nombre2, c.apellido1, c.apellido2,
       c.telefono_principal, c.correo_electronico,
       c.tipo_cliente,
       GROUP_CONCAT(DISTINCT p.nombre ORDER BY p.nombre SEPARATOR ', ') as productos_rentados,
       COUNT(rii.inventario_item_id) as cantidad_items,
       d.calle, d.ciudad, d.estado_provincia,
       r.created_at
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
LEFT JOIN renta_inventario_item rii ON r.id = rii.renta_id
LEFT JOIN inventario_item ii ON rii.inventario_item_id = ii.id
LEFT JOIN producto p ON ii.producto_id = p.id
LEFT JOIN entrega e ON r.id = e.renta_id
LEFT JOIN direccion d ON e.direccion_id = d.id
WHERE r.estado_renta IN ('Programada', 'EnCurso')
GROUP BY r.id, r.fecha_inicio, r.fecha_fin_prevista,
         r.fecha_devolucion_real, r.estado_renta,
         r.monto_total_renta, r.deposito_garantia, r.notas,
         c.nombre, c.nombre2, c.apellido1, c.apellido2,
         c.telefono_principal, c.correo_electronico, c.tipo_cliente,
         d.calle, d.ciudad, d.estado_provincia, r.created_at;

-- 5. Vista de rentas finalizadas con resumen
CREATE OR REPLACE VIEW vista_rentas_finalizadas AS
SELECT r.id, r.fecha_inicio, r.fecha_fin_prevista,
       r.fecha_devolucion_real, r.estado_renta,
       r.monto_total_renta, r.deposito_garantia,
       DATEDIFF(r.fecha_devolucion_real, r.fecha_inicio) as dias_real_renta,
       DATEDIFF(r.fecha_fin_prevista, r.fecha_inicio) as dias_previsto_renta,
       CASE
           WHEN r.fecha_devolucion_real > r.fecha_fin_prevista THEN 'Retrasada'
           WHEN r.fecha_devolucion_real <= r.fecha_fin_prevista THEN 'A tiempo'
           ELSE 'Pendiente'
       END as cumplimiento,
       c.nombre, c.apellido1, c.correo_electronico,
       COUNT(rii.inventario_item_id) as cantidad_items
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
LEFT JOIN renta_inventario_item rii ON r.id = rii.renta_id
WHERE r.estado_renta = 'Finalizada'
GROUP BY r.id, r.fecha_inicio, r.fecha_fin_prevista,
         r.fecha_devolucion_real, r.estado_renta,
         r.monto_total_renta, r.deposito_garantia,
         c.nombre, c.apellido1, c.correo_electronico;

-- =====================================================
-- VISTAS DE REPORTES Y ESTADÍSTICAS
-- =====================================================

-- 6. Vista de resumen de clientes por actividad
CREATE OR REPLACE VIEW vista_resumen_clientes AS
SELECT c.id, c.nombre, c.apellido1, c.correo_electronico,
       c.tipo_cliente, c.estado_cliente,
       COUNT(DISTINCT r.id) as total_rentas,
       COUNT(DISTINCT s.id) as total_solicitudes,
       COUNT(DISTINCT cot.id) as total_cotizaciones,
       SUM(r.monto_total_renta) as monto_total_rentas,
       MAX(r.fecha_inicio) as ultima_renta,
       DATEDIFF(CURRENT_DATE, MAX(r.fecha_inicio)) as dias_sin_renta,
       CASE
           WHEN MAX(r.fecha_inicio) >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN 'Activo'
           WHEN MAX(r.fecha_inicio) >= DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY) THEN 'Regular'
           WHEN MAX(r.fecha_inicio) IS NULL THEN 'Nuevo'
           ELSE 'Inactivo'
       END as nivel_actividad
FROM cliente c
LEFT JOIN renta r ON c.id = r.cliente_id
LEFT JOIN solicitud s ON c.id = s.cliente_id
LEFT JOIN cotizacion cot ON c.id = cot.cliente_id
GROUP BY c.id, c.nombre, c.apellido1, c.correo_electronico,
         c.tipo_cliente, c.estado_cliente;

-- 7. Vista de productos más rentados
CREATE OR REPLACE VIEW vista_productos_mas_rentados AS
SELECT p.id, p.nombre, p.marca, p.modelo, p.precio_referencia_renta,
       COUNT(rii.inventario_item_id) as veces_rentado,
       COUNT(DISTINCT r.cliente_id) as clientes_distintos,
       SUM(r.monto_total_renta) as ingreso_generado,
       AVG(r.monto_total_renta) as renta_promedio,
       MAX(r.fecha_inicio) as ultima_renta,
       MIN(r.fecha_inicio) as primera_renta,
       s.nombre as subcategoria,
       cat.nombre as categoria
FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
LEFT JOIN renta r ON rii.renta_id = r.id
LEFT JOIN producto_subcategoria ps ON p.id = ps.producto_id
LEFT JOIN subcategoria s ON ps.subcategoria_id = s.id
LEFT JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
LEFT JOIN categoria cat ON cs.categoria_id = cat.id
GROUP BY p.id, p.nombre, p.marca, p.modelo, p.precio_referencia_renta,
         s.nombre, cat.nombre
ORDER BY veces_rentado DESC;

-- 8. Vista de ingresos por período
CREATE OR REPLACE VIEW vista_ingresos_por_periodo AS
SELECT YEAR(fecha_inicio) as año,
       MONTH(fecha_inicio) as mes,
       QUARTER(fecha_inicio) as trimestre,
       COUNT(*) as cantidad_rentas,
       SUM(monto_total_renta) as ingreso_total_rentas,
       SUM(deposito_garantia) as ingreso_total_garantias,
       SUM(monto_total_renta + deposito_garantia) as ingreso_total_general,
       AVG(monto_total_renta) as renta_promedio,
       COUNT(DISTINCT cliente_id) as clientes_unicos
FROM renta
WHERE estado_renta = 'Finalizada'
GROUP BY YEAR(fecha_inicio), MONTH(fecha_inicio), QUARTER(fecha_inicio)
ORDER BY año DESC, mes DESC;

-- =====================================================
-- VISTAS DE INVENTARIO Y DISPONIBILIDAD
-- =====================================================

-- 9. Vista de disponibilidad de productos
CREATE OR REPLACE VIEW vista_disponibilidad_productos AS
SELECT p.id, p.nombre, p.marca, p.modelo, p.precio_referencia_renta,
       COUNT(ii.id) as total_items,
       SUM(CASE WHEN ii.estado_item = 'Disponible' THEN 1 ELSE 0 END) as disponibles,
       SUM(CASE WHEN ii.estado_item = 'Rentado' THEN 1 ELSE 0 END) as rentados,
       SUM(CASE WHEN ii.estado_item = 'EnMantenimiento' THEN 1 ELSE 0 END) as en_mantenimiento,
       SUM(CASE WHEN ii.estado_item = 'DeBaja' THEN 1 ELSE 0 END) as de_baja,
       ROUND((SUM(CASE WHEN ii.estado_item = 'Disponible' THEN 1 ELSE 0 END) / COUNT(ii.id)) * 100, 2) as porcentaje_disponibilidad,
       s.nombre as subcategoria,
       cat.nombre as categoria
FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN producto_subcategoria ps ON p.id = ps.producto_id
LEFT JOIN subcategoria s ON ps.subcategoria_id = s.id
LEFT JOIN categoria_subcategoria cs ON s.id = cs.subcategoria_id
LEFT JOIN categoria cat ON cs.categoria_id = cat.id
GROUP BY p.id, p.nombre, p.marca, p.modelo, p.precio_referencia_renta,
         s.nombre, cat.nombre;

-- 10. Vista de items que requieren mantenimiento
CREATE OR REPLACE VIEW vista_items_mantenimiento_pendiente AS
SELECT ii.id, ii.numero_serie, ii.estado_item,
       ii.fecha_adquisicion, ii.ubicacion_fisica,
       p.nombre as producto, p.marca, p.modelo,
       DATEDIFF(CURRENT_DATE, ii.fecha_adquisicion) as dias_desde_adquisicion,
       m.fecha_inicio as ultimo_mantenimiento,
       DATEDIFF(CURRENT_DATE, m.fecha_inicio) as dias_sin_mantenimiento,
       CASE
           WHEN m.fecha_inicio IS NULL THEN 'Nunca mantenido'
           WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 180 THEN 'Mantenimiento urgente'
           WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 90 THEN 'Mantenimiento recomendado'
           ELSE 'Mantenimiento al día'
       END as estado_mantenimiento
FROM inventario_item ii
INNER JOIN producto p ON ii.producto_id = p.id
LEFT JOIN mantenimiento m ON ii.id = m.inventario_item_id
    AND m.id = (SELECT MAX(id) FROM mantenimiento WHERE inventario_item_id = ii.id)
WHERE ii.estado_item != 'DeBaja'
ORDER BY
    CASE
        WHEN m.fecha_inicio IS NULL THEN 1
        WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 180 THEN 2
        WHEN DATEDIFF(CURRENT_DATE, m.fecha_inicio) > 90 THEN 3
        ELSE 4
    END,
    ii.fecha_adquisicion;

-- =====================================================
-- VISTAS DE SOLICITUDES Y COTIZACIONES
-- =====================================================

-- 11. Vista de solicitudes pendientes con información del cliente
CREATE OR REPLACE VIEW vista_solicitudes_pendientes AS
SELECT s.id, s.fecha_solicitud, s.nombre_producto_alternativo,
       s.cantidad_solicitada, s.descripcion_necesidad,
       s.estado_solicitud,
       c.nombre, c.nombre2, c.apellido1, c.apellido2,
       c.telefono_principal, c.correo_electronico, c.tipo_cliente,
       GROUP_CONCAT(DISTINCT p.nombre ORDER BY p.nombre SEPARATOR ', ') as productos_solicitados,
       DATEDIFF(CURRENT_DATE, s.fecha_solicitud) as dias_pendiente
FROM solicitud s
INNER JOIN cliente c ON s.cliente_id = c.id
LEFT JOIN solicitud_producto sp ON s.id = sp.solicitud_id
LEFT JOIN producto p ON sp.producto_id = p.id
WHERE s.estado_solicitud IN ('Nueva', 'EnProceso')
GROUP BY s.id, s.fecha_solicitud, s.nombre_producto_alternativo,
         s.cantidad_solicitada, s.descripcion_necesidad,
         s.estado_solicitud, c.nombre, c.nombre2, c.apellido1, c.apellido2,
         c.telefono_principal, c.correo_electronico, c.tipo_cliente;

-- 12. Vista de cotizaciones con detalle
CREATE OR REPLACE VIEW vista_cotizaciones_detalle AS
SELECT cot.id, cot.fecha_cotizacion, cot.fecha_validez,
       cot.monto_total, cot.estado_cotizacion,
       cot.terminos_condiciones, cot.notas_internas,
       c.nombre, c.apellido1, c.correo_electronico,
       s.fecha_solicitud, s.descripcion_necesidad,
       DATEDIFF(cot.fecha_validez, CURRENT_DATE) as dias_para_vencer,
       CASE
           WHEN cot.fecha_validez < CURRENT_DATE THEN 'Vencida'
           WHEN DATEDIFF(cot.fecha_validez, CURRENT_DATE) <= 7 THEN 'Por vencer'
           ELSE 'Vigente'
       END as estado_validez
FROM cotizacion cot
INNER JOIN cliente c ON cot.cliente_id = c.id
LEFT JOIN solicitud s ON cot.solicitud_id = s.id;

-- =====================================================
-- VISTAS DE USUARIOS Y PERMISOS
-- =====================================================

-- 13. Vista de usuarios con roles
CREATE OR REPLACE VIEW vista_usuarios_roles AS
SELECT u.id, u.nombre_usuario, u.nombre, u.nombre2, u.apellido1, u.apellido2,
       u.email, u.telefono, u.departamento, u.estado,
       GROUP_CONCAT(r.nombre ORDER BY r.nombre SEPARATOR ', ') as roles,
       GROUP_CONCAT(r.codigo ORDER BY r.codigo SEPARATOR ', ') as codigos_roles,
       u.created_at, u.updated_at
FROM usuario u
LEFT JOIN usuario_rol ur ON u.id = ur.usuario_id
LEFT JOIN rol r ON ur.rol_id = r.id
GROUP BY u.id, u.nombre_usuario, u.nombre, u.nombre2, u.apellido1, u.apellido2,
         u.email, u.telefono, u.departamento, u.estado,
         u.created_at, u.updated_at;

-- =====================================================
-- VISTAS DE PROVEEDORES
-- =====================================================

-- 14. Vista de proveedores con información completa
CREATE OR REPLACE VIEW vista_proveedores_completa AS
SELECT prov.id, prov.nombre_empresa, prov.rfc,
       prov.nombre_contacto, prov.telefono_contacto,
       prov.correo_contacto, prov.estado_proveedor,
       d.calle, d.numero_exterior, d.numero_interior,
       d.colonia, d.ciudad, d.estado_provincia,
       d.codigo_postal, d.pais, d.referencias,
       COUNT(ii.id) as productos_suministrados,
       prov.created_at, prov.updated_at
FROM proveedor prov
LEFT JOIN proveedor_direccion pd ON prov.id = pd.proveedor_id AND pd.es_principal = 1
LEFT JOIN direccion d ON pd.direccion_id = d.id
LEFT JOIN inventario_item ii ON prov.id = ii.proveedor_id
GROUP BY prov.id, prov.nombre_empresa, prov.rfc,
         prov.nombre_contacto, prov.telefono_contacto,
         prov.correo_contacto, prov.estado_proveedor,
         d.calle, d.numero_exterior, d.numero_interior,
         d.colonia, d.ciudad, d.estado_provincia,
         d.codigo_postal, d.pais, d.referencias,
         prov.created_at, prov.updated_at;

-- =====================================================
-- VISTAS DE DASHBOARD Y MÉTRICAS
-- =====================================================

-- 15. Vista de métricas generales del sistema
CREATE OR REPLACE VIEW vista_metricas_generales AS
SELECT
    (SELECT COUNT(*) FROM cliente WHERE estado_cliente = 'Activo') as clientes_activos,
    (SELECT COUNT(*) FROM producto) as total_productos,
    (SELECT COUNT(*) FROM inventario_item WHERE estado_item = 'Disponible') as items_disponibles,
    (SELECT COUNT(*) FROM renta WHERE estado_renta = 'EnCurso') as rentas_activas,
    (SELECT COUNT(*) FROM solicitud WHERE estado_solicitud IN ('Nueva', 'EnProceso')) as solicitudes_pendientes,
    (SELECT SUM(monto_total_renta) FROM renta WHERE estado_renta = 'Finalizada' AND YEAR(fecha_inicio) = YEAR(CURRENT_DATE)) as ingresos_anio_actual,
    (SELECT AVG(monto_total_renta) FROM renta WHERE estado_renta = 'Finalizada') as renta_promedio,
    (SELECT COUNT(*) FROM mantenimiento WHERE estado_mantenimiento = 'Programado') as mantenimientos_pendientes;

-- 16. Vista de alertas del sistema
CREATE OR REPLACE VIEW vista_alertas_sistema AS
SELECT 'Rentas por vencer' as tipo_alerta,
       COUNT(*) as cantidad,
       CONCAT('Hay ', COUNT(*), ' rentas que vencen en los próximos 3 días') as mensaje,
       'warning' as severidad
FROM renta
WHERE estado_renta = 'EnCurso'
  AND fecha_fin_prevista BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)

UNION ALL

SELECT 'Items sin mantenimiento' as tipo_alerta,
       COUNT(*) as cantidad,
       CONCAT('Hay ', COUNT(*), ' items que no han recibido mantenimiento en más de 6 meses') as mensaje,
       'error' as severidad
FROM inventario_item ii
LEFT JOIN mantenimiento m ON ii.id = m.inventario_item_id
WHERE ii.estado_item != 'DeBaja'
  AND (m.fecha_inicio IS NULL OR m.fecha_inicio < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH))
GROUP BY ii.id
HAVING COUNT(*) > 0

UNION ALL

SELECT 'Cotizaciones por vencer' as tipo_alerta,
       COUNT(*) as cantidad,
       CONCAT('Hay ', COUNT(*), ' cotizaciones que vencen en los próximos 7 días') as mensaje,
       'info' as severidad
FROM cotizacion
WHERE estado_cotizacion = 'Enviada'
  AND fecha_validez BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY);

-- =====================================================
-- VISTAS PARA REPORTES ESPECÍFICOS
-- =====================================================

-- 17. Vista de rentas por período detallada
CREATE OR REPLACE VIEW vista_rentas_por_periodo_detallada AS
SELECT YEAR(r.fecha_inicio) as año,
       MONTH(r.fecha_inicio) as mes,
       QUARTER(r.fecha_inicio) as trimestre,
       c.nombre as cliente, c.tipo_cliente,
       COUNT(r.id) as cantidad_rentas,
       SUM(r.monto_total_renta) as monto_total,
       AVG(r.monto_total_renta) as monto_promedio,
       GROUP_CONCAT(DISTINCT p.nombre ORDER BY p.nombre SEPARATOR '; ') as productos_rentados
FROM renta r
INNER JOIN cliente c ON r.cliente_id = c.id
LEFT JOIN renta_inventario_item rii ON r.id = rii.renta_id
LEFT JOIN inventario_item ii ON rii.inventario_item_id = ii.id
LEFT JOIN producto p ON ii.producto_id = p.id
WHERE r.estado_renta = 'Finalizada'
GROUP BY YEAR(r.fecha_inicio), MONTH(r.fecha_inicio), QUARTER(r.fecha_inicio),
         c.id, c.nombre, c.tipo_cliente
ORDER BY año DESC, mes DESC, cliente;

-- 18. Vista de rendimiento de productos
CREATE OR REPLACE VIEW vista_rendimiento_productos AS
SELECT p.nombre, p.marca, p.modelo,
       COUNT(DISTINCT r.id) as rentas_totales,
       COUNT(DISTINCT CASE WHEN r.estado_renta = 'Finalizada' THEN r.id END) as rentas_completadas,
       COUNT(DISTINCT CASE WHEN r.estado_renta = 'Retrasada' THEN r.id END) as rentas_retrasadas,
       SUM(CASE WHEN r.estado_renta = 'Finalizada' THEN r.monto_total_renta END) as ingresos_generados,
       AVG(CASE WHEN r.estado_renta = 'Finalizada' THEN DATEDIFF(r.fecha_devolucion_real, r.fecha_inicio) END) as dias_promedio_renta,
       ROUND(
           (COUNT(DISTINCT CASE WHEN r.estado_renta = 'Finalizada' THEN r.id END) /
            NULLIF(COUNT(DISTINCT r.id), 0)) * 100, 2
       ) as porcentaje_completadas,
       MAX(r.fecha_inicio) as ultima_renta
FROM producto p
LEFT JOIN inventario_item ii ON p.id = ii.producto_id
LEFT JOIN renta_inventario_item rii ON ii.id = rii.inventario_item_id
LEFT JOIN renta r ON rii.renta_id = r.id
GROUP BY p.id, p.nombre, p.marca, p.modelo
ORDER BY ingresos_generados DESC;