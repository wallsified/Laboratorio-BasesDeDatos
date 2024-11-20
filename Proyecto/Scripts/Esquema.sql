CREATE DATABASE SistemaDeTickets;

USE SistemaDeTickets;

CREATE TABLE Area (
    ID_Area INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE
-- El nombre del área debe ser único y no nulo
);

CREATE TABLE Tecnico (
    ID_Tecnico INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Nivel VARCHAR(20) NOT NULL CHECK (Nivel IN ('Junior', 'Medio', 'Senior')),
-- Solo estos niveles son permitidos
ID_Area INT NOT NULL,
    FOREIGN KEY (ID_Area) REFERENCES Area(ID_Area) ON
DELETE
	RESTRICT
	-- No se puede eliminar un área si tiene técnicos asignados
    ON
	UPDATE
		CASCADE
);

CREATE TABLE UsuarioEmpleado (
    ID_Usuario INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    RolPuesto VARCHAR(50) NOT NULL,
    ID_Area INT NOT NULL,
    FOREIGN KEY (ID_Area) REFERENCES Area(ID_Area) ON
DELETE
	RESTRICT
	-- No se puede eliminar un área si tiene usuarios asignados
    ON
	UPDATE
		CASCADE
);

CREATE TABLE EquipoComputo (
    ID_EquipoComputo INT PRIMARY KEY,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    No_Serial VARCHAR(50) NOT NULL UNIQUE,
-- El número de serie debe ser único
CantidadMemoria VARCHAR(20) NOT NULL,
    CantidadAlmacenamiento VARCHAR(20) NOT NULL,
    ModeloProcesador VARCHAR(50) NOT NULL,
    ID_Usuario INT NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES UsuarioEmpleado(ID_Usuario) ON
DELETE
	RESTRICT
	-- No se puede eliminar un usuario si tiene equipos asignados
    ON
	UPDATE
		CASCADE
);

CREATE TABLE CategoriaTicket (
    ID_Categoria INT PRIMARY KEY,
    Categoria VARCHAR(20) NOT NULL CHECK (Categoria IN ('Mantenimiento', 'Cambio de Equipo', 
   'Ajuste de Software', 'Ajuste de Hardware', 'Redes', 'Soporte General')));

CREATE TABLE Ticket (
    ID_Ticket INT PRIMARY KEY,
    Titulo VARCHAR(100) NOT NULL,
    Descripcion TEXT NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Abierto', 'En Proceso', 'Cerrado')),
	-- Solo estos estados son permitidos
	Prioridad VARCHAR(20) NOT NULL CHECK (Prioridad IN ('Baja', 'Media', 'Alta')),
	-- Solo estas prioridades son permitidas
	FechaCreacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FechaCierre DATETIME,
    ID_EquipoComputo INT NOT NULL,
    ID_Usuario INT NOT NULL,
    ID_Categoria INT NOT NULL,
    CHECK (
        FechaCierre IS NULL
	OR FechaCierre >= FechaCreacion
    ),
-- La fecha de cierre debe ser posterior a la de creación
    FOREIGN KEY (ID_EquipoComputo) REFERENCES EquipoComputo(ID_EquipoComputo) ON
DELETE
	RESTRICT
	-- No se puede eliminar un equipo si tiene tickets asociados
    ON
	UPDATE
		CASCADE,
		FOREIGN KEY (ID_Usuario) REFERENCES UsuarioEmpleado(ID_Usuario) ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE,
				FOREIGN KEY (ID_Categoria) REFERENCES CategoriaTicket(ID_Categoria) ON
				DELETE
					RESTRICT ON
					UPDATE
						CASCADE
);

CREATE TABLE Asignacion (
    ID_Asignacion INT PRIMARY KEY,
    FechaAsignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_Ticket INT UNIQUE NOT NULL,
-- Garantiza la cardinalidad 1:1 con Ticket
    ID_Tecnico INT NOT NULL,
    FOREIGN KEY (ID_Ticket) REFERENCES Ticket(ID_Ticket) ON
DELETE
	RESTRICT
	-- No se puede eliminar un ticket si tiene asignación
    ON
	UPDATE
		CASCADE,
		FOREIGN KEY (ID_Tecnico) REFERENCES Tecnico(ID_Tecnico) ON
		DELETE
			RESTRICT
			-- No se puede eliminar un técnico si tiene asignaciones
    ON
			UPDATE
				CASCADE
);

CREATE TABLE Comentarios (
    ID_Comentario INT PRIMARY KEY,
    Contenido TEXT NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_Ticket INT NOT NULL,
    ID_Tecnico INT NOT NULL,
    FOREIGN KEY (ID_Ticket) REFERENCES Ticket(ID_Ticket) ON
DELETE
	CASCADE
	-- Si se elimina un ticket, se eliminan sus comentarios
    ON
	UPDATE
		CASCADE,
		FOREIGN KEY (ID_Tecnico) REFERENCES Tecnico(ID_Tecnico) ON
		DELETE
			RESTRICT
			-- No se puede eliminar un técnico si tiene comentarios
    ON
			UPDATE
				CASCADE
);