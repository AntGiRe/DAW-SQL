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

/* 1. Inserta un nuevo fabricante indicando su código y su nombre. */

INSERT INTO fabricante VALUES(10, 'Nfortec');

/* 2. Inserta un nuevo fabricante indicando solamente su nombre. */

INSERT INTO fabricante VALUES(null, 'Empresa2');

/* 3. Inserta un nuevo producto asociado a uno de los nuevos fabricantes. 
La sentencia de inserción debe incluir: código, nombre, precio y código_fabricante. */

INSERT INTO producto VALUES(123, 'Producto1', 450, 10);

/* 4. Inserta un nuevo producto asociado a uno de los nuevos fabricantes. 
La sentencia de inserción debe incluir: nombre, precio y código_fabricante. */

INSERT INTO producto VALUES(null, 'Producto2', 450, 10);

/* 5. Crea una nueva tabla con el nombre fabricante_productos que tenga las siguientes columnas: nombre_fabricante, 
nombre_producto y precio. Una vez creada la tabla inserta todos los registros de la base de datos tienda en esta 
tabla haciendo uso de única operación de inserción. */

create table fabricante_productos (
	codigo int unsigned auto_increment primary key,
	nombre_fabricante varchar(100) not null,
    nombre_producto varchar(100) not null,
    precio double not null
);

insert into fabricante_productos (codigo,nombre_fabricante,nombre_producto,precio)
select null, fabricante.nombre, producto.nombre, precio
from fabricante inner join producto
on cod_fabricante = fabricante.codigo;

/* 6. Crea una vista con el nombre vista_fabricante_productos que tenga las siguientes columnas: nombre_fabricante, nombre_producto y precio. */

create view vista_fabricante_productosque as
select nombre_fabricante, nombre_producto, precio
from fabricante_productos;

/* 7. Elimina el fabricante Asus. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo? */
/*no*/

alter table producto
drop foreign key producto_ibfk_1;

alter table producto
add constraint producto_ibfk_1 
    foreign key (cod_fabricante)
    references fabricante(codigo)
    on delete cascade
    on update cascade;

delete from fabricante
where nombre = "Asus";
/* Ahora sí*/

/* 8. Elimina el fabricante Xiaomi. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo? */

delete from fabricante
where nombre = "xiaomi";
/* si */

/* 9. Actualiza el código del fabricante Lenovo y asígnale el valor 20. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo? */

update fabricante
set codigo=20
where nombre="Lenovo";
/* si */

/* 10. Actualiza el código del fabricante Huawei y asígnale el valor 30. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo? */

update fabricante
set codigo=30
where nombre="Huawei";
/* si */

/* 11. Actualiza el precio de todos los productos sumándole 5 € al precio actual. */

update producto
set precio = (precio + 5);

/* 12. Elimina todas las impresoras que tienen un precio menor de 200 €. */

delete from producto
where nombre like "%impresora%" and precio < 200;