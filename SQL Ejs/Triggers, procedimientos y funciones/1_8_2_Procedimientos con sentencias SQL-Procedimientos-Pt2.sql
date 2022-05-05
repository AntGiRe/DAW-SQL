/* Antonio Jesús Gil Reyes */
/* 1.8.2 Procedimientos con sentencias SQL */

/* 4. Crea una base de datos llamada procedimientos que contenga una tabla llamada cuadrados. 
La tabla cuadrados debe tener dos columnas de tipo INT UNSIGNED, una columna llamada número y otra columna llamada cuadrado. */
drop database if exists procedimientos;
create database procedimientos;
use procedimientos;

create table cuadrados (
	numero int unsigned,
	cuadrado int unsigned
);

/* Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_cuadrados con las siguientes características. 
El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y calculará el valor de los cuadrados de los 
primeros números naturales hasta el valor introducido como parámetro. El valor del números y de sus cuadrados deberán ser almacenados 
en la tabla cuadrados que hemos creado previamente.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los nuevos valores de los cuadrados 
que va a calcular.
Utilice un bucle WHILE para resolver el procedimiento. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_cuadrados$$
CREATE PROCEDURE calcular_cuadrados(in tope int unsigned)
BEGIN
    
	DECLARE contador int;
	SET contador = 1;
    
    TRUNCATE TABLE cuadrados;
    
	WHILE contador <= tope DO
		insert into cuadrados values(contador,pow(contador,2));
        SET contador = contador + 1;
	END WHILE;
  
END
$$

DELIMITER ;
call calcular_cuadrados(5);

select * from cuadrados;

/* 5. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_cuadrados$$
CREATE PROCEDURE calcular_cuadrados(in tope int unsigned)
BEGIN

	DECLARE contador int;
	SET contador = 1;
    
    TRUNCATE TABLE cuadrados;
    
	REPEAT
		insert into cuadrados values(contador,pow(contador,2));
        SET contador = contador + 1;
	UNTIL contador > tope
	END REPEAT;
  
END
$$

DELIMITER ;
call calcular_cuadrados(5);

select * from cuadrados;

/* 6. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_cuadrados$$
CREATE PROCEDURE calcular_cuadrados(in tope int unsigned)
BEGIN

	DECLARE contador int;
	SET contador = 1;
    
    TRUNCATE TABLE cuadrados;
    
	bucle: LOOP
    IF contador > tope THEN
      LEAVE bucle;
    END IF;

		insert into cuadrados values(contador,pow(contador,2));
        SET contador = contador + 1;
	END LOOP;
  
END
$$

DELIMITER ;
call calcular_cuadrados(5);

select * from cuadrados;

/* 7. Crea una base de datos llamada procedimientos que contenga una tabla llamada ejercicio. 
La tabla debe tener una única columna llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED. */
create table ejercicio(
	numero int unsigned
);

/* Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_números con las siguientes características. 
El procedimiento recibe un parámetro de entrada llamado valor_inicial de tipo INT UNSIGNED y deberá almacenar en la 
tabla ejercicio toda la secuencia de números desde el valor inicial pasado como entrada hasta el 1.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.
Utilice un bucle WHILE para resolver el procedimiento. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_numeros$$
CREATE PROCEDURE calcular_numeros(in valor_inicial int unsigned)
BEGIN
    
    TRUNCATE TABLE ejercicio;
    
    WHILE valor_inicial <> 0 DO
		insert into ejercicio values(valor_inicial);
        SET valor_inicial = valor_inicial - 1;
	END WHILE;
  
END
$$

DELIMITER ;
call calcular_numeros(13);

select * from ejercicio;

/* 8. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_numeros$$
CREATE PROCEDURE calcular_numeros(in valor_inicial int unsigned)
BEGIN
    
    TRUNCATE TABLE ejercicio;
    
    REPEAT
		insert into ejercicio values(valor_inicial);
        SET valor_inicial = valor_inicial - 1;
	UNTIL valor_inicial = 0
	END REPEAT;
  
END
$$

DELIMITER ;
call calcular_numeros(13);

select * from ejercicio;

/* 9. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_numeros$$
CREATE PROCEDURE calcular_numeros(in valor_inicial int unsigned)
BEGIN
    
    TRUNCATE TABLE ejercicio;
    
    bucle: LOOP
    IF valor_inicial = 0 THEN
      LEAVE bucle;
    END IF;

		insert into ejercicio values(valor_inicial);
        SET valor_inicial = valor_inicial - 1;
	END LOOP;
  
END
$$

DELIMITER ;
call calcular_numeros(13);

select * from ejercicio;

/* 10. Crea una base de datos llamada procedimientos que contenga una tabla llamada pares y otra tabla llamada impares. 
Las dos tablas deben tener única columna llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED.*/
create table pares(
	numero int unsigned
);

create table impares(
	numero int unsigned
);

/* Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado calcular_pares_impares con las siguientes características. 
El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y deberá almacenar 
en la tabla pares aquellos números pares que existan entre el número 1 el valor introducido como parámetro. 
Habrá que realizar la misma operación para almacenar los números impares en la tabla impares.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.
Utilice un bucle WHILE para resolver el procedimiento. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_pares_impares$$
CREATE PROCEDURE calcular_pares_impares(in tope int unsigned)
BEGIN

	DECLARE	numero INT;
    SET numero = 1;
    
    TRUNCATE TABLE pares;
    TRUNCATE TABLE impares;
    
    WHILE numero <= tope DO
    
		IF (numero%2) = 0
        THEN
			insert into pares values(numero);
		ELSE
			insert into impares values(numero);
        END IF;

        SET numero = numero + 1;
	END WHILE;
  
END
$$

DELIMITER ;
call calcular_pares_impares(13);

select * from pares;
select * from impares;

/* 11. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_pares_impares$$
CREATE PROCEDURE calcular_pares_impares(in tope int unsigned)
BEGIN

	DECLARE	numero INT;
    SET numero = 1;
    
    TRUNCATE TABLE pares;
    TRUNCATE TABLE impares;
    
    REPEAT
		
        IF (numero%2) = 0
        THEN
			insert into pares values(numero);
		ELSE
			insert into impares values(numero);
        END IF;
        
        SET numero = numero + 1;
	UNTIL numero > tope
	END REPEAT;
  
END
$$

DELIMITER ;
call calcular_pares_impares(13);

select * from pares;
select * from impares;

/* 12. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior. */
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_pares_impares$$
CREATE PROCEDURE calcular_pares_impares(in tope int unsigned)
BEGIN

	DECLARE	numero INT;
    SET numero = 1;
    
    TRUNCATE TABLE pares;
    TRUNCATE TABLE impares;
    
    bucle: LOOP
    IF numero > tope THEN
      LEAVE bucle;
    END IF;

		IF (numero%2) = 0
        THEN
			insert into pares values(numero);
		ELSE
			insert into impares values(numero);
        END IF;
        
        SET numero = numero + 1;
	END LOOP;
  
END
$$

DELIMITER ;
call calcular_pares_impares(13);

select * from pares;
select * from impares;