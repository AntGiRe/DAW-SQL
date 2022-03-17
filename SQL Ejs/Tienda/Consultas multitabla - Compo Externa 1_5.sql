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

/* 1. Devuelve un listado de todos los fabricantes que existen en la base de datos, junto con los productos que tiene cada uno de ellos. 
El listado deberá mostrar también aquellos fabricantes que no tienen productos asociados.*/
select fabricante.nombre, producto.nombre
from fabricante left join producto
on fabricante.codigo = producto.cod_fabricante;

/* 2. Devuelve un listado donde sólo aparezcan aquellos fabricantes que no tienen ningún producto asociado. */
select distinct fabricante.nombre
from fabricante left join producto
on fabricante.codigo = producto.cod_fabricante
where cod_fabricante is null;

/* 3. ¿Pueden existir productos que no estén relacionados con un fabricante? Justifique su respuesta. */

/* No, ya que en la declaración de la tabla producto, el codigo del fabricante no puede ser nulo*/