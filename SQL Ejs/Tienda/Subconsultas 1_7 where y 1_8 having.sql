drop database if exists tienda;
create database tienda character set utf8mb4;
use tienda;

create table fabricante (
	codigo int unsigned auto_increment primary key,
    nombre varchar(100) not null
);

create table producto (
	codigo int unsigned auto_increment primary key,
    nombre varchar(100) not null,
    precio double not null,
    cod_fabricante int unsigned not null,
    foreign key (cod_fabricante) references fabricante(codigo)
);

INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');

INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

/* 1. Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN). */
select *
from producto
where cod_fabricante = 2;

/* 2. Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN). */
select *
from producto
where precio = (select max(precio)
				from producto
				where cod_fabricante = 2);
                
/* 3. Lista el nombre del producto más caro del fabricante Lenovo. */
select nombre
from producto
where cod_fabricante = 2 and precio = (select max(precio)
								from producto
								where cod_fabricante = 2);
                                
/* 4. Lista el nombre del producto más barato del fabricante Hewlett-Packard. */
select nombre
from producto
where cod_fabricante = 3 and precio = (select min(precio)
								from producto
								where cod_fabricante = 3);
                                
/* 5.  Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al producto más caro del fabricante Lenovo. */
select nombre
from producto
where precio >= (select max(precio)
				from producto
				where cod_fabricante = 2);
                
/* 6.  Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus productos. */
select nombre
from producto
where cod_fabricante = 1 and precio >= (select avg(precio)
										from producto
										where cod_fabricante = 1);
                                        
/* 8.  Devuelve el producto más caro que existe en la tabla producto sin hacer uso deMAX, ORDER BY ni LIMIT. */
select nombre
from producto
where precio >= all (select precio
				from producto);
                
/* 9.  Devuelve el producto más barato que existe en la tabla producto sin hacer usode MIN, ORDER BY ni LIMIT. */
select nombre
from producto
where precio <= all (select precio
				from producto);
			
/* 10.  Devuelve los nombres de los fabricantes que tienen productos asociados.(Utilizando ALL o ANY). */
select distinct nombre
from fabricante
where codigo = any (select producto.cod_fabricante
					from producto);
                            
/* 11.  Devuelve los nombres de los fabricantes que no tienen productos asociados.(Utilizando ALL o ANY). */
select distinct nombre
from fabricante
where codigo <> all (select producto.cod_fabricante
					from producto);

/* 12.  Devuelve los nombres de los fabricantes que tienen productos asociados.(Utilizando IN o NOT IN ). */
select nombre
from fabricante
where codigo in (select cod_fabricante
				from producto);
                
/* 13.  Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN ). */
select nombre
from fabricante
where codigo not in (select cod_fabricante
				from producto);
                
/* 14.  Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT EXISTS ). */
select nombre
from fabricante
where exists (select cod_fabricante
				from producto
                where fabricante.codigo = producto.cod_fabricante);
                
/* 15.  Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT EXISTS ). */
select nombre
from fabricante
where not exists (select cod_fabricante
				from producto
                where fabricante.codigo = producto.cod_fabricante);
                
/* 16.  Lista el nombre de cada fabricante con el nombre y el precio de su producto más caro */
select f.nombre as "Nombre Fabricante", p.nombre as "Nombre Producto", precio
from fabricante f inner join producto p
on f.codigo = p.cod_fabricante
where precio = (select max(precio)
				from producto
				where f.codigo = cod_fabricante)
group by f.codigo, p.nombre;

/* 17. Devuelve un listado de todos los productos que tienen un precio mayor o igual a
la media de todos los productos de su mismo fabricante. */
select p.nombre
from producto p inner join fabricante f
on f.codigo = p.cod_fabricante
where precio >= (select avg(precio)
				from producto
                where f.codigo = cod_fabricante)
group by p.codigo;

/* 18. Lista el nombre del producto más caro del fabricante Lenovo. */
select p.nombre
from producto p inner join fabricante f
on f.codigo = p.cod_fabricante
where p.cod_fabricante = 2 and precio = (select max(precio)
				from producto
				where f.codigo = cod_fabricante);
                
/* 1.8 Subconsultas HAVING */
/* 7. Devuelve un listado con todos los nombres de los fabricantes que tienen el
mismo número de productos que el fabricante Lenovo. */
select fabricante.nombre
from fabricante inner join producto
on producto.cod_fabricante = fabricante.codigo
group by fabricante.nombre
having count(producto.codigo) = (select count(codigo)
								from producto
                                where cod_fabricante = 2);
                