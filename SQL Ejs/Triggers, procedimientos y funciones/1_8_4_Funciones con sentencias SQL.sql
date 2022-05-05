/* Antonio Jesús Gil Reyes */
/* 1.8.4 Funciones con sentencias SQL */

use tienda;

/* 1. Escribe una función para la base de datos tienda que devuelva el número total de productos que hay en la tabla productos. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio1$$
CREATE FUNCTION ejercicio1()
  RETURNS INT UNSIGNED
BEGIN

	DECLARE resultado INT UNSIGNED;

	SET resultado = (
    SELECT count(*) FROM producto
    );

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio1();

/* 2. Escribe una función para la base de datos tienda que devuelva el valor medio del precio de los productos de un determinado 
fabricante que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio2$$
CREATE FUNCTION ejercicio2(nombreFabricante VARCHAR(50))
  RETURNS DOUBLE
BEGIN

	DECLARE resultado DOUBLE;

	SET resultado = (
    SELECT avg(precio) 
    FROM producto INNER JOIN fabricante
    ON producto.cod_fabricante = fabricante.codigo
    WHERE nombreFabricante = fabricante.nombre
    );

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio2("Asus");

/* 3. Escribe una función para la base de datos tienda que devuelva el valor máximo del precio de los productos de un determinado 
fabricante que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio3$$
CREATE FUNCTION ejercicio3(nombreFabricante VARCHAR(50))
  RETURNS DOUBLE
BEGIN

	DECLARE resultado DOUBLE;

	SET resultado = (
    SELECT max(precio) 
    FROM producto INNER JOIN fabricante
    ON producto.cod_fabricante = fabricante.codigo
    WHERE nombreFabricante = fabricante.nombre
    );

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio3("Asus");

/* 4 Escribe una función para la base de datos tienda que devuelva el valor mínimo del precio de los productos de un 
determinado fabricante que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante. */
DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio4$$
CREATE FUNCTION ejercicio4(nombreFabricante VARCHAR(50))
  RETURNS DOUBLE
BEGIN

	DECLARE resultado DOUBLE;

	SET resultado = (
    SELECT min(precio) 
    FROM producto INNER JOIN fabricante
    ON producto.cod_fabricante = fabricante.codigo
    WHERE nombreFabricante = fabricante.nombre
    );

	RETURN resultado;
END
$$

DELIMITER ;
SELECT ejercicio4("Asus");