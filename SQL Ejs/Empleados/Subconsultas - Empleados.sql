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

/* 1. Devuelve un listado con todos los empleados que tiene el departamento de Sistemas. (Sin utilizar INNER JOIN). */
select empleado.nombre, apellido1, apellido2
from departamento, empleado
where empleado.codigo_departamento = departamento.codigo and departamento.codigo = 2;

/* 2. Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada. */
select nombre, presupuesto
from departamento
where presupuesto = (select max(presupuesto)
					from departamento);
                    
/* 3. Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada. */
select nombre, presupuesto
from departamento
where presupuesto = (select min(presupuesto)
					from departamento);
                    
/* 4. Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada. 
Sin hacer uso de MAX, ORDER BY ni LIMIT. */
select nombre, presupuesto
from departamento
where presupuesto >= all (select presupuesto
						from departamento);
                        
/* 5. Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada. 
Sin hacer uso de MAX, ORDER BY ni LIMIT. */
select nombre, presupuesto
from departamento
where presupuesto <= all (select presupuesto
						from departamento);
		
/* 6. Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando ALL o ANY). */
select nombre
from departamento
where codigo = any(select codigo_departamento
					from empleado);
                    
/* 7. Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando ALL o ANY). */
select nombre 
from departamento
where departamento.codigo <> all (select empleado.codigo_departamento
								from empleado
								where codigo_departamento is not null);
                    
/* 8. Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando IN o NOT IN). */
select nombre
from departamento
where codigo in (select codigo_departamento
					from empleado);
                    
/* 9. Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando IN o NOT IN). */
select nombre
from departamento
where codigo not in (select codigo_departamento
					from empleado
                    where codigo_departamento is not null);
				
/* 10. Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando EXISTS o NOT EXISTS). */
select nombre
from departamento
where exists (select codigo_departamento
					from empleado
                    where departamento.codigo = codigo_departamento);
                    
/* 11. Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando EXISTS o NOT EXISTS). */
select nombre
from departamento
where not exists (select codigo_departamento
					from empleado
                    where departamento.codigo = codigo_departamento and codigo_departamento is not null);