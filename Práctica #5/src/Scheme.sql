CREATE DATABASE p5_fbd;
USE p5_fbd;

CREATE TABLE Departments(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    manager_id INT DEFAULT NULL
);

CREATE TABLE Employees(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

ALTER TABLE Departments ADD CONSTRAINT fk_employees 
    FOREIGN KEY (manager_id) 
        REFERENCES Employees(employee_id);

CREATE TABLE Suppliers(
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    contact_info VARCHAR(50)
);

CREATE TABLE Projects(
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10, 2),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Assignment_Project(
    assignment_id INT,
    employee_id INT,
    project_id INT,
    roole VARCHAR(50),
    hours_worked DECIMAL(10, 2),
    PRIMARY KEY (assignment_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);


CREATE TABLE Customers(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    contact_info VARCHAR(100)
);

CREATE TABLE Customer_Project(
    customer_id INT,
    project_id INT,
    PRIMARY KEY (customer_id, project_id),
    CONSTRAINT fk_customer_project_customer_id FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_customer_project_project_id FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);