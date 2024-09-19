-- Práctica #5: Procedimientos Almacenados, Funciones y Triggers
-- Alumnos:
-- * Paredes Zamudio Luis Daniel
-- * Rivera Morales David
-- * Tapia Hernandez Carlos Alberto

/* Procedimientos Almacenados

1. Procedimiento 1: AddNewEmployee
Este procedimiento almacenado permite agregar un nuevo empleado y, opcionalmente, asignarlo
como gerente de un departamento. Se verifica que el departamento no tenga ya un gerente.
*/

DELIMITER //

CREATE PROCEDURE AddNewEmployee (
    -- Consideramos los mismos atributos para el empleado que hay en la tabla Employees
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN email VARCHAR(50),
    IN hire_date DATE,
    IN salary DECIMAL(10, 2),
    IN department_id INT,
    -- Aqui más que declarar una variable, es para que el usuario decida si le queremos 
    -- asignar como gerente o no.
    IN assign_as_manager BOOLEAN,
    OUT new_emp_id INT
)
BEGIN
   
    INSERT INTO Employees(employee_id, first_name, last_name, email, hire_date, salary, department_id)
        VALUES (employee_id, first_name, last_name, email, hire_date, salary, department_id);
    
    -- LAST_INSERT_ID() nos regresa el último ID insertado previo al recien insertado.
    SET new_emp_id = LAST_INSERT_ID();

    -- Aqui se verifica si el usuario decidió que el empleado recien insertado fuera gerente.
    -- Si es así, se verifica que el departamento no tenga ya un gerente asignado.

    IF assign_as_manager THEN
        IF (SELECT manager_id FROM Departments WHERE department_id = department_id) IS NULL THEN
            UPDATE Departments SET manager_id = new_emp_id WHERE department_id = department_id;
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El departamento ya tiene un gerente asignado';
        END IF;
    END IF;
END //

DELIMITER ;

/* 2. Procedimiento 2: AssignEmployeeToProject
Este procedimiento asigna a un empleado a un proyecto. Además, valida que el empleado no trabaje
más de 40 horas en todos los proyectos combinados.  */

DELIMITER //

CREATE PROCEDURE AssignEmployeeToProject(
    -- Consideramos los mismos atributos para la asignación de un empleado a un proyecto que hay en
    -- Assignment_Project
    IN assignment_id INT,
    IN employee_id INT,
    IN project_id INT,
    IN roole VARCHAR(50),
    IN hours_worked DECIMAL(10, 2),
    OUT new_assignment_id INT
)
BEGIN
    INSERT INTO Assignment_Project(assignment_id, employee_id, project_id, roole, hours_worked)
        VALUES (assignment_id, employee_id, project_id, roole, hours_worked);

    SET new_assignment_id = LAST_INSERT_ID();

    -- Aqui se verifica que el empleado no trabaje más de 40 horas en todos los proyectos combinados.
    -- Se usa SUM para sumar las horas trabajadas en todos los proyectos de un empleado.
    -- y luego este resultado se compara con que no sea mayor a 40. Si lo es, se manda un mensaje de error.
    
    IF (SELECT SUM(hours_worked) FROM Assignment_Project WHERE employee_id = employee_id) > 40 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El empleado excede las 40 horas de trabajo en todos los proyectos';
    END IF;
END //
DELIMITER ;


/* 3. Procedimiento 3: AddCustomerToProject
Este procedimiento asigna un cliente a un proyecto, validando que el cliente no esté vinculado a más
de tres proyectos activos al mismo tiempo.*/ 

DELIMITER //

CREATE PROCEDURE AddCustomerToProject(
    IN customer_id INT,
    IN project_id INT,
    OUT new_customer_id INT
)
BEGIN
    INSERT INTO Customers_Projects(customer_id, project_id)
        VALUES (customer_id, project_id);

    SET new_customer_id = LAST_INSERT_ID();

    -- Aqui se verifica que el cliente no esté vinculado a más de tres proyectos activos al mismo tiempo.
    -- Se usa COUNT para contar cuantos proyectos tiene un cliente.
    -- y luego este resultado se compara con que no sea mayor a 3. Si lo es, se manda un mensaje de error.\
    IF (SELECT COUNT(*) FROM Customers_Projects WHERE customer_id = customer_id) > 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente ya tiene 3 proyectos activos';
    END IF;
