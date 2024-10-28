-- Práctica #8: Creación y Manejo de Usuarios (Privilegios y Roles)
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

/* Asignación de Privilegios

'user_manager' debe tener los siguientes permisos:
    • Permisos para ejecutar procedimientos almacenados (transacciones).
    • Permisos para realizar operaciones INSERT, UPDATE, y DELETE en las tablas involucradas en las transacciones.
    • Acceso completo a todas las tablas y a los ´ındices creados.
    • Permisos para manejar transacciones.

'user_viewer' debe tener los siguientes permisos
    • Permisos solo de lectura (SELECT) sobre todas las tablas en la base de datos.
    • Sin permisos para modificar datos o ejecutar procedimientos almacenados. 

Para cada usuario, utiliza la creación y asignación de roles, de modo que, se llegue al mismo estado que
el paso anterior. Además, debes designar estos roles como predeterminados cuando los usuarios inicien
sesíon.
*/

/* El archivo debe además debe 
    - Exhibir el resultado de realizar pruebas de DDL y DML, así como la llamada a procedimientos.
    - Explicar brevemente la relaci´on entre roles y privilegios.
    - Contener comentarios que deben mostrar el error, la razón del mismo, cómo corregirlo (o evitarlo) y 
    argumentación respecto impacto tiene esto en la seguridad del esquema, así como explicar en que contextos
    es adecuado designar los permisos solicitados a usuarios (de ser necesario, argumentar la asignación
    de política de expiración). 
*/