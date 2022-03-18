DROP DATABASE IF EXISTS universidad;
CREATE DATABASE universidad CHARACTER SET utf8mb4;
USE universidad;

CREATE TABLE departamento (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE persona (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nif VARCHAR(9) UNIQUE,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('H', 'M') NOT NULL,
    tipo ENUM('profesor', 'alumno') NOT NULL
);

CREATE TABLE profesor (
    id_profesor INT UNSIGNED PRIMARY KEY,
    id_departamento INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES persona(id),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

 CREATE TABLE grado (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE asignatura (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos FLOAT UNSIGNED NOT NULL,
    tipo ENUM('básica', 'obligatoria', 'optativa') NOT NULL,
    curso TINYINT UNSIGNED NOT NULL,
    cuatrimestre TINYINT UNSIGNED NOT NULL,
    id_profesor INT UNSIGNED,
    id_grado INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY(id_grado) REFERENCES grado(id)
);

CREATE TABLE curso_escolar (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    anyo_inicio YEAR NOT NULL,
    anyo_fin YEAR NOT NULL
);

CREATE TABLE alumno_se_matricula_asignatura (
    id_alumno INT UNSIGNED NOT NULL,
    id_asignatura INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_alumno, id_asignatura, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES persona(id),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);

/* 1. Devuelve el número total de alumnas que hay. */
select count(*)
from persona
where tipo="alumno" and sexo="M";

/* 2. Calcula cuántos alumnos nacieron en 1999. */
select count(*)
from persona
where tipo="alumno" and year(fecha_nacimiento)=1999;

/* 3. Calcula cuántos profesores hay en cada departamento. 
El resultado sólo debe mostrar dos columnas, una con el nombre del departamento y otra con el número de profesores que hay en ese departamento. 
El resultado sólo debe incluir los departamentos que tienen profesores asociados y deberá estar ordenado de mayor a menor por el número de profesores. */
select departamento.nombre, count(profesor.id_profesor)
from departamento inner join profesor
on departamento.id = profesor.id_departamento
group by departamento.nombre
order by 2 desc;

/* 4. Devuelve un listado con todos los departamentos y el número de profesores que hay en cada uno de ellos. 
Tenga en cuenta que pueden existir departamentos que no tienen profesores asociados. 
Estos departamentos también tienen que aparecer en el listado. */
select departamento.nombre, count(profesor.id_profesor)
from departamento left join profesor
on departamento.id = profesor.id_departamento
group by departamento.nombre
order by 2 desc;

/* 5. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que tiene cada uno. 
Tenga en cuenta que pueden existir grados que no tienen asignaturas asociadas. Estos grados también tienen que aparecer en el listado. 
El resultado deberá estar ordenado de mayor a menor por el número de asignaturas. */
select grado.nombre, count(asignatura.id)
from grado left join asignatura
on grado.id = asignatura.id_grado
group by grado.nombre
order by 2 desc;

/* 6. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que
tiene cada uno, de los grados que tengan más de 40 asignaturas asociadas. */
select grado.nombre, count(asignatura.id)
from grado inner join asignatura
on grado.id = asignatura.id_grado
group by grado.nombre
having count(asignatura.id) > 40
order by 2 desc;

/* 7. Devuelve un listado que muestre el nombre de los grados y la suma del número total de créditos que hay para cada tipo de asignatura.
El resultado debe tener tres columnas: nombre del grado, tipo de asignatura y la suma de los créditos de todas las asignaturas que hay de ese tipo. 
Ordene el resultado de mayor a menor por el número total de crédidos. */
select grado.nombre, asignatura.tipo, sum(creditos)
from grado inner join asignatura
on grado.id = asignatura.id_grado
group by asignatura.tipo
order by 3 desc;

/* 8. Devuelve un listado que muestre cuántos alumnos se han matriculado de alguna asignatura en cada uno de los cursos escolares. 
El resultado deberá mostrar dos columnas, una columna con el año de inicio del curso escolar y otra con el número de alumnos matriculados. */
select anyo_inicio, count(id_alumno)
from alumno_se_matricula_asignatura inner join curso_escolar
on id_curso_escolar = curso_escolar.id
group by anyo_inicio;

/* 9. Devuelve un listado con el número de asignaturas que imparte cada profesor. 
El listado debe tener en cuenta aquellos profesores que no imparten ninguna asignatura. El resultado mostrará cinco columnas: id, nombre, primer apellido, segundo apellido y número de asignaturas. 
El resultado estará ordenado de mayor a menor por el número de asignaturas. */
select profesor.id_profesor, persona.nombre, apellido1, apellido2, count(asignatura.id)
from profesor inner join persona
on persona.id = profesor.id_profesor
left join asignatura
on asignatura.id_profesor = profesor.id_profesor
group by profesor.id_profesor
order by 5 desc;