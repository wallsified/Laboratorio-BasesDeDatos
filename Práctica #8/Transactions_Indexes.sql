/*
 * Nota: Estas transacciónes provienen de la práctica #7
 * Se reutilizan con motivos de la práctica en curso.
 */
/* Transacciones
 
 1. Transacción para realizar una orden:
 Debes escribir una transacción que inserte una nueva orden en la tabla orders y asocie productos
 a la orden en la tabla orderdetails. Asegúrate de que no se vendan más productos de los que
 hay disponibles en el inventario (quantityInStock en la tabla products). Si el stock es insuficiente
 para completar la orden, la transacción debe hacer un ROLLBACK. */
DELIMITER //

CREATE PROCEDURE create_new_order(
    p_customer_number INT,
    p_product_code VARCHAR(15),
    p_quantity INT,
    p_price DECIMAL(10, 2)
)
BEGIN
    DECLARE v_new_order_number INT;

    START TRANSACTION;

    SELECT
        COALESCE(MAX(orderNumber), 0) + 1 INTO v_new_order_number
    FROM
        orders;

    INSERT INTO
        orders (
            orderNumber,
            orderDate,
            requiredDate,
            status,
            customerNumber
        )
    VALUES
        (
            v_new_order_number,
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 7 DAY),
            'Processing',
            p_customer_number
        );

    IF (
        SELECT
            quantityInStock
        FROM
            products
        WHERE
            productCode = p_product_code
    ) >= p_quantity THEN
        UPDATE
            products
        SET
            quantityInStock = quantityInStock - p_quantity
        WHERE
            productCode = p_product_code;

        INSERT INTO
            orderdetails (
                orderNumber,
                productCode,
                quantityOrdered,
                priceEach,
                orderLineNumber
            )
        VALUES
            (
                v_new_order_number,
                p_product_code,
                p_quantity,
                p_price,
                1
            );

        COMMIT;

    ELSE
        ROLLBACK;

    END IF;

END //

DELIMITER ;


/* 2. Transacción para verificar el pago antes de procesar la orden: Escribe una transacción que
 verifique que una orden no puede ser marcada como ”Shipped” si el pago no ha sido registrado
 en la tabla payments. Si no existe un pago para la orden, la transacción debe ser cancelada con
 ROLLBACK. */
DELIMITER //

CREATE PROCEDURE update_order_status(p_order_number INT)
BEGIN
    START TRANSACTION;

    IF EXISTS (
        SELECT
            1
        FROM
            payments p
            JOIN customers c ON p.customerNumber = c.customerNumber
            JOIN orders o ON c.customerNumber = o.customerNumber
        WHERE
            o.orderNumber = p_order_number
    ) THEN
        UPDATE
            orders
        SET
            status = 'Shipped',
            shippedDate = CURDATE()
        WHERE
            orderNumber = p_order_number;

        COMMIT;

    ELSE
        ROLLBACK;

    END IF;

END //

DELIMITER ;
/* 3. Transacción para actualización de precios:
 Implementa una transacción que permita actualizar los precios (MSRP) de los productos en la tabla
 products, asegurándote de que los productos que están asociados a órdenes pendientes (órdenes
 con status igual a ”Processing”) no puedan ser modificados. Si se intenta modificar el precio de un
 producto con órdenes pendientes, la transacción debe hacer un ROLLBACK. */
DELIMITER //


CREATE PROCEDURE update_product_price(p_product_code VARCHAR(15), p_new_price DECIMAL(10,2))
BEGIN
    -- First check if product exists
    IF NOT EXISTS (SELECT 1 FROM products WHERE productCode = p_product_code) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El producto no existe';
    END IF;
    
    START TRANSACTION;
    
    -- Check for processing orders and print result
    IF EXISTS (
        SELECT 1 
        FROM orderdetails od 
        JOIN orders o ON od.orderNumber = o.orderNumber 
        WHERE od.productCode = p_product_code 
        AND o.status = 'Processing'
    ) THEN
        SELECT 'No se puede actualizar: El producto tiene órdenes en proceso' as mensaje;
        ROLLBACK;
    ELSE
        -- Update the price
        UPDATE products 
        SET MSRP = p_new_price 
        WHERE productCode = p_product_code;
        
        -- Check if any rows were affected
        IF ROW_COUNT() > 0 THEN
            SELECT 'Precio actualizado exitosamente' as mensaje;
            COMMIT;
        ELSE
            SELECT 'No se actualizaron filas' as mensaje;
            ROLLBACK;
        END IF;
    END IF;
END //

DELIMITER ;

/* 4. Transacción para evitar eliminación de empleados con ventas en curso:
 Crea una transacción que permita eliminar empleados de la tabla employees, excepto aquellos que
 están relacionados con órdenes no concluidas. Si se intenta eliminar un empleado con órdenes no
 concluidas, la transacción debe hacer un ROLLBACK. */
DELIMITER //


CREATE PROCEDURE delete_employee(p_employee_number INT)
BEGIN
    DECLARE v_exists INT;
    
    SELECT COUNT(*) INTO v_exists 
    FROM employees 
    WHERE employeeNumber = p_employee_number;
    
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El empleado no existe';
    END IF;
    
    START TRANSACTION;
    
    IF EXISTS (
        SELECT 1 
        FROM customers c
        JOIN orders o ON c.customerNumber = o.customerNumber
        WHERE c.salesRepEmployeeNumber = p_employee_number
        AND o.status != 'Shipped'
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se puede eliminar: El empleado tiene órdenes pendientes';
    ELSEIF EXISTS (
        SELECT 1 
        FROM employees 
        WHERE reportsTo = p_employee_number
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se puede eliminar: El empleado tiene subordinados';
    ELSE
        DELETE FROM employees 
        WHERE employeeNumber = p_employee_number;
        COMMIT;
    END IF;
END //

DELIMITER ;