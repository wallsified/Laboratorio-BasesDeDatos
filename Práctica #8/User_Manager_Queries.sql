-- Conectar como user_manager
-- mysql -u user_manager -p // mariadb -u user_manager -p 
-- Contraseña: Youcanmanage0

/*
 * Como user_manager tiene permisos de SELECT, INSERT, UPDATE, DELETE, todas
 * estas queries se pueden realizar sin problema alguno en P8_FBD. Recordemos 
 * que con CALL se llaman a los procedimientos almacenados, los cuales se pueden
 * llamar por que user_manager tiene permisos de EXECUTE.
 */

SELECT * FROM P8_FBD.products LIMIT 5;
SELECT * FROM P8_FBD.orders LIMIT 5;
INSERT INTO P8_FBD.products VALUES ('TEST001', 'Producto Prueba', 'Classic Cars', '1:10', 'Vendedor Prueba', 'Descripción de Prueba', 100, 50.00, 95.70);
UPDATE P8_FBD.products SET quantityInStock = 99 WHERE productCode = 'TEST001';
DELETE FROM P8_FBD.products WHERE productCode = 'TEST001';
CALL P8_FBD.create_new_order(103, 'S10_1678', 5, 95.70);
CALL P8_FBD.update_product_price('S10_1678', 105.99);

/*
* Aunque este tipo de usuarios es necesario para llevar una gestión correcta y segmentada de la BD, el tener
* permisos como UPDATE, DELETE y EXECUTE puede ser delicado si se asignan a personas cuyo rol no corresponde
* con sus actividades a realizar. Inclusive, este nivel de acceso requiere un cuidado considerable en cuestión
* de como se gestionan las contraseñas (aqui es donde una política de expiración se vuelve necesaria), ya que
* usuarios con este nivel de acceso a la BD suelen ser que principalmente se buscan cuando se intenta vulnerar
* una BD.
*/