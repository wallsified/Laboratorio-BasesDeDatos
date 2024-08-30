--La base de datos debe incluir una tabla que almacene la informaci ́on de los Empleados, inclu- yendo atributos como el employee id, first name, last name, email, hire date, y salary. Cada empleado debe estar asignado a un Departamento.

-- Un pequeño comentario
CREATE TABLE Employees (
    employee_ID NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    department_ID NUMBER,
    hire_Date DATE,
    salary NUMBER,
    FOREIGN KEY (department_ID) REFERENCES Departments(department_ID)
);


--Los Departamentos deben ser gestionados en una tabla separada, con atributos como department id, department name, y manager id. Cada departamento tiene un gerente, que es un empleado, y puede tener mu ́ltiples empleados asignados.


--Los Proyectos en la empresa deben ser gestionados en otra tabla, que incluye atributos como project id, project name, start date, end date, y budget. Cada proyecto puede estar asociado a mu ́ltiples empleados, y cada empleado puede estar asignado a mu ́ltiples proyectos.


--Las Asignaciones de Proyectos deben ser gestionadas en una tabla que relacione a los empleados con los proyectos a los que est ́an asignados. Esta tabla debe incluir atributos como assignment id, employee id, project id, role, y hours worked.


--Se deben implementar relaciones de clave for ́anea entre las tablas, como la relaci ́on entre employee id en la tabla de Empleados y manager id en la tabla de Departamentos, y entre department id en la tabla de Empleados y la tabla de Departamentos. Tambi ́en debe existir una relaci ́on entre employee id y project id en la tabla de Asignaciones de Proyectos.


--El esquema debe permitir la extracci ́on de informaci ́on agregada, como el salario promedio de los empleados en cada departamento, el nu ́mero total de horas trabajadas por empleado en cada proyecto, y el presupuesto total asignado a proyectos activos.


--El sistema debe permitir el manejo de Proveedores, que son entidades externas involucradas en los proyectos. Los proveedores tienen atributos como supplier id, supplier name y contact info. Cada proveedor puede estar relacionado con mu ́ltiples proyectos, pero cada proyecto solo tiene un provedor.


--Se debe manejar la relaci ́on entre Clientes y proyectos. Cada cliente, almacenado en una tabla con atributos como customer id, customer name, contact info, y project id, puede estar relacionado con uno o m ́as proyectos, y cada proyecto puede estar relacionado con mu ́ltiples clientes.




CREATE TABLE Departments (
    department_ID NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    manager_ID VARCHAR2(50) NULL,
    FOREIGN KEY (manager_ID) REFERENCES Employees(employee_ID)
);

CREATE TABLE Proyectos (
    project_ID NUMBER PRIMARY KEY,
    project_name VARCHAR2(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget NUMBER CHECK (budget > 0)
);

CREATE TABLE Project_Asignment (
    assignment_ID NUMBER PRIMARY KEY,
    project_ID NUMBER,
    EMPLOYEE_ID NUMBER,
    roll VARCHAR2(20),
    hours_worked NUMBER,
    FOREIGN KEY (project_ID) REFERENCES Project(project_ID),
    FOREIGN KEY (employee_ID) REFERENCES Employees(employee_ID)
);

CREATE TABLE Custumer_project (
    custumer_ID NUMBER PRIMARY KEY,
    project_ID NUMBER,
    roll NUMBER VARCHAR2(20),
    FOREIGN KEY (project_ID) REFERENCES CUSTOMERS(project_ID),
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES CUSTOMERS(EMPLOYEE_ID)
);

-- Práctica #3: Creación de Tablas Complejas y
-- Consultas Avanzadas
-- Alumnos: 
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto
