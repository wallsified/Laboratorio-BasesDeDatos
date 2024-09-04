-- Práctica #4: Consultas Avanzadas y Joins
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

-- * Sección #2: Consultas Avanzadas

-- * 1. Obtener el nombre completo (first name, last name) y el salario de los empleados
-- * junto con el nombre del departamento al que pertenecen. Ordenar los resultados por el nombre del
-- * departamento y luego por el apellido del empleado.

-- Ocupamos `||` para concatenar strings en SQL. Esto nos permitirá usar un alias para tener en una sola
-- columna el nombre completo del empleado. El JOIN se hace entre EMPLOYEES y DEPARTMENTS, pues necesitamos
-- que se nos retorne el nombre de cada departamento y revisar que, dado un empleado, su DEPARTMENT_ID coincida
-- con el DEPARTMENT_ID de algún departamento.
SELECT
        E.FIRST_NAME || ' ' || E.LAST_NAME AS FULL_NAME,
        E.SALARY,
        D.DEPARTMENT_NAME
    FROM
        EMPLOYEES E
        JOIN DEPARTMENTS D
        ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    ORDER BY
        D.DEPARTMENT_NAME ASC,
        E.LAST_NAME ASC;

-- * 2: Calcular el salario promedio, el salario mı́nimo y el salario máximo de los empleados
-- * en cada departamento. Mostrar el nombre del departamento y los valores calculados, usando alias
-- * para las columnas agregadas.

-- Ocupamos `ROUND` para redondear el salario promedio de cada departamento (si nos da, por ejemplo,
-- valores como 50000.345, y lo que necesitamos es quedarnos con, por ejemplo, 50000). El JOIN realizado
-- tiene la misma lógica que del query anterior.
SELECT
    D.DEPARTMENT_NAME AS "Nombre del Departamento",
    ROUND(AVG(E.SALARY)) AS "Salario Promedio",
    MIN(E.SALARY) AS "Salario Mínimo",
    MAX(E.SALARY) AS "Salario Máximo"
FROM
    EMPLOYEES E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY
    D.DEPARTMENT_NAME;

-- * 3. Listar todos los proyectos activos (aquellos cuyo end date es posterior a la fecha
-- * actual) junto con el número total de empleados asignados a cada proyecto. Utilizar joins y una
-- * subconsulta para filtrar los proyectos activos.

-- Ocuparemos GETDATE() para obtener la fecha actual del sistema y asi hacer la comparación con el
-- end_date de cada proyecto. El JOIN se hará entre PROJECTS y PROJECT_ASIGNMENT para revisar que
-- dada una asignación de proyecto el PROJECT_ID coincida en ambas tablas.
-- Luego, se agrupa/ordena dado el nombre del proyecto.
SELECT
    P.PROJECT_NAME,
    COUNT(PA.EMPLOYEE_ID) AS ASIGNED_EMPL
FROM
    PROJECT_ASIGNMENT PA
    INNER JOIN PROJECTS P
    ON PA.PROJECT_ID = P.PROJECT_ID
WHERE
    SYSDATE < P.END_DATE
GROUP BY
    P.PROJECT_NAME
ORDER BY
    P.PROJECT_NAME;

-- * 4: Obtener el nombre de los empleados que trabajan en más de un proyecto, junto con
-- * la cantidad de proyectos en los que están involucrados. Los resultados deben estar ordenados por el
-- * número de proyectos en orden descendente.

-- Ocuparemos COUNT para saber cuantos projectos hay total dada la columna PROJECT_ID en PROJECTS y tomaremos
-- los valores del nombre en la tabla EMPLOYEES. El JOIN se hace entre las tablas mencionadas para revisar
-- que dado un empleado, su EMPLOYEE_ID coincida en ambas tablas. Se agrupa por EMPLOYEE_ID, FIRST_NAME y LAST_NAME
-- y se usa HAVING para quedarnos con los empleados que trabajan en más de un proyecto.
SELECT
    E.FIRST_NAME,
    E.LAST_NAME,
    COUNT(PA.PROJECT_ID) AS NUM_PROYECTOS
FROM
    EMPLOYEES         E
    JOIN PROJECT_ASIGNMENT PA
    ON E.EMPLOYEE_ID = PA.EMPLOYEE_ID
GROUP BY
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME
HAVING
    COUNT(PA.PROJECT_ID) > 1
ORDER BY
    NUM_PROYECTOS DESC;

-- * 5: Mostrar el nombre del gerente (manager_id) y el nombre del departamento que ges-
-- * tiona, junto con el número total de empleados en cada departamento. Considerar solo aquellos
-- * departamentos que tienen más de 5 empleados.
-- En este esquema 
-- ? Por qué esta consulta nos está dando a los managers?
SELECT
    E.FIRST_NAME,
    D.DEPARTMENT_NAME,
    COUNT(E.EMPLOYEE_ID)
FROM
    DEPARTMENTS D
    INNER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY
    E.FIRST_NAME,
    D.DEPARTMENT_NAME
HAVING
    COUNT(E.EMPLOYEE_ID) > 5;

-- * 6: Obtener una lista de los proyectos que tienen un presupuesto superior al promedio de
-- * todos los proyectos en la empresa. Mostrar el project_name, budget, y el start_date.

-- En este caso, se usa una subconsulta para obtener el promedio de los presupuestos de todos los proyectos,
-- y luego se usa este valor para filtrar los proyectos que tienen un presupuesto superior a dicho valor.
-- Finalmente, se ordenan los resultados por el presupuesto en orden descendente.
SELECT
    P.PROJECT_NAME,
    P.BUDGET,
    P.START_DATE
FROM
    PROJECTS P
WHERE
    P.BUDGET > (
        SELECT
            AVG(BUDGET)
        FROM
            PROJECTS
    )
ORDER BY
    P.BUDGET DESC;

-- * 7: Concatenar el first name y last name de los empleados en un solo campo, junto
-- * con su employee id y el nombre del departamento al que pertenecen. Los resultados deben estar
-- * ordenados por el nombre completo del empleado.

-- Como en el ejercicio 1, se usa || para concatenar los nombres y apellidos de los empleados. El JOIN que
-- se realiza también el mismo, con la diferencia de que ahora se usa ORDER BY para ordenar los resultados
-- por el nombre completo del empleado.
SELECT
    E.EMPLOYEE_ID,
    E.FIRST_NAME
    || ' '
    || E.LAST_NAME    AS FULL_NAME,
    D.DEPARTMENT_NAME
FROM
    EMPLOYEES   E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY
    FULL_NAME;

-- * 8: Listar los empleados que no tienen asignado ningún proyecto actualmente. Mostrar el
-- * employee id, first name, last name, y el nombre del departamento. Usar una subconsulta para
-- * identificar a los empleados sin proyectos.

-- A pesar de hacer el mismo JOIN que en el ejercicio 7, el resultado es diferente pues se buscan
-- los empleados que no estan asignados a ningun proyecto aplicando un WHERE con NOT IN, haciendo
-- una subconsulta con el SELECT de los EMPLOYEE_ID de PROJECT_ASIGNMENT.
-- ! Regresa un único valor pues solo hay un empleado que no esta asignado a un proyecto con la
-- ! información de prueba ingresada en 'random_inserts.sql'.
SELECT
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME
FROM
    EMPLOYEES         E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE
    E.EMPLOYEE_ID NOT IN (
        SELECT
            PA.EMPLOYEE_ID
        FROM
            PROJECT_ASIGNMENT PA
    );

-- * 9: Obtener el nombre y el contacto de los proveedores (suppliers) que están asociados
-- * con proyectos en los que trabaja al menos un empleado del departamento de IT. Usar un join para
-- * combinar la información de proveedores, proyectos, y empleados.

-- Se usa un INNER JOIN para combinar la información de proveedores, proyectos, y empleados en las tablas
-- correspondientes. La idea de esto es revisar las igualdades SUPPLIER_ID = SUPPLIER_ID entre SUPPLIERS y PROJECTS
-- , PROJECT_ID = PROJECT_ID entre PROJECTS y PROJECT_ASIGNMENT, EMPLOYEE_ID = EMPLOYEE_ID entre EMPLOYEES y PROJECT_ASIGNMENT
-- y DEPARTMENT_ID = DEPARTMENT_ID entre DEPARTMENTS y EMPLOYEES. Luego, se usa un WHERE para filtrar los resultados por el departamento de IT.
SELECT
    S.SUPPLIER_NAME,
    S.CONTACT_INFO
