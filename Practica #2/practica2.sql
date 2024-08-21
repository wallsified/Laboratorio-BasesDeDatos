-- Práctica #2: Creación y Gestión de Esqauemas Básicos
-- Alumnos: 
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

-- Paso #1: Crear Esquema con Tablas Relacionadas
-- 
-- 1. Creación de Tabla "departments"
CREATE TABLE departments (
	department_id NUMBER PRIMARY KEY,
	department_name VARCHAR2(50) NOT NULL
);

-- 2. Creación de Tabla "employees", referenciando a "departments"
CREATE TABLE employees (
	employee_id NUMBER PRIMARY KEY,
	first_name VARCHAR2(50),
	last_name VARCHAR2(50),
	department_id NUMBER,
	CONSTRAINT fk_department
	FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 3. Creación de una Tabla "projects" para gestionar los proyectos de los empleados.
CREATE TABLE projects (
    project_id NUMBER PRIMARY KEY,
    -- Se considera como variable no nula para siempre tener un nombre para referirse al proyecto.
    project_name VARCHAR2(100) NOT NULL,
    start_date DATE,
    end_date DATE
);

-- 4. Tabla Relación "Employees"-"Projects"
--
-- Usar el nombre 'employee-projects' vuelve mas mnemotecnica el nombre 
-- de la relacion 
CREATE TABLE employee_projects (
    employee_id NUMBER,
    project_id NUMBER,
    -- Almacenar el rol del empleado en el proyecto.
    role VARCHAR2(50) DEFAULT 'Por Definir',
    PRIMARY KEY (employee_id, project_id),
    -- Restricciones para siempre tener a donde referenciar informacion.
    CONSTRAINT fk_employee
        FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id),
    CONSTRAINT fk_project
        FOREIGN KEY (project_id) 
        REFERENCES projects(project_id)
);

