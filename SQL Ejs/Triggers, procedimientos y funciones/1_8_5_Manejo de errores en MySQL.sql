/* Antonio Jesús Gil Reyes */
/* 1.8.5 Manejo de errores en MySQL */

/* 1. Crea una base de datos llamada test que contenga una tabla llamada alumno. La tabla debe tener cuatro columnas: id: entero sin signo (clave primaria), 
nombre: cadena de 50 caracteres, apellido1: cadena de 50 caracteres, apellido2: cadena de 50 caracteres.*/
drop database if exists test;
create database test;
use test;

create table alumno(
	id int unsigned primary key,
    nombre varchar(50),
    apellido1 varchar(50),
    apellido2 varchar(50)
);

/* Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado insertar_alumno con las siguientes características. El procedimiento 
recibe cuatro parámetros de entrada (id, nombre, apellido1, apellido2) y los insertará en la tabla alumno. El procedimiento devolverá como salida un 
parámetro llamado error que tendrá un valor igual a 0 si la operación se ha podido realizar con éxito y un valor igual a 1 en caso contrario.
Deberá manejar los errores que puedan ocurrir cuando se intenta insertar una fila que contiene una clave primaria repetida. */
DELIMITER $$
DROP PROCEDURE IF EXISTS insertar_alumno$$
CREATE PROCEDURE insertar_alumno(in id int unsigned, in nombre varchar(50), in apellido1 varchar(50), in apellido2 varchar(50), out error boolean)
BEGIN
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET error = true;
    
	INSERT INTO alumno VALUES(id,nombre,apellido1,apellido2);
    SET error = false;
  
END
$$

DELIMITER ;
call insertar_alumno(1,"nombre","apellido1","apellido2",@resultado);

select @resultado;
