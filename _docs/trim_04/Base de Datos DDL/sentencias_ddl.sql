/* ************************************************************************************* */
/* ---------------------------------------- DDL ---------------------------------------- */
/* ----------------------------- DATA DEFINITION LANGUAGE ------------------------------ */
/* -------------------------- LENGUAJE DE DEFINICIÓN DE DATOS -------------------------- */
/* ------------------------------------------------------------------------------------- */
/* ************************************************************************************* */
/* ------------------------------------------------------------------------------------- */
/* 01. Mostrar BBDDs : .................... SHOW DATABASES                               */
/* 02. Usar BBDD : ........................ USE __                                       */
/* 03. Eliminar BBDD : .................... DROP DATABASE __                             */
/* 04. Mostrar Tablas : ................... SHOW TABLES __.                              */
/* 05. Mostar Columnas : .................. SHOW COLUMNS FROM __ . DESCRIBE __           */
/* 06. Agregar Columna : .................. ALTER TABLE __ ADD __ __                     */
/* 07. Renombrar Columna : ................ ALTER TABLE __ CHANGE __ __                  */
/* 08. Eliminar Columna : ................. ALTER TABLE __ DROP __                       */
/* 09. Agregar Valor x Defecto Columna : .. ALTER TABLE __ ALTER __ SET DEFAULT __       */
/* 10. Eliminar Valor x Defecto Columna : . ALTER TABLE __ ALTER __ DROP DEFAULT         */
/* 11. Mostrar Creación Tabla : ........... SHOW CREATE TABLE __                         */
/* 12. Eliminar Restricción : ............. ALTER TABLE __ DROP CONSTRAINT __            */
/* 13. Eliminar Índice : .................. ALTER TABLE __ DROP INDEX __                 */
/* 14. Eliminar Llave Primaria : .......... ALTER TABLE __ DROP PRIMARY KEY              */
/* 15. Limpiar Registros : ................ TRUNCATE __                                  */
/* 16. Eliminar Tabla : ................... DROP TABLE __                                */
/* 17. Crear Tabla : ...................... CREATE TABLE __ ( __ , __ )                  */
/* 18. Renombrar Tabla : .................. RENAME TABLE __ TO __                        */
/* 19. Crear Llave Primaria : ............. ALTER TABLE __ ADD PRIMARY KEY ( __ )        */
/* 20. Crear Índice Campo : ............... CREATE INDEX __ ON __ ( __ )                 */
/* 21. Crear Índice Multicampo : .......... CREATE INDEX _ ON _ ( __ , __ )              */
/* 22. Crear Índice Único : ............... CREATE UNIQUE INDEX __ ON __ ( __ )          */
/* 23. Crear Restricción : ................ ALTER TABLE __ ADD CONSTRAINT __             */
/*     FOREIGN KEY ( __ ) REFERENCES __ ( __ ) ON DELETE CASCADE ON UPDATE CASCADE       */
/* ------------------------------------------------------------------------------------- */
/* BIBLIOGRAFÍA                                                                          */
/* ------------------------------------------------------------------------------------- */
/* ************************************************************************************* */
/* EN CONSOLA: XAMPP / SHELL / cd mysql/bin / mysql -h localhost -u root -p / ENTER      */
/* ************************************************************************************* */

-- ------------------------------------------------------------------------------------- --
-- 01. Mostrar BBDDs. ------------------------------------------------------------------ --
--     SHOW DATABASES : ---------------------------------------------------------------- -- 
-- ------------------------------------------------------------------------------------- --
SHOW DATABASES;

-- ------------------------------------------------------------------------------------- --
-- 02. Usar BBDD. ---------------------------------------------------------------------- --
--     USE __ : ------------------------------------------------------------------------ --
-- ------------------------------------------------------------------------------------- --
-- Asegúrate de que el nombre de tu base de datos sea el correcto.
USE sistemarenta;

-- ------------------------------------------------------------------------------------- --
-- 03. Eliminar BBDD. ------------------------------------------------------------------ --
--     DROP DATABASE __ : -------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --

DROP DATABASE sistemarenta;

-- ------------------------------------------------------------------------------------- --
-- 04. Mostrar Tablas. ----------------------------------------------------------------- --
--     SHOW TABLES __ : ---------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
SHOW TABLES;