FROM
    SUPPLIERS         S
    INNER JOIN PROJECTS P
    ON S.SUPPLIER_ID = P.SUPPLIER_ID
    INNER JOIN PROJECT_ASIGNMENT AP
    ON P.PROJECT_ID = AP.PROJECT_ID
    INNER JOIN EMPLOYEES E
    ON AP.EMPLOYEE_ID = E.EMPLOYEE_ID
    INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE
    D.DEPARTMENT_NAME= 'IT';

-- * 10: Listar los nombres de los clientes que están asociados con más de un proyecto. Mostrar
-- * el customer name, el número de proyectos asociados y el contact info del cliente.

-- Se usa un INNER JOIN para combinar la información de clientes, proyectos y project_asignments en las tablas
-- correspondientes. La idea de esto es revisar las igualdades CUSTOMER_ID = CUSTOMER_ID entre CUSTOMERS y PROJECTS
-- , PROJECT_ID = PROJECT_ID entre PROJECTS y PROJECT_ASIGNMENT. Luego, se usa un GROUP BY para agrupar los resultados
-- por el nombre del cliente y se usa HAVING para quedarse con los clientes que tienen más de un proyecto.
SELECT
    C.CUSTOMER_NAME,
    COUNT(P.PROJECT_ID) AS NUM_PROYECTOS,
    C.CONTACT_INFO
FROM
    CUSTOMERS C
    JOIN PROJECTS P
    ON C.CUSTOMER_ID = P.CUSTOMER_ID
GROUP BY
    C.CUSTOMER_NAME,
    C.CONTACT_INFO
HAVING
    COUNT(P.PROJECT_ID) > 1;

-- * 11: Mostrar los nombres de los proyectos que tienen más de 100 horas trabajadas en
-- * total, junto con el nombre del cliente asociado y el número total de horas trabajadas. Usar joins y
-- * funciones de agregación.

-- Se usa un INNER JOIN para combinar la información de proyectos, project_asignments y customers en las tablas
-- correspondientes. La idea es revisar las igualdades PROJECT_ID = PROJECT_ID entre PROJECTS y PROJECT_ASIGNMENT
-- y CUSTOMER_ID = CUSTOMER_ID entre PROJECTS y CUSTOMERS. Luego, se usa un GROUP BY para agrupar los resultados
-- por el nombre del proyecto y el nombre del cliente. Se usa HAVING para quedarse con los proyectos que tienen
-- más de 100 horas trabajadas. Finalmente, se ordenan los resultados por el número total de horas trabajadas en
-- orden descendente.
SELECT
    P.PROJECT_NAME,
    C.CUSTOMER_NAME,
    SUM(PA.HOURS_WORKED) AS TOTAL_HOURS
FROM
    PROJECTS          P
    JOIN PROJECT_ASIGNMENT PA
    ON P.PROJECT_ID = PA.PROJECT_ID
    JOIN CUSTOMERS C
    ON P.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
    P.PROJECT_NAME,
    C.CUSTOMER_NAME
HAVING
    SUM(PA.HOURS_WORKED) > 100
ORDER BY
    TOTAL_HOURS DESC;

-- * 12: Obtener una lista de todos los empleados cuyo salario es superior al salario promedio
-- * de su departamento. Mostrar el employee id, first name, last name, salary, y el nombre del
-- * departamento. Ordenar los resultados por el salario en orden descendente.

-- Se usa una subconsulta para obtener el salario promedio de cada departamento y luego se usa
-- un INNER JOIN para combinar la información de empleados y departamentos en las tablas correspondientes.
-- La idea de esto es revisar las igualdades DEPARTMENT_ID = DEPARTMENT_ID entre DEPARTMENTS y EMPLOYEES.
-- Luego, se usa un WHERE para filtrar los resultados por los empleados cuyo salario es superior al
-- promedio de su departamento. Finalmente, se ordenan los resultados por el salario en orden descendente.
SELECT
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    D.DEPARTMENT_NAME
FROM
    EMPLOYEES   E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE
    E.SALARY > (
        SELECT
            AVG(E2.SALARY)
        FROM
            EMPLOYEES E2
        WHERE
            E2.DEPARTMENT_ID = E.DEPARTMENT_ID
    )
ORDER BY
    E.SALARY DESC;