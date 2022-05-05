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
    fecha_nacimiento date
);

insert into alumnos values (1,"n1","a1","a2",20020410);
insert into alumnos values (2,"n1","a1","a2",20020410);
insert into alumnos values (3,"n1","a1","a2",20020410);
insert into alumnos values (4,"n1","a1","a2",20020410);
insert into alumnos values (5,"n1","a1","a2",20020410);


/* 2. Modifica la tabla alumnos del ejercicio anterior para añadir una nueva columna email. 
Una vez que hemos modificado la tabla necesitamos asignarle una dirección de correo electrónico de forma automática.*/

alter table alumnos add email varchar(100);

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

delimiter $$
drop procedure if exists actualizar_columna_email$$
create procedure actualizar_columna_email()
begin
	declare id int;
    declare email varchar(100);
    declare nombre varchar(100);
    declare apellido1 varchar(100);
    declare apellido2 varchar(100);
    declare done boolean default false;
    
    declare cursor_email cursor for (select alumnos.id, alumnos.email, alumnos.nombre, alumnos.apellido1, alumnos.apellido2 from alumnos);
    
    declare continue handler for not found set done = true;
    
    open cursor_email;
    
    read_loop: loop
		fetch cursor_email INTO id, email, nombre, apellido1, apellido2;
        
		IF done THEN
			LEAVE read_loop;
		END IF;
        
        call crear_email(nombre, apellido1, apellido2, "gmail.com", @email);
        
        update alumnos set alumnos.email = @email
        where alumnos.id = id;
        
    END LOOP;
    
    close cursor_email;
end;

call actualizar_columna_email();

select * from alumnos;