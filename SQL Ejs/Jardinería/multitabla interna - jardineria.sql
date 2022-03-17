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

/* 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas. */
select nombre_cliente, empleado.nombre, empleado.apellido1
from cliente inner join empleado
on cliente.codigo_empleado_rep_ventas = codigo_empleado;

/* 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas. */
select distinct nombre_cliente, empleado.nombre
from cliente inner join pago
on cliente.codigo_cliente = pago.codigo_cliente
inner join empleado
on cliente.codigo_empleado_rep_ventas = codigo_empleado;

/* 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas. */
select distinct nombre_cliente, empleado.nombre
from cliente left join pago
on cliente.codigo_cliente = pago.codigo_cliente
inner join empleado
on cliente.codigo_empleado_rep_ventas = codigo_empleado
where pago.codigo_cliente is null;

/* 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes 
junto con la ciudad de la oficina a la que pertenece el representante. */
select distinct nombre_cliente, empleado.nombre, oficina.ciudad
from cliente inner join pago
on cliente.codigo_cliente = pago.codigo_cliente
inner join empleado
on cliente.codigo_empleado_rep_ventas = codigo_empleado
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina;

/* 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes
 junto con la ciudad de la oficina a la que pertenece el representante. */
select distinct nombre_cliente, empleado.nombre, oficina.ciudad
from cliente left join pago
on cliente.codigo_cliente = pago.codigo_cliente
inner join empleado
on cliente.codigo_empleado_rep_ventas = codigo_empleado
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina
where pago.codigo_cliente is null;
 
/* 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada. */
select distinct oficina.linea_direccion1, oficina.linea_direccion2
from oficina inner join empleado
on empleado.codigo_oficina = oficina.codigo_oficina
inner join cliente
on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
where cliente.ciudad = "Fuenlabrada";

/* 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante. */
select cliente.nombre_cliente, empleado.nombre, oficina.ciudad
from cliente inner join empleado
on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina;

/* 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes. */
select em.nombre, jefe.nombre
from empleado em left join empleado jefe
on jefe.codigo_empleado = em.codigo_jefe;

/* 9. Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe. */
select em.nombre, jefe.nombre, jefejefe.nombre
from empleado em left join empleado jefe
on jefe.codigo_empleado = em.codigo_jefe
left join empleado jefejefe
on jefejefe.codigo_empleado = jefe.codigo_jefe;

/* 10. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido. */
select cliente.nombre_cliente, fecha_entrega, fecha_esperada
from cliente inner join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
where fecha_entrega > fecha_esperada;

/* 11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente. */
select distinct cliente.nombre_cliente, producto.gama
from cliente inner join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
inner join detalle_pedido
on detalle_pedido.codigo_pedido = pedido.codigo_pedido
inner join producto
on producto.codigo_producto = detalle_pedido.codigo_producto;