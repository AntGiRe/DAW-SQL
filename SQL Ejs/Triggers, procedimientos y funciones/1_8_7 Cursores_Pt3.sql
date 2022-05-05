/* Antonio Jesús Gil Reyes */
/* 1.8.7 Cursores */

/* 3. Escribe un procedimiento llamado crear_lista_emails_alumnos que devuelva la lista de emails de
la tabla alumnos separados por un punto y coma. Ejemplo: juan@iescelia.org;maria@iescelia.
org;pepe@iescelia.org;lucia@iescelia.org. */
delimiter $$
drop procedure if exists lista_email$$
create procedure lista_email(out lista varchar(1000))
begin
	declare email varchar(100);
    declare done boolean default false;
	declare cursor_emails cursor for (select alumnos.email from alumnos);
    
    declare continue handler for not found set done = true;
    
    open cursor_emails;
    
    set lista = "";
    read_loop: loop
		fetch cursor_emails INTO email;
        
		IF done THEN
			LEAVE read_loop;
		END IF;
        
        set lista = concat(email,";",lista);
        
    END LOOP;

end;

call lista_email(@lista);
select @lista;