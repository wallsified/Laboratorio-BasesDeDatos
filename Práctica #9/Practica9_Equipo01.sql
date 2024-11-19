-- Práctica #9: Bloqueo y Concurrencia
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

/*
 * En la empresa (esquema de práctica anterior), cada pedido está relacionado con un único pago,
 * y para garantizar la consistencia, es crucial que:
 * - El proceso de pago se verifique antes de crear la orden y actualizar el inventario.
 * - Si el pago es exitoso, se crea la orden, se vincula el pago, se generan los detalles de la orden y se
 * actualiza el inventario.
 * - Si el pago falla, el sistema debe permitir el procesamiento de otros pagos pendientes sin afectar la
 * consistencia de los datos del inventario.
 * Para ello, se debe asegurar que, cuando un pago está siendo procesado, ningún otro proceso pueda modificar 
 * el inventario hasta que el pago haya sido confirmado como exitoso o fallido.
 * Para el flujo de pago y creación de pedidos, se propone el siguiente control de concurrencia:
 */

/*
 * 1. Selección de Productos: Múltiples usuarios pueden seleccionar productos sin interferencia en el
 * inventario (desde la aplicación).
 */

/**
 * Procedimiento permite a múltiples usuarios seleccionar productos sin interferir con el inventario.
 * Se seleccionan los detalles del producto especificado por el código del producto sin bloquear 
 * el inventario.
 * 
 * Parámetros de Entrada:
 * - IN codigoProducto (VARCHAR(15)): El código del producto que se desea seleccionar.
 * 
 * Parámetros de Salida:
 * - OUT nombreProducto (VARCHAR(70)): El nombre del producto.
 * - OUT lineaProducto (VARCHAR(50)): La línea del producto.
 * - OUT escalaProducto (VARCHAR(10)): La escala del producto.
 * - OUT proveedorProducto (VARCHAR(50)): El proveedor del producto.
 * - OUT descripcionProducto (TEXT): La descripción del producto.
 * - OUT cantidadEnStock (INT): La cantidad del producto en stock.
 * - OUT precioCompra (DECIMAL(10, 2)): El precio de compra del producto.
 * - OUT precioVentaSugerido (DECIMAL(10, 2)): El precio de venta sugerido del producto.
 * 
 *  Ejemplo de Uso:
 *  CALL SeleccionarProducto('S10_1678', @nombreProducto, @lineaProducto, @escalaProducto, @proveedorProducto, @descripcionProducto, @cantidadEnStock, @precioCompra, @precioVentaSugerido);
 * 
 *  Notas:
 * - Este procedimiento no realiza ningún bloqueo en el inventario, permitiendo que múltiples usuarios 
 *   puedan seleccionar productos simultáneamente.
 */
DELIMITER //

CREATE PROCEDURE SeleccionarProducto(
    IN productCode VARCHAR(15),
    OUT productName VARCHAR(70),
    OUT productLine VARCHAR(50),
    OUT productScale VARCHAR(10),
    OUT productVendor VARCHAR(50),
    OUT productDescription TEXT,
    OUT quantityInStock INT,
    OUT buyPrice DECIMAL(10, 2),
    OUT MSRP DECIMAL(10, 2)
)
BEGIN
     -- Se seleccionan los detalles del producto sin bloquear el inventario
    SELECT productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP
    INTO productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP
    FROM products
    WHERE productCode = productCode;
END //

DELIMITER ;


/*
 * 2. Proceso de Pago: Cuando un usuario procede al pago, se debe asegurar la consistencia mediante 
 * los siguientes pasos:
 * 	- Se bloquean los demás procesos de pago que puedan modificar el inventario, utilizando un
 * bloqueo de nivel de tabla o transacciones con aislamiento en la tabla products para evitar que
 * otras transacciones afecten el stock.
 * - Si el pago falla, se libera el bloqueo, permitiendo que el sistema continúe con el procesamiento
 * de los pedidos pendientes. 
 * Si el pago es exitoso, se realizan las siguientes acciones:
 * 		a) Crear el pedido en la tabla orders, vinculándolo con el pago verificado.
 * 		b) Crear los detalles del pedido en la tabla orderdetails.
 * 		c) Actualizar el inventario, reduciendo la columna quantityInStock en la tabla products
 * 		para cada producto del pedido.
 * - Una vez completada la actualización del inventario, se desbloquea la sección crı́tica, permitiendo 
 * el procesamiento de otros pagos.
 */

/**
 * Procedimiento para verificar si hay suficiente stock.
 * Funcion axiliar para el procedimiento principal ProcesarPagoYOrden.
 * 
 * Parámetros de Entrada:
 * @param p_productCode El código del producto a verificar.
 * @param p_quantityRequired La cantidad requerida del producto.
 * 
 * Parámetros de Salida:
 * @param p_isAvailable El resultado de la verificación de stock.
 * 
 * Ejemplo de Uso:
 * CALL VerificarStock('S10_1678', 5, @isAvailable);
 */
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

/**
 * Procedimiento principal para procesar pago y orden.
 * 
 * Parametros de Entrada:
 * @param p_customerNumber El número de cliente.
 * @param p_checkNumber El número de cheque.
 * @param p_amount El monto del pago.
 * @param p_productCode El código del producto.
 * @param p_quantity La cantidad del producto.
 * @param p_priceEach El precio unitario del producto.
 * 
 * Ejemplo de Uso:
 * CALL ProcesarPagoYOrden(103, 'CH12345', 500.00, 'S10_1678', 5, 100.00);
 */
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
    -- SERIALIZABLE evita que otros procesos modifiquen el inventario mientras se procesa el pago
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
    
    INSERT INTO orders (ordParámetros de Entrada:erNumber, orderDate, requiredDate, status, customerNumber)
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

/*
 * 3. Control de Concurrencia para Actualización de Información de Cliente:}
 * Los estudiantes deben implementar un mecanismo de concurrencia que permita que los clientes
 * o sus representantes de ventas actualicen la información del cliente sin conflicto.
 * 
 * Sugerencia: Los estudiantes pueden optar por una de las siguientes estrategias:
 * - Usar bloqueos optimistas con detección de cambios mediante un campo version o updated at
 * 	en la tabla customers, permitiendo ası́ la detección de cambios antes de proceder con la
 * 	actualización.
 * - Utilizar bloqueos explı́citos en la tabla customers mediante transacciones con el nivel de
 * aislamiento, asegurando que si un usuario o representante está realizando una actualización,
 * el otro proceso esperará hasta que finalice la transacción.

/**
 * Procedimiento para actualizar información del cliente (usando bloqueo explícito).
 * 
 * Parametros de Entrada:
 * @param p_customerNumber El número de cliente.
 * @param p_phone El número de teléfono del cliente.
 * @param p_addressLine1 La dirección del cliente.
 * @param p_city La ciudad del cliente.
 * 
 * Ejemplo de Uso:
 * CALL ActualizarCliente(103, '555-1234', '123 Main St', 'Springfield');
 */
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
    
    -- Bloquear el registro del cliente. 
    -- Esto se hace mediante la cláusula FOR UPDATE, que bloquea la fila para evitar modificaciones concurrentes.
    SELECT customerNumber 
    FROM customers 
    WHERE customerNumber = p_customerNumber 
    FOR UPDATE;

    -- Actualizar información con los nuevos valores proporcionados.
    UPDATE customers 
    SET phone = p_phone,
        addressLine1 = p_addressLine1,
        city = p_city
    WHERE customerNumber = p_customerNumber;

    COMMIT;
END //
DELIMITER ;