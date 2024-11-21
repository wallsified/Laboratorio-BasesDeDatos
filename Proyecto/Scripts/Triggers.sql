DELIMITER / / 
/*
* Trigger que valida que un ticket no pueda cerrarse sin asignación.
* El trigger se dispara antes de actualizar un ticket. Analiza si el nuevo 
* estado del ticket es 'Cerrado' y si no existe una asignación para el ticket.
* En caso de que se cumplan ambas condiciones, se lanza una excepción.
*/
CREATE TRIGGER NoCierreNoAsignacion BEFORE
UPDATE
	ON
	Ticket FOR EACH ROW
BEGIN
		IF NEW.Status = 'Cerrado'
		AND NOT EXISTS (
		SELECT
			1
		FROM
			Asignacion
		WHERE
			ID_Ticket = NEW.ID_Ticket
    ) THEN SIGNAL SQLSTATE '45000'
SET
		MESSAGE_TEXT = 'No se puede cerrar un ticket sin asignación';
END IF;
END //


DELIMITER $$ 

/*
* Trigger que valida que solo el técnico asignado a un ticket pueda hacer comentarios.
* El trigger se dispara antes de insertar un comentario. Analiza si el técnico que
* está intentando insertar el comentario es el técnico asignado al ticket. En caso
* contrario, se lanza una excepción.
*/
CREATE TRIGGER TecnicoAsignadoComentarios BEFORE
INSERT
	ON
	Comentarios FOR EACH ROW
BEGIN
		IF NOT EXISTS (
		SELECT
			1
		FROM
			Asignacion
		WHERE
			ID_Ticket = NEW.ID_Ticket
			AND ID_Tecnico = NEW.ID_Tecnico
    ) THEN SIGNAL SQLSTATE '45000'
SET
		MESSAGE_TEXT = 'Solo el técnico asignado puede hacer comentarios';
END IF;
END$$

DELIMITER ;
