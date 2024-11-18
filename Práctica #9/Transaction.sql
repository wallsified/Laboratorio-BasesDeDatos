-- Procedimiento para verificar si hay suficiente stock
DELIMITER //
CREATE PROCEDURE VerificarStock(
    IN p_productCode VARCHAR(15),
    IN p_quantityRequired INT,
    OUT p_isAvailable BOOLEAN
)
BEGIN
    DECLARE current_stock INT;
    
    SELECT quantityInStock INTO current_stock
    FROM products 
    WHERE productCode = p_productCode
    FOR UPDATE;  -- Bloquea la fila para evitar modificaciones concurrentes
    
    SET p_isAvailable = (current_stock >= p_quantityRequired);
END //
DELIMITER ;

-- Procedimiento principal para procesar pago y orden
DELIMITER //
CREATE PROCEDURE ProcesarPagoYOrden(
    IN p_customerNumber INT,
    IN p_checkNumber VARCHAR(50),
    IN p_amount DECIMAL(10,2),
    IN p_productCode VARCHAR(15),
    IN p_quantity INT,
    IN p_priceEach DECIMAL(10,2)
)
BEGIN
    DECLARE v_orderNumber INT;
    DECLARE v_stockAvailable BOOLEAN;
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la transacción';
    END;

    START TRANSACTION;
    
    -- Establecer nivel de aislamiento
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    
    -- Verificar stock
    CALL VerificarStock(p_productCode, p_quantity, v_stockAvailable);
    
    IF NOT v_stockAvailable THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;

    -- Registrar el pago
    INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount)
    VALUES (p_customerNumber, p_checkNumber, CURDATE(), p_amount);

    -- Crear la orden
    SET v_orderNumber = (SELECT COALESCE(MAX(orderNumber), 0) + 1 FROM orders);
    
    INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
    VALUES (v_orderNumber, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'In Process', p_customerNumber);

    -- Crear detalle de orden
    INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
    VALUES (v_orderNumber, p_productCode, p_quantity, p_priceEach, 1);

    -- Actualizar inventario
    UPDATE products 
    SET quantityInStock = quantityInStock - p_quantity
    WHERE productCode = p_productCode;

    COMMIT;
END //
DELIMITER ;

-- Procedimiento para actualizar información del cliente (usando bloqueo explícito)
DELIMITER //
CREATE PROCEDURE ActualizarCliente(
    IN p_customerNumber INT,
    IN p_phone VARCHAR(50),
    IN p_addressLine1 VARCHAR(50),
    IN p_city VARCHAR(50)
)
BEGIN
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al actualizar cliente';
    END;

    START TRANSACTION;
    
    -- Bloquear el registro del cliente
    SELECT customerNumber 
    FROM customers 
    WHERE customerNumber = p_customerNumber 
    FOR UPDATE;

    -- Actualizar información
    UPDATE customers 
    SET phone = p_phone,
        addressLine1 = p_addressLine1,
        city = p_city
    WHERE customerNumber = p_customerNumber;

    COMMIT;
END //
DELIMITER ;