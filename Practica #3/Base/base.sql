CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    LAST_NAME VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(100),
    PHONE_NUMBER VARCHAR2(15),
    CITY VARCHAR2(50)
);

CREATE TABLE PRODUCTS (
    PRODUCT_ID NUMBER PRIMARY KEY,
    PRODUCT_NAME VARCHAR2(100) NOT NULL,
    CATEGORY VARCHAR2(50),
    PRICE NUMBER CHECK (PRICE > 0)
);

CREATE TABLE ORDERS (
    ORDER_ID NUMBER PRIMARY KEY,
    ORDER_DATE DATE NOT NULL,
    CUSTOMER_ID NUMBER,
    TOTAL_AMOUNT NUMBER CHECK (TOTAL_AMOUNT >= 0),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
);

CREATE TABLE ORDER_ITEMS (
    ORDER_ITEM_ID NUMBER PRIMARY KEY,
    ORDER_ID NUMBER,
    PRODUCT_ID NUMBER,
    QUANTITY NUMBER CHECK (QUANTITY > 0),
    PRICE_AT_PURCHASE NUMBER CHECK (PRICE_AT_PURCHASE >= 0),
    FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID)
);

-- Lo siguiente no necesariamente va a dar algun resultad. Mas bien
-- lo que está puesto son los comandos que vimos en clase y en que
-- contextos se pueden ocupar.

/* -- Seleccionar todos los clientes que viven en una ciudad especifica
SELECT * FROM customers WHERE city = "____";

-- Obtener una lista distinta de todas las categorias de productos disponible
SELECT DISTINCT category FROM products; 

-- Seleccionar todos los pedidos realizados por un cliente especifico, ordenados 
-- por la fecha de pedido en orden descendente.
SELECT order_id from orders WHERE customer_id = __ ORDER BY order_date DESC;

-- Buscar Productos cuyo nombre contenga una palabra clave especifica
SELECT * FROM products WHERE product_name LIKE "%___%";

-- Seleccionar todos los productos que están en una categoría específica y cuyo
-- precio sea mayor que un valor dado.
SELECT * FROM products WHERE category = "___" AND (price>__);

-- Seleccionar pedidos que tengan un monto total entre dos valores especificos
SELECT * FROM orders WHERE total_amount BETWEEN ___ AND ___;

-- Contar cuantos productos pertenecen a una categoria específica
SELECT COUNT(product_id) FROM products WHERE category ="___";

-- Calcular el monto total gastado por un cliente espececífico en todas sus ordenes
SELECT SUM(total_amount) FROM orders WHERE customer_id = "__";

-- Actualizar el precio de todos los productos en una categoría específica, incrementandolos
-- en un porcentaje dado.
UPDATE products SET price = price + (price * x) WHERE category = "___";

-- Eliminar todos los prodcutos que no han sido comprados en ninguna orden
DELETE FROM products WHERE product_id NOT IN (SELECT product FROM orders);

-- Seleccionar los cinco pedidos más recientes realizados en la tienda
SELECT * FROM orders FETCH 5 ROWS ONLY;

-- Calcular el precio promedio de todos los productos en una categoria
SELECT AVG(price) FROM products WHERE category ="__"; */