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

/* 1. Devuelve el nombre del cliente con mayor límite de crédito. */
select nombre_cliente
from cliente
where limite_credito = (select max(limite_credito)
						from cliente);
                        
/* 2. Devuelve el nombre del producto que tenga el precio de venta más caro. */
select nombre
from producto
where precio_venta = (select max(precio_venta)
						from producto);
                        
/* 3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál 
es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido) */ 
select producto.nombre
from producto
where codigo_producto = (select codigo_producto
						from detalle_pedido
                        group by codigo_producto
                        order by count(*) desc
                        limit 1);
                        
/* 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN). */
select *
from cliente
where limite_credito > (select sum(total)
						from pago
                        where cliente.codigo_cliente = pago.codigo_cliente);
                        
/* 5. Devuelve el producto que más unidades tiene en stock. */
select *
from producto
where codigo_producto = (select codigo_producto
						from producto
						group by codigo_producto
                        order by cantidad_en_stock desc
                        limit 1);
                        
/* 6. Devuelve el producto que menos unidades tiene en stock */
select *
from producto
where codigo_producto = (select codigo_producto
						from producto
						group by codigo_producto
                        order by cantidad_en_stock
                        limit 1);
                        
/* 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria. */
select nombre, apellido1, apellido2, email
from empleado
where codigo_jefe = (select codigo_empleado
						from empleado
                        where nombre = "Alberto" and apellido1 = "Soria");
                        
/* 8. Devuelve el nombre del cliente con mayor límite de crédito. */
select nombre_cliente
from cliente
where limite_credito >= all (select max(limite_credito)
						from cliente);
                        
/* 9. Devuelve el nombre del producto que tenga el precio de venta más caro */
select nombre
from producto
where precio_venta >= all (select max(precio_venta)
						from producto);
                        
/* 10. Devuelve el producto que menos unidades tiene en stock. */
select *
from producto
where codigo_producto = (select codigo_producto
						from producto
						group by codigo_producto
                        order by cantidad_en_stock
                        limit 1);                    

/* 11. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente. */
select nombre, apellido1, puesto
from empleado
where codigo_empleado not in (select codigo_empleado_rep_ventas
								from cliente);
		
/* 12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago. */
select *
from cliente
where codigo_cliente not in (select codigo_cliente
							from pago);
                            
/* 13. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago. */
select *
from cliente
where codigo_cliente in (select codigo_cliente
							from pago);
                            
/* 14. Devuelve un listado de los productos que nunca han aparecido en un pedido. */
select *
from producto
where codigo_producto not in (select codigo_producto
								from detalle_pedido);
                                
/* 15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados 
que no sean representante de ventas de ningún cliente. */
select nombre, apellido1, puesto, oficina.telefono
from empleado inner join oficina
on empleado.codigo_oficina = oficina.codigo_oficina
where codigo_empleado not in (select codigo_empleado_rep_ventas
								from cliente);
                                
/* 16. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas 
de algún cliente que haya realizado la compra de algún producto de la gama Frutales. */
select *
from oficina
where codigo_oficina not in (select codigo_oficina
							from empleado
							where codigo_empleado in (select codigo_empleado_rep_ventas
													from cliente
                                                    where codigo_cliente in (select codigo_cliente
																			from pedido
                                                                            where codigo_pedido in (select codigo_pedido
																									from detalle_pedido
                                                                                                    where codigo_producto in (select codigo_producto
																															from producto
                                                                                                                            where gama = "Frutales")))));
/* 17. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago. */
select *
from cliente
where codigo_cliente in (select codigo_cliente
						from pedido) and codigo_cliente not in (select codigo_cliente
																from pago);
                                                                
/* 18. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago. */
select *
from cliente
where not exists (select codigo_cliente
				from pago
                where cliente.codigo_cliente = pago.codigo_cliente);
                
/* 19. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago. */   
select *
from cliente
where exists (select codigo_cliente
				from pago
                where cliente.codigo_cliente = pago.codigo_cliente);

/* 20. Devuelve un listado de los productos que nunca han aparecido en un pedido. */
select *
from producto
where not exists (select codigo_producto
				from detalle_pedido
                where detalle_pedido.codigo_producto = producto.codigo_producto);
                
/* 21. Devuelve un listado de los productos que han aparecido en un pedido alguna vez. */
select *
from producto
where exists (select codigo_producto
				from detalle_pedido
                where detalle_pedido.codigo_producto = producto.codigo_producto);