USE SistemaDeTickets;

INSERT INTO Area (ID_Area, Nombre) VALUES (1, 'Compras');
INSERT INTO Area (ID_Area, Nombre) VALUES (2, 'Recursos Humanos');
INSERT INTO Area (ID_Area, Nombre) VALUES (3, 'Finanzas');
INSERT INTO Area (ID_Area, Nombre) VALUES (4, 'Marketing');
INSERT INTO Area (ID_Area, Nombre) VALUES (5, 'Ventas');


INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (1, 'Juan', 'Perez', 'Senior', 1);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (2, 'Ana', 'Martinez', 'Medio', 1);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (3, 'Luis', 'Lopez', 'Junior', 2);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (4, 'Sofia', 'Garcia', 'Medio', 3);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (5, 'Miguel', 'Hernandez', 'Senior', 4);


INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (1, 'Carlos', 'Ramos', 'Desarrollador', 1);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (2, 'Laura', 'Diaz', 'Contador', 3);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (3, 'Marta', 'Fernandez', 'Diseñadora', 4);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (4, 'Jose', 'Ruiz', 'Vendedor', 5);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (5, 'Elena', 'Gomez', 'Analista', 2);


INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (1, 'Dell', 'Inspiron', 'SN12345', '8GB', '512GB', 'Intel i5', 1);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (2, 'HP', 'Pavilion', 'SN67890', '16GB', '1TB', 'Intel i7', 2);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (3, 'Lenovo', 'ThinkPad', 'SN11223', '8GB', '256GB', 'Intel i3', 3);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (4, 'Apple', 'MacBook', 'SN44556', '16GB', '512GB', 'M1', 4);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (5, 'Asus', 'VivoBook', 'SN77889', '12GB', '1TB', 'AMD Ryzen 7', 5);


INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (1, 'Mantenimiento');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (2, 'Cambio de Equipo');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (3, 'Ajuste de Software');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (4, 'Ajuste de Hardware');


INSERT INTO Ticket (ID_Ticket, Titulo, Descripcion, Status, Prioridad, FechaCreacion, ID_EquipoComputo, ID_Usuario, ID_Categoria)
VALUES (1, 'Problema con impresora', 'La impresora no imprime correctamente', 'Abierto', 'Media', NOW(), 1, 1, 1);
INSERT INTO Ticket (ID_Ticket, Titulo, Descripcion, Status, Prioridad, FechaCreacion, ID_EquipoComputo, ID_Usuario, ID_Categoria)
VALUES (2, 'Actualización de software', 'Actualizar el sistema operativo a la última versión', 'En Proceso', 'Alta', NOW(), 2, 2, 3);
INSERT INTO Ticket (ID_Ticket, Titulo, Descripcion, Status, Prioridad, FechaCreacion, ID_EquipoComputo, ID_Usuario, ID_Categoria)
VALUES (3, 'Cambio de teclado', 'El teclado actual está dañado', 'Cerrado', 'Baja', NOW(), 3, 3, 2);


INSERT INTO Asignacion (ID_Asignacion, FechaAsignacion, ID_Ticket, ID_Tecnico) VALUES (1, NOW(), 1, 1);
INSERT INTO Asignacion (ID_Asignacion, FechaAsignacion, ID_Ticket, ID_Tecnico) VALUES (2, NOW(), 2, 2);
INSERT INTO Asignacion (ID_Asignacion, FechaAsignacion, ID_Ticket, ID_Tecnico) VALUES (3, NOW(), 3, 3);


INSERT INTO Comentarios (ID_Comentario, Contenido, Fecha, ID_Ticket, ID_Tecnico) VALUES (1, 'Revisaré el problema de conexion a internet', NOW(), 1, 1);
INSERT INTO Comentarios (ID_Comentario, Contenido, Fecha, ID_Ticket, ID_Tecnico) VALUES (2, 'Estamos trabajando en la actualización del sistema', NOW(), 2, 2);
INSERT INTO Comentarios (ID_Comentario, Contenido, Fecha, ID_Ticket, ID_Tecnico) VALUES (3, 'Teclado reemplazado satisfactoriamente', NOW(), 3, 3);
