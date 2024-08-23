-- Insertar departamentos
INSERT INTO Departments (department_id, department_name, budget) VALUES (1, 'Human Resources', 50000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (2, 'Finance', 75000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (3, 'IT Support', 100000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (4, 'Marketing', 60000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (5, 'Sales', 90000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (6, 'Customer Service', 45000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (7, 'Product Development', 120000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (8, 'Legal', 70000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (9, 'Operations', 80000);
INSERT INTO Departments (department_id, department_name, budget) VALUES (10, 'Research & Development', 95000);


-- Insertar empleados
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (1, 'Alice', 'Johnson', 'alice.johnson@example.com', '123-456-7890', TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'Software Engineer', 3, 7000);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (2, 'Bob', 'Smith', 'bob.smith@example.com', '234-567-8901', TO_DATE('2022-03-22', 'YYYY-MM-DD'), 'Project Manager', 1, 8000);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (3, 'Charlie', 'Brown', 'charlie.brown@example.com', '345-678-9012', TO_DATE('2022-05-10', 'YYYY-MM-DD'), 'UX Designer', 4, 6500);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (4, 'Diana', 'Clark', 'diana.clark@example.com', '456-789-0123', TO_DATE('2022-07-18', 'YYYY-MM-DD'), 'Data Analyst', 6, 7200);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (5, 'Edward', 'Miller', 'edward.miller@example.com', '567-890-1234', TO_DATE('2022-09-25', 'YYYY-MM-DD'), 'Marketing Specialist', 4, 6000);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (6, 'Fiona', 'Davis', 'fiona.davis@example.com', '678-901-2345', TO_DATE('2022-11-30', 'YYYY-MM-DD'), 'Customer Support', 6, 5500);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (7, 'George', 'Martinez', 'george.martinez@example.com', '789-012-3456', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Financial Analyst', 2, 7300);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (8, 'Hannah', 'Wilson', 'hannah.wilson@example.com', '890-123-4567', TO_DATE('2023-03-20', 'YYYY-MM-DD'), 'HR Coordinator', 1, 6700);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (9, 'Ian', 'Lee', 'ian.lee@example.com', '901-234-5678', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 'Web Developer', 3, 7100);
INSERT INTO Employees (employee_id, fst_name, lst_name, email, phone_number, hire_date, job_title, department_id, salary) VALUES (10, 'Julia', 'Taylor', 'julia.taylor@example.com', '012-345-6789', TO_DATE('2023-07-30', 'YYYY-MM-DD'), 'Operations Manager', 9, 7800);

-- Insertar proyectos
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (1, 'Website Redesign', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), 200000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (2, 'New CRM System', TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-08-31', 'YYYY-MM-DD'), 150000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (3, 'Mobile App Development', TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-09-30', 'YYYY-MM-DD'), 175000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (4, 'Data Warehouse Implementation', TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 300000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (5, 'Marketing Campaign', TO_DATE('2024-05-01', 'YYYY-MM-DD'), TO_DATE('2024-10-31', 'YYYY-MM-DD'), 120000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (6, 'Product Launch', TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-11-30', 'YYYY-MM-DD'), 250000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (7, 'Employee Training Program', TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 80000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (8, 'Infrastructure Upgrade', TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-11-30', 'YYYY-MM-DD'), 130000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (9, 'Customer Feedback System', TO_DATE('2024-09-01', 'YYYY-MM-DD'), TO_DATE('2025-03-31', 'YYYY-MM-DD'), 160000);
INSERT INTO Projects (project_id, project_name, start_date, end_date, budget) VALUES (10, 'Regulatory Compliance', TO_DATE('2024-10-01', 'YYYY-MM-DD'), TO_DATE('2025-06-30', 'YYYY-MM-DD'), 190000);

-- Insertar salarios


INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (1, 1, 5000, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (2, 2, 6000, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (3, 3, 5500, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (4, 4, 7000, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (5, 5, 6500, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (6, 1, 5200, TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (7, 2, 6100, TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (8, 3, 5600, TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (9, 4, 7100, TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO Salaries (salary_id, employee_id, salary_amount, salary_date) VALUES (10, 5, 6600, TO_DATE('2024-02-15', 'YYYY-MM-DD'));


-- Insertar asignaciones de proyecto
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (1, 1, 1, 'Lead Developer', 120);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (2, 2, 1, 'Project Manager', 100);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (3, 3, 2, 'UX Designer', 110);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (4, 4, 3, 'Data Analyst', 130);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (5, 5, 4, 'Marketing Specialist', 90);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (6, 6, 5, 'Customer Support', 80);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (7, 7, 6, 'Financial Analyst', 150);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (8, 8, 7, 'HR Coordinator', 70);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (9, 9, 8, 'Web Developer', 125);
INSERT INTO Project_Assignments (assignment_id, employee_id, project_id, roole, hours_allocated) VALUES (10, 10, 9, 'Operations Manager', 140);

