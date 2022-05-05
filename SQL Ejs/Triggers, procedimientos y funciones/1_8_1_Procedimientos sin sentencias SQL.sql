/* Antonio Jesús Gil Reyes */
/* 1.8.1 Procedimientos sin sentencias SQL */

drop database if exists test;
create database test;
use test;

/* 1. Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto ¡Hola mundo!. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio1$$
CREATE PROCEDURE ejercicio1()
BEGIN
  SELECT "¡Hola mundo!";
END
$$

DELIMITER ;
call ejercicio1;

/* 2. Escribe un procedimiento que reciba un número real de entrada y muestre un mensaje indicando si el número es positivo, negativo o cero. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio2$$
CREATE PROCEDURE ejercicio2(in numero double)
BEGIN

	IF numero>0 
    THEN
		select "Positivo";
	ELSE IF numero<0
	THEN
		select "Negativo";
	ELSE
		select "Cero";
    END IF;
	END IF;
END
$$

DELIMITER ;
call ejercicio2(-4.5);

/* 3. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, 
con el valor un número real, y un parámetro de salida, con una cadena de caracteres indicando si el número es positivo, negativo o cero. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio3$$
CREATE PROCEDURE ejercicio3(in numero double, out salidaNum varchar(30))
BEGIN

	IF numero>0 
    THEN
		SET salidaNum = "Positivo";
	ELSE IF numero<0
	THEN
		SET salidaNum = "Negativo";
	ELSE
		SET salidaNum = "Cero";
    END IF;
	END IF;
END
$$

DELIMITER ;
call ejercicio3(-4.5, @resultado);
select @resultado;

/* 4. Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de un alumno, 
y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes condiciones: */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio4$$
CREATE PROCEDURE ejercicio4(in numero double)
BEGIN

	IF numero>=9 and numero<=10 
    THEN
		select "Sobresaliente";
	ELSE IF numero<9 and numero>=7
	THEN
		select "Notable";
	ELSE IF numero<7 and numero>=6
    THEN
		select "Bien";
	ELSE IF numero<6 and numero>=5
    THEN
		select "Aprobado";
	ELSE IF numero<5 and numero>=0
    THEN
		select "Insuficiente";
	ELSE
		select "La nota no es válida";
    END IF;
    END IF;
	END IF;
    END IF;
	END IF;
END
$$

DELIMITER ;
call ejercicio4(10);

/* 5. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor de la nota en formato 
numérico y un parámetro de salida, con una cadena de texto indicando la nota correspondiente. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio4$$
CREATE PROCEDURE ejercicio4(in numero double, out salidaNum varchar(30))
BEGIN

	IF numero>=9 and numero<=10 
    THEN
		SET salidaNum = "Sobresaliente";
	ELSE IF numero<9 and numero>=7
	THEN
		SET salidaNum = "Notable";
	ELSE IF numero<7 and numero>=6
    THEN
		SET salidaNum = "Bien";
	ELSE IF numero<6 and numero>=5
    THEN
		SET salidaNum = "Aprobado";
	ELSE IF numero<5 and numero>=0
    THEN
		SET salidaNum = "Insuficiente";
	ELSE
		SET salidaNum = "La nota no es válida";
    END IF;
    END IF;
	END IF;
    END IF;
	END IF;
END
$$

DELIMITER ;
call ejercicio4(10, @resultado);
select @resultado;

/* 6. Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio6$$
CREATE PROCEDURE ejercicio6(in numero double, out salidaNum varchar(30))
BEGIN

	CASE
		WHEN (numero>=9 and numero<=10)
		THEN
			SET salidaNum = "Sobresaliente";
		WHEN (numero<9 and numero>=7)
		THEN
			SET salidaNum = "Notable";
		WHEN (numero<7 and numero>=6)
		THEN
			SET salidaNum = "Bien";
		WHEN (numero<6 and numero>=5)
		THEN
			SET salidaNum = "Aprobado";
		WHEN (numero<5 and numero>=0)
		THEN
			SET salidaNum = "Insuficiente";
		WHEN numero>10
		THEN
			SET salidaNum = "La nota no es válida";
	END CASE;
END
$$

DELIMITER ;
call ejercicio6(10, @resultado);
select @resultado;

/* 7. Escribe un procedimiento que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva 
una cadena de caracteres con el nombre del día de la semana correspondiente. 
Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio7$$
CREATE PROCEDURE ejercicio7(in numero double, out salidaSemana varchar(30))
BEGIN

	CASE
		WHEN numero=1
		THEN
			SET salidaSemana = "Lunes";
		WHEN numero=2
		THEN
			SET salidaSemana = "Martes";
		WHEN numero=3
		THEN
			SET salidaSemana = "Miércoles";
		WHEN numero=4
		THEN
			SET salidaSemana = "Jueves";
		WHEN numero=5
		THEN
			SET salidaSemana = "Viernes";
		WHEN numero=6
		THEN
			SET salidaSemana = "Sábado";
		WHEN numero=7
		THEN
			SET salidaSemana = "Domingo";
		ELSE SET salidaSemana = "Día erróneo";
	END CASE;
END
$$

DELIMITER ;
call ejercicio7(8, @resultado);
select @resultado;
