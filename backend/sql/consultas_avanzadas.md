# Consultas SQL Avanzadas

Este documento proporciona ejemplos de consultas SQL más avanzadas, incluyendo el uso de JOINs, GROUP BY, subconsultas y CTEs.

## 1. Consultas con JOINs

Los JOINs se utilizan para combinar filas de dos o más tablas, basándose en una columna relacionada entre ellas. Aquí hay algunos ejemplos:

### INNER JOIN: Clientes y sus Direcciones

Esta consulta devuelve todos los clientes que tienen al menos una dirección registrada y la dirección principal asociada a cada uno.

```sql
SELECT
    c.nombre AS NombreCliente,
    c.apellido1 AS ApellidoPaterno,
    d.calle,
    d.ciudad,
    d.codigo_postal
FROM
    cliente c
INNER JOIN
    cliente_direccion cd ON c.id = cd.cliente_id
INNER JOIN
    direccion d ON cd.direccion_id = d.id
WHERE
    cd.es_principal = 1;
```

### LEFT JOIN: Productos y sus Subcategorías (incluyendo productos sin subcategoría)

Esta consulta muestra todos los productos y, si tienen, las subcategorías a las que pertenecen. Los productos sin subcategoría también serán listados.

```sql
SELECT
    p.nombre AS NombreProducto,
    p.marca,
    s.nombre AS NombreSubcategoria
FROM
    producto p
LEFT JOIN
    producto_subcategoria ps ON p.id = ps.producto_id
LEFT JOIN
    subcategoria s ON ps.subcategori-id = s.id;
```

### RIGHT JOIN: Roles y Usuarios (incluyendo roles sin usuarios asociados)

Esta consulta lista todos los roles y los usuarios asignados a ellos. Los roles que no tienen usuarios también serán mostrados.

```sql
SELECT
    r.nombre AS NombreRol,
    u.nombre_usuario AS NombreUsuario
FROM
    usuario_rol ur
RIGHT JOIN
    rol r ON ur.rol_id = r.id
LEFT JOIN
    usuario u ON ur.usuario_id = u.id;
```

## 2. Consultas con GROUP BY y Funciones de Agregación

`GROUP BY` se utiliza para agrupar filas que tienen los mismos valores en columnas especificadas en un conjunto de filas de resumen. Se usa a menudo con funciones de agregación (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`).

### Conteo de Productos por Categoría

```sql
SELECT
    categoria.nombre AS NombreCategoria,
    COUNT(producto.id) AS TotalProductos
FROM
    categoria
INNER JOIN
    producto_subcategoria ON categoria.id = producto_subcategoria.categori-id -- Asumiendo que existe una relación directa o a través de subcategoria
INNER JOIN
    producto ON producto_subcategoria.producto_id = producto.id
GROUP BY
    categoria.nombre
HAVING
    COUNT(producto.id) > 5 -- Solo categorías con más de 5 productos
ORDER BY
    TotalProductos DESC;
```

## 3. Subconsultas (Subqueries)

Una subconsulta es una consulta dentro de otra consulta. Puede ser utilizada en la cláusula `WHERE`, `FROM`, o `SELECT`.

### Clientes que han realizado al menos una renta

```sql
SELECT
    id,
    nombre,
    apellido1
FROM
    cliente
WHERE
    id IN (
        SELECT DISTINCT cliente_id
        FROM renta
    );
```

### Productos con el precio de alquiler más alto

```sql
SELECT
    nombre,
    precio_alquiler_dia
FROM
    producto
WHERE
    precio_alquiler_dia = (
        SELECT MAX(precio_alquiler_dia)
        FROM producto
    );
```

## 4. Common Table Expressions (CTEs)

Las CTEs (expresiones de tabla comunes) son conjuntos de resultados nombrados y temporales que puedes referenciar dentro de una sentencia `SELECT`, `INSERT`, `UPDATE` o `DELETE`.

### Clientes con el total de sus rentas

```sql
WITH ClientesConRentas AS (
    SELECT
        c.id AS ClienteID,
        c.nombre AS NombreCliente,
        c.apellido1 AS ApellidoCliente,
        SUM(r.monto_total_renta) AS TotalGastado
    FROM
        cliente c
    INNER JOIN
        renta r ON c.id = r.cliente_id
    GROUP BY
        c.id, c.nombre, c.apellido1
)
SELECT
    ClienteID,
    NombreCliente,
    ApellidoCliente,
    TotalGastado
FROM
    ClientesConRentas
WHERE
    TotalGastado > 1000 -- Solo clientes que han gastado más de 1000
ORDER BY
    TotalGastado DESC;
```

## 5. Consultas con Funciones de Ventana (Window Functions)

Las funciones de ventana realizan cálculos a través de un conjunto de filas de la tabla que están relacionadas con la fila actual. A diferencia de las funciones de agregación de `GROUP BY`, las funciones de ventana no agrupan las filas en una sola fila de salida, sino que devuelven un valor para cada fila.

### Ranking de Productos por Precio de Alquiler Diario

```sql
SELECT
    nombre AS NombreProducto,
    marca,
    precio_alquiler_dia,
    RANK() OVER (ORDER BY precio_alquiler_dia DESC) AS RangoPrecio
FROM
    producto;
```

### Promedio de Monto Total de Renta por Cliente (con partición)

```sql
SELECT
    c.nombre AS NombreCliente,
    c.apellido1 AS ApellidoCliente,
    r.monto_total_renta,
    AVG(r.monto_total_renta) OVER (PARTITION BY c.id) AS PromedioRentaCliente
FROM
    cliente c
INNER JOIN
    renta r ON c.id = r.cliente_id
ORDER BY
    c.nombre, r.fech-inicio;
```

