-- Conectar como user_viewer
-- mysql -u user_viewer -p // mariadb -u user_viewer -p 
-- Contraseña: Youcanonlyselect0

-- Probar permisos SELECT (debería funcionar)
SELECT * FROM P8_FBD.products LIMIT 5;
SELECT * FROM P8_FBD.orders LIMIT 5;

-- Probar permisos INSERT (debería fallar)
INSERT INTO P8_FBD.products VALUES ('TEST002', 'Producto Prueba', 'Classic Cars', '1:10', 'Vendedor Prueba', 'Descripción de Prueba', 100, 50.00, 95.70);
/*
 * SQL Error [1142] [42000]: (conn=23) INSERT command denied to user 'user_viewer'@'localhost' for table `P8_FBD`.`products`
 */

-- Probar permisos UPDATE (debería fallar)
UPDATE P8_FBD.products SET quantityInStock = 99 WHERE productCode = 'S10_1678';
/*
 * SQL Error [1142] [42000]: (conn=23) UPDATE command denied to user 'user_viewer'@'localhost' for table `P8_FBD`.`products`
 */

-- Probar permisos DELETE (debería fallar)
DELETE FROM P8_FBD.products WHERE productCode = 'S10_1678';
/*
 * SQL Error [1142] [42000]: (conn=23) DELETE command denied to user 'user_viewer'@'localhost' for table `P8_FBD`.`products`
 */

-- Probar procedimientos almacenados (debería fallar)
CALL P8_FBD.create_new_order(103, 'S10_1678', 5, 95.70);
/*
 * SQL Error [1370] [42000]: (conn=23) execute command denied to user 'user_viewer'@'localhost' for routine 'P8_FBD.create_new_order'
 */


/*
 * En general, estos errores ocupan por la cantidad de permisos que tiene el usuario. Un usuario con este nivel de
 * acceso tiene sentido en escenarios donde, por ejemplo, se busca hacer una revisión de los productos y de las
 * órdenes en la BD. Por ejemplo, cuando una persona busca hacer un inventario de los productos que se venden, 
 * o si algún administrativo (ajeno a la BD pero de una misma empresa) quisiese obtener un historial de todas 
 * las órdenes que se han hecho, etc. 
 * 
 * Se vuelve necesario tener un usuario que solo tenga este nivel de acceso para prevenir inserciones y/o 
 * modificaciones no permitadas (ya sea por acceso o por la información que se busca alterar). Incluso, en un
 * escenario de que un tercero tenga las contraseñas de acceso, limitar a estos permisos evita nuevamente lo
 * anterior. 
 */

