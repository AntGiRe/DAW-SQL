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

/* 1. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos. */
select producto.nombre as "Nombre producto", precio, fabricante.nombre as "Nombre fabricante"
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo;

/* 2. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos. 
Ordene el resultado por el nombre del fabricante, por orden alfabético.*/
select producto.nombre as "Nombre producto", precio, fabricante.nombre as "Nombre fabricante"
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
order by fabricante.nombre;

/* 3. Devuelve una lista con el código del producto, nombre del producto, código del fabricante y nombre del fabricante, de todos los productos de la base de datos. */
select producto.codigo, producto.nombre, fabricante.codigo, fabricante.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo;

/* 4. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato. */
select producto.nombre, producto.precio, fabricante.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where precio = (select min(precio)
				from producto);

/* 5. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más caro. */
select producto.nombre, producto.precio, fabricante.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where precio = (select max(precio)
				from producto);

/* 6. Devuelve una lista de todos los productos del fabricante Lenovo. */
select producto.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where fabricante.codigo = 2;

/* 7. Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que 200€. */
select producto.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where fabricante.codigo = 6 and producto.precio > 200;

/* 8. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. Sin utilizar el operador IN. */
select producto.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where fabricante.codigo = 2 or fabricante.codigo = 3 or fabricante.codigo = 5;

/* 9. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy Seagate. Utilizando el operador IN. */
select producto.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where fabricante.codigo in (2,3,5);

/* 10. Devuelve un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre termine por la vocal e. */
select producto.nombre, producto.precio
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where fabricante.nombre like "%e";

/* 11. Devuelve un listado con el nombre y el precio de todos los productos cuyo nombre de fabricante contenga el carácter w en su nombre. */
select producto.nombre, producto.precio
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where fabricante.nombre like "%w%";

/* 12. Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos que tengan un precio mayor o igual a 180€. 
Ordene el resultado en primer lugar por el precio (en orden descendente) y en segundo lugar por el nombre (en orden ascendente) */
select producto.nombre, precio, fabricante.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo
where producto.precio >= 180
order by precio desc, producto.nombre;

/* 13. Devuelve un listado con el código y el nombre de fabricante, solamente de aquellos fabricantes que tienen productos asociados en la base de datos. */
select distinct fabricante.codigo, fabricante.nombre
from producto inner join fabricante
on producto.cod_fabricante = fabricante.codigo;