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
