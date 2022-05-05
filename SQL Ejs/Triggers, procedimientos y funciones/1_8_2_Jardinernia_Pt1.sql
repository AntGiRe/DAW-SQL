/* Antonio Jesús Gil Reyes */
/* 1.8.2 Procedimientos con sentencias SQL - Jardineria Pt. 1 */
use jardineria;

/* 1. Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada y 
realice una consulta sobre la tabla cliente para obtener todos los clientes que existen en la tabla de ese país. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio1$$
CREATE PROCEDURE ejercicio1(in pais varchar(20))
BEGIN
  SELECT *
  FROM cliente
  WHERE pais = cliente.pais;
END
$$

DELIMITER ;
call ejercicio1("Spain");

/* 2. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres 
(Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida el pago de máximo valor realizado para esa forma de pago. 
Deberá hacer uso de la tabla pago de la base de datos jardineria. */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio2$$
CREATE PROCEDURE ejercicio2(in formaPago varchar(20))
BEGIN
  SELECT max(total)
  FROM pago
  WHERE formaPago = pago.forma_pago;
END
$$

DELIMITER ;
call ejercicio2("Paypal");

/* 3. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres 
(Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida los siguientes valores teniendo en cuenta la forma de pago 
seleccionada como parámetro de entrada: el pago de máximo valor, el pago de mínimo valor, el valor medio de los pagos realizados,
la suma de todos los pagos, el número de pagos realizados para esa forma de pago*/
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio3$$
CREATE PROCEDURE ejercicio3(in formaPago varchar(20), out pagoMax NUMERIC(15,2), out pagoMin NUMERIC(15,2), out valorMedio NUMERIC(15,2), out sumPago NUMERIC(15,2), out numPagos int)
BEGIN
	SET pagoMax = (
		SELECT max(total)
		FROM pago
		WHERE formaPago = pago.forma_pago
    );
    
    SET pagoMin = (
		SELECT min(total)
		FROM pago
		WHERE formaPago = pago.forma_pago
    );
    
    SET valorMedio = (
		SELECT avg(total)
		FROM pago
		WHERE formaPago = pago.forma_pago
    );
    
    SET sumPago = (
		SELECT sum(total)
		FROM pago
		WHERE formaPago = pago.forma_pago
    );
    
    SET numPagos = (
		SELECT count(total)
		FROM pago
		WHERE formaPago = pago.forma_pago
    );
    
END
$$

DELIMITER ;
call ejercicio3("Paypal",@pagoMax, @pagoMin, @valorMedio, @sumPago, @numPagos);