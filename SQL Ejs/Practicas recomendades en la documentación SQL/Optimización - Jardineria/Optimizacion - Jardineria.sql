DROP DATABASE IF EXISTS jardineria;
CREATE DATABASE jardineria CHARACTER SET utf8mb4;
USE jardineria;

CREATE TABLE oficina (
  codigo_oficina VARCHAR(10) NOT NULL,
  ciudad VARCHAR(30) NOT NULL,
  pais VARCHAR(50) NOT NULL,
  region VARCHAR(50) DEFAULT NULL,
  codigo_postal VARCHAR(10) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (codigo_oficina)
);

CREATE TABLE empleado (
  codigo_empleado INTEGER NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50) DEFAULT NULL,
  extension VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  codigo_oficina VARCHAR(10) NOT NULL,
  codigo_jefe INTEGER DEFAULT NULL,
  puesto VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (codigo_empleado),
  FOREIGN KEY (codigo_oficina) REFERENCES oficina (codigo_oficina),
  FOREIGN KEY (codigo_jefe) REFERENCES empleado (codigo_empleado)
);

CREATE TABLE gama_producto (
  gama VARCHAR(50) NOT NULL,
  descripcion_texto TEXT,
  descripcion_html TEXT,
  imagen VARCHAR(256),
  PRIMARY KEY (gama)
);

CREATE TABLE cliente (
  codigo_cliente INTEGER NOT NULL,
  nombre_cliente VARCHAR(50) NOT NULL,
  nombre_contacto VARCHAR(30) DEFAULT NULL,
  apellido_contacto VARCHAR(30) DEFAULT NULL,
  telefono VARCHAR(15) NOT NULL,
  fax VARCHAR(15) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50) DEFAULT NULL,
  ciudad VARCHAR(50) NOT NULL,
  region VARCHAR(50) DEFAULT NULL,
  pais VARCHAR(50) DEFAULT NULL,
  codigo_postal VARCHAR(10) DEFAULT NULL,
  codigo_empleado_rep_ventas INTEGER DEFAULT NULL,
  limite_credito NUMERIC(15,2) DEFAULT NULL,
  PRIMARY KEY (codigo_cliente),
  FOREIGN KEY (codigo_empleado_rep_ventas) REFERENCES empleado (codigo_empleado)
);

CREATE TABLE pedido (
  codigo_pedido INTEGER NOT NULL,
  fecha_pedido date NOT NULL,
  fecha_esperada date NOT NULL,
  fecha_entrega date DEFAULT NULL,
  estado VARCHAR(15) NOT NULL,
  comentarios TEXT,
  codigo_cliente INTEGER NOT NULL,
  PRIMARY KEY (codigo_pedido),
  FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo_cliente)
);

CREATE TABLE producto (
  codigo_producto VARCHAR(15) NOT NULL,
  nombre VARCHAR(70) NOT NULL,
  gama VARCHAR(50) NOT NULL,
  dimensiones VARCHAR(25) NULL,
  proveedor VARCHAR(50) DEFAULT NULL,
  descripcion text NULL,
  cantidad_en_stock SMALLINT NOT NULL,
  precio_venta NUMERIC(15,2) NOT NULL,
  precio_proveedor NUMERIC(15,2) DEFAULT NULL,
  PRIMARY KEY (codigo_producto),
  FOREIGN KEY (gama) REFERENCES gama_producto (gama)
);

CREATE TABLE detalle_pedido (
  codigo_pedido INTEGER NOT NULL,
  codigo_producto VARCHAR(15) NOT NULL,
  cantidad INTEGER NOT NULL,
  precio_unidad NUMERIC(15,2) NOT NULL,
  numero_linea SMALLINT NOT NULL,
  PRIMARY KEY (codigo_pedido, codigo_producto),
  FOREIGN KEY (codigo_pedido) REFERENCES pedido (codigo_pedido),
  FOREIGN KEY (codigo_producto) REFERENCES producto (codigo_producto)
);

CREATE TABLE pago (
  codigo_cliente INTEGER NOT NULL,
  forma_pago VARCHAR(40) NOT NULL,
  id_transaccion VARCHAR(50) NOT NULL,
  fecha_pago date NOT NULL,
  total NUMERIC(15,2) NOT NULL,
  PRIMARY KEY (codigo_cliente, id_transaccion),
  FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo_cliente)
);

/* 1. Consulte cuáles son los índices que hay en la tabla producto utilizando las instrucciones 
SQL que nos permiten obtener esta información de la tabla. */
show index from producto;

