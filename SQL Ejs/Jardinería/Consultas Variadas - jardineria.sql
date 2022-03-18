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

/* 1. Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. 
Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido. */
select nombre_cliente, count(pedido.codigo_cliente)
from cliente left join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
group by cliente.codigo_cliente
order by 2 desc;

/* 2. Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. 
Tenga en cuenta que pueden existir clientes que no han realizado ningún pago. */
select nombre_cliente, sum(total)
from cliente left join pago
on cliente.codigo_cliente = pago.codigo_cliente
group by cliente.codigo_cliente
order by 2 desc;

/* 3. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor. */
select distinct nombre_cliente
from cliente inner join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
where year(fecha_pedido)=2008
order by 1;

/* 4. Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de 
teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago. */
select nombre_cliente, empleado.nombre, empleado.apellido1, oficina.telefono
from cliente inner join empleado
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina
left join pago
on cliente.codigo_cliente = pago.codigo_cliente
where pago.codigo_cliente is null;

/* 5. Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido 
de su representante de ventas y la ciudad donde está su oficina. */
select nombre_cliente, empleado.nombre, empleado.apellido1, oficina.ciudad
from cliente inner join empleado
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina;

/* 6. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no 
sean representante de ventas de ningún cliente. */
select nombre, apellido1, apellido2, puesto, oficina.telefono
from empleado left join cliente
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina
where cliente.codigo_empleado_rep_ventas is null;

/* 7. Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene. */
select oficina.ciudad, count(*)
from oficina inner join empleado
on empleado.codigo_oficina = oficina.codigo_oficina
group by oficina.ciudad;
