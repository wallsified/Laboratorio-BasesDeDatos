-- Consulta 1: Obtener el nombre completo (first name, last name) y el salario de los empleados
-- junto con el nombre del departamento al que pertenecen. Ordenar los resultados por el nombre del
-- departamento y luego por el apellido del empleado.
SELECT e.first_name, e.last_name, e.salary, d.department_name FROM Employees e
	INNER JOIN Departments d  ON e.employee_id = d.department_id ORDER BY d.department_name, e.last_name ;

-- Consulta 2: Calcular el salario promedio, el salario mınimo y el salario maximo de los empleados
-- en cada departamento. Mostrar el nombre del departamento y los valores calculados, usando alias
-- para las columnas agregadas.
SELECT d.department_name, AVG(e.salary), MIN(e.salary), MAX(e.salary) FROM Employees e
		INNER JOIN Departments d ON d.manager_id = e.employee_id
			GROUP BY d.department_name;
		
-- Consulta 3: Listar todos los proyectos activos (aquellos cuyo end date es posterior a la fecha
-- actual) junto con el n´umero total de empleados asignados a cada proyecto. Utilizar joins y una
-- subconsulta para filtrar los proyectos activos.
SELECT p.project_name, COUNT(ap.employee_id) FROM Assignment_Project ap
	INNER JOIN Projects p ON p.project_id = ap.assignment_id
		WHERE ap.project_id IN (SELECT project_id FROM Projects p2 WHERE p2.end_date < SYSDATE())
		GROUP BY p.project_name;
	
-- Consulta 4: Obtener el nombre de los empleados que trabajan en m´as de un proyecto, junto con
-- la cantidad de proyectos en los que est´an involucrados. Los resultados deben estar ordenados por el
-- n´umero de proyectos en orden descendente.
SELECT CONCAT_WS(', ', e.first_name, e.last_name) AS nombre, COUNT(ap.project_id) as Projectos FROM Assignment_Project ap
	INNER JOIN Employees e ON e.employee_id = ap.employee_id
		GROUP BY nombre
			ORDER BY Projectos DESC;
		
-- Consulta 5: Mostrar el nombre del gerente (manager id) y el nombre del departamento que ges-
-- tiona, junto con el n´umero total de empleados en cada departamento. Considerar solo aquellos
-- departamentos que tienen m´as de 5 empleados.
SELECT CONCAT_WS(', ', e.first_name, e.last_name) AS manager_name,
    d.department_name,
    COUNT(emp.employee_id) AS total_employees FROM Departments d
		INNER JOIN Employees e ON d.manager_id = e.employee_id
		INNER JOIN Employees emp ON d.department_id = emp.department_id
			GROUP BY e.first_name, e.last_name, d.department_name
				HAVING COUNT(emp.employee_id) > 5;
		
-- Consulta 6: Obtener una lista de los proyectos que tienen un presupuesto superior al promedio de
-- todos los proyectos en la empresa. Mostrar el project name, budget, y el start date.
SELECT p.project_name, p.budget, p.start_date FROM Projects p 
	WHERE p.budget > (SELECT AVG(budget) FROM Projects);

-- Consulta 7: Concatenar el first name y last name de los empleados en un solo campo, junto
-- con su employee id y el nombre del departamento al que pertenecen. Los resultados deben estar
-- ordenados por el nombre completo del empleado
SELECT e.employee_id, CONCAT_WS(' ', e.first_name,e.last_name) AS nombre, d.department_name FROM Employees e 
	INNER JOIN Departments d ON e.department_id = d.department_id 
		ORDER BY nombre;

-- Consulta 8: Listar los empleados que no tienen asignado ning´un proyecto actualmente. Mostrar el
-- employee id, first name, last name, y el nombre del departamento. Usar una subconsulta para
-- identificar a los empleados sin proyectos.
SELECT e.employee_id, e.first_name, e.last_name, d.department_name FROM Employees e
	INNER JOIN Departments d ON d.department_id = e.department_id 
			WHERE e.employee_id NOT IN (SELECT ap.employee_id FROM Assignment_Project ap);
		
-- Consulta 9: Obtener el nombre y el contacto de los proveedores (suppliers) que est´an asociados
-- con proyectos en los que trabaja al menos un empleado del departamento de IT. Usar un join para
-- combinar la informaci´on de proveedores, proyectos, y empleados
SELECT s.supplier_name, s.contact_info FROM Suppliers s
	INNER JOIN Projects p ON s.supplier_id = p.supplier_id
		INNER JOIN Assignment_Project ap ON p.project_id = ap.project_id
			INNER JOIN Employees e ON ap.employee_id = e.employee_id
				INNER JOIN Departments d ON e.department_id = d.department_id
					WHERE d.department_name = 'IT';

		
-- Consulta 10: Listar los nombres de los clientes que estan asociados con mas de un proyecto. Mostrar
-- el customer name, el numero de proyectos asociados y el contact info del cliente.
SELECT c.customer_id ,c.customer_name, c.contact_info FROM Customer_Project cp
	INNER JOIN Customers c  ON c.customer_id = cp.customer_id
		WHERE (SELECT COUNT(cp2.project_id) FROM Customer_Project cp2 WHERE cp2.customer_id = cp.customer_id) > 1;
	
	
	
-- Consulta 11: Mostrar los nombres de los proyectos que tienen mas de 100 horas trabajadas en
-- total, junto con el nombre del cliente asociado y el numero total de horas trabajadas. Usar joins y
-- funciones de agregacion.
SELECT p.project_name , c.customer_name , SUM(ap.hours_worked) AS 'Horas trabajadas' FROM Projects p 
	INNER JOIN Assignment_Project ap ON p.project_id = ap.project_id
		INNER JOIN 	Customer_Project cp ON ap.project_id = cp.project_id 
			INNER JOIN Customers c ON cp.customer_id = c.customer_id 
				GROUP BY p.project_name , c.customer_name 
					HAVING SUM(ap.hours_worked)<100;
		

-- Consulta 12: Obtener una lista de todos los empleados cuyo salario es superior al salario promedio
-- de su departamento. Mostrar el employee id, first name, last name, salary, y el nombre del
-- departamento. Ordenar los resultados por el salario en orden descendente.
SELECT e.employee_id , e.first_name , e.last_name , e.salary , d.department_name FROM Employees e 
	INNER JOIN Departments d ON d.department_id = e.department_id 
		WHERE e.salary > (SELECT AVG(e2.salary) FROM Employees e2  WHERE e2.department_id = e.department_id)
			ORDER BY e.salary DESC;
	
	
SELECT d.department_name , AVG(e.salary)  FROM Employees e 
	INNER JOIN Departments d ON d.department_id  = e.department_id 
		GROUP BY d.department_name ;

	
	
		