-- Conectar como user_manager
-- mysql -u user_manager -p // mariadb -u user_manager -p 
-- Contraseña: Youcanmanage0

SELECT * FROM P8_FBD.products LIMIT 5;
SELECT * FROM P8_FBD.orders LIMIT 5;
INSERT INTO P8_FBD.products VALUES ('TEST001', 'Producto Prueba', 'Classic Cars', '1:10', 'Vendedor Prueba', 'Descripción de Prueba', 100, 50.00, 95.70);
UPDATE P8_FBD.products SET quantityInStock = 99 WHERE productCode = 'TEST001';
DELETE FROM P8_FBD.products WHERE productCode = 'TEST001';
CALL P8_FBD.create_new_order(103, 'S10_1678', 5, 95.70);
CALL P8_FBD.update_product_price('S10_1678', 105.99);