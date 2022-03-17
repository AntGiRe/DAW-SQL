DROP DATABASE IF EXISTS empleados;
CREATE DATABASE empleados CHARACTER SET utf8mb4;
USE empleados;

CREATE TABLE departamento (
  codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  presupuesto DOUBLE UNSIGNED NOT NULL,
  gastos DOUBLE UNSIGNED NOT NULL
);

CREATE TABLE empleado (
  codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nif VARCHAR(9) NOT NULL UNIQUE,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  codigo_departamento INT UNSIGNED,
  FOREIGN KEY (codigo_departamento) REFERENCES departamento(codigo)
);

INSERT INTO departamento VALUES(1, 'Desarrollo', 120000, 6000);
INSERT INTO departamento VALUES(2, 'Sistemas', 150000, 21000);
INSERT INTO departamento VALUES(3, 'Recursos Humanos', 280000, 25000);
INSERT INTO departamento VALUES(4, 'Contabilidad', 110000, 3000);
INSERT INTO departamento VALUES(5, 'I+D', 375000, 380000);
INSERT INTO departamento VALUES(6, 'Proyectos', 0, 0);
INSERT INTO departamento VALUES(7, 'Publicidad', 0, 1000);

INSERT INTO empleado VALUES(1, '32481596F', 'Aarón', 'Rivero', 'Gómez', 1);
INSERT INTO empleado VALUES(2, 'Y5575632D', 'Adela', 'Salas', 'Díaz', 2);
INSERT INTO empleado VALUES(3, 'R6970642B', 'Adolfo', 'Rubio', 'Flores', 3);
INSERT INTO empleado VALUES(4, '77705545E', 'Adrián', 'Suárez', NULL, 4);
INSERT INTO empleado VALUES(5, '17087203C', 'Marcos', 'Loyola', 'Méndez', 5);
INSERT INTO empleado VALUES(6, '38382980M', 'María', 'Santana', 'Moreno', 1);
INSERT INTO empleado VALUES(7, '80576669X', 'Pilar', 'Ruiz', NULL, 2);
INSERT INTO empleado VALUES(8, '71651431Z', 'Pepe', 'Ruiz', 'Santana', 3);
INSERT INTO empleado VALUES(9, '56399183D', 'Juan', 'Gómez', 'López', 2);
INSERT INTO empleado VALUES(10, '46384486H', 'Diego','Flores', 'Salas', 5);
INSERT INTO empleado VALUES(11, '67389283A', 'Marta','Herrera', 'Gil', 1);
INSERT INTO empleado VALUES(12, '41234836R', 'Irene','Salas', 'Flores', NULL);
INSERT INTO empleado VALUES(13, '82635162B', 'Juan Antonio','Sáez', 'Guerrero', NULL);

/* 1. Lista el primer apellido de todos los empleados. */
select apellido1
from empleado;

/* 2. Lista el primer apellido de los empleados eliminando los apellidos que estén repetidos. */
select distinct apellido1
from empleado;

/* 3. Lista todas las columnas de la tabla empleado. */
select *
from empleado;

/* 4. Lista el nombre y los apellidos de todos los empleados. */
select nombre, apellido1, apellido2
from empleado;

/* 5. Lista el código de los departamentos de los empleados que aparecen en la tabla empleado. */
select codigo_departamento
from empleado;

/* 6. Lista el código de los departamentos de los empleados que aparecen en la tabla empleado, eliminando los códigos que aparecen repetidos. */
select distinct codigo_departamento
from empleado;

/* 7. Lista el nombre y apellidos de los empleados en una única columna. */
select concat_ws(' ', nombre, apellido1, apellido2) as "Nombre y apellidos"
from empleado;

/* 8. Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los caracteres en mayúscula. */
select upper(concat_ws(' ', nombre, apellido1, apellido2)) as "Nombre y apellidos"
from empleado;

/* 9. Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los caracteres en minúscula. */
select lower(concat_ws(' ', nombre, apellido1, apellido2)) as "Nombre y apellidos"
from empleado;

/* 10. Lista el código de los empleados junto al nif, pero el nif deberá aparecer en dos columnas, 
una mostrará únicamente los dígitos del nif y la otra la letra. */
select codigo, substr(nif, 1, 8), substr(nif, 9, 9)
from empleado;

/* 11. Lista el nombre de cada departamento y el valor del presupuesto actual del que dispone. 
Para calcular este dato tendrá que restar al valor del presupuesto inicial (columna presupuesto) los gastos que se han generado (columna gastos). 
Tenga en cuenta que en algunos casos pueden existir valores negativos. Utilice un alias apropiado para la nueva columna columna que está calculando.*/
select nombre, (presupuesto-gastos) as "Presupuesto actual"
from departamento;

