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

/* La tabla log_alumnos_eliminados contiene los siguientes campos:
• id: clave primaria (entero autonumérico)
• id_alumno: id del alumno (entero)
• fecha_hora: marca de tiempo con el instante del cambio (fecha y hora)
• nombre: nombre del alumno eliminado (cadena de caracteres)
• apellido1: primer apellido del alumno eliminado (cadena de caracteres)
• apellido2: segundo apellido del alumno eliminado (cadena de caracteres)
• email: email del alumno eliminado (cadena de caracteres)
*/

create table log_alumnos_eliminados (
id int unsigned auto_increment primary key,
id_alumno int unsigned,
fecha_hora timestamp,
nombre varchar(50) not null,
apellido1 varchar(50) not null,
apellido2 varchar(50),
email varchar(100)
);

/* Trigger: trigger_guardar_alumnos_eliminados:
• Se ejecuta sobre la tabla alumnos.
• Se ejecuta después de una operación de borrado.
• Cada vez que se elimimie un alumno de la tabla alumnos se deberá insertar un nuevo registro en una
tabla llamada log_alumnos_eliminados.
*/
delimiter $$
drop trigger if exists  trigger_guardar_alumnos_eliminados$$
create trigger  trigger_guardar_alumnos_eliminados
after delete on alumnos for each row
begin
	insert into log_alumnos_eliminados values ("",old.id,now(),old.nombre,old.apellido1,old.apellido2,old.email);
end;

insert into alumnos values (1,"n1","a1","a2",null);
insert into alumnos values (2,"n1","a1","a2",null);

delete from alumnos where id=1;
select * from alumnos;
select * from log_alumnos_eliminados;