/* 2. Haga uso de EXPLAIN para obtener información sobre cómo se están realizando las consultas y diga 
cuál de las dos consultas realizará menos comparaciones para encontrar el producto que estamos buscando. 
¿Cuántas comparaciones se realizan en cada caso? ¿Por qué?. */

EXPLAIN SELECT *
FROM producto
WHERE codigo_producto = 'OR-114';

EXPLAIN SELECT *
FROM producto
WHERE nombre = 'Evonimus Pulchellus';

/* En el primer caso hay que examinar 62 filas y en el segundo caso hay que examinar todas las filas. Esto se debe a que en el primer caso
usamos un indice para opmitización de consultas*/

/* 3. Suponga que estamos trabajando con la base de datos jardineria y queremos saber optimizar las siguientes consultas. 
¿Cuál de las dos sería más eficiente?. Se recomienda hacer uso de EXPLAIN para obtener información sobre cómo se están 
realizando las consultas. */

EXPLAIN SELECT AVG(total)
FROM pago
WHERE YEAR(fecha_pago) = 2008;

EXPLAIN SELECT AVG(total)
FROM pago
WHERE fecha_pago >= '2008-01-01' AND fecha_pago <= '2008-12-31';

/* La segunda opción sería la mas eficiente ya que la función year() no aprovechara el indice en caso de disponer de el*/

/* 4. Optimiza la siguiente consulta creando índices cuando sea necesario. 
Se recomienda hacer uso de EXPLAIN para obtener información sobre cómo se están realizando las consultas. */

EXPLAIN SELECT *
FROM cliente INNER JOIN pedido
ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE cliente.nombre_cliente LIKE 'A%';

DESCRIBE cliente;

CREATE INDEX idx_nombreCliente ON cliente(nombre_cliente);

/* 5. ¿Por qué no es posible optimizar el tiempo de ejecución de las siguientes consultas, incluso haciendo uso de índices? */

EXPLAIN SELECT *
FROM cliente INNER JOIN pedido
ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE cliente.nombre_cliente LIKE '%A%';

EXPLAIN SELECT *
FROM cliente INNER JOIN pedido
ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE cliente.nombre_cliente LIKE '%A';

/* Cuando se coloca un “%” al comienzo de una cadena, estamos haciendo imposible el uso de cualquier índice ascendente. */

/* 6. Crea un índice de tipo FULLTEXT sobre las columnas nombre y descripcion de la tabla producto. */

CREATE FULLTEXT INDEX idx_nombre_descripcion ON producto(nombre, descripcion);

/* 7. Una vez creado el índice del ejercicio anterior realiza las siguientes consultas haciendo uso de la función MATCH, 
para buscar todos los productos que: */

/* Contienen la palabra planta en el nombre o en la descripción. */

SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('%planta%');

/* Contienen la palabra planta seguida de cualquier carácter o conjunto de caracteres, en el nombre o en la descripción. */

SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('planta%');

/* Empiezan con la palabra planta en el nombre o en la descripción. */

SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('planta%');

/* Contienen la palabra tronco o la palabra árbol en el nombre o en la descripción. */

SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('%tronco%') or match(nombre, descripcion) against ('%arbol%');

/* Contienen la palabra tronco o la palabra árbol en el nombre o en la descripción. */
SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('%tronco%' '%arbol%');

/* Contienen la palabra tronco pero no contienen la palabra árbol en el nombre o en la descripción. */

SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('%tronco%') and not match(nombre, descripcion) against ('%arbol%');

/* Contiene la frase proviene de las costas en el nombre o en la descripción. */

SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('proviene de las costas');

/* 8. Crea un índice de tipo INDEX compuesto por las columnas apellido_contacto y nombre_contacto de la tabla cliente. */

CREATE INDEX idx_apellido_nombre ON cliente(apellido_contacto, nombre_contacto);

/* 9. Una vez creado el índice del ejercicio anterior realice las siguientes consultas haciendo uso de EXPLAIN: */
/* Busca el cliente Javier Villar. ¿Cuántas filas se han examinado hasta encontrar el resultado? - 1 */

explain select *
from cliente
where nombre_contacto = "Javier" and apellido_contacto = "Villar";

/* Busca el ciente anterior utilizando solamente el apellido Villar. ¿Cuántas filas se han examinado hasta encontrar el resultado? - 1 */

explain select *
from cliente
where apellido_contacto = "Villar";

/* Busca el ciente anterior utilizando solamente el nombre Javier. ¿Cuántas filas se han examinado hasta encontrar el resultado? 
¿Qué ha ocurrido en este caso? - 36, no se uso el indice y se comprobaron todas las filas */

explain select *
from cliente
where nombre_contacto = "Javier";