CREATE DATABASE P9_FBD;

USE P9_FBD;

/*
 
 ENGINE=InnoDB
 Define el motor de almacenamiento que MySQL utilizará para esta tabla. En este caso, se está utilizando el motor InnoDB.
 Transacciones con soporte para ACID (Atomicidad, Consistencia, Aislamiento, Durabilidad).
 Integridad referencial a través de claves foráneas.
 Bloqueo a nivel de fila, lo que mejora el rendimiento en entornos con muchas escrituras concurrentes.
 --
 DEFAULT CHARSET=latin1
 Define el conjunto de caracteres por defecto que se utilizará para almacenar y representar los datos de texto en la tabla.
 En este caso, el conjunto de caracteres utilizado es latin1, que es una codificación de 8 bits comúnmente conocida como ISO-8859-1.
 Este charset está diseñado para manejar la mayoría de los caracteres de los idiomas occidentales, pero tiene ciertas limitaciones 
 con caracteres no occidentales (como chino o árabe).
 Alternativamente, podrías usar conjuntos de caracteres como utf8 o utf8mb4 si necesitas manejar una gama más amplia de caracteres,
 incluidos emojis y otros símbolos no latinos.
 --
 KEY productLine (productLine)
 Esto indica que se está creando un índice sobre la columna productLine.
 Los índices mejoran el rendimiento de las consultas en la columna productLine, permitiendo que las búsquedas, uniones (JOIN),
 y otras operaciones que involucren esa columna sean más rápidas.
 Este índice no es la clave primaria (que ya está definida como productCode), sino un índice adicional. 
 El hecho de que sea una columna que participa en una clave foránea (hacia la tabla productlines) hace que el índice también
 mejore el rendimiento de las consultas que involucren dicha relación.
 */
/*Table structure for table `offices` */
-- DROP TABLE IF EXISTS `offices`;
CREATE TABLE `offices` (
    `officeCode` varchar(10) NOT NULL,
    `city` varchar(50) NOT NULL,
    `phone` varchar(50) NOT NULL,
    `addressLine1` varchar(50) NOT NULL,
    `addressLine2` varchar(50) DEFAULT NULL,
    `state` varchar(50) DEFAULT NULL,
    `country` varchar(50) NOT NULL,
    `postalCode` varchar(15) NOT NULL,
    `territory` varchar(10) NOT NULL,
    PRIMARY KEY (`officeCode`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

/*Table structure for table `employees` */
-- DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
    `employeeNumber` int(11) NOT NULL,
    `lastName` varchar(50) NOT NULL,
    `firstName` varchar(50) NOT NULL,
    `extension` varchar(10) NOT NULL,
    `email` varchar(100) NOT NULL,
    `officeCode` varchar(10) NOT NULL,
    `reportsTo` int(11) DEFAULT NULL,
    `jobTitle` varchar(50) NOT NULL,
    PRIMARY KEY (`employeeNumber`),
    KEY `reportsTo` (`reportsTo`),
    KEY `officeCode` (`officeCode`),
    CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`reportsTo`) REFERENCES `employees` (`employeeNumber`),
    CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`officeCode`) REFERENCES `offices` (`officeCode`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
    `customerNumber` int(11) NOT NULL,
    `customerName` varchar(50) NOT NULL,
    `contactLastName` varchar(50) NOT NULL,
    `contactFirstName` varchar(50) NOT NULL,
    `phone` varchar(50) NOT NULL,
    `addressLine1` varchar(50) NOT NULL,
    `addressLine2` varchar(50) DEFAULT NULL,
    `city` varchar(50) NOT NULL,
    `state` varchar(50) DEFAULT NULL,
    `postalCode` varchar(15) DEFAULT NULL,
    `country` varchar(50) NOT NULL,
    `salesRepEmployeeNumber` int(11) DEFAULT NULL,
    `creditLimit` decimal(10, 2) DEFAULT NULL,
    PRIMARY KEY (`customerNumber`),
    KEY `salesRepEmployeeNumber` (`salesRepEmployeeNumber`),
    CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`salesRepEmployeeNumber`) REFERENCES `employees` (`employeeNumber`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

/*Table structure for table `orders` */
-- DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
    `orderNumber` int(11) NOT NULL,
    `orderDate` date NOT NULL,
    `requiredDate` date NOT NULL,
    `shippedDate` date DEFAULT NULL,
    `status` varchar(15) NOT NULL,
    `comments` text,
    `customerNumber` int(11) NOT NULL,
    PRIMARY KEY (`orderNumber`),
    KEY `customerNumber` (`customerNumber`),
    CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

/*Table structure for table `payments` */
-- DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
    `customerNumber` int(11) NOT NULL,
    `checkNumber` varchar(50) NOT NULL,
    `paymentDate` date NOT NULL,
    `amount` decimal(10, 2) NOT NULL,
    PRIMARY KEY (`customerNumber`, `checkNumber`),
    CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

/*Table structure for table `productlines` */
-- DROP TABLE IF EXISTS `productlines`;
CREATE TABLE `productlines` (
    `productLine` varchar(50) NOT NULL,
    `textDescription` varchar(4000) DEFAULT NULL,
    `htmlDescription` mediumtext,
    `image` mediumblob,
    PRIMARY KEY (`productLine`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

/*Table structure for table `products` */
-- DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
    `productCode` varchar(15) NOT NULL,
    `productName` varchar(70) NOT NULL,
    `productLine` varchar(50) NOT NULL,
    `productScale` varchar(10) NOT NULL,
    `productVendor` varchar(50) NOT NULL,
    `productDescription` text NOT NULL,
    `quantityInStock` SMALLINT(6) NOT NULL,
    `buyPrice` decimal(10, 2) NOT NULL,
    `MSRP` decimal(10, 2) NOT NULL,
    PRIMARY KEY (`productCode`),
    KEY `productLine` (`productLine`),
    CONSTRAINT `products_ibfk_1` FOREIGN KEY (`productLine`) REFERENCES `productlines` (`productLine`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

/*Table structure for table `orderdetails` */
-- DROP TABLE IF EXISTS `orderdetails`;
CREATE TABLE `orderdetails` (
    `orderNumber` int(11) NOT NULL,
    `productCode` varchar(15) NOT NULL,
    `quantityOrdered` int(11) NOT NULL,
    `priceEach` decimal(10, 2) NOT NULL,
    `orderLineNumber` SMALLINT(6) NOT NULL,
    PRIMARY KEY (`orderNumber`, `productCode`),
    KEY `productCode` (`productCode`),
    CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`orderNumber`) REFERENCES `orders` (`orderNumber`),
    CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`productCode`) REFERENCES `products` (`productCode`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;