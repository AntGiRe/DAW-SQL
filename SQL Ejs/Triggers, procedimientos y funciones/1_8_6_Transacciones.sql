/* Antonio Jesús Gil Reyes */
/* 1.8.6 Transacciones con procedimientos almacenados */

/* 1. Crea una base de datos llamada cine que contenga dos tablas con las siguientes columnas.
Tabla cuentas:

id_cuenta: entero sin signo (clave primaria).
saldo: real sin signo.

Tabla entradas:

id_butaca: entero sin signo (clave primaria).
nif: cadena de 9 caracteres. */
drop database if exists cine;
create database cine;
use cine;

create table cuentas(
	id_cuenta int unsigned primary key,
    saldo double unsigned
);

create table entradas(
	id_butaca int unsigned primary key,
    nif varchar(9)
);

insert into cuentas values ("111111",100);
insert into cuentas values ("222222",10);


/* Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado comprar_entrada con las siguientes características. 
El procedimiento recibe 3 parámetros de entrada (nif, id_cuenta, id_butaca) y devolverá como salida un parámetro llamado error que tendrá 
un valor igual a 0 si la compra de la entrada se ha podido realizar con éxito y un valor igual a 1 en caso contrario. */
DELIMITER $$
DROP PROCEDURE IF EXISTS comprar_entrada$$
CREATE PROCEDURE comprar_entrada(in nif varchar(9), in id_cuenta int unsigned, id_butaca int unsigned, out error boolean)
BEGIN
    
    declare continue handler for 1264, 1062
		begin
		set error = 1;
		end;
    
	start transaction;
    
    set error = false;
    
    update cuentas
    set saldo = saldo - 5
    where cuentas.id_cuenta = id_cuenta;
    
    insert into entradas values(id_butaca,nif);
    
	if error = false then
		commit;
	else
		rollback;
	end if;
    
end
$$

DELIMITER ;
call comprar_entrada("345345634",111111,"56",@error);
select @error;

call comprar_entrada('312345354', 2, 56, @error);
SELECT @error;
SELECT * FROM cuentas;
SELECT * FROM entradas;

/* 2. ¿Qué ocurre cuando intentamos comprar una entrada y le pasamos como parámetro un número de cuenta 
que no existe en la tabla cuentas? ¿Ocurre algún error o podemos comprar la entrada?*/
DELIMITER $$
DROP PROCEDURE IF EXISTS comprar_entrada$$
CREATE PROCEDURE comprar_entrada(in nif varchar(9), in id_cuenta int unsigned, id_butaca int unsigned, out error boolean)
BEGIN
    
    declare saldo_cuenta double unsigned;
    
    declare continue handler for 1264, 1062
		begin
		set error = true;
		end;
    
    set saldo_cuenta = (select saldo from cuentas where id_cuenta = cuentas.id_cuenta);
    
	start transaction;
    
    if saldo_cuenta > 5 then
		set error = false;
        
        update cuentas
		set saldo = saldo - 5
		where cuentas.id_cuenta = id_cuenta;
    
		insert into entradas values(id_butaca,nif);
    
	else
		set error = true;
	end if;
    
	if error = false then
		commit;
	else
		rollback;
	end if;
    
end
$$

call comprar_entrada("345345634",345,"56",@error);
select @error;