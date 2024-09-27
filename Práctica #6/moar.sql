CREATE TRIGGER PreventProductBD BEFORE DELETE ON products FOR EACH ROW
BEGIN 
	DECLARE pendientes BOOLEAN
	SET pendientes = (SELECT COUNT(od.productCode) > 0 FROM orderdetails od
		INNER JOIN orders o on o.orderNumber = od.orderNumber
			WHERE o.status = "Shipped");
	IF pendientes THEN
		SIGNAL SQLSTATE '4500'
			SET MESSAGE_TEXT = 'ERROR En La Eliminación';
	END IF;
END;
-- DROP TRIGGER PreventProductBD
-- DELETE FROM products WHERE productCode = 'S18_1749'

CREATE TRIGGER ProductInventorySaleAU AFTER INSERT ON orderdetails FOR EACH ROW
BEGIN 
	IF (products.quantityInStock - NEW.quantityOrdered) < 0 THEN
		
	UPDATE products 
		SET products.quantityInStock = (products.quantityInStock - NEW.quantityOrdered);
	END;
END;

CREATE VIEW ProductInventoryView AS 
	SELECT productCode, productName, quantityInStock FROM products p;

-- Las vistas siempre se llaman con SELECT * FROM <VIEW> a menos que se
-- necesiten columnas específicas.
SELECT * FROM ProductInventoryView;