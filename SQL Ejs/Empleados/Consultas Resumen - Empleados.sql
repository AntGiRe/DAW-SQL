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

/* 1. Calcula la suma del presupuesto de todos los departamentos. */
select sum(presupuesto)
from departamento;

/* 2. Calcula la media del presupuesto de todos los departamentos. */
select avg(presupuesto)
from departamento;

/* 3. Calcula el valor mínimo del presupuesto de todos los departamentos. */
select min(presupuesto)
from departamento;

/* 4. Calcula el nombre del departamento y el presupuesto que tiene asignado, del departamento con menor presupuesto. */
select nombre, presupuesto
from departamento
where presupuesto = (select min(presupuesto)
					from departamento);
                    
/* 5. Calcula el valor máximo del presupuesto de todos los departamentos. */
select max(presupuesto)
from departamento;

/* 6. Calcula el nombre del departamento y el presupuesto que tiene asignado, del departamento con mayor presupuesto. */
select nombre, presupuesto
from departamento
where presupuesto = (select max(presupuesto)
					from departamento);
                    
/* 7. Calcula el número total de empleados que hay en la tabla empleado. */
select count(*)
from empleado;

/* 8. Calcula el número de empleados que no tienen NULL en su segundo apellido. */
select count(*)
from empleado
where apellido2 is not null;

/* 9. Calcula el número de empleados que hay en cada departamento. 
Tienes que devolver dos columnas, una con el nombre del departamento y otra con el número de empleados que tiene asignados. */
select departamento.nombre as "Nombre Dept", count(*) as "Num Empleados"
from empleado inner join departamento
on empleado.codigo_departamento = departamento.codigo
group by codigo_departamento;

/* 10. Calcula el nombre de los departamentos que tienen más de 2 empleados. 
El resultado debe tener dos columnas, una con el nombre del departamento y otra con el número de empleados que tiene asignados. */
select departamento.nombre as "Nombre Dept", count(*) as "Num Empleados"
from empleado inner join departamento
on empleado.codigo_departamento = departamento.codigo
group by codigo_departamento
having count(*) > 2;

/* 11. Calcula el número de empleados que trabajan en cada uno de los departamentos. 
El resultado de esta consulta también tiene que incluir aquellos departamentos que no tienen ningún empleado asociado. */
select departamento.nombre as "Nombre Dept", count(empleado.codigo) as "Num Empleados"
from empleado right join departamento
on empleado.codigo_departamento = departamento.codigo
group by departamento.codigo;

/* 12. Calcula el número de empleados que trabajan en cada unos de los departamentos que tienen un presupuesto mayor a 200000 euros. */
select count(*)
from empleado right join departamento
on empleado.codigo_departamento = departamento.codigo
where presupuesto > 200000;
