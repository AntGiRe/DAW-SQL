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

/* 1. Inserta un nuevo departamento indicando su código, nombre y presupuesto. */

alter table departamento
modify column gastos double unsigned null;

insert into departamento values(5278,"nombre1",5676,null);

/* 2. Inserta un nuevo departamento indicando su nombre y presupuesto. */

insert into departamento values(null,"nombre1",5676,345,null);

/* 3. Inserta un nuevo departamento indicando su código, nombre, presupuesto y gastos. */

insert into departamento values(5678,"nombre1",5676,345);

/* 4. Inserta un nuevo empleado asociado a uno de los nuevos departamentos. 
La sentencia de inserción debe incluir: código, nif, nombre, apellido1, apellido2 y codigo_departamento. */

insert into empleado values(56,'54654654654j','nombre1','apellido10','apellido2',5678);

/* 5. Inserta un nuevo empleado asociado a uno de los nuevos departamentos. 
La sentencia de inserción debe incluir: nif, nombre, apellido1, apellido2 y codigo_departamento. */

insert into empleado values(null,'54654654j','nombre1','apellido10','apellido2',5678);

/* 6. Crea una nueva tabla con el nombre departamento_backup que tenga las mismas columnas que la tabla departamento. 
Una vez creada copia todos las filas de tabla departamento en departamento_backup. */

create table departamento_backup (
  codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  presupuesto DOUBLE UNSIGNED NOT NULL,
  gastos DOUBLE UNSIGNED NOT NULL
);

insert into departamento_backup 
select *
from departamento;

/* 7. Elimina el departamento Proyectos. ¿Es posible eliminarlo? Si no fuese posible, 
¿qué cambios debería realizar para que fuese posible borrarlo? */

/* sí */
delete from departamento
where nombre = "Proyectos";

/* 8. Elimina el departamento Desarrollo. ¿Es posible eliminarlo? Si no fuese posible, 
¿qué cambios debería realizar para que fuese posible borrarlo? */

/* no */

alter table empleado
drop foreign key empleado_ibfk_1;

alter table empleado
add constraint empleado_ibfk_1 
    foreign key (codigo_departamento)
    references departamento(codigo)
    on delete cascade
    on update cascade;

delete from departamento
where nombre = "Desarrollo";

/* 9. Actualiza el código del departamento Recursos Humanos y asígnale el valor 30. 
¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo? */

update departamento
set codigo=30
where nombre="Recursos Humanos";
/* si */

/* 10. Actualiza el código del departamento Publicidad y asígnale el valor 40. 
¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo? */

update departamento
set codigo=40
where nombre="Publicidad";
/* si */

/* 11. Actualiza el presupuesto de los departamentos sumándole 50000 € al valor del presupuesto actual, 
solamente a aquellos departamentos que tienen un presupuesto menor que 20000 €. */

update departamento
set presupuesto = (presupuesto + 50000)
where presupuesto < 20000;
