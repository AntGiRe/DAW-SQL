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

/* 1. Devuelve un listado con los nombres de todos los profesores y los departamentos que tienen vinculados. 
El listado también debe mostrar aquellos profesores que no tienen ningún departamento asociado. 
El listado debe devolver cuatro columnas, nombre del departamento, primer apellido, segundo apellido y nombre del profesor. 
El resultado estará ordenado alfabéticamente de menor a mayor por el nombre del departamento, apellidos y el nombre. */
select departamento.nombre, persona.apellido1, persona.apellido2, persona.nombre
from persona inner join profesor
on persona.id = profesor.id_profesor
left join departamento
on profesor.id_departamento = departamento.id
where tipo="profesor"
order by 2,3,4;

/* 2. Devuelve un listado con los profesores que no están asociados a un departamento. */
select *
from persona inner join profesor
on persona.id = profesor.id_profesor
left join departamento
on profesor.id_departamento = departamento.id
where tipo="profesor" and departamento.id is null;

/* 3. Devuelve un listado con los departamentos que no tienen profesores asociados. */
select departamento.nombre
from persona inner join profesor
on persona.id = profesor.id_profesor
right join departamento
on profesor.id_departamento = departamento.id
where profesor.id_profesor is null;

/* 4. Devuelve un listado con los profesores que no imparten ninguna asignatura. */
select persona.nombre
from profesor left join asignatura
on asignatura.id_profesor = profesor.id_profesor
inner join persona
on persona.id = profesor.id_profesor
where asignatura.id is null;

/* 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado. */
select asignatura.nombre
from profesor right join asignatura
on asignatura.id_profesor = profesor.id_profesor
where asignatura.id_profesor is null;

/* 6. Devuelve un listado con todos los departamentos que tienen alguna asignatura que no se haya impartido en ningún curso escolar. 
El resultado debe mostrar el nombre del departamento y el nombre de la asignatura que no se haya impartido nunca. */
select departamento.nombre, asignatura.nombre
from asignatura inner join profesor
on profesor.id_profesor = asignatura.id_profesor
inner join departamento
on departamento.id = profesor.id_departamento
left join alumno_se_matricula_asignatura
on alumno_se_matricula_asignatura.id_asignatura = asignatura.id
where alumno_se_matricula_asignatura.id_curso_escolar is null;