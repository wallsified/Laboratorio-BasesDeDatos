DELIMITER / / -- Aceptada
-- Trigger para validar que un ticket no pueda cerrarse sin asignación
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

-- Trigger para validar que solo el técnico asignado pueda hacer comentarios
CREATE TRIGGER ComentarioAsignadoComentarios BEFORE
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