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

/* Una vez creada la tabla se decide añadir una nueva columna a la tabla llamada edad que será un valor calculado a 
partir de la columna fecha_nacimiento. Escriba la sentencia SQL necesaria para modificar la tabla y añadir la nueva columna */

alter table alumnos
add edad int unsigned;

/* Escriba una función llamada calcular_edad que reciba una fecha y devuelva el número de años que han
pasado desde la fecha actual hasta la fecha pasada como parémetro:
• Función: calcular_edad
• Entrada: Fecha
• Salida: Número de años (entero)
*/
delimiter $$
drop function if exists calcular_edad$$
create function calcular_edad(fecha date)
returns int unsigned

begin

declare total int UNSIGNED;

set total = (Select (DATEDIFF(now(), fecha))/360);
 
return total;
end
$$

/* Ahora escriba un procedimiento que permita calcular la edad de todos los alumnmos que ya existen en la tabla.
Para esto será necesario crear un procedimiento llamado actualizar_columna_edad que calcule la edad
de cada alumno y actualice la tabla. Este procedimiento hará uso de la función calcular_edad que hemos
creado en el paso anterior. */
delimiter $$
drop procedure if exists actualizar_columna_edad$$
create procedure actualizar_columna_edad()
begin
	declare id int;
    declare fecha_nacimiento date;
    declare done boolean default false;
    
    declare cursor_edad cursor for (select alumnos.id, alumnos.fecha_nacimiento from alumnos);
    
    declare continue handler for not found set done = true;
    
    open cursor_edad;
    
    read_loop: loop
		fetch cursor_edad INTO id, fecha_nacimiento;
        
		IF done THEN
			LEAVE read_loop;
		END IF;
        
        update alumnos set alumnos.edad = calcular_edad(fecha_nacimiento)
        where alumnos.id = id;
        
    END LOOP;
    
    close cursor_edad;
end;

call actualizar_columna_edad();
select * from alumnos;
