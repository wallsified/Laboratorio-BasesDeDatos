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
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (6, 'Felipe', 'Castillo', 'Junior', 1);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (7, 'Monica', 'Ramirez', 'Medio', 2);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (8, 'Alberto', 'Sandoval', 'Senior', 3);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (9, 'Carolina', 'Espinosa', 'Medio', 4);
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area) VALUES (10, 'Hector', 'Navarro', 'Junior', 5);

INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (1, 'Carlos', 'Ramos', 'Desarrollador', 1);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (2, 'Laura', 'Diaz', 'Contador', 3);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (3, 'Marta', 'Fernandez', 'Diseñadora', 4);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (4, 'Jose', 'Ruiz', 'Vendedor', 5);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (5, 'Elena', 'Gomez', 'Analista', 2);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (6, 'Andres', 'Lara', 'Soporte Técnico', 1);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (7, 'Carla', 'Mendoza', 'Líder de Proyectos', 1);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (8, 'Roberto', 'Vega', 'Reclutador', 2);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (9, 'Natalia', 'Ortiz', 'Especialista de Nómina', 2);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (10, 'Gabriel', 'Flores', 'Analista Financiero', 3);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (11, 'Silvia', 'Cortez', 'Supervisor de Contabilidad', 3);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (12, 'Pablo', 'Jimenez', 'Diseñador Gráfico', 4);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (13, 'Luz', 'Hernández', 'Community Manager', 4);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (14, 'Victor', 'Pérez', 'Ejecutivo de Ventas', 5);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (15, 'Maria', 'Santos', 'Representante de Ventas', 5);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (16, 'Esteban', 'Torres', 'Ingeniero de Software', 1);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (17, 'Daniela', 'Cruz', 'Consultor Interno', 2);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (18, 'Juan', 'Villalobos', 'Asistente Financiero', 3);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (19, 'Isabel', 'Garza', 'Planificadora de Marketing', 4);
INSERT INTO UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area) VALUES (20, 'Diego', 'Bautista', 'Coordinador de Ventas', 5);

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
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (6, 'Acer', 'Aspire', 'SN10001', '8GB', '512GB', 'Intel i5', 1);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (7, 'HP', 'EliteBook', 'SN10002', '16GB', '1TB', 'Intel i7', 2);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (8, 'Dell', 'XPS', 'SN10003', '32GB', '1TB', 'Intel i9', 3);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (9, 'Apple', 'Mac Mini', 'SN10004', '16GB', '512GB', 'M2', 4);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (10, 'Lenovo', 'Yoga', 'SN10005', '8GB', '256GB', 'AMD Ryzen 5', 5);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (11, 'Asus', 'ROG', 'SN10006', '16GB', '1TB', 'AMD Ryzen 7', 1);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (12, 'MSI', 'Stealth', 'SN10007', '32GB', '2TB', 'Intel i9', 2);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (13, 'Huawei', 'MateBook', 'SN10008', '8GB', '512GB', 'Intel i5', 3);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (14, 'Samsung', 'Galaxy Book', 'SN10009', '16GB', '1TB', 'Intel i7', 4);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (15, 'Acer', 'Nitro', 'SN10010', '16GB', '512GB', 'AMD Ryzen 7', 5);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (16, 'LG', 'Gram', 'SN10011', '8GB', '256GB', 'Intel i3', 1);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (17, 'Razer', 'Blade', 'SN10012', '32GB', '1TB', 'Intel i9', 2);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (18, 'Microsoft', 'Surface', 'SN10013', '16GB', '512GB', 'Intel i7', 3);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (19, 'Alienware', 'Aurora', 'SN10014', '64GB', '2TB', 'Intel i9', 4);
INSERT INTO EquipoComputo (ID_EquipoComputo, Marca, Modelo, No_Serial, CantidadMemoria, CantidadAlmacenamiento, ModeloProcesador, ID_Usuario)
VALUES (20, 'Sony', 'Vaio', 'SN10015', '16GB', '512GB', 'AMD Ryzen 5', 5);

INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (1, 'Mantenimiento');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (2, 'Cambio de Equipo');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (3, 'Ajuste de Software');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (4, 'Ajuste de Hardware');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (5, 'Redes');
INSERT INTO CategoriaTicket (ID_Categoria, Categoria) VALUES (6, 'Soporte General');

