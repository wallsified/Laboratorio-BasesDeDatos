-- Práctica #4: Consultas Avanzadas y Joins
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

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
/* SELECT 
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
    D.DEPARTMENT_NAME; */
SELECT
    D.DEPARTMENT_NAME AS "Nombre del Departamento",
    AVG(E.SALARY)     AS "Salario Promedio",
    MIN(E.SALARY)     AS "Salario Mínimo",
    MAX(E.SALARY)     AS "Salario Máximo"
FROM
    EMPLOYEES   E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY
    D.DEPARTMENT_NAME;

-- * 3. Listar todos los proyectos activos (aquellos cuyo end date es posterior a la fecha
-- * actual) junto con el número total de empleados asignados a cada proyecto. Utilizar joins y una
-- * subconsulta para filtrar los proyectos activos.

-- Encontré que existe el GETDATE() para obtener la fecha actual del sistema, pero no recuerdo si sí lo vimos en clase.
-- ! La tabla resultante debe de dar 1 por cada proyecto por que solo hay un empleado por proyecto (al 02/Sept/24 00:06 Hrs).
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

-- ? Probablemente haya que añadir más valores en general antes de probar/hacer lo siguiente.
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

-- ? Esta de nuevo da un 'data not found'. Pero no estoy aun seguro del por que.

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
SELECT 
    C.CUSTOMER_NAME,
    C.CONTACT_INFO,
    COUNT(CP.PROJECT_ID)
    --P.PROJECT_ID
FROM
    CUSTOMER_PROJECT CP
    INNER JOIN CUSTOMER C
    ON C.CUSTOMER_ID = CP.CUSTOMER_ID
GROUP BY 
    C.CUSTOMER_NAME
HAVING
    COUNT(CP.PROJECT_ID) > 1;

-- * 11: Mostrar los nombres de los proyectos que tienen más de 100 horas trabajadas en
-- * total, junto con el nombre del cliente asociado y el número total de horas trabajadas. Usar joins y
-- * funciones de agregación.

-- * 12: Obtener una lista de todos los empleados cuyo salario es superior al salario promedio
-- * de su departamento. Mostrar el employee id, first name, last name, salary, y el nombre del
-- * departamento. Ordenar los resultados por el salario en orden descendente.