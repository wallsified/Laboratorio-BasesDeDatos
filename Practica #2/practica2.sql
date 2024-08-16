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
FOREIGN KEY (department_id)
REFERENCES departments(department_id)
);