INSERT INTO Ticket (ID_Ticket, Titulo, Descripcion, Status, Prioridad, FechaCreacion, ID_EquipoComputo, ID_Usuario, ID_Categoria)
VALUES (1, 'Problema con impresora', 'La impresora no imprime correctamente', 'Abierto', 'Media', NOW(), 1, 1, 1);
INSERT INTO Ticket (ID_Ticket, Titulo, Descripcion, Status, Prioridad, FechaCreacion, ID_EquipoComputo, ID_Usuario, ID_Categoria)
VALUES (2, 'Actualización de software', 'Actualizar el sistema operativo a la última versión', 'En Proceso', 'Alta', NOW(), 2, 2, 3);
INSERT INTO Ticket (ID_Ticket, Titulo, Descripcion, Status, Prioridad, FechaCreacion, ID_EquipoComputo, ID_Usuario, ID_Categoria)
VALUES (3, 'Cambio de teclado', 'El teclado actual está dañado', 'Cerrado', 'Baja', NOW(), 3, 3, 2);
INSERT INTO Ticket (ID_Ticket, Titulo, Descripcion, Status, Prioridad, FechaCreacion, FechaCierre, ID_EquipoComputo, ID_Usuario, ID_Categoria)
VALUES 
(4, 'Falla en conexión a internet', 'No hay conexión estable en la oficina.', 'Abierto', 'Alta', '2024-11-01 10:45:00', NULL, 8, 8, 5),
(5, 'Cambio de equipo', 'Se necesita cambiar la laptop antigua.', 'Cerrado', 'Alta', '2024-06-25 08:00:00', '2024-06-30 12:00:00', 9, 9, 2),
(6, 'Revisión de hardware', 'El ventilador hace un ruido inusual.', 'Abierto', 'Media', '2024-10-15 14:20:00', NULL, 10, 10, 4),
(7, 'Instalación de antivirus', 'No tiene protección instalada.', 'En Proceso', 'Baja', '2024-09-20 16:45:00', NULL, 11, 11, 3),
(8, 'Problema con teclado', 'La tecla “Enter” no funciona.', 'Cerrado', 'Media', '2024-08-05 12:30:00', '2024-08-10 10:00:00', 12, 12, 4),
(9, 'Optimización del sistema', 'El equipo funciona lento.', 'En Proceso', 'Alta', '2024-07-10 09:00:00', NULL, 13, 13, 3),
(10, 'Solicitud de nuevo equipo', 'Se necesita un monitor adicional.', 'Abierto', 'Alta', '2024-10-01 08:45:00', NULL, 14, 14, 2),
(11, 'Error en pantalla', 'La pantalla parpadea intermitentemente.', 'Cerrado', 'Media', '2024-08-25 15:00:00', '2024-09-01 18:00:00', 15, 15, 1),
(12, 'Problema con cámara web', 'No detecta la cámara integrada.', 'En Proceso', 'Media', '2024-09-15 11:30:00', NULL, 16, 16, 3),
(13, 'Restauración de sistema', 'El sistema operativo no arranca.', 'Cerrado', 'Alta', '2024-07-05 13:10:00', '2024-07-08 16:30:00', 17, 17, 4),
(14, 'Configuración de impresora', 'No está configurada en red.', 'Abierto', 'Baja', '2024-11-10 17:45:00', NULL, 18, 18, 5),
(15, 'Falla en disco duro', 'El disco genera errores al guardar.', 'En Proceso', 'Alta', '2024-10-05 08:10:00', NULL, 19, 19, 4),
(16, 'Solicitud de software', 'Se necesita licencia de Adobe.', 'Cerrado', 'Media', '2024-09-10 14:00:00', '2024-09-15 09:30:00', 20, 20, 3),
(17, 'Actualización de sistema', 'Instalar Windows 11.', 'En Proceso', 'Media', '2024-10-20 10:00:00', NULL, 6, 6, 1),
(18, 'Problema de arranque', 'No inicia después de un reinicio.', 'Cerrado', 'Alta', '2024-06-12 14:20:00', '2024-06-15 16:00:00', 7, 7, 4),
(19, 'Falla en ventilador', 'El ventilador está muy ruidoso.', 'En Proceso', 'Media', '2024-09-18 09:40:00', NULL, 8, 8, 3),
(20, 'Cambio de teclado', 'Teclado dañado.', 'Abierto', 'Baja', '2024-11-12 12:30:00', NULL, 9, 9, 2),
(21, 'Solicitud de mouse', 'No tiene mouse óptico.', 'Cerrado', 'Baja', '2024-06-18 10:30:00', '2024-06-20 11:30:00', 10, 10, 5);

INSERT INTO Asignacion (ID_Asignacion, FechaAsignacion, ID_Ticket, ID_Tecnico) 
VALUES (1, '2024-06-11 09:00:00', 1, 1),
       (2, '2024-09-02 10:00:00', 2, 2),
       (3, '2024-11-02 14:00:00', 3, 3),
       (4, '2024-06-26 12:00:00', 4, 4),
       (5, '2024-10-16 08:00:00', 5, 5),
       (6, '2024-09-21 11:00:00', 6, 6),
       (7, '2024-08-06 10:30:00', 7, 7),
       (8, '2024-07-11 09:30:00', 8, 8),
       (9, '2024-10-02 15:00:00', 9, 9),
       (10, '2024-08-26 13:00:00', 10, 10),
       (11, '2024-09-16 12:45:00', 11, 6),
       (12, '2024-07-06 11:00:00', 12, 7),
       (13, '2024-11-11 15:30:00', 13, 8),
       (14, '2024-10-06 13:45:00', 14, 9),
       (15, '2024-09-11 12:15:00', 15, 10);

INSERT INTO Comentarios (ID_Comentario, Contenido, Fecha, ID_Ticket, ID_Tecnico)
VALUES 
(1, 'Se realizó limpieza al cabezal de la impresora.', '2024-06-11 16:30:00', 1, 1),
(2, 'El software está descargando actualizaciones.', '2024-09-02 11:30:00', 2, 2),
(3, 'Se verificó el modem, pero sigue inestable.', '2024-11-03 13:00:00', 3, 3),
(4, 'Se realizó cambio completo del equipo.', '2024-06-27 09:00:00', 4, 4),
(5, 'Se diagnosticó que es problema del hardware.', '2024-10-16 10:30:00', 5, 5),
(6, 'Antivirus actualizado correctamente.', '2024-09-21 14:00:00', 6, 6),
(7, 'El teclado fue reemplazado con éxito.', '2024-08-07 13:30:00', 7, 7),
(8, 'Optimización del sistema concluida.', '2024-07-12 09:00:00', 8, 8),
(9, 'Monitor adicional será asignado en 3 días.', '2024-10-03 11:30:00', 9, 9),
(10, 'Pantalla fue reemplazada por garantía.', '2024-08-27 10:00:00', 10, 10);
