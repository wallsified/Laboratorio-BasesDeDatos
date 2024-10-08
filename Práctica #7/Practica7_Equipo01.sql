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


/* 2. Transacción para verificar el pago antes de procesar la orden: Escribe una transacción que
verifique que una orden no puede ser marcada como ”Shipped” si el pago no ha sido registrado
en la tabla payments. Si no existe un pago para la orden, la transacción debe ser cancelada con
ROLLBACK. */

/* 3. Transacción para actualización de precios:
Implementa una transacción que permita actualizar los precios (MSRP) de los productos en la tabla
products, asegurándote de que los productos que están asociados a órdenes pendientes (órdenes
con status igual a ”Processing”) no puedan ser modificados. Si se intenta modificar el precio de un
producto con órdenes pendientes, la transacción debe hacer un ROLLBACK. */

/* 4. Transacción para evitar eliminación de empleados con ventas en curso:
Crea una transacción que permita eliminar empleados de la tabla employees, excepto aquellos que
están relacionados con órdenes no concluidas. Si se intenta eliminar un empleado con órdenes no
concluidas, la transacción debe hacer un ROLLBACK. */

/* Indices

1. Crea un ı́ndice en la columna customerNumber de la tabla orders. */

/* 2. Crea un ı́ndice en la columna employeeNumber de la tabla employees. */

/* 3. Crea un ı́ndice en las columnas productCode y quantityOrdered de la tabla orderdetails. */


/* Evaluación de Eficiencia

Una vez que los ı́ndices hayan sido creados, realiza una evaluación de rendimiento usando la instrucción
EXPLAIN en las transacciones antes y después de la creación de los ı́ndices. Debes ejecutar las transacciones
para:
 - Medir el rendimiento de las consultas antes de la creación de ı́ndices.
 - Medir el rendimiento de las consultas después de la creación de los ı́ndices.
Para cada transacción, captura y analiza la salida de EXPLAIN para comparar el costo de ejecución de
las operaciones con y sin los ı́ndices. */