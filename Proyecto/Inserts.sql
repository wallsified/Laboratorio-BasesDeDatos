-- Insertar Areas
INSERT INTO
    Area (ID_Area, Nombre)
VALUES
    (1, 'Desarrollo de Software'),
    (2, 'Soporte Técnico'),
    (3, 'Recursos Humanos'),
    (4, 'Contabilidad'),
    (5, 'Ventas');

-- Insertar Técnicos
INSERT INTO
    Tecnico (ID_Tecnico, Nombre, Apellido, Nivel, ID_Area)
VALUES
    (1, 'Juan', 'Pérez', 'Senior', 2),
    (2, 'María', 'García', 'Junior', 2),
    (3, 'Carlos', 'López', 'Medio', 2),
    (4, 'Ana', 'Martínez', 'Senior', 1),
    (5, 'Roberto', 'Sánchez', 'Junior', 1);

-- Insertar Usuarios/Empleados
INSERT INTO
    UsuarioEmpleado (ID_Usuario, Nombre, Apellido, RolPuesto, ID_Area)
VALUES
    (1, 'Luis', 'Rodríguez', 'Desarrollador', 1),
    (2, 'Patricia', 'Gómez', 'Contador', 4),
    (3, 'Miguel', 'Torres', 'Vendedor', 5),
    (4, 'Laura', 'Díaz', 'Reclutador', 3),
    (5, 'Jorge', 'Ramírez', 'Desarrollador Senior', 1);

-- Insertar Equipos de Cómputo
INSERT INTO
    EquipoComputo (
        ID_EquipoComputo,
        Marca,
        Modelo,
        No_Serial,
        CantidadMemoria,
        CantidadAlmacenamiento,
        ModeloProcesador,
        ID_Usuario
    )
VALUES
    (
        1,
        'Dell',
        'Latitude 5420',
        'DL123456',
        '16GB',
        '512GB',
        'Intel i7-1165G7',
        1
    ),
    (
        2,
        'HP',
        'ProBook 450',
        'HP789012',
        '8GB',
        '256GB',
        'Intel i5-1135G7',
        2
    ),
    (
        3,
        'Lenovo',
        'ThinkPad T14',
        'LN345678',
        '32GB',
        '1TB',
        'AMD Ryzen 7',
        3
    ),
    (
        4,
        'Apple',
        'MacBook Pro',
        'AP901234',
        '16GB',
        '512GB',
        'M1 Pro',
        4
    ),
    (
        5,
        'Dell',
        'XPS 13',
        'DL567890',
        '16GB',
        '1TB',
        'Intel i9-11900H',
        5
    );

-- Insertar Categorías de Tickets
INSERT INTO
    CategoriaTicket (ID_Categoria, Nombre)
VALUES
    (1, 'Hardware'),
    (2, 'Software'),
    (3, 'Red'),
    (4, 'Accesos'),
    (5, 'Otros');

-- Insertar Tickets
INSERT INTO
    Ticket (
        ID_Ticket,
        Titulo,
        Descripcion,
        Status,
        Prioridad,
        FechaCreacion,
        FechaCierre,
        ID_EquipoComputo,
        ID_Usuario,
        ID_Categoria
    )
VALUES
    (
        1,
        'Error al iniciar Windows',
        'El equipo no inicia correctamente',
        'Abierto',
        'Alta',
        '2024-03-15 09:00:00',
        NULL,
        1,
        1,
        2
    ),
    (
        2,
        'Problema de impresión',
        'No se puede conectar a la impresora',
        'En Proceso',
        'Media',
        '2024-03-14 14:30:00',
        NULL,
        2,
        2,
        3
    ),
    (
        3,
        'Actualización de memoria',
        'Solicitud de actualización RAM',
        'Cerrado',
        'Baja',
        '2024-03-13 11:15:00',
        '2024-03-14 16:00:00',
        3,
        3,
        1
    ),
    (
        4,
        'Acceso denegado',
        'No puedo acceder al sistema CRM',
        'Abierto',
        'Alta',
        '2024-03-15 10:45:00',
        NULL,
        4,
        4,
        4
    ),
    (
        5,
        'Lentitud en el sistema',
        'El equipo está muy lento',
        'En Proceso',
        'Media',
        '2024-03-14 13:20:00',
        NULL,
        5,
        5,
        2
    );

-- Insertar Asignaciones
INSERT INTO
    Asignacion (
        ID_Asignacion,
        FechaAsignacion,
        ID_Ticket,
        ID_Tecnico
    )
VALUES
    (1, '2024-03-15 09:15:00', 1, 1),
    (2, '2024-03-14 14:45:00', 2, 2),
    (3, '2024-03-13 11:30:00', 3, 3),
    (4, '2024-03-15 11:00:00', 4, 4),
    (5, '2024-03-14 13:35:00', 5, 5);

-- Insertar Comentarios
INSERT INTO
    Comentarios (
        ID_Comentario,
        Contenido,
        Fecha,
        ID_Ticket,
        ID_Tecnico
    )
VALUES
    (
        1,
        'Se inició diagnóstico del sistema',
        '2024-03-15 09:30:00',
        1,
        1
    ),
    (
        2,
        'Verificando configuración de red',
        '2024-03-14 15:00:00',
        2,
        2
    );