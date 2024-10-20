-- Práctica #7: Transacciones, Índices y Evaluación de Rendimiento
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

/* Transacciones

1. Transacción para realizar una orden:
Debes escribir una transacción que inserte una nueva orden en la tabla orders y asocie productos
a la orden en la tabla orderdetails. Asegúrate de que no se vendan más productos de los que
hay disponibles en el inventario (quantityInStock en la tabla products). Si el stock es insuficiente
para completar la orden, la transacción debe hacer un ROLLBACK. */

START TRANSACTION;

-- 1. Insertar una nueva orden en la tabla orders
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, customerNumber)
VALUES (NEW_ORDER_NUMBER, NOW(), CURRENT_DAY, NULL, 'Processing', CUSTOMER_NUMBER);

-- 2. Insertar productos en orderdetails y verificar stock
-- Este bloque se repite por cada producto en la orden
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
END;

-- Verificar si el stock es suficiente. Se necesita ingresar el código del producto, la cantidad ordenada y el precio de alguna manera.
IF (SELECT quantityInStock FROM products WHERE productCode = 'PRODUCT_CODE') >= ORDERED_QUANTITY THEN
    -- Reducir el stock disponible
    UPDATE products
    SET quantityInStock = quantityInStock - ORDERED_QUANTITY
    WHERE productCode = 'PRODUCT_CODE';

    -- Insertar en orderdetails
    INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
    VALUES (NEW_ORDER_NUMBER, 'PRODUCT_CODE', ORDERED_QUANTITY, PRICE, LINE_NUMBER);
ELSE
    -- Si el stock es insuficiente, lanzar error
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para el producto PRODUCT_CODE';
END IF;

COMMIT;
    
END;

/* 2. Transacción para verificar el pago antes de procesar la orden: Escribe una transacción que
verifique que una orden no puede ser marcada como ”Shipped” si el pago no ha sido registrado
en la tabla payments. Si no existe un pago para la orden, la transacción debe ser cancelada con
ROLLBACK. */

START TRANSACTION;

-- Manejo de errores para hacer rollback en caso de problemas
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
END;

-- Verificar si existe un pago registrado para la orden
IF NOT EXISTS (
    SELECT 1
    FROM payments p
    JOIN orders o ON p.customerNumber = o.customerNumber
    WHERE o.orderNumber = 'ORDER_NUMBER'  -- Mismo problema de la entrada de parámetros
) THEN
    -- Si no existe un pago para la orden, hacer ROLLBACK
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se ha registrado un pago para esta orden, no puede ser marcada como "Shipped".';
ELSE
    -- Si existe un pago, actualizar el estado de la orden a "Shipped"
    UPDATE orders
    SET status = 'Shipped', shippedDate = NOW()
    WHERE orderNumber = 'ORDER_NUMBER';  -- Problema de entrada de parámetros.
END IF;

-- Confirmar la transacción
COMMIT;

END;

/* 3. Transacción para actualización de precios:
Implementa una transacción que permita actualizar los precios (MSRP) de los productos en la tabla
products, asegurándote de que los productos que están asociados a órdenes pendientes (órdenes
con status igual a ”Processing”) no puedan ser modificados. Si se intenta modificar el precio de un
producto con órdenes pendientes, la transacción debe hacer un ROLLBACK. */

START TRANSACTION;

-- 1. Manejar posibles errores para realizar un ROLLBACK en caso de que se detecte un producto con orden pendiente
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
END;

-- 2. Verificar si el producto tiene órdenes pendientes
IF EXISTS (
    SELECT 1
    FROM orderdetails od
    JOIN orders o ON od.orderNumber = o.orderNumber
    WHERE o.status = 'Processing'
    AND od.productCode = 'PRODUCT_CODE' -- Pero aqui se necesitaria ingresar el código del producto de alguna manera. 
) THEN
    -- Si hay una orden pendiente con status "Processing", cancelar la transacción
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto tiene órdenes pendientes en procesamiento, no se puede actualizar el precio.';
ELSE
    -- 3. Si no hay órdenes pendientes, actualizar el precio (MSRP) del producto
    UPDATE products
    SET MSRP = NEW_PRICE -- Aquí también se necesita ingresar el nuevo precio de alguna manera.
    WHERE productCode = 'PRODUCT_CODE';
END IF;

-- 4. Confirmar la transacción si no hubo problemas
COMMIT;

END;

/* 4. Transacción para evitar eliminación de empleados con ventas en curso:
Crea una transacción que permita eliminar empleados de la tabla employees, excepto aquellos que
están relacionados con órdenes no concluidas. Si se intenta eliminar un empleado con órdenes no
concluidas, la transacción debe hacer un ROLLBACK. */

START TRANSACTION;

-- Handler para hacer rollback  alguna transacción transaction en caso de alguna excepción.
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed, rolled back.';
END;

-- Revisa si el employee existe
IF NOT EXISTS (
    SELECT 1 
    FROM employees 
    WHERE employeeNumber = 'EMPLOYEE_NUMBER'
) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee does not exist.';
END IF;

-- Check if the employee has any pending orders (que no hayan estado enviadas "Shipped")
IF EXISTS (
    SELECT 1 
    FROM orders o
    WHERE o.employeeNumber = 'EMPLOYEE_NUMBER'
    AND o.status != 'Shipped'
    FOR UPDATE -- Lock the rows to prevent race conditions during deletion
) THEN
    -- If there are pending orders, rollback and raise an error
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete employee with pending orders.';
ELSE
    -- If no pending orders, proceed to delete the employee
    DELETE FROM employees 
    WHERE employeeNumber = 'EMPLOYEE_NUMBER';
END IF;

-- If everything is fine, commit the transaction
COMMIT;

/* Indices

1. Crea un ı́ndice en la columna customerNumber de la tabla orders. */

CREATE INDEX idx_customerNumber ON orders(customerNumber);

/* 2. Crea un ı́ndice en la columna employeeNumber de la tabla employees. */

CREATE INDEX idx_employeeNumber ON employees(employeeNumber);

/* 3. Crea un ı́ndice en las columnas productCode y quantityOrdered de la tabla orderdetails. */

CREATE INDEX idx_productCode_quantityOrdered ON orderdetails(productCode, quantityOrdered);

/* Evaluación de Eficiencia

Una vez que los ı́ndices hayan sido creados, realiza una evaluación de rendimiento usando la instrucción
EXPLAIN en las transacciones antes y después de la creación de los ı́ndices. Debes ejecutar las transacciones
para:
 - Medir el rendimiento de las consultas antes de la creación de ı́ndices.
 - Medir el rendimiento de las consultas después de la creación de los ı́ndices.
Para cada transacción, captura y analiza la salida de EXPLAIN para comparar el costo de ejecución de
las operaciones con y sin los ı́ndices. */