END //

DELIMITER ;

/* Funciones
1. Función 1: CalculateTotalHoursWorked
Calcula el total de horas trabajadas por un empleado en todos los proyectos a los que está asignado.
*/

DELIMITER //

CREATE FUNCTION CalculateTotalHoursWorked (in_employee_id INT)
-- Notese que el parametro de entrada es in_employee_id, y no employee_id como en los otros procedimientos.
-- Esto es para evitar ambiguedades y que se entienda que es una variable de entrada y el atributo de
-- la tabla. 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_hours DECIMAL(10, 2);

    SELECT SUM(hours_worked) INTO total_hours
    FROM Assignment_Project
    WHERE employee_id = in_employee_id;
    
    RETURN total_hours;
END //

DELIMITER ;

/*2. Función 2: GetProjectBudgetRemaining
Calcula el presupuesto restante de un proyecto teniendo en cuenta los pagos realizados a los proveedores asociados. */

DELIMITER //

CREATE FUNCTION GetProjectBudgetRemaining(in_project_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_budget DECIMAL(10, 2)
    DECLARE budget_remaining DECIMAL(10, 2);

    -- Selecciona el budget de un project específico
    SELECT budget INTO total_budget
    FROM Projects
    WHERE project_id = in_project_id;

    -- Obtener el total de pagos realizados a los proveedores del proyecto
    SELECT SUM(amount) INTO total_payments
    FROM Payments
    WHERE project_id = in_project_id;

    SET budget_remaining = total_budget - IFNULL(total_payments, 0);

    RETURN budget_remaining;
END //

DELIMITER ;
    


/* 3. Función 3: IsDepartmentManager
Verifica si un empleado es gerente de su departamento. */

DELIMITER //

CREATE FUNCTION IsDepartmentManager (employee_id INT)
    RETURNS BOOLEAN
    DETERMINISTIC
    BEGIN
        DECLARE is_manager BOOLEAN;
        /* Aqui pasa lo siguiente. Se consulta
        en Departments cuantos departamentos
        tienen un manager_id que coincida con
        employee_id. Como solo se puede ser manager
        de un proyecto, esto regresa o 0 o 1. Justo
        esto es lo que se almacena en is_manager */
        SELECT COUNT(*) INTO is_manager
        FROM Departments
        WHERE manager_id = employee_id;
        RETURN is_manager;
    END //

DELIMITER ;


/* Triggers
1. Trigger 1: BeforeEmployeeDelete
Evita la eliminación de un empleado si este es gerente de algún departamento. */

DELIMITER //

CREATE TRIGGER BeforeEmployeeDelete
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
-- Primero lo que se hace es contar la cantidad de departamentos que tienen un manager_id que coincida
-- con el employee_id del empleado que se desea eliminar. Idealmente, deberia regresar 0, lo que indicaria
-- que efectivamente, el empleado no es gerente de ningun departamento. Si regresa algo distinto, se manda
-- un mensaje de error, ya que entonces el empleado es gerente de al menos un departamento, y no puede ser
-- eliminado.
    IF (SELECT COUNT(*) FROM Departments WHERE manager_id = OLD.employee_id) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El empleado es gerente de un departamento. No puede ser eliminado';
    END IF;
END //

DELIMITER ;


/*2. Trigger 2: AfterInsertAssignment
Se activa después de que se inserte una asignación de proyecto, invocando la función CalculateTo-
talHoursWorked para verificar que el empleado no exceda las 40 horas.  */

DELIMITER //

CREATE TRIGGER AfterInsertAssignment
AFTER INSERT ON Assignment_Project
FOR EACH ROW
BEGIN
    -- Aqui se llama a la función CalculateTotalHoursWorked con el employee_id de la nueva asignación.
    -- De ahi que se use la función NEW.
    CALL CalculateTotalHoursWorked(NEW.employee_id);
END //

DELIMITER ;


/* 3. Trigger 3: BeforeUpdateProjectBudget
Verifica, antes de actualizar el presupuesto de un proyecto, si los pagos exceden el presupuesto
original utilizando la función GetProjectBudgetRemaining. */