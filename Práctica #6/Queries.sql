-- DELIMITER //
CREATE FUNCTION TotalOrdersDiscount
					(orderNumber INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
	DECLARE discount DECIMAL(10,2);
	SET discount = (SELECT SUM((p.MSRP - od.priceEach) * od.quantityOrdered) FROM orders o 
	INNER JOIN orderdetails od ON 
		o.orderNumber  = od.orderNumber 
	INNER JOIN products p ON
		p.productCode = od.productCode 
			WHERE o.orderNumber = orderNumber);
	RETURN discount;
END ;
	
-- DELIMITER ;


CREATE PROCEDURE UpdateCustomerState(
				IN customerNumber INT)
BEGIN
	DECLARE pendientes BOOLEAN;
	DECLARE yearLstOrder YEAR;
	SET pendientes = (SELECT COUNT(o.orderNumber) = 0 FROM orders o 
	WHERE o.customerNumber = customerNumber
	-- Se puede verificar si está y negar la salida
	-- equivalencia entre condicionales
		AND o.status NOT IN ('Resolved', 'Cancelled'));
	IF NOT pendientes THEN 
		UPDATE customer 
			SET customer.state = 'Deactivate'
				WHERE customer.customerNumber = customerNumber;
			-- Obtenemos la fecha más reciente de ordenes asociadas a un cliente
			-- Obtenemos el año de la fecha más reciente 
			-- Se podría hacer con DATE_SUBB() 
			SET yearLstOrder = (SELECT EXTRACT(YEAR FROM MAX(o.orderDate)) from orders o
									WHERE o.customerNumber = customerNumber);
								-- Obtenemos el año actual y le restamos uno
			IF yearLstOrder = (EXTRACT(YEAR FROM CURDATE())-1) THEN
				UPDATE customers SET customers.salesRepEmployeeNumber = NULL 
					WHERE customers.customerNumber = customerNumber;
			END IF;
		-- Podríamos agregar un else para notificar al usuario que no se aplico la operación
	END IF;
	-- También aquí
END ; 

	

	
	