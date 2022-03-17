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

/* 1. Calcula el número total de productos que hay en la tabla productos. */
select count(*)
from producto;

/* 2. Calcula el número total de fabricantes que hay en la tabla fabricante. */
select count(*)
from fabricante;

/* 3. Calcula el número de valores distintos de código de fabricante aparecen en la tabla productos. */
select count(distinct cod_fabricante)
from producto;

/* 4. Calcula la media del precio de todos los productos. */
select avg(precio)
from producto;

/* 5. Calcula el precio más barato de todos los productos. */
select min(precio)
from producto;

/* 6. Calcula el precio más caro de todos los productos. */
select max(precio)
from producto;

/* 7. Lista el nombre y el precio del producto más barato. */
select nombre, precio
from producto
where precio = (select min(precio) 
				from producto);

/* 8. Lista el nombre y el precio del producto más caro. */
select nombre, precio
from producto
where precio = (select max(precio) 
				from producto);
                
/* 9. Calcula la suma de los precios de todos los productos. */
select sum(precio)
from producto;

/* 10. Calcula el número de productos que tiene el fabricante Asus. */
select count(*)
from producto
where cod_fabricante = 1;

/* 11. Calcula la media del precio de todos los productos del fabricante Asus. */
select avg(precio)
from producto
where cod_fabricante = 1;

/* 12. Calcula el precio más barato de todos los productos del fabricante Asus. */
select min(precio)
from producto
where cod_fabricante = 1;

/* 13. Calcula el precio más caro de todos los productos del fabricante Asus. */
select max(precio)
from producto
where cod_fabricante = 1;

/* 14. Calcula la suma de todos los productos del fabricante Asus. */
select sum(precio)
from producto
where cod_fabricante = 1;

/* 15. Muestra el precio máximo, precio mínimo, precio medio y el número total de productos que tiene el fabricante Crucial. */
select max(precio), min(precio), avg(precio), count(*)
from producto
where cod_fabricante = 6;

/* 16. Muestra el número total de productos que tiene cada uno de los fabricantes. 
El listado también debe incluir los fabricantes que no tienen ningún producto. 
El resultado mostrará dos columnas, una con el nombre del fabricante y otra con el número de productos que tiene. 
Ordene el resultado descendentemente por el número de productos. */
select fabricante.nombre, count(producto.codigo)
from producto right join fabricante
on cod_fabricante = fabricante.codigo
group by fabricante.nombre
order by 2 desc;

/* 17. Muestra el precio máximo, precio mínimo y precio medio de los productos de cada uno de los fabricantes. 
El resultado mostrará el nombre del fabricante junto con los datos que se solicitan. */
select fabricante.nombre, max(precio), min(precio), avg(precio)
from producto inner join fabricante
on cod_fabricante = fabricante.codigo
group by fabricante.nombre;

/* 18. Muestra el precio máximo, precio mínimo, precio medio y el número total de productos de los fabricantes que tienen un precio medio superior a 200€. 
No es necesario mostrar el nombre del fabricante, con el código del fabricante es suficiente. */
select cod_fabricante, max(precio), min(precio), avg(precio), count(*)
from producto
group by cod_fabricante
having avg(precio) > 200;

/* 19. Muestra el nombre de cada fabricante, junto con el precio máximo, precio mínimo, precio medio y el número total de productos de los fabricantes que tienen un precio medio superior a 200€. 
Es necesario mostrar el nombre del fabricante.*/
select fabricante.nombre, max(precio), min(precio), avg(precio), count(*)
from producto inner join fabricante
on fabricante.codigo = cod_fabricante
group by fabricante.nombre
having avg(precio) > 200;

/* 20. Calcula el número de productos que tienen un precio mayor o igual a 180€. */
select count(*)
from producto
where precio >= 180;

/* 21. Calcula el número de productos que tiene cada fabricante con un precio mayor o igual a 180€. */
select fabricante.nombre, count(*)
from producto inner join fabricante
on fabricante.codigo = cod_fabricante
where precio >= 180
group by fabricante.nombre;

/* 22. Lista el precio medio los productos de cada fabricante, mostrando solamente el código del fabricante. */
select cod_fabricante, avg(precio)
from producto
group by cod_fabricante;

/* 23. Lista el precio medio los productos de cada fabricante, mostrando solamente el nombre del fabricante. */
select fabricante.nombre, avg(precio)
from producto inner join fabricante
on fabricante.codigo = cod_fabricante
group by fabricante.nombre;

/* 24. Lista los nombres de los fabricantes cuyos productos tienen un precio medio mayor o igual a 150€. */
select fabricante.nombre
from fabricante inner join producto
on fabricante.codigo = cod_fabricante
group by fabricante.nombre
having avg(precio) >= 150;

/* 25. Devuelve un listado con los nombres de los fabricantes que tienen 2 o más productos. */
select fabricante.nombre
from fabricante inner join producto
on fabricante.codigo = cod_fabricante
group by fabricante.nombre
having count(*) >= 2;

/* 26. Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con un precio superior o igual a 220 €. 
No es necesario mostrar el nombre de los fabricantes que no tienen productos que cumplan la condición. */
select fabricante.nombre, count(*)
from fabricante inner join producto
on fabricante.codigo = cod_fabricante
where precio >= 220
group by fabricante.nombre;

/* 27. Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con un precio superior o igual a 220 €. 
El listado debe mostrar el nombre de todos los fabricantes, es decir, si hay algún fabricante que no tiene productos con un precio superior o igual a 220€ deberá aparecer en el listado con un valor igual a 0 en el número de productos. */
select fabricante.nombre, count(*)
from fabricante inner join producto
on fabricante.codigo = cod_fabricante
where precio >= 220
group by fabricante.nombre
union
select fabricante.nombre, 0
from fabricante inner join producto
on fabricante.codigo = cod_fabricante
group by fabricante.nombre;

/* 28. Devuelve un listado con los nombres de los fabricantes donde la suma del precio de todos sus productos es superior a 1000 €. */
select f.nombre as "Nombre Fabricante"
from fabricante f inner join producto p
on f.codigo = p.cod_fabricante
group by f.codigo
having sum(all precio) > 1000;

/* 29. Devuelve un listado con el nombre del producto más caro que tiene cada fabricante. 
El resultado debe tener tres columnas: nombre del producto, precio y nombre del fabricante. 
El resultado tiene que estar ordenado alfabéticamente de menor a mayor por el nombre del fabricante.*/
select f.nombre as "Nombre Fabricante", p.nombre as "Nombre Producto", precio
from fabricante f inner join producto p
on f.codigo = p.cod_fabricante
where precio = (select max(precio)
				from producto
				where f.codigo = cod_fabricante)
group by f.codigo, p.nombre
order by f.nombre;
