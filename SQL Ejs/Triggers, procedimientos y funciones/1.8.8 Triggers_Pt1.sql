/* Antonio Jesús Gil Reyes */
/* 1.8.8 Triggers */

drop database if exists test;
create database test;
use test;

create table alumnos(
	id int unsigned primary key,
    nombre varchar(50),
    apellido1 varchar(50),
    apellido2 varchar(50),
    nota float
);

/* Una vez creada la tabla escriba dos triggers con las siguientes características: 
Trigger 1: trigger_check_nota_before_insert
– Se ejecuta sobre la tabla alumnos.
– Se ejecuta antes de una operación de inserción.
– Si el nuevo valor de la nota que se quiere insertar es negativo, se guarda como 0.
– Si el nuevo valor de la nota que se quiere insertar es mayor que 10, se guarda como 10.
• Trigger2 : trigger_check_nota_before_update
– Se ejecuta sobre la tabla alumnos.
– Se ejecuta antes de una operación de actualización.
– Si el nuevo valor de la nota que se quiere actualizar es negativo, se guarda como 0.
– Si el nuevo valor de la nota que se quiere actualizar es mayor que 10, se guarda como 10.*/

delimiter $$
drop trigger if exists trigger_check_nota_before_insert$$
create trigger trigger_check_nota_before_insert
before insert on alumnos for each row
begin

	if new.nota < 0 then
		set new.nota = 0;
	else if new.nota > 10 then
		set new.nota = 10;
	end if;
    end if;
    
end $$;

delimiter $$
drop trigger if exists trigger_check_nota_before_update$$
create trigger trigger_check_nota_before_update
before update on alumnos for each row
begin

	if new.nota < 0 then
		set new.nota = 0;
	else if new.nota > 10 then
		set new.nota = 10;
	end if;
    end if;
    
end;

insert into alumnos values (1,"n1","a1","a2",-1);
insert into alumnos values (2,"n1","a1","a2",11);
insert into alumnos values (3,"n1","a1","a2",10);
insert into alumnos values (4,"n1","a1","a2",0);

select * from alumnos;

update alumnos set nota = -1 where id = 1;
update alumnos set nota = 11 where id = 2;
update alumnos set nota = 10 where id = 3;
update alumnos set nota = 0 where id = 4;

select * from alumnos;