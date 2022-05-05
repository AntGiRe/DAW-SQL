/* Antonio Jesús Gil Reyes */
/* 1.8.7 Cursores */

/* 1. Escribe las sentencias SQL necesarias para crear una base de datos llamada test,una tabla llamada alumnos 
y 4 sentencias de inserción para inicializar la tabla. Latabla alumnos está formada por las siguientes columnas:
id (entero sin signo y clave primaria)
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
fecha_nacimiento (fecha) */

drop database if exists test;
create database test;
use test;

create table alumnos(
	id int unsigned primary key,
    nombre varchar(50),
    apellido1 varchar(50),
    apellido2 varchar(50),
    email varchar(100)
);

/* Escriba un procedimiento llamado crear_email que dados los parámetros de entrada: nombre, apellido1,
apellido2 y dominio, cree una dirección de email y la devuelva como salida.
Entrada:
– nombre (cadena de caracteres)
– apellido1 (cadena de caracteres)
– apellido2 (cadena de caracteres)
– dominio (cadena de caracteres)
• Salida:
– email (cadena de caracteres)
devuelva una dirección de correo electrónico con el siguiente formato:
• El primer carácter del parámetro nombre.
• Los tres primeros caracteres del parámetro apellido1.
• Los tres primeros caracteres del parámetro apellido2.
• El carácter @.
• El dominio pasado como parámetro.
*/

delimiter $$
drop procedure if exists crear_email$$
create procedure crear_email(in nombre varchar(50), in apellido1 varchar(50), in apellido2 varchar(50), in dominio varchar(50), out email varchar(100))
begin
	set email = concat(substring(nombre,1,1),substring(apellido1,1,3),substring(apellido2,1,3),"@",dominio);
end $$;

/* Una vez creada la tabla escriba un trigger con las siguientes características:
• Trigger: trigger_crear_email_before_insert
– Se ejecuta sobre la tabla alumnos.
– Se ejecuta antes de una operación de inserción.
– Si el nuevo valor del email que se quiere insertar es NULL, entonces se le creará automáticamente
una dirección de email y se insertará en la tabla.
– Si el nuevo valor del email no es NULL se guardará en la tabla el valor del email. */
delimiter $$
drop trigger if exists trigger_crear_email_before_insert$$
create trigger trigger_crear_email_before_insert
before insert on alumnos for each row
begin
	declare email varchar(100);
    declare dominio varchar(50);
		set dominio = "gmail.com";
        
    if new.email is null then
		call crear_email(new.nombre,new.apellido1,new.apellido2,dominio,@email);
        set new.email = @email;
	end if;
end;

insert into alumnos values (1,"n1","a1","a2",null);
insert into alumnos values (2,"n1","a1","a2",null);
insert into alumnos values (3,"n1","a1","a2",null);
insert into alumnos values (4,"n1","a1","a2",null);
insert into alumnos values (5,"n1","a1","a2",null);

select * from alumnos;