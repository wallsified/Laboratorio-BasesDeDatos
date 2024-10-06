-- Práctica #6: Procedimientos Almacenados, Funciones y Triggers
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

/* Funciones

1. TotalOrders. Deberá devolver el total de órdenes realizadas por ese cliente en el año proporcionado. */

CREATE FUNCTION TotalOrders(p_customerNumber INT, p_year INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    -- Primero se cuentan todas las filas en la tabla 'orders'
    -- que coincidan con el 'customerNumber' proporcionado y el año de la 'orderDate'.
    -- Luego se filtran las órdenes por el 'customerNumber' y el año.
    -- de 'orderDate' .
    SELECT COUNT(*) INTO total
    FROM orders
    WHERE customerNumber = p_customerNumber
      AND YEAR(orderDate) = p_year;
      
    RETURN total;
END;

/* 2. TotalOrdersDiscount: Esta función recibirá como parámetros el orderNumber y calculará el des-
cuento total basado en la diferencia entre el precio sugerido (MSRP) y el precio real de cada producto
ordenado en esa orden. */

CREATE FUNCTION TotalOrdersDiscount(p_orderNumber INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE totalDiscount DECIMAL(10,2) DEFAULT 0.00;
    -- Primero se calcula la suma de los descuentos por cada producto en la orden.
    -- Luego se hace un join entre 'orderdetails' (od) y 'products' (p) para obtener
    -- el precio sugerido (MSRP) y el precio real (priceEach) de cada producto.
    -- La diferencia entre MSRP y priceEach se multiplica por la cantidad ordenada (quantityOrdered)
    -- para obtener el descuento por producto.
    SELECT SUM((p.MSRP - od.priceEach) * od.quantityOrdered) INTO totalDiscount
    FROM orderdetails od
    INNER JOIN products p ON od.productCode = p.productCode
    -- Filtramos los detalles de la orden por el 'orderNumber' proporcionado a la función.
    WHERE od.orderNumber = p_orderNumber;
    
    RETURN totalDiscount;
END;

/* 3. IsOffManager: Devolverá un valor booleano indicando si ese empleado es el gerente de la oficina
asociada. */

CREATE FUNCTION IsOffManager(p_employeeNumber INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE managerCount INT;
    -- Se cuenta cuántas veces el título del empleado contiene 'Manager'.
    -- Retorna TRUE si el empleado es un gerente, de lo contrario, FALSE.
    SELECT COUNT(*) INTO managerCount
    FROM employees e
    WHERE e.employeeNumber = p_employeeNumber
      AND e.jobTitle LIKE '%Manager%';
      
    RETURN managerCount > 0;
END;

/* 4. GetTotalPayments: Devolverá el total de pagos realizados por ese cliente durante el rango de
fechas proporcionado. */

CREATE FUNCTION GetTotalPayments(
    p_customerNumber INT,
    p_startDate DATE,
    p_endDate DATE
) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE totalPayments DECIMAL(10,2) DEFAULT 0.00;

    -- Se ejecuta un SELECT SUM() para sumar los montos de los pagos en la tabla 'payments'.
    -- Luego se filtran los pagos por 'customerNumber' y el rango de fechas entre 'p_startDate' y 'p_endDate'.
    -- El resultado de la suma se almacena en la variable 'totalPayments'.
    
    SELECT SUM(amount) INTO totalPayments
    FROM payments
    WHERE customerNumber = p_customerNumber
      AND paymentDate BETWEEN p_startDate AND p_endDate;
      
    RETURN IFNULL(totalPayments, 0.00);
END;


/* Procedimientos Almacenados

1. Procedimiento para registrar una nueva orden (RegisterNewOrder): Este procedimien-
to recibirá los detalles necesarios para registrar una nueva orden, incluyendo el customerNumber,
el orderDate, los productos y la cantidad de cada uno. El procedimiento debe crear la orden y
actualizar el inventario de los productos involucrados.
*/

CREATE PROCEDURE RegisterNewOrder(
    IN p_customerNumber INT,
    IN p_orderDate DATE,
    IN p_productCodes VARCHAR(1000),
    IN p_quantities VARCHAR(1000)
)
BEGIN
    DECLARE newOrderNumber INT;
    DECLARE productCode VARCHAR(15);
    DECLARE quantityOrdered INT;
    DECLARE idx INT DEFAULT 1;
    DECLARE totalProducts INT;
    
    -- Quisimos ocupar TRANSACTION para este procedimiento 
    -- para experimentar. Entendemos que para que una transacción
    -- funcione, todas sus partes deben funcionar. Esto fue lo que
    -- nos hizo probar esto.
    START TRANSACTION;
    
    -- Se obtiene el siguiente número de orden
    SELECT IFNULL(MAX(orderNumber), 10000) + 1 INTO newOrderNumber FROM orders;
    
    -- Se inserta la nueva orden
    INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
    VALUES (newOrderNumber, p_orderDate, DATE_ADD(p_orderDate, INTERVAL 7 DAY), 'Processing', p_customerNumber);
    
    -- Se calcula el número total de productos
    SET totalProducts = (LENGTH(p_productCodes) - LENGTH(REPLACE(p_productCodes, ',', '')) + 1);
    
    WHILE idx <= totalProducts DO
        -- Extraer el código de producto
        SET productCode = SUBSTRING_INDEX(SUBSTRING_INDEX(p_productCodes, ',', idx), ',', -1);
        -- Extraer la cantidad correspondiente
        SET quantityOrdered = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(p_quantities, ',', idx), ',', -1) AS UNSIGNED);
        
        -- Insertar en orderdetails con la información necesaria.
        INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
        VALUES (
            newOrderNumber,
            productCode,
            quantityOrdered,
            (SELECT buyPrice FROM products WHERE productCode = productCode),
            idx
        );
        
        -- Se actualiza el inventario
        UPDATE products
        SET quantityInStock = quantityInStock - quantityOrdered
        WHERE productCode = productCode;
        
        SET idx = idx + 1;
    END WHILE;
    
    -- Se confirma la transacción
    COMMIT;
    
    -- Y finalmente se regresa el número de la nueva orden.
    SELECT newOrderNumber AS 'NewOrderNumber';
END;

/* 2. Procedimiento para actualizar la el estado de un cliente (UpdateCustomerState): El
procedimiento debe recibir el customerNumber y actualizar el estado del cliente a Deactivate sino
tiene ordenes pendientes asociadas, además sino ha realizado ordenes en el último año debe actualizar
su representante de ventas a NULL, asegurando que las actualizaciones no rompan la integridad
referencial con otros registros.
*/

CREATE PROCEDURE UpdateCustomerState(
    IN customerNumber INT
)
BEGIN
    DECLARE pendientes INT;
    DECLARE yearLstOrder YEAR;
   
    -- Se busca la cantidad de ordenes pendientes dado su estatus.
    SELECT COUNT(o.orderNumber) INTO pendientes
    FROM orders o
    WHERE o.customerNumber = customerNumber
      AND o.status NOT IN ('Resolved', 'Cancelled');
   
    -- Si no hay pendientes, el cliente pasa a 'Deactivate'.
    IF pendientes = 0 THEN
        UPDATE customers
        SET state = 'Deactivate'
        WHERE customerNumber = customerNumber;

    
    SELECT EXTRACT(YEAR FROM MAX(o.orderDate)) INTO yearLstOrder
    FROM orders o
    WHERE o.customerNumber = customerNumber;

    -- Se verifica si el año de la última orden es el año anterior al actual.
    IF yearLstOrder = (EXTRACT(YEAR FROM CURDATE()) - 1) THEN
        -- Si es así, se actualiza el representante de ventas del cliente a NULL,
        -- lo que indica que el cliente ya no tiene un representante asignado.
        UPDATE customers
        SET salesRepEmployeeNumber = NULL
        WHERE customerNumber = customerNumber;
    END IF;
ELSE
    -- Si el cliente tiene órdenes pendientes, se lanza un error y se cancela la operación.
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se aplicó la operación: el cliente tiene órdenes pendientes';
END IF;
END;

/* 3. Procedimiento para asignar un empleado como representante de ventas (AssignSa-
lesRepToCustomer): Este procedimiento recibirá el employeeNumber y el customerNumber, y
asignará ese empleado como representante de ventas de dicho cliente. Si el cliente ya tiene
un representante de ventas asignado, deberá actualizarse al nuevo empleado. */

CREATE PROCEDURE AssignSalesRepToCustomer(
    IN p_employeeNumber INT,
    IN p_customerNumber INT
)
BEGIN
    -- Verificar si el empleado existe
    IF NOT EXISTS (SELECT 1 FROM employees WHERE employeeNumber = p_employeeNumber) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Empleado no encontrado.';
    END IF;
    
    -- Verificar si el cliente existe
    IF NOT EXISTS (SELECT 1 FROM customers WHERE customerNumber = p_customerNumber) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cliente no encontrado.';
    END IF;
    
    -- Asignar o actualizar el representante de ventas
    UPDATE customers
    SET salesRepEmployeeNumber = p_employeeNumber
    WHERE customerNumber = p_customerNumber;
    
    -- Confirmar la actualización
    SELECT 
        customerNumber, 
        customerName, 
        salesRepEmployeeNumber 
    FROM customers 
    WHERE customerNumber = p_customerNumber;
END;

/* 4. Procedimiento para calcular el total de ventas por empleado en un rango de fechas
(TotalSalesByEmployee): Este procedimiento recibirá un rango de fechas y un employeeNumber,
y devolverá el total de ventas que ese empleado ha generado en ese perı́odo. */

CREATE PROCEDURE TotalSalesByEmployee(
    IN p_employeeNumber INT,
    IN p_startDate DATE,
    IN p_endDate DATE,
    OUT p_totalSales DECIMAL(10,2)
)
BEGIN
    -- Verificar si el empleado existe
    IF NOT EXISTS (SELECT 1 FROM employees WHERE employeeNumber = p_employeeNumber) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Empleado no encontrado.';
    END IF;
    
    -- Calcular el total de ventas
    SELECT SUM(od.quantityOrdered * od.priceEach) INTO p_totalSales
    FROM orders o
    INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
    INNER JOIN customers c ON o.customerNumber = c.customerNumber
    WHERE c.salesRepEmployeeNumber = p_employeeNumber
      AND o.orderDate BETWEEN p_startDate AND p_endDate
      AND o.status = 'Shipped';
    
    -- Manejar casos donde no hay ventas
    SET p_totalSales = IFNULL(p_totalSales, 0.00);
END;


/* Triggers

1. Trigger para evitar la eliminación de productos con órdenes pendientes (PreventPro-
ductBD): Este trigger debe activarse antes de intentar eliminar un producto y verificar si ese
producto está involucrado en alguna orden que aún no ha sido enviada. Si es ası́, debe lanzar un
error y cancelar la eliminación.
*/

CREATE TRIGGER PreventProductBD BEFORE DELETE ON products FOR EACH ROW
BEGIN
	DECLARE pendientes INT;
	-- Se revisa si el codigo de producto no corresponde a algúna
	-- orden que aun no sea enviada. En lugar de realizar casos, 
	-- solo se consideran las ordenes que tengan un estado distinto
	-- a 'Shipped', ya que por ende, los que no lo tengan serán las
	-- pendientes. 
	SELECT COUNT(od.productCode) INTO pendientes FROM orderdetails od
	INNER JOIN orders o on o.orderNumber = od.orderNumber
			WHERE o.status != "Shipped" AND od.productCode = OLD.productCode;
	-- Tengo entendido que a´si sí se cumpliría que use los diferentes a enviados
	-- Si el número de pendientes es mayor a 0, por ende no se puede borrar.
	IF pendientes > 0 THEN
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Error en la Eliminación';
	END IF;
END;


/* 2. Trigger para actualizar la cantidad de productos en inventario después de una venta
(ProductInventorySaleAU): Este trigger se debe activar después de insertar una nueva orden.
El propósito es actualizar la cantidad disponible de los productos en el inventario tras la venta de
esos productos. */

CREATE TRIGGER ProductInventorySaleAU AFTER INSERT ON orderdetails FOR EACH ROW
BEGIN 
    DECLARE currStock INT;
    -- Se revisa si la cantidad de productos en stock es suficiente para realizar la venta y se almacena en una variable currStock
    SELECT quantityInStock INTO currStock
    FROM products
    WHERE productCode = NEW.productCode;
-- Si no lo es, se lanza un error y se cancela la inserción de la orden
    IF currStock - NEW.quantityOrdered < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: No hay Stock suficiente para realizar la venta';
    ELSE
	-- En caso de que haya suficiente stock, se actualiza la cantidad de productos en stock.
        UPDATE products 
        SET quantityInStock = quantityInStock - NEW.quantityOrdered
        WHERE productCode = NEW.productCode;
    END IF;
END;

/* 3. Trigger para validar el lı́mite de crédito de un cliente (ValidateCustomerCreditLimit-
BI): Este trigger se debe ejecutar antes de registrar una nueva orden. Si la suma del monto de la
nueva orden más las órdenes previas excede el lı́mite de crédito del cliente, el trigger debe cancelar
la inserción de la orden. */

CREATE TRIGGER ValidateCustomerCreditLimitBI 
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE totalExistingOrders DECIMAL(10,2);
    DECLARE newOrderTotal DECIMAL(10,2);
    DECLARE creditLimit DECIMAL(10,2);

    -- Obtener el límite de crédito del cliente
    SELECT creditLimit INTO creditLimit 
    FROM customers 
    WHERE customerNumber = NEW.customerNumber;

    -- Calcular el total de órdenes existentes (sumando el total de cada orden)
    SELECT IFNULL(SUM(od.quantityOrdered * od.priceEach), 0.00) INTO totalExistingOrders
    FROM orders o
    INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
    WHERE o.customerNumber = NEW.customerNumber
      AND o.status NOT IN ('Cancelled');

    -- Calcular el total de la nueva orden
    SELECT IFNULL(SUM(od.quantityOrdered * od.priceEach), 0.00) INTO newOrderTotal
    FROM orderdetails od
    WHERE od.orderNumber = NEW.orderNumber;

    -- Verificar si el límite de crédito será excedido
    IF (totalExistingOrders + newOrderTotal) > creditLimit THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Excede el límite de crédito del cliente.';
    END IF;
END;

/* 4. Trigger para actualizar el estado de un cliente a Activate (CustomerStatusBI): Antes
de que se realice una orden, deberá verificar que si ya está activo no haga actualización. */

CREATE TRIGGER CustomerStatusBI 
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE currentStatus VARCHAR(20);

    -- Obtener el estado actual del cliente
    SELECT state INTO currentStatus 
    FROM customers 
    WHERE customerNumber = NEW.customerNumber;

    -- Verificar el estado del cliente
    IF currentStatus = 'Active' THEN
        -- No hacer nada si ya está activo
        NULL;
    ELSE
        -- Se actualiza el estado del cliente a 'Active' si es necesario
        UPDATE customers 
        SET state = 'Active' 
        WHERE customerNumber = NEW.customerNumber;
    END IF;
END;

/* Vistas

1. Vista para mostrar el historial de órdenes de cada cliente (CustomerOrderHistory-
View): Esta vista debe incluir el nombre del cliente, la cantidad de órdenes realizadas, el total de
pagos recibidos, y el estado actual de cada una de sus órdenes.
*/

CREATE VIEW CustomerOrderHistoryView AS 
	SELECT c.customerName, COUNT(o.orderNumber) as 'Cantidad de Ordenes', 
		SUM(p.amount) as 'Total de Pagos Recibidos', o.status as 'Estado de la Orden'
	FROM customers c
	-- El join se hace para revisar las coincidencias entre las tablas customers y orders
	-- revisando si el customerNumber es igual en ambas tablas y de ahi obtener cuantas ordenes
	-- ha realizado un cliente en específico.
		INNER JOIN orders o on c.customerNumber = o.customerNumber
	-- El segundo join se hace para revisar las coincidencias entre las tablas customers y payments
	-- revisando si el customerNumber es igual en ambas tablas y de ahi obtener el total de pagos
	-- del cliente específico
		INNER JOIN payments p on c.customerNumber = p.customerNumber
	GROUP BY c.customerNumber;

/* 2. Vista para consultar el inventario de productos (ProductInventoryView): Debe mostrar
el productCode, productName, quantityInStock, y el precio de cada producto disponible. Esta
vista se usará para generar reportes de inventario. */

CREATE VIEW ProductInventoryView AS 
	SELECT productCode, productName, quantityInStock FROM products p;

/* 3. Vista para consultar las ventas por empleado (EmployeeSalesView): Esta vista debe mos-
trar el nombre completo del empleado, el número de clientes que tiene asignados, y el total de ventas
generadas por ese empleado. */

CREATE VIEW EmployeeSalesView AS 
    SELECT CONCAT(e.firstName, ' ', e.lastName) as 'Nombre Completo Empleado', 
        COUNT(c.customerNumber) as 'Número de Clientes', 
        SUM(od.quantityOrdered * od.priceEach) as 'Total de Ventas'
    FROM employees e
	-- Se necesitan 3 joins para obtener el total de ventas por empleado. Primero se une 
	-- la tabla employees con customers revisando si el employeeNumber es igual al salesRepEmployeeNumber
	-- luego se une la tabla customers con orders revisando si el customerNumber es igual en ambas tablas
	-- y finalmente se une la tabla orders con orderdetails revisando si el orderNumber coincide en ambas tablas
        INNER JOIN customers c on e.employeeNumber = c.salesRepEmployeeNumber
        INNER JOIN orders o on c.customerNumber = o.customerNumber
        INNER JOIN orderdetails od on o.orderNumber = od.orderNumber
    GROUP BY e.employeeNumber;

/* 4. Vista para consultar el detalle de órdenes (OrderDetailsView): Debe incluir información
sobre cada orden, como el número de orden, la fecha de la orden, el cliente que la realizó, el total
de productos ordenados, y el monto total de la orden. */

CREATE VIEW OrderDetailsView AS 
	SELECT o.orderNumber, o.orderDate, c.customerName, 
		SUM(od.quantityOrdered) as 'Total de Productos Ordenados', 
		SUM(od.quantityOrdered * od.priceEach) as 'Monto Total de la Orden'
	FROM orders o
	-- Se necesitan 2 joins para obtener el detalle de órdenes. Primero se une 
	-- 'orders' con 'customers' revisando si el customerNumber es igual en ambas tablas y
	-- luego se une 'customers' con 'orderdetails' revisando si el 'customerNumber' coincide tambien.
		INNER JOIN customers c on o.customerNumber = c.customerNumber
		INNER JOIN orderdetails od on o.orderNumber = od.orderNumber
	GROUP BY o.orderNumber;
