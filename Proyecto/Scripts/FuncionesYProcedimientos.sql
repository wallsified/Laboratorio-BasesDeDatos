USE SistemaDeTickets;

DELIMITER $$

/*
* Función que cuenta el número total de tickets que tienen un estado específico.
*
* Parámetros:
* - estadoTicket (VARCHAR(20)): Estado del ticket a contar
* 
* Retorna: 
* INT - Cantidad de tickets en el estado especificado
* 
* Ejemplo de uso:
* SELECT ContarTicketsPorEstado('Abierto');
*/

CREATE FUNCTION ContarTicketsPorEstado(estadoTicket VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE cantidad INT;
    -- Contar la cantidad de tickets con el estado especificado
	SELECT COUNT(*) INTO cantidad FROM Ticket WHERE Status = estadoTicket;
	RETURN cantidad;
END$$

DELIMITER ;

DELIMITER $$ 

/*
* Procedimiento que actualiza el estado de un ticket específico.
* 
* Parámetros:
* - ticket_id (INT): ID del ticket a modificar
* - nuevo_estado (VARCHAR(20)): Nuevo estado del ticket. Estados válidos: 'Abierto', 'En Proceso', 'Cerrado'
* 
* Ejemplo de uso:
* CALL CambiarEstadoTicket(1, 'En Proceso');
*/

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
    SET Status = nuevo_estado
    WHERE ID_Ticket = ticket_id;
    
    COMMIT;
END $$

DELIMITER ;

DELIMITER $$

/*
* Procedimiento que asigna un ticket a un técnico específico.
* Valida que el técnico pertenezca al área del ticket.
* 
* Parámetros:
* - ticket_id (INT): ID del ticket a asignar.
* - tecnico_id (INT): ID del técnico al que se asignará el ticket.
* 
* Ejemplo de uso:
* CALL AsignarTicket(1, 2);
*/
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

/*
* Procedimiento que agrega un comentario a un ticket específico.
* 
* Parámetros:
* - ticket_id (INT): ID del ticket al que se agregará el comentario.
* - comentario (TEXT): Comentario a agregar.
* 
* Ejemplo de uso:
* CALL AgregarComentario(1, 'Se ha iniciado el proceso de revisión.');
*/

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

