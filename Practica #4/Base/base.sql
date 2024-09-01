-- Práctica #4: Consultas Avanzadas y Joins
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

-- * Especificaciones de Desarollo
-- *
-- * - La base de datos debe incluir una tabla que almacene la informacion de los Empleados,
-- * incluyendo atributos como el employee id, first name, last name, email, hire date, y
-- * salary. Cada empleado debe estar asignado a un Departamento.
-- *
-- * - Los Departamentos deben ser gestionados en una tabla separada, con atributos como
-- * department id, department name, y manager id. Cada departamento tiene un gerente,
-- * que es un empleado, y puede tener mu ́ltiples empleados asignados.
-- *
-- * - Los Proyectos en la empresa deben ser gestionados en otra tabla, que incluye atributos
-- * como project id, project name, start date, end date, y budget. Cada proyecto puede estar
-- * asociado a multiples empleados, y cada empleado puede estar asignado a multiples proyectos.
-- *
-- * - Las Asignaciones de Proyectos deben ser gestionadas en una tabla que relacione a los empleados
-- * con los proyectos a los que est ́an asignados. Esta tabla debe incluir atributos como assignment_id,
-- * employee id, project id, role, y hours_worked.
-- *
-- * - Se deben implementar relaciones de clave for ́anea entre las tablas, como la relacion entre
-- * employee_id en la tabla de Empleados y manager id en la tabla de Departamentos, y entre
-- * department_id en la tabla de Empleados y la tabla de Departamentos. También debe existir una
-- * relacion entre employee_id y project_id en la tabla de Asignaciones de Proyectos.
-- *
-- * - El esquema debe permitir la extracción de información agregada, como el salario promedio de los
-- * empleados en cada departamento, el numero total de horas trabajadas por empleado en cada proyecto
-- * y el presupuesto total asignado a proyectos activos.
-- *
-- * - El sistema debe permitir el manejo de Proveedores, que son entidades externas involucradas en los
-- * proyectos. Los proveedores tienen atributos como supplier_id, supplier_name y contact_info. Cada
-- * proveedor puede estar relacionado con mu ́ltiples proyectos, pero cada proyecto solo tiene un provedor.
-- *
-- * - Se debe manejar la relación entre Clientes y Proyectos. Cada cliente, almacenado en una tabla con
-- * atributos como customer_id, customer_name, contact_info, y project_id, puede estar relacionado con uno
-- * o más proyectos, y cada proyecto puede estar relacionado con multiples clientes.

-- * Sección #1: Creacion de Tablas

CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    LAST_NAME VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(100),
    DEPARTMENT_ID NUMBER,
    HIRE_DATE DATE,
    SALARY NUMBER,
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID)
);

CREATE TABLE DEPARTMENTS (
    DEPARTMENT_ID NUMBER PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR2(50) NOT NULL,
    MANAGER_ID VARCHAR2(50) NULL,
    FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
);

CREATE TABLE PROYECTS (
    PROJECT_ID NUMBER PRIMARY KEY,
    PROJECT_NAME VARCHAR2(100) NOT NULL,
    START_DATE DATE,
    END_DATE DATE,
    BUDGET NUMBER CHECK (BUDGET > 0)
);

CREATE TABLE PROJECT_ASIGNMENT (
    ASSIGNMENT_ID NUMBER PRIMARY KEY,
    PROJECT_ID NUMBER,
    EMPLOYEE_ID NUMBER,
    ROLL VARCHAR2(20),
    HOURS_WORKED NUMBER,
    FOREIGN KEY (PROJECT_ID) REFERENCES PROJECTS(PROJECT_ID),
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
);

-- Me di a entender que algo asi se necesita.
CREATE TABLE SUPPLIERS (
    SUPPLIER_ID NUMBER PRIMARY KEY,
    SUPPLIER_NAME VARCHAR2(100) NOT NULL,
    CONTACT_INFO VARCHAR2(200),
    PROJECT_ID NUMBER,
    FOREIGN KEY (PROJECT_ID) REFERENCES PROJECTS(PROJECT_ID)
);

CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    CUSTOMER_NAME VARCHAR2(100) NOT NULL,
    CONTACT_INFO VARCHAR2(200)
);

CREATE TABLE CUSTOMER_PROJECT (
    CUSTOMER_ID NUMBER,
    PROJECT_ID NUMBER,
    PRIMARY KEY (CUSTOMER_ID, PROJECT_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),
    FOREIGN KEY (PROJECT_ID) REFERENCES PROJECTS(PROJECT_ID)
);

-- * Sección #2: Consultas Avanzadas

-- * 1. Obtener el nombre completo (first name, last name) y el salario de los empleados
-- * junto con el nombre del departamento al que pertenecen. Ordenar los resultados por el nombre del
-- * departamento y luego por el apellido del empleado.

