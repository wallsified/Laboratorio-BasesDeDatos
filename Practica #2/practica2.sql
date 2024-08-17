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
    project_name VARCHAR2(100) NOT NULL,
    start_date DATE,
    end_date DATE
);

-- 4. Tabla Relación "Employees"-"Projects"
CREATE TABLE employee_projects (
    employee_id NUMBER,
    project_id NUMBER,
    role VARCHAR2(50) DEFAULT 'Por Definir',-- Almacenar el rol del empleado en el proyecto.
    PRIMARY KEY (employee_id, project_id),
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
INSERT INTO departments (department_id, department_name) VALUES (3, 'IT');

-- 2. Insertar datos en 'employees'
INSERT INTO employees (employee_id, first_name, last_name, department_id) VALUES (1, 'Juan', 'Pérez', 1);
INSERT INTO employees (employee_id, first_name, last_name, department_id) VALUES (2, 'Ana', 'Garcı́a', 2);
INSERT INTO employees (employee_id, first_name, last_name, department_id) VALUES (3, 'Luis', 'Martı́nez', 3);

-- 3. Insertar proyectos 'Implementacion de ERP', 'Rediseño Sitio Web', 'Migración a la Nube'
INSERT INTO projects (project_id, project_name) VALUES (1, 'Implementación de ERP');
INSERT INTO projects (project_id, project_name) VALUES (2, 'Rediseño Sitio Web');
INSERT INTO projects (project_id, project_name) VALUES (3, 'Migración a la Nube');

-- 4. Asociación empleados-projectos en la tabla 'employee projects'
INSERT INTO employee_projects (employee_id, project_id) VALUES (1, 1);
INSERT INTO employee_projects (employee_id, project_id) VALUES (2, 2);
INSERT INTO employee_projects (employee_id, project_id) VALUES (3, 3);
INSERT INTO employee_projects (employee_id, project_id) VALUES (1, 2);

-- Paso #3: Manipulación de Datos
-- Ejercicio 1: Actualiza el departamento de Ana García a IT
UPDATE
    employees
SET
    department_id = 3
WHERE
    employee_id = 2;

-- Ejercicio 2: Elimina el registro del proyecto "Rediseño Sitio Web" y todos los registros relacionados en la tabla "employee_projects"
DELETE FROM
    employee_projects
WHERE
    project_id = (
        SELECT
            project_id
        FROM
            projects
        WHERE
            project_name = 'Rediseño Sitio Web'
    );

DELETE FROM
    projects
WHERE
    project_name = 'Rediseño Sitio Web';

-- Ejercicio 3: Agrega una nueva columna "email" a la tabla "employees" si no existe
ALTER TABLE
    employees
ADD
    email VARCHAR2(100);

-- Ejercicio 4: Inserta los correos electrónicos correspondientes para cada empleado
UPDATE
    employees
SET
    email = 'juan.perez@empresa.com'
WHERE
    employee_id = 1;

UPDATE
    employees
SET
    email = 'ana.garcia@empresa.com'
WHERE
    employee_id = 2;

UPDATE
    employees
SET
    email = 'luis.martinez@empresa.com'
WHERE
    employee_id = 3;

-- Ejercicio 5: Elimina la tabla "employee_projects"

DROP TABLE employee_projects;

-- Justificación: En un contexto real, eliminar la tabla "employee_projects" podría ser necesario si se decide cambiar la estructura de la base de datos o si se adopta un nuevo sistema de gestión que maneje las relaciones entre empleados y proyectos de manera diferente.