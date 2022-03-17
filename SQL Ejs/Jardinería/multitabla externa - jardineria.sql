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

/* 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago. */
select distinct *
from cliente left join pago
on cliente.codigo_cliente = pago.codigo_cliente
where pago.codigo_cliente is null;

/* 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido. */
select distinct *
from cliente left join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
where pedido.codigo_cliente is null;

/* 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido. */
select distinct *
from cliente left join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
left join pago
on cliente.codigo_cliente = pago.codigo_cliente
where pedido.codigo_cliente is null and pago.codigo_cliente is null;

/* 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada. */
select *
from empleado left join oficina
on empleado.codigo_oficina = oficina.codigo_oficina
where empleado.codigo_oficina is null;

/* 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado. */
select concat_ws(' ',empleado.nombre,empleado.apellido1,empleado.apellido2) as "Nombre empleados"
from empleado left join cliente
on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
where cliente.codigo_empleado_rep_ventas is null;

/* 6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan. */
select concat_ws(' ',empleado.nombre,empleado.apellido1,empleado.apellido2) as "Nombre empleados", oficina.codigo_oficina, oficina.ciudad
from empleado left join cliente
on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina
where cliente.codigo_empleado_rep_ventas is null;

/* 7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado. */
select concat_ws(' ',empleado.nombre,empleado.apellido1,empleado.apellido2) as "Nombre empleados", oficina.codigo_oficina, oficina.ciudad
from empleado left join cliente
on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina
where cliente.codigo_empleado_rep_ventas is null and empleado.codigo_oficina is null;

/* 8. Devuelve un listado de los productos que nunca han aparecido en un pedido. */
select distinct *
from producto left join detalle_pedido
on producto.codigo_producto = detalle_pedido.codigo_producto
where codigo_pedido is null;

/* 9. Devuelve un listado de los productos que nunca han aparecido en un pedido. 
El resultado debe mostrar el nombre, la descripción y la imagen del producto. */
select distinct producto.nombre, producto.descripcion, gama_producto.imagen
from producto left join detalle_pedido
on producto.codigo_producto = detalle_pedido.codigo_producto
inner join gama_producto
on producto.gama = gama_producto.gama
where codigo_pedido is null;

/* 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los 
representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales. */
select distinct oficina.codigo_oficina
from oficina
where oficina.codigo_oficina not in (select distinct oficina.codigo_oficina
									from cliente inner join pedido
                                    on cliente.codigo_cliente = pedido.codigo_cliente
                                    inner join empleado
                                    on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
                                    inner join oficina
                                    on empleado.codigo_oficina = oficina.codigo_oficina
                                    inner join detalle_pedido
                                    on detalle_pedido.codigo_pedido = pedido.codigo_pedido
                                    inner join producto
									on producto.codigo_producto = detalle_pedido.codigo_producto
									inner join gama_producto
									on gama_producto.gama = producto.gama
                                    where gama_producto.gama = "Frutales");
                                    
/* 11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago. */
select *
from cliente left join pago
on cliente.codigo_cliente = pago.codigo_cliente
inner join pedido
on pedido.codigo_cliente = cliente.codigo_cliente
where pago.codigo_cliente is null;

/* 12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado. */
select *
from empleado left join cliente
on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
inner join empleado jefe
on empleado.codigo_empleado = jefe.codigo_empleado
where codigo_cliente is null;