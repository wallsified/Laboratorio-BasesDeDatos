USE SistemaDeTickets;

/*
 * Vista para revisar la informacion sobre los tickets activos sin importar su prioridad.
 */
CREATE VIEW TicketsActivos AS
SELECT
	t.ID_Ticket,
	t.Titulo,
	t.Prioridad,
	t.FechaCreacion,
	ec.ID_EquipoComputo,
	ue.Nombre AS "Nombre Usuario", 
	ue.Apellido AS "Apellido Usuario",
	a.Nombre AS "Nombre Area",
	ct.Categoria
FROM
	Ticket t
JOIN EquipoComputo ec ON
	t.ID_EquipoComputo = ec.ID_EquipoComputo
JOIN UsuarioEmpleado ue ON
	t.ID_Usuario = ue.ID_Usuario
JOIN Area a ON
	ue.ID_Area = a.ID_Area
JOIN CategoriaTicket ct ON
	t.ID_Categoria = ct.ID_Categoria
WHERE
	t.Status IN ('Abierto', 'En Proceso')
ORDER BY
	t.FechaCreacion DESC;

/*
 * Vista para revisar la informacion sobre los tickets cerrados.
 */
CREATE VIEW TicketsCerrados AS
SELECT
	t.ID_Ticket,
	t.Titulo,
	t.Prioridad,
	t.FechaCreacion,
	ec.ID_EquipoComputo,
	ue.Nombre AS "Nombre Usuario", 
	ue.Apellido AS "Apellido Usuario",
	a.Nombre AS "Nombre Area",
	ct.Categoria
FROM
	Ticket t
JOIN EquipoComputo ec ON
	t.ID_EquipoComputo = ec.ID_EquipoComputo
JOIN UsuarioEmpleado ue ON
	t.ID_Usuario = ue.ID_Usuario
JOIN Area a ON
	ue.ID_Area = a.ID_Area
JOIN CategoriaTicket ct ON
	t.ID_Categoria = ct.ID_Categoria
WHERE
	t.Status IN ('Cerrado')
ORDER BY
	t.FechaCreacion DESC;

/*
 * Vista para revisar la informacion sobre los tickets activos con alta prioridad
 */
CREATE VIEW TicketsActivosAltaPrioridad AS
SELECT
	t.ID_Ticket,
	t.Titulo,
	t.FechaCreacion,
	ec.ID_EquipoComputo,
	ue.Nombre AS "Nombre Usuario", 
	ue.Apellido AS "Apellido Usuario",
	a.Nombre AS "Nombre Area",
	ct.Categoria
FROM
	Ticket t
JOIN EquipoComputo ec ON
	t.ID_EquipoComputo = ec.ID_EquipoComputo
JOIN UsuarioEmpleado ue ON
	t.ID_Usuario = ue.ID_Usuario
JOIN Area a ON
	ue.ID_Area = a.ID_Area
JOIN CategoriaTicket ct ON
	t.ID_Categoria = ct.ID_Categoria
WHERE
	t.Status IN ('Abierto', 'En Proceso')
	AND t.Prioridad = 'Alta'
ORDER BY
	t.FechaCreacion DESC;

/*
 * Vista para revisar la informacion sobre los tickets activos con prioridad media.
 */
CREATE VIEW TicketsActivosMediaPrioridad AS
SELECT
	t.ID_Ticket,
	t.Titulo,
	t.FechaCreacion,
	ec.ID_EquipoComputo,
	ue.Nombre AS "Nombre Usuario", 
	ue.Apellido AS "Apellido Usuario",
	a.Nombre AS "Nombre Area",
	ct.Categoria
FROM
	Ticket t
JOIN EquipoComputo ec ON
	t.ID_EquipoComputo = ec.ID_EquipoComputo
JOIN UsuarioEmpleado ue ON
	t.ID_Usuario = ue.ID_Usuario
JOIN Area a ON
	ue.ID_Area = a.ID_Area
JOIN CategoriaTicket ct ON
	t.ID_Categoria = ct.ID_Categoria
WHERE
	t.Status IN ('Abierto', 'En Proceso')
	AND t.Prioridad = 'Media'
ORDER BY
	t.FechaCreacion DESC;

/*
 * Vista para revisar la informacion sobre los tickets activos con prioridad baja.
 */
CREATE VIEW TicketsActivosBajaPrioridad AS
SELECT
	t.ID_Ticket,
	t.Titulo,
	t.FechaCreacion,
	ec.ID_EquipoComputo,
	ue.Nombre AS "Nombre Usuario", 
	ue.Apellido AS "Apellido Usuario",
	a.Nombre AS "Nombre Area",
	ct.Categoria
FROM
	Ticket t
JOIN EquipoComputo ec ON
	t.ID_EquipoComputo = ec.ID_EquipoComputo
JOIN UsuarioEmpleado ue ON
	t.ID_Usuario = ue.ID_Usuario
JOIN Area a ON
	ue.ID_Area = a.ID_Area
JOIN CategoriaTicket ct ON
	t.ID_Categoria = ct.ID_Categoria
WHERE
	t.Status IN ('Abierto', 'En Proceso')
	AND t.Prioridad = 'Baja'
ORDER BY
	t.FechaCreacion DESC;

/*
 * Vista para revisar las asignaciones a tecnicos sobre tickets abiertos
 */
CREATE VIEW AsignacionTicketsAbiertos AS
SELECT
	t.ID_Ticket,
	a.ID_Asignacion,
	t.Titulo,
	tec.Nombre,
	tec.Apellido,
	tec.Nivel,
	t.Prioridad,
	ec.ID_EquipoComputo, 
	t.FechaCreacion,
	t.FechaCierre,
	a.FechaAsignacion
FROM
	Ticket t
JOIN EquipoComputo ec ON
	t.ID_EquipoComputo = ec.ID_EquipoComputo
JOIN Asignacion a ON
	t.ID_Ticket = a.ID_Ticket
JOIN Tecnico tec ON
	a.ID_Tecnico = tec.ID_Tecnico
WHERE
	t.Status IN ('Abierto', 'En Proceso')
ORDER BY
	t.FechaCreacion DESC;

/*
 * Vista para revisar las asignaciones a tecnicos sobre tickets cerrados
 */
CREATE VIEW AsignacionTicketsCerrados AS
SELECT
	t.ID_Ticket,
	a.ID_Asignacion,
	t.Titulo,
	tec.Nombre,
	tec.Apellido,
	tec.Nivel,
	t.Prioridad,
	ec.ID_EquipoComputo, 
	t.FechaCreacion,
	t.FechaCierre,
	a.FechaAsignacion
FROM
	Ticket t
JOIN EquipoComputo ec ON
	t.ID_EquipoComputo = ec.ID_EquipoComputo
JOIN Asignacion a ON
	t.ID_Ticket = a.ID_Ticket
JOIN Tecnico tec ON
	a.ID_Tecnico = tec.ID_Tecnico
WHERE
	t.Status IN ('Cerrado')
ORDER BY
	t.FechaCreacion DESC;