-- Resulta que con || ' ' || contatenamos resultados.
SELECT
    E.FIRST_NAME
    || ' '
    || E.LAST_NAME    AS FULL_NAME,
    E.SALARY,
    D.DEPARTMENT_NAME
FROM
    EMPLOYEES   E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY
    D.DEPARTMENT_NAME ASC,
    E.LAST_NAME ASC;

-- * 2: Calcular el salario promedio, el salario mı́nimo y el salario máximo de los empleados
-- * en cada departamento. Mostrar el nombre del departamento y los valores calculados, usando alias
-- * para las columnas agregadas.
SELECT 
    E.SALARY,
    D.DEPARTMENT_NAME
FROM 
    EMPLOYEES E
    INNER JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;
    AVG(E.SALARY) AS AVG_SALARY,
    MIN(E.SALARY) AS MIN_SALARY,
    MAX(E.SALARY) AS MAX_SALARY,
GROUP BY 
    D.DEPARTMENT_NAME;
ORDER BY 
    D.DEPARTMENT_NAME;



-- * 3. Listar todos los proyectos activos (aquellos cuyo end date es posterior a la fecha
-- * actual) junto con el número total de empleados asignados a cada proyecto. Utilizar joins y una
-- * subconsulta para filtrar los proyectos activos.

-- Encontré que existe el GETDATE() para obtener la fecha actual del sistema, pero no recuerdo si sí lo vimos en clase.
SELECT 
    P.PROJECT_NAME, 
    COUNT(PA.EMPLOYEE_ID) AS ASIGNED_EMPL,
FROM  
    PROJECT_ASIGNMENT PA
    INNER JOIN PROJECTS P ON PA.PROJECT_ID = P.PROJECT_ID;
WHERE
    SYSDATE < P.END_DATE
GROUP BY
    P.PROJECT_NAME;
ORDER BY
    P.PROJECT_NAME;


-- * 4: Obtener el nombre de los empleados que trabajan en más de un proyecto, junto con
-- * la cantidad de proyectos en los que están involucrados. Los resultados deben estar ordenados por el
-- * número de proyectos en orden descendente.

-- * 5: Mostrar el nombre del gerente (manager_id) y el nombre del departamento que ges-
-- * tiona, junto con el número total de empleados en cada departamento. Considerar solo aquellos
-- * departamentos que tienen más de 5 empleados.

SELECT
    E.FIRST_NAME,
    D.DEPARTMENT_NAME,
    COUNT(E.EMPLOYEE_ID)
FROM
    DEPARTMENTS D
    INNER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;

GROUP BY E.FIRST_NAME, D.DEPARTMENT_NAME
HAVING COUNT(E.EMPLOYEE_ID) > 5;

-- * 6: Obtener una lista de los proyectos que tienen un presupuesto superior al promedio de
-- * todos los proyectos en la empresa. Mostrar el project name, budget, y el start date.

-- * 7: Concatenar el first name y last name de los empleados en un solo campo, junto
-- * con su employee id y el nombre del departamento al que pertenecen. Los resultados deben estar
-- * ordenados por el nombre completo del empleado.

-- * 8: Listar los empleados que no tienen asignado ningún proyecto actualmente. Mostrar el
-- * employee id, first name, last name, y el nombre del departamento. Usar una subconsulta para
-- * identificar a los empleados sin proyectos.

-- * 9: Obtener el nombre y el contacto de los proveedores (suppliers) que están asociados
-- * con proyectos en los que trabaja al menos un empleado del departamento de IT. Usar un join para
-- * combinar la información de proveedores, proyectos, y empleados.

SELECT
    S.SUPPLIERS_NAME,
    S.CONTACT_INFO
FROM
    SUPPLIERS S
    INNER JOIN PROJECTS P
    ON S.SUPPLIER_ID = P.SUPPLIER_ID
    INNER JOIN ASSIGNMENT_PROJECT AP
    ON P.PROJECT_ID = AP.PROJECT_ID
    INNER JOIN EMPLOYEES E
    ON AP.EMPLOYEE_ID = E.EMPLOYEE_ID
    INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE
    D,
    DEPARTMENT_NAME= 'IT';

-- * 10: Listar los nombres de los clientes que están asociados con más de un proyecto. Mostrar
-- * el customer name, el número de proyectos asociados y el contact info del cliente.

-- * 11: Mostrar los nombres de los proyectos que tienen más de 100 horas trabajadas en
-- * total, junto con el nombre del cliente asociado y el número total de horas trabajadas. Usar joins y
-- * funciones de agregación.

-- * 12: Obtener una lista de todos los empleados cuyo salario es superior al salario promedio
-- * de su departamento. Mostrar el employee id, first name, last name, salary, y el nombre del
-- * departamento. Ordenar los resultados por el salario en orden descendente.