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

