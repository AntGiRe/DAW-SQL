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

/* 1. Devuelve un listado con los empleados y los datos de los departamentos donde trabaja cada uno. */
select *
from empleado inner join departamento
on codigo_departamento = departamento.codigo;

/* 2. Devuelve un listado con los empleados y los datos de los departamentos donde trabaja cada uno. Ordena el resultado, 
en primer lugar por el nombre del departamento (en orden alfabético) y en segundo lugar por los apellidos y el nombre de los empleados. */
select *
from empleado inner join departamento
on codigo_departamento = departamento.codigo
order by departamento.nombre, apellido1, apellido2, empleado.nombre;

/* 3. Devuelve un listado con el código y el nombre del departamento, solamente de aquellos departamentos que tienen empleados. */
select distinct departamento.codigo, departamento.nombre
from empleado inner join departamento
on codigo_departamento = departamento.codigo;

/* 4. Devuelve un listado con el código, el nombre del departamento y el valor del presupuesto actual del que dispone, 
solamente de aquellos departamentos que tienen empleados. El valor del presupuesto actual lo puede calcular restando al valor del 
presupuesto inicial (columna presupuesto) el valor de los gastos que ha generado (columna gastos). */
select distinct departamento.codigo, departamento.nombre, (presupuesto-gastos) as "Presupuesto Actual"
from empleado inner join departamento
on codigo_departamento = departamento.codigo;

/* 5. Devuelve el nombre del departamento donde trabaja el empleado que tiene el nif 38382980M. */
select departamento.nombre
from empleado inner join departamento
on codigo_departamento = departamento.codigo
where nif="38382980M";

/* 6. Devuelve el nombre del departamento donde trabaja el empleado Pepe Ruiz Santana. */
select departamento.nombre
from empleado inner join departamento
on codigo_departamento = departamento.codigo
where empleado.nombre="Pepe" and apellido1="Ruiz" and apellido2="Santana";

/* 7. Devuelve un listado con los datos de los empleados que trabajan en el departamento de I+D. Ordena el resultado alfabéticamente. */
select *
from empleado inner join departamento
on codigo_departamento = departamento.codigo
where departamento.nombre="I+D"
order by empleado.nombre;

/* 8. Devuelve un listado con los datos de los empleados que trabajan en el departamento de Sistemas, Contabilidad o I+D. Ordena el resultado alfabéticamente. */
select *
from empleado inner join departamento
on codigo_departamento = departamento.codigo
where departamento.nombre in ('Sistemas','Contabilidad','I+D')
order by empleado.nombre;

/* 9. Devuelve una lista con el nombre de los empleados que tienen los departamentos que no tienen un presupuesto entre 100000 y 200000 euros. */
select empleado.nombre, apellido1, apellido2
from empleado inner join departamento
on codigo_departamento = departamento.codigo
where presupuesto between 100000 and 200000;

/* 10. Devuelve un listado con el nombre de los departamentos donde existe algún empleado cuyo segundo apellido sea NULL. 
Tenga en cuenta que no debe mostrar nombres de departamentos que estén repetidos. */
select distinct departamento.nombre
from empleado inner join departamento
on codigo_departamento = departamento.codigo
where apellido2 is null;