/* 12. Lista el nombre de los departamentos y el valor del presupuesto actual ordenado de forma ascendente. */
select nombre, (presupuesto-gastos) as "Presupuesto actual"
from departamento
order by 2;

/* 13. Lista el nombre de todos los departamentos ordenados de forma ascendente. */
select nombre
from departamento
order by 1;

/* 14. Lista el nombre de todos los departamentos ordenados de forma descendiente. */
select nombre
from departamento
order by 1 desc;

/* 15. Lista los apellidos y el nombre de todos los empleados, ordenados de forma alfabética tendiendo en cuenta en primer lugar sus apellidos y luego su nombre. */
select apellido1, apellido2, nombre
from empleado
order by 1,2,3;

/* 16. Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos que tienen mayor presupuesto. */
select nombre, presupuesto
from departamento
order by 2 desc
limit 3;

/* 17. Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos que tienen menor presupuesto. */
select nombre, presupuesto
from departamento
order by 2
limit 3;

/* 18. Devuelve una lista con el nombre y el gasto, de los 2 departamentos que tienen mayor gasto. */
select nombre, gastos
from departamento
order by 2 desc
limit 2;

/* 19. Devuelve una lista con el nombre y el gasto, de los 2 departamentos que tienen menor gasto. */
select nombre, gastos
from departamento
order by 2
limit 2;

/* 20. Devuelve una lista con 5 filas a partir de la tercera fila de la tabla empleado. La tercera fila se debe incluir en la respuesta. 
La respuesta debe incluir todas las columnas de la tabla empleado. */
select *
from empleado
limit 2,5;

/* 21. Devuelve una lista con el nombre de los departamentos y el presupuesto, de aquellos que tienen un presupuesto mayor o igual a 150000 euros. */
select nombre, presupuesto
from departamento
where presupuesto >= 150000;

/* 22. Devuelve una lista con el nombre de los departamentos y el gasto, de aquellos que tienen menos de 5000 euros de gastos. */
select nombre, gastos
from departamento
where gastos< 5000;

/* 23. Devuelve una lista con el nombre de los departamentos y el presupesto, de aquellos que tienen un presupuesto entre 100000 y 200000 euros. 
Sin utilizar el operador BETWEEN. */
select nombre, presupuesto
from departamento
where presupuesto >= 100000 and presupuesto <= 200000;

/* 24. Devuelve una lista con el nombre de los departamentos que no tienen un presupuesto entre 100000 y 200000 euros. 
Sin utilizar el operador BETWEEN. */
select nombre, presupuesto
from departamento
where presupuesto < 100000 or presupuesto > 200000;

/* 25. Devuelve una lista con el nombre de los departamentos que tienen un presupuesto entre 100000 y 200000 euros. 
Utilizando el operador BETWEEN. */
select nombre, presupuesto
from departamento
where presupuesto between 100000 and 200000;

/* 26. Devuelve una lista con el nombre de los departamentos que no tienen un presupuesto entre 100000 y 200000 euros. 
Utilizando el operador BETWEEN. */
select nombre, presupuesto
from departamento
where presupuesto not between 100000 and 200000;

/* 27. Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, 
de quellos departamentos donde los gastos sean mayores que el presupuesto del que disponen. */
select nombre, gastos, presupuesto
from departamento
where gastos > presupuesto;

/* 28. Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, 
de aquellos departamentos donde los gastos sean menores que el presupuesto del que disponen. */
select nombre, gastos, presupuesto
from departamento
where gastos < presupuesto;

/* 29. Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, 
de aquellos departamentos donde los gastos sean iguales al presupuesto del que disponen. */
select nombre, gastos, presupuesto
from departamento
where gastos = presupuesto;

/* 30. Lista todos los datos de los empleados cuyo segundo apellido sea NULL. */
select *
from empleado
where apellido2 is null;

/* 31. Lista todos los datos de los empleados cuyo segundo apellido no sea NULL. */
select *
from empleado
where apellido2 is not null;

/* 32. Lista todos los datos de los empleados cuyo segundo apellido sea López. */
select *
from empleado
where apellido2 like "Lopez";

/* 33. Lista todos los datos de los empleados cuyo segundo apellido sea Díaz o Moreno. Sin utilizar el operador IN. */
select *
from empleado
where apellido2 like "Díaz" or apellido2 like "Moreno";

/* 34. Lista todos los datos de los empleados cuyo segundo apellido sea Díaz o Moreno. Utilizando el operador IN. */
select *
from empleado
where apellido2 in ('Díaz','Moreno');

/* 35. Lista los nombres, apellidos y nif de los empleados que trabajan en el departamento 3. */
select nombre, apellido1, apellido2, nif
from empleado
where codigo_departamento = 3;

/* 36. Lista los nombres, apellidos y nif de los empleados que trabajan en los departamentos 2, 4 o 5. */
select nombre, apellido1, apellido2, nif
from empleado
where codigo_departamento in (2,4,5);