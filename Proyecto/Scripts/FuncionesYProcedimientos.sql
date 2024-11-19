DELIMITER $$

CREATE FUNCTION ContarTicketsPorEstado(estadoTicket VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE cantidad INT;
	SELECT COUNT(*) INTO cantidad FROM Ticket WHERE Status = estadoTicket;
	RETURN cantidad;
END$$

DELIMITER ;

DELIMITER $$ 

CREATE PROCEDURE CambiarEstadoTicket(
    IN ticket_id INT,
    IN nuevo_estado VARCHAR(20)
)
BEGIN
    START TRANSACTION;
    
    -- Validar que el nuevo estado es válido
    IF nuevo_estado NOT IN ('Abierto', 'En Proceso', 'Cerrado') THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estado no válido.';
    END IF;
    
    -- Cambiar el estado del ticket
    UPDATE Ticket
    SET Estado = nuevo_estado
    WHERE ID_Ticket = ticket_id;
    
    COMMIT;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AsignarTicket( -- Aceptada
    IN ticket_id INT,
    IN tecnico_id INT
)
BEGIN
    START TRANSACTION;
    
    -- Validar que el técnico pertenece al área del ticket
    IF EXISTS (
        SELECT 1 
        FROM Tickets T
        JOIN Tecnico Tec ON T.ID_Area = Tec.ID_Area
        WHERE T.ID_Ticket = ticket_id AND Tec.ID_Tecnico = tecnico_id
    ) THEN
        -- Asignar el técnico al ticket
        UPDATE Tickets
        SET ID_Tecnico = tecnico_id, Estado = 'En Proceso'
        WHERE ID_Ticket = ticket_id;
        
        COMMIT;
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El técnico no pertenece al área del ticket.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AgregarComentario(
    IN ticket_id INT,
    IN comentario TEXT
)
BEGIN
    -- Declarar variables para manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- En caso de error, se revierte la transacción
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error al agregar comentario. Operación revertida.';
    END;

    START TRANSACTION;

    -- Verificar si el ticket existe
    IF NOT EXISTS (
        SELECT 1 
        FROM Ticket
        WHERE ID_Ticket = ticket_id
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ticket especificado no existe.';
    END IF;

    -- Insertar el comentario
    INSERT INTO Comentarios (ID_Ticket, Comentario)
    VALUES (ticket_id, comentario);

    -- Confirmar los cambios
    COMMIT;
END $$

DELIMITER ;
