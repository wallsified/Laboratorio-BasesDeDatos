-- Práctica #8: Creación y Manejo de Usuarios (Privilegios y Roles)
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

/* Asignación de Privilegios
*
* 'user_manager' debe tener los siguientes permisos:
* 	• Permisos para ejecutar procedimientos almacenados (transacciones).
* 	• Permisos para realizar operaciones INSERT, UPDATE, y DELETE en las tablas involucradas en las transacciones.
* 	• Acceso completo a todas las tablas y a los ´ındices creados.
* • Permisos para manejar transacciones.
*/

CREATE USER 'user_manager'@'localhost' IDENTIFIED BY 'Youcanmanage0';

-- Permisos de ejecución en todos los procedimientos de la base de datos. 
GRANT EXECUTE ON P8_FBD.* TO 'user_manager'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.orderdetails TO 'user_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.orders TO 'user_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.employees TO 'user_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.payments TO 'user_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.products TO 'user_manager'@'localhost';
GRANT SELECT ON P8_FBD.* TO 'user_manager'@'localhost';

/*
* 'user_viewer' debe tener los siguientes permisos
* 	• Permisos solo de lectura (SELECT) sobre todas las tablas en la base de datos.
* 	• Sin permisos para modificar datos o ejecutar procedimientos almacenados.
*/

CREATE USER 'user_viewer'@'localhost' IDENTIFIED BY 'Youcanonlyselect0';
GRANT SELECT ON P8_FBD.* TO 'user_viewer'@'localhost';

/*
* Para cada usuario, utiliza la creación y asignación de roles, de modo que, se llegue al mismo estado que
* el paso anterior. Además, debes designar estos roles como predeterminados cuando los usuarios inicien
* sesíon.
*/
 
-- Primero se quitan privilegios a los usarios. No es lo mismo que borrarlos. 
 
REVOKE SELECT ON P8_FBD.* FROM 'user_viewer'@'localhost';
REVOKE ALL ON P8_FBD.* FROM 'user_manager'@'localhost';

CREATE ROLE 'user_manager_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.orderdetails TO 'user_manager_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.orders TO 'user_manager_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.employees TO 'user_manager_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.payments TO 'user_manager_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON P8_FBD.products TO 'user_manager_role';
GRANT EXECUTE ON P8_FBD.* TO 'user_manager_role';
GRANT SELECT ON P8_FBD.* TO 'user_manager_role';
GRANT 'user_manager_role' TO 'user_manager'@'localhost';


CREATE ROLE 'user_viewer_role';
GRANT SELECT ON P8_FBD.* TO 'user_viewer_role';
GRANT 'user_viewer_role' TO 'user_viewer'@'localhost';
SET DEFAULT ROLE 'user_viewer_role' FOR 'user_viewer'@'localhost';

/*
* El archivo debe además debe
* • Exhibir el resultado de realizar pruebas de DDL y DML, así como la llamada a procedimientos.
* • Explicar brevemente la relaci´on entre roles y privilegios.
* • Contener comentarios que deben mostrar el error, la razón del mismo, cómo corregirlo (o evitarlo) y
* 	 argumentación respecto impacto tiene esto en la seguridad del esquema, así como explicar en que contextos
*   es adecuado designar los permisos solicitados a usuarios (de ser necesario, argumentar la asignación
*   de política de expiración).
*/

/*
 Resultados Esperados:
 
 user_manager:
 - Debe poder realizar todas las operaciones CRUD (CREAR, LEER, ACTUALIZAR, ELIMINAR)
 - Debe poder ejecutar procedimientos almacenados
 - Debe tener acceso a todas las tablas
 
 user_viewer:
 - Solo debe poder realizar operaciones SELECT
 - NO debe poder realizar INSERT, UPDATE o DELETE
 - NO debe poder ejecutar procedimientos almacenados
 
 Errores comunes y soluciones:
 1. Acceso denegado para user_viewer en INSERT/UPDATE/DELETE
 - Este es el comportamiento esperado
 - Solución: Usar user_manager para estas operaciones
 
 2. No se puede ejecutar el procedimiento almacenado
 - Verificar si se otorgaron privilegios EXECUTE
 - Solución: Otorgar privilegios EXECUTE a user_manager_role
 
 3. Rol no activo
 - Solución: SET DEFAULT ROLE ALL TO 'nombre_usuario'@'localhost';
 
 Implicaciones de seguridad:
 - user_viewer tiene acceso de solo lectura, perfecto para roles de reportes y análisis
 - user_manager tiene acceso CRUD completo, adecuado para cuentas de servicio de aplicaciones
 - La separación de responsabilidades evita modificaciones no autorizadas de datos
 */