-- ------------------------------------------------------------------------------------- --
-- 05. Mostar Columnas. ---------------------------------------------------------------- --
--     SHOW COLUMNS FROM __ . DESCRIBE __ : -------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
SHOW COLUMNS FROM usuario;
DESCRIBE cliente;
DESCRIBE producto;
DESCRIBE renta;

-- ------------------------------------------------------------------------------------- --
-- 06. Agregar Columna. ---------------------------------------------------------------- --
--     ALTER TABLE __ ADD __ __ : ------------------------------------------------------ --
-- ------------------------------------------------------------------------------------- --
-- Agregamos una columna para el peso en la tabla de productos.
ALTER TABLE producto ADD peso_kg DECIMAL(7,2) NULL;
ALTER TABLE cliente ADD apellido varchar(200) NOT NULL;
-- ------------------------------------------------------------------------------------- --
-- 07. Renombrar Columna. -------------------------------------------------------------- --
--     ALTER TABLE __ CHANGE __ __ : --------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Cambiamos el nombre de la columna y su tipo, si es necesario.
ALTER TABLE producto CHANGE peso_kg peso_en_kg DECIMAL(8,2) NULL;

-- ------------------------------------------------------------------------------------- --
-- 08. Eliminar Columna. --------------------------------------------------------------- --
--     ALTER TABLE __ DROP __ : -------------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
ALTER TABLE producto DROP peso_en_kg;

-- ------------------------------------------------------------------------------------- --
-- 09. Agregar Valor x Defecto Columna. ------------------------------------------------ --
--     ALTER TABLE __ ALTER __ SET DEFAULT __ :	---------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Hacemos que cada nuevo cliente sea 'Activo' por defecto.
ALTER TABLE cliente ALTER estado_cliente SET DEFAULT 'Activo';

-- ------------------------------------------------------------------------------------- --
-- 10. Eliminar Valor x Defecto Columna. ----------------------------------------------- --
--     ALTER TABLE __ ALTER __ DROP DEFAULT : ------------------------------------------ --
-- ------------------------------------------------------------------------------------- --
ALTER TABLE cliente ALTER estado_cliente DROP DEFAULT;

-- ------------------------------------------------------------------------------------- --
-- 11. Mostrar Creación Tabla. --------------------------------------------------------- --
--     SHOW CREATE TABLE __ : ---------------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
SHOW CREATE TABLE usuario;
SHOW CREATE TABLE cliente;
SHOW CREATE TABLE producto;
SHOW CREATE TABLE cotizacion;

-- ------------------------------------------------------------------------------------- --
-- 12. Eliminar Restricción. ----------------------------------------------------------- --
--     ALTER TABLE __ DROP CONSTRAINT __ / DROP FOREIGN KEY __ : ----------------------- --
-- ------------------------------------------------------------------------------------- --

ALTER TABLE renta DROP FOREIGN KEY fk_renta_cliente;
ALTER TABLE renta add FOREIGN KEY fk_renta_cliente;
ALTER TABLE detalle_cotizacion DROP FOREIGN KEY fk_detalle_cotizacion;

-- ------------------------------------------------------------------------------------- --
-- 13. Eliminar Índice. ---------------------------------------------------------------- --
--     ALTER TABLE __ DROP INDEX __ : -------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
ALTER TABLE producto DROP INDEX uq_producto_sku;
ALTER TABLE inventario_item DROP INDEX idx_item_producto_id;

-- ------------------------------------------------------------------------------------- --
-- 14. Eliminar Llave Primaria. -------------------------------------------------------- --
--     ALTER TABLE __ DROP PRIMARY KEY : ----------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Es poco común, pero útil si necesitas redefinirla.
ALTER TABLE producto DROP PRIMARY KEY;
ALTER TABLE cliente DROP PRIMARY KEY;

-- ------------------------------------------------------------------------------------- --
-- 15. Limpiar Registros. -------------------------------------------------------------- --
--     TRUNCATE __ : ------------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Vacía una tabla completamente, es más rápido que DELETE.
TRUNCATE TABLE detalle_cotizacion;
TRUNCATE TABLE cotizacion;

-- ------------------------------------------------------------------------------------- --
-- 16. Eliminar Tabla. ----------------------------------------------------------------- --
--     DROP TABLE __ : ----------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Borra tablas. Generalmente se borran primero las que tienen las llaves foráneas.
DROP TABLE detalle_renta_inventario_item;
DROP TABLE detalle_renta;

-- ------------------------------------------------------------------------------------- --
-- 17. Crear Tabla. -------------------------------------------------------------------- --
--     CREATE TABLE __ ( __ , __ ) : --------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --

CREATE TABLE `proveedor` (
  `id` int(11) NOT NULL,
  `nombre_empresa` varchar(200) NOT NULL,
  `rfc` varchar(13) DEFAULT NULL,
  `nombre_contacto` varchar(150) DEFAULT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `correo_contacto` varchar(100) DEFAULT NULL,
  `estado_proveedor` enum('Activo','Inactivo') DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


-- ------------------------------------------------------------------------------------- --
-- 18. Renombrar Tabla. ---------------------------------------------------------------- --
--     RENAME TABLE __ TO __ : --------------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
RENAME TABLE proveedor TO suppliers;
RENAME TABLE suppliers TO proveedor;

-- ------------------------------------------------------------------------------------- --
-- 19. Crear Llave Primaria. ----------------------------------------------------------- --
--     ALTER TABLE __ ADD PRIMARY KEY ( __ ) : ----------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Volvemos a agregar las llaves primarias eliminadas en el paso 14.
-- El campo ID también debe ser autoincremental (AUTO_INCREMENT).
ALTER TABLE producto MODIFY id INT(11) NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (id);
ALTER TABLE cliente MODIFY id INT(11) NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (id);

-- ------------------------------------------------------------------------------------- --
-- 20. Crear Índice Campo. ------------------------------------------------------------- --
--     CREATE INDEX __ ON __ ( __ ) :  ------------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Acelera las búsquedas sobre columnas que no son llaves primarias, como las foráneas.
CREATE INDEX idx_item_producto_id ON inventario_item (producto_id);
CREATE INDEX idx_cotizacion_cliente_id ON cotizacion (cliente_id);

-- ------------------------------------------------------------------------------------- --
-- 21. Crear Índice Multicampo. -------------------------------------------------------- --
--     CREATE INDEX __ ON __ ( __ , __ ) : ----------------------------------------------- -- 
-- ------------------------------------------------------------------------------------- --
-- Útil cuando frecuentemente buscas/ordenas por múltiples columnas a la vez.
CREATE INDEX idx_renta_cliente_estado ON renta (cliente_id, estado_renta);

-- ------------------------------------------------------------------------------------- --
-- 22. Crear Índice Único. ------------------------------------------------------------- --
--     CREATE UNIQUE INDEX __ ON __ ( __ ) : ------------------------------------------- --
-- ------------------------------------------------------------------------------------- --
-- Asegura que no haya valores duplicados en una columna.
CREATE UNIQUE INDEX uq_producto_sku ON producto (sku);
CREATE UNIQUE INDEX uq_cliente_rfc ON cliente (rfc);

-- ------------------------------------------------------------------------------------- --
-- 23. Crear Restricción (Llave Foránea). ---------------------------------------------- --
--     ALTER TABLE __ ADD CONSTRAINT __ FOREIGN KEY ( __ ) REFERENCES __ ( __ ) -------- --
-- ------------------------------------------------------------------------------------- --
-- Es crucial para mantener la integridad de los datos.
-- Creamos un nombre descriptivo para la restricción: fk_[tabla_origen]_[tabla_destino]

-- La columna cliente_id en la tabla 'renta' debe existir en la tabla 'cliente'.
ALTER TABLE renta ADD 
CONSTRAINT fk_renta_cliente 
	FOREIGN KEY (cliente_id)
	REFERENCES cliente (id)
	ON DELETE RESTRICT -- Evita borrar un cliente que tenga rentas asociadas
	ON UPDATE CASCADE; -- Si el id del cliente cambia, se actualiza aquí

-- La columna cotizacion_id en la tabla 'detalle_cotizacion' debe existir en 'cotizacion'.
ALTER TABLE detalle_cotizacion ADD 
CONSTRAINT fk_detalle_cotizacion 
	FOREIGN KEY (cotizacion_id)
	REFERENCES cotizacion (id)
	ON DELETE CASCADE -- Si se borra la cotización, se borran sus detalles
	ON UPDATE CASCADE;

-- La columna producto_id en 'inventario_item' debe existir en 'producto'.
ALTER TABLE inventario_item ADD
CONSTRAINT fk_item_producto
  FOREIGN KEY (producto_id)
  REFERENCES producto (id)
  ON DELETE SET NULL -- Si se borra un producto, el item de inventario queda sin asociar.
  ON UPDATE CASCADE;

