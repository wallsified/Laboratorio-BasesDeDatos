USE SistemaDeTickets;

/*
 * TecnicoSr tendria control total sobre los tickets, pero no sobre la información 
 * de la empresa. Tambien puede cambiar de equipo a un usuario. Tiene los permisos
 * para trabajar sobre las tablas Ticket, Asignacion, EquipoComputo, CategoriaTicket
 * y Comentarios.
 */

CREATE ROLE 'TecnicoSr';
GRANT ALL PRIVILEGES ON SistemaDeTickets.Asignacion TO 'TecnicoSr';
GRANT ALL PRIVILEGES ON SistemaDeTickets.EquipoComputo TO 'TecnicoSr';
GRANT ALL PRIVILEGES ON SistemaDeTickets.Ticket TO 'TecnicoSr';
GRANT ALL PRIVILEGES ON SistemaDeTickets.CategoriaTicket TO 'TecnicoSr';
GRANT ALL PRIVILEGES ON SistemaDeTickets.Comentarios TO 'TecnicoSr';
CREATE USER 'tecnicoSudo'@'localhost' IDENTIFIED BY 'aunNoEresRoot';
GRANT 'TecnicoSr' TO 'tecnicoSudo'@'localhost';
SET DEFAULT ROLE 'TecnicoSr' FOR 'tecnicoSudo'@'localhost';

/*
 * TecnicoJr podria crear y editar nuevos tickets, pero no borrarlos.
 * Se supondrá que un Tecnico de mayor rango asigna al Jr los tickets
 * que deberá resolver. Tecnico Jr puede hacer operaciones mínimas
 * sobre Ticket y Comentarios.
 */

CREATE ROLE 'TecnicoJr';
GRANT SELECT, UPDATE ON SistemaDeTickets.Ticket TO 'TecnicoJr';
GRANT SELECT, INSERT, UPDATE ON SistemaDeTickets.Comentarios TO 'TecnicoJr';
GRANT SELECT ON SistemaDeTickets.TicketsActivos TO 'TecnicoJr';
GRANT SELECT ON SistemaDeTickets.TicketsActivosAltaPrioridad TO 'TecnicoJr';
GRANT SELECT ON SistemaDeTickets.TicketsCerrados TO 'TecnicoJr';
GRANT SELECT ON SistemaDeTickets.TicketsActivosBajaPrioridad TO 'TecnicoJr';
GRANT SELECT ON SistemaDeTickets.TicketsActivosMediaPrioridad TO 'TecnicoJr';
GRANT SELECT ON SistemaDeTickets.AsignacionTicketsAbiertos TO 'TecnicoJr';
GRANT EXECUTE ON SistemaDeTickets.* TO 'TecnicoJr';
CREATE USER 'tecnicoSteveRodgers'@'localhost' IDENTIFIED BY 'buckyNeverDied';
GRANT 'TecnicoJr' TO 'tecnicoSteveRodgers'@'localhost';
SET DEFAULT ROLE 'TecnicoJr' FOR 'tecnicoSteveRodgers'@'localhost';

/*
 * TecnicoMedio debe de tener un control medio sobre las tablas referentes 
 * a los tickets. TecnicoMedio puede asignar a otros tecnicos ciertos
 * tickets y hacer operaciones basicas sobre las tablas Ticket, Comentarios
 * y Asignacion.
 * 
 * ! Falta añadir permisos de ejecución. Vease el caso del usuario anterior.
 */

CREATE ROLE 'TecnicoMedio';
GRANT SELECT, UPDATE, INSERT, INDEX ON SistemaDeTickets.Ticket TO 'TecnicoMedio';
GRANT SELECT, UPDATE, INSERT, INDEX ON SistemaDeTickets.Comentarios TO 'TecnicoMedio';
GRANT SELECT, UPDATE, INSERT, INDEX ON SistemaDeTickets.Asignacion TO 'TecnicoMedio';
GRANT SELECT ON SistemaDeTickets.TicketsActivos TO 'TecnicoMedio';
GRANT SELECT ON SistemaDeTickets.TicketsActivosAltaPrioridad TO 'TecnicoMedio';
GRANT SELECT ON SistemaDeTickets.TicketsCerrados TO 'TecnicoMedio';
GRANT SELECT ON SistemaDeTickets.TicketsActivosBajaPrioridad TO 'TecnicoMedio';
GRANT SELECT ON SistemaDeTickets.TicketsActivosMediaPrioridad TO 'TecnicoMedio';
GRANT SELECT ON SistemaDeTickets.AsignacionTicketsAbiertos TO 'TecnicoMedio';
GRANT EXECUTE ON SistemaDeTickets.* TO 'TecnicoMedio';
CREATE USER 'tecnicoBarryAlen'@'localhost' IDENTIFIED BY 'notAnotherFlashpoint';
GRANT 'TecnicoMedio' TO 'tecnicoBarryAlen'@'localhost';
SET DEFAULT ROLE 'TecnicoMedio' FOR 'tecnicoBarryAlen'@'localhost';

/*
 * AdminBD tendría control total. Puede crear nuevos tecnicos y modificar información
 * provista por la empresa. Notemos que esto no es lo mismo que el usuario root ya que
 * estamos restringiendo ese Rol/Usuario unicamente a la base de datos del Sistema de
 * Tickets y no damos acceso a otras bases que puedan existir en la misma conexion. 
 */
CREATE ROLE 'AdminBD';
GRANT ALL PRIVILEGES ON SistemaDeTickets.* TO 'AdminBD';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'APbuDqoK6j5u0UyMN';
GRANT 'AdminBD' TO 'admin'@'localhost';
SET DEFAULT ROLE 'AdminBD' FOR 'admin'@'localhost';