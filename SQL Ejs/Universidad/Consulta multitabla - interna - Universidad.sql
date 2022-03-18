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

/* 1. Devuelve un listado con los datos de todas las alumnas que se han matriculado alguna vez en el Grado en Ingeniería Informática (Plan 2015). */
select distinct persona.nombre, apellido1, apellido2
from persona inner join alumno_se_matricula_asignatura
on id_alumno = persona.id
inner join asignatura
on alumno_se_matricula_asignatura.id_asignatura = asignatura.id
inner join grado
on asignatura.id_grado = grado.id
where sexo="M" and grado.nombre="Grado en Ingeniería Informática (Plan 2015)";

/* 2. Devuelve un listado con todas las asignaturas ofertadas en el Grado en Ingeniería Informática (Plan 2015). */
select *
from asignatura inner join grado
on asignatura.id_grado = grado.id
where grado.nombre="Grado en Ingeniería Informática (Plan 2015)";

/* 3. Devuelve un listado de los profesores junto con el nombre del departamento al que están vinculados. 
El listado debe devolver cuatro columnas, primer apellido, segundo apellido, nombre y nombre del departamento. 
El resultado estará ordenado alfabéticamente de menor a mayor por los apellidos y el nombre. */
select apellido1, apellido2, persona.nombre, departamento.nombre
from persona inner join profesor
on persona.id = id_profesor
inner join departamento
on id_departamento = departamento.id
where tipo = "profesor"
order by apellido1, apellido2, nombre;

/* 4. Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del alumno con nif 26902806M. */
select asignatura.nombre, anyo_inicio, anyo_fin
from persona inner join alumno_se_matricula_asignatura
on id_alumno = persona.id
inner join asignatura
on alumno_se_matricula_asignatura.id_asignatura = asignatura.id
inner join curso_escolar
on id_curso_escolar = curso_escolar.id
where persona.tipo="alumno" and nif="26902806M";

/* 5. Devuelve un listado con el nombre de todos los departamentos que tienen profesores que imparten alguna asignatura en el Grado en Ingeniería Informática (Plan 2015). */
select distinct departamento.nombre
from departamento inner join profesor
on id_departamento = departamento.id
inner join asignatura
on profesor.id_profesor = asignatura.id_profesor
inner join grado
on id_grado = grado.id
where grado.nombre = "Grado en Ingeniería Informática (Plan 2015)";

/* 6. Devuelve un listado con todos los alumnos que se han matriculado en alguna asignatura durante el curso escolar 2018/2019. */
select distinct persona.nombre, apellido1, apellido2
from persona inner join alumno_se_matricula_asignatura
on id_alumno = persona.id
inner join curso_escolar
on id_curso_escolar = curso_escolar.id
where anyo_inicio="2018" and anyo_fin="2019" and tipo="alumno";
