CREATE TABLE departamentos( 
    department_id NUMBER PRIMARY KEY, 
    department_name VARCHAR2(30) NOT NULL, 
);

CREATE TABLE empleados( 
    employee_id NUMBER PRIMARY KEY, 
    first_name VARCHAR(30) NOT NULL, 
    last_name VARCHAR(30) NOT NULL, 
    department_id NUMBER, 
    hire_date DATE NOT NULL, 
    salary NUMBER, 
    email VARCHAR2(40) NOT NULL UNIQUE, 
    FOREIGN KEY (department_id) REFERENCES departamentos(department_id), 
    CONSTRAINT check_salary CHECK (salario > 0), 
);

CREATE TABLE proyectos( 
    project_id NUMBER PRIMARY KEY, 
    project_name VARCHAR2(30) NOT NULL UNIQUE, 
    -- Obtiene la fecha en la cual se inicia el projecto. 
    start_date DATE DEFAULT GETDATE(), 
    end_date DATE, 
    budget NUMBER NOT NULL, 
    CONSTRAINT check_date CHECK (end_date IS NULL OR end_date>start_date), 
    CONSTRAINT check_budget CHECK (budget > 0), 
);

CREATE TABLE asignaciones( 
    assignment_id NUMBER PRIMARY KEY, 
    FOREIGN KEY (employee_id) REFERENCES empleados(employee_id), 
	FOREIGN KEY (project_id) REFERENCES proyectos(project_id), 
    assigned_hours NUMBER NOT NULL, 
    assignment_date DATE DATE DEFAULT GETDATE(), 
    CONSTRAINT check_assigned_hours CHECK (assigned_hours > 0), 
);

CREATE SEQUENCE auto_increment_employee_id 
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER increment_enployee_id_before_insert 
BEFORE INSERT ON empleados 
FOR EACH ROW 
BEGIN 
	IF :NEW.employee_id IS NULL THEN 
	SELECT auto_increment_employee_id_NEXTVAL 
	INTO :NEW.employee_id 
	FROM dual, 
	END IF; 
END;
