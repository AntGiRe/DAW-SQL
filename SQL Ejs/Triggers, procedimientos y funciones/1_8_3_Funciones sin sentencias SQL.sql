/* Antonio Jesús Gil Reyes*/
/* 1.8.3 Funciones sin sentencias SQL */

/* 1. Escribe una función que reciba un número entero de entrada y devuelva TRUE si el número es par o FALSE en caso contrario. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio1$$
CREATE FUNCTION ejercicio1(numero int unsigned)
  RETURNS BOOLEAN
BEGIN

  DECLARE resultado BOOLEAN;

  IF numero%2=0
  THEN
	SET resultado = true;
  ELSE
	SET resultado = false;
  END IF;

  RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio1(2);

/* 2. Escribe una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de sus lados. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio2$$
CREATE FUNCTION ejercicio2(lado1 int unsigned, lado2 int unsigned)
  RETURNS DOUBLE
BEGIN

  DECLARE resultado DOUBLE;

  SET resultado = sqrt(pow(lado1,2) + pow(lado2,2));

  RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio2(2,6);

/* 3. Escribe una función que reciba como parámetro de entrada un valor numérico que represente un día 
de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. 
Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio3$$
CREATE FUNCTION ejercicio3(numero int unsigned)
  RETURNS VARCHAR(30)
BEGIN

	DECLARE resultado VARCHAR(30);

	CASE
		WHEN numero=1
		THEN
			SET resultado = "Lunes";
		WHEN numero=2
		THEN
			SET resultado = "Martes";
		WHEN numero=3
		THEN
			SET resultado = "Miércoles";
		WHEN numero=4
		THEN
			SET resultado = "Jueves";
		WHEN numero=5
		THEN
			SET resultado = "Viernes";
		WHEN numero=6
		THEN
			SET resultado = "Sábado";
		WHEN numero=7
		THEN
			SET resultado = "Domingo";
		ELSE SET resultado = "Día erróneo";
	END CASE;

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio3(2);

/* 4. Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el mayor de los tres. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio4$$
CREATE FUNCTION ejercicio4(valor1 double, valor2 double, valor3 double)
  RETURNS DOUBLE
BEGIN

  DECLARE resultado DOUBLE;

  IF valor1>valor2
  THEN
	
    IF valor1>valor3
    THEN
		SET resultado = valor1;
    END IF;
    
  ELSE
	IF valor2>valor3
    THEN
		SET resultado = valor2;
    ELSE
		SET resultado = valor3;
    END IF;
  END IF;

  RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio4(12,45,8);

/* 5. Escribe una función que devuelva el valor del área de un círculo a partir del valor del radio que se recibirá como parámetro de entrada. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio5$$
CREATE FUNCTION ejercicio5(radio double)
  RETURNS DOUBLE
BEGIN

	DECLARE resultado DOUBLE;

	SET resultado = pi() * pow(radio,2);

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio5(10);

/* 6. Escribe una función que devuelva como salida el número de años que han transcurrido entre dos fechas que se reciben como parámetros de entrada. 
Por ejemplo, si pasamos como parámetros de entrada las fechas 2018-01-01 y 2008-01-01 la función tiene que devolver que han pasado 10 años. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio6$$
CREATE FUNCTION ejercicio6(fecha1 date, fecha2 date)
  RETURNS DOUBLE
BEGIN

	DECLARE resultado DOUBLE;

	SET resultado = datediff(fecha1, fecha2)/365;

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio6(20180101,20080101);

/* 7. Escribe una función que reciba una cadena de entrada y devuelva la misma cadena pero sin acentos. 
La función tendrá que reemplazar todas las vocales que tengan acento por la misma vocal pero sin acento. 
Por ejemplo, si la función recibe como parámetro de entrada la cadena María la función debe devolver la cadena Maria. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio6$$
CREATE FUNCTION ejercicio6(cadena varchar(30))
  RETURNS VARCHAR(30)
BEGIN

	DECLARE resultado VARCHAR(30);

	SET resultado = REPLACE(lower(cadena), 'á', 'a');
    SET resultado = REPLACE(resultado, 'é', 'e');
    SET resultado = REPLACE(resultado, 'í', 'i');
    SET resultado = REPLACE(resultado, 'ó', 'o');
    SET resultado = REPLACE(resultado, 'ú', 'u');

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio6("MaTÉ");
