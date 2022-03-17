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

/* 1. ¿Cuántos empleados hay en la compañía? */
select count(*)
from empleado;

/* 2. ¿Cuántos clientes tiene cada país? */
select pais, count(*)
from cliente
group by pais;

/* 3. ¿Cuál fue el pago medio en 2009? */
select avg(total)
from pago;

/* 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos. */
select estado, count(*)
from pedido
group by estado
order by 2 desc;

/* 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta. */
select max(precio_venta), min(precio_venta)
from producto;

/* 6. Calcula el número de clientes que tiene la empresa. */
select count(*)
from cliente;

/* 7. ¿Cuántos clientes existen con domicilio en la ciudad de Madrid? */
select count(*)
from cliente
where ciudad="Madrid";

/* 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M? */
select ciudad, count(*)
from cliente
where ciudad like "M%"
group by ciudad;

/* 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno. */
select empleado.nombre, count(*)
from empleado inner join cliente
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
group by empleado.codigo_empleado;

/* 10. Calcula el número de clientes que no tiene asignado representante de ventas. */
select count(*)
from cliente
where codigo_empleado_rep_ventas is null;

/* 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. 
El listado deberá mostrar el nombre y los apellidos de cada cliente. */
select cliente.codigo_cliente, cliente.nombre_cliente, max(fecha_pago), min(fecha_pago)
from cliente inner join pago
on cliente.codigo_cliente = pago.codigo_cliente
group by cliente.codigo_cliente;

/* 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos. */
select count(distinct codigo_producto)
from detalle_pedido;

/* 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos. */
select sum(precio_venta)
from detalle_pedido inner join producto
on detalle_pedido.codigo_producto = producto.codigo_producto;

/* 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. 
El listado deberá estar ordenado por el número total de unidades vendidas. */
select detalle_pedido.codigo_producto, producto.nombre, count(detalle_pedido.codigo_producto)
from detalle_pedido inner join producto
on detalle_pedido.codigo_producto = producto.codigo_producto
group by detalle_pedido.codigo_producto
order by 3 desc
limit 20;

/* 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. 
La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla detalle_pedido. 
El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores. */
select (sum(precio_venta)) as "Base Imponible", ((sum(precio_venta))*0.21) as "IVA", (((sum(precio_venta))*0.21) + (sum(precio_venta))) as "Total facturado"
from detalle_pedido inner join producto
on detalle_pedido.codigo_producto = producto.codigo_producto;

/* 16. La misma información que en la pregunta anterior, pero agrupada por código de producto. */
select producto.codigo_producto, (count(*)*precio_venta) as "Base Imponible", ((count(*)*precio_venta)*0.21) as "IVA", (((count(*)*precio_venta)*0.21) + (count(*)*precio_venta)) as "Total facturado"
from detalle_pedido inner join producto
on detalle_pedido.codigo_producto = producto.codigo_producto
group by producto.codigo_producto;

/* 17. La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR. */
select producto.codigo_producto, (count(*)*precio_venta) as "Base Imponible", ((count(*)*precio_venta)*0.21) as "IVA", (((count(*)*precio_venta)*0.21) + (count(*)*precio_venta)) as "Total facturado"
from detalle_pedido inner join producto
on detalle_pedido.codigo_producto = producto.codigo_producto
where producto.codigo_producto like "OR%"
group by producto.codigo_producto;

/* 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, 
total facturado y total facturado con impuestos (21% IVA). */
select producto.nombre, count(*), (count(*)*precio_venta) as "Facturado", (((count(*)*precio_venta)*0.21) + (count(*)*precio_venta)) as "Total facturado"
from detalle_pedido inner join producto
on detalle_pedido.codigo_producto = producto.codigo_producto
where (precio_venta*(select count(*)
					from detalle_pedido
                    where producto.codigo_producto = detalle_pedido.codigo_producto) + 0.21 * (precio_venta* (select count(*)
																								from detalle_pedido
																								where producto.codigo_producto = detalle_pedido.codigo_producto)))> 3000
group by producto.codigo_producto;
            
/* 19. Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos. */
select year(fecha_pago), sum(total)
from pago
group by year(fecha_pago);