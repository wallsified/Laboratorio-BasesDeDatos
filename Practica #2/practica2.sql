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