-- Paso #2: Insertar Datos en las Tablas
--
-- 1. Insertar datos en 'departments'
INSERT INTO departments (department_id, department_name) VALUES (1, 'Recursos Humanos');
INSERT INTO departments (department_id, department_name) VALUES (2, 'Finanzas');
-- Insertamos el departamento IT como la 2-tupla de valores (3, 'IT) 
INSERT INTO departments (department_id, department_name) VALUES (3, 'IT');

-- 2. Insertar datos en 'employees'
INSERT INTO employees (employee_id, first_name, last_name, department_id) VALUES (1, 'Juan', 'Pérez', 1);
INSERT INTO employees (employee_id, first_name, last_name, department_id) VALUES (2, 'Ana', 'Garcı́a', 2);
INSERT INTO employees (employee_id, first_name, last_name, department_id) VALUES (3, 'Luis', 'Martı́nez', 3);

-- 3. Insertar proyectos 'Implementacion de ERP', 'Rediseño Sitio Web', 'Migración a la Nube'
--
-- Los valores se agregan en 2-tuplas (numero-id, nombre). 
INSERT INTO projects (project_id, project_name) VALUES (1, 'Implementación de ERP');
INSERT INTO projects (project_id, project_name) VALUES (2, 'Rediseño Sitio Web');
INSERT INTO projects (project_id, project_name) VALUES (3, 'Migración a la Nube');

-- 4. Asociación empleados-projectos en la tabla 'employee projects'
INSERT INTO employee_projects (employee_id, project_id) VALUES (1, 1);
INSERT INTO employee_projects (employee_id, project_id) VALUES (2, 2);
INSERT INTO employee_projects (employee_id, project_id) VALUES (3, 3);
INSERT INTO employee_projects (employee_id, project_id) VALUES (1, 2);

-- Paso #3: Manipulación de Datos
--
-- 1. Actualiza el departamento de Ana García a IT
--
-- Al ser una actualizacion de valores, usamos UPDATE y WHERE. 
-- El primero como la instruccion principal y el segundo para indicar
-- donde se realiza la accion. En este caso, en el employee_id = 2.
UPDATE employees SET department_id = 3 WHERE employee_id = 2;

-- 2. Elimina el registro del proyecto "Rediseño Sitio Web" y todos los registros relacionados en la 
-- tabla "employee_projects"
--
-- Primero se debe eliminar el proyecto de 'employee-projects' y posteriormente de 
-- 'projects'. Anidamos un SELECT en la primera instruccion para tener identificada
-- la clave foranea del proyecto en cuestion en su tabla original. 
DELETE FROM employee_projects WHERE
	project_id = (
        SELECT
            project_id
        FROM
            projects
        WHERE
            project_name = 'Rediseño Sitio Web'
);

DELETE FROM projects WHERE project_name = 'Rediseño Sitio Web';

-- 3. Agrega una nueva columna "email" a la tabla "employees" si no existe
--
-- Se ocupa el comando ALTER TABLE y despues indicamos el nombre y el tipo de
-- valor que va a ocupar la columna nueva. 
ALTER TABLE employees ADD email VARCHAR2(100);

-- 4. Inserta los correos electrónicos correspondientes para cada empleado
UPDATE employees SET email = 'juan.perez@empresa.com' WHERE employee_id = 1;
UPDATE employees SET email = 'ana.garcia@empresa.com' WHERE employee_id = 2;
UPDATE employees SET email = 'luis.martinez@empresa.com' WHERE employee_id = 3;

-- 5. Elimina la tabla "employee_projects"
DROP TABLE employee_projects;

-- Justificación: En un contexto real, eliminar la tabla "employee_projects" podría ser necesario si se decide 
-- cambiar la estructura de la base de datos o si se adopta un nuevo sistema de gestión que maneje las relaciones 
-- entre empleados y proyectos de manera diferente.

-- Paso #4: Consultas con Condiciones

-- 1. Realiza una consulta para listar todos los empleados que trabajan en el departamento de IT:
SELECT * FROM employees WHERE department_id = 3;

-- 2. Realiza una consulta para encontrar los empleados que no están asignados a ningún proyecto:
SELECT * FROM employees WHERE employee_id NOT IN (SELECT employee_id FROM employee_projects);

-- 3. Realiza una consulta para listar todos los departamentos que tienen menos de 2 empleados:
SELECT department_id, COUNT(*) as num_employees 
FROM employees 
GROUP BY department_id 
HAVING COUNT(*) < 2;

-- Paso #5: Demostración de la Integridad Referencial

-- 1. Intenta eliminar un registro de la tabla departments que esté referenciado en la tabla employees:
DELETE FROM departments WHERE department_id = 1;

-- 2. Observa el error de consistencia generado y describe el comportamiento:
-- Deberías recibir un error similar a:
-- ORA-02292: integrity constraint (SCHEMA.FK_DEPARTMENT) violated - child record found

-- Este error ocurre debido a que con la línea anterior se está tratando de eliminar una instancia de la que dependen referencias secundarias, si esto pasara se perdería la consistencia de la base de datos.

-- 3. Ahora, explica qué deberíamos hacer para poder eliminar todo un departamento. (+0.5 por explicación correcta/ +1.0 con operaciones en sintaxis de SQL)
-- Lo que debería hacerse es eliminar primero las dependecias del registro padre y ya que todas estas estén eliminadas podría eliminarse el registro padre. Primero sería el registro emplyees porque este depende de depertments
-- Al existir una condición precedente en employees, eliminamos dicha condición primero
ALTER TABLE employees DROP CONSTRAINT fk_department;
-- Agregamos la nueva condición y añadimos ON DELETE CASCADE para que al querer eliminar un registro padre se eliminen los hijos y así se mantenga la integridad referencial.
ALTER TABLE employees 
ADD CONSTRAINT fk_department
    FOREIGN KEY (department_id) 
    REFERENCES departments(department_id)
    ON DELETE CASCADE;


