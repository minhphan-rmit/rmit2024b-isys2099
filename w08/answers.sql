-- Exercise 1

-- Creating views

CREATE VIEW Dept_stats
AS
SELECT Dnumber, Dname, Mgr.Fname AS Manager_name, COUNT(*) AS NoOfEmp
FROM Department JOIN Employee Mgr
ON Mgr_ssn = Mgr.Ssn
JOIN Employee Emp
ON Dnumber = Emp.Dno
GROUP BY Dnumber, Dname, Mgr.Fname;

-- Using views

SELECT * FROM Dept_stats
WHERE NoOfEmp > 3;

-- Check views updatable property

SELECT * FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'Dept_stats';

--------------------------------------------

-- Exercise 2

-- Create MVs

CREATE TABLE Project_Resources
SELECT Pnumber AS ProjectNumber, Pname AS ProjectName,
       Plocation AS ProjectLocation, COUNT(*) AS TotalEmployees
FROM Project JOIN Works_on
ON Pnumber = Pno
GROUP BY ProjectNumber, ProjectName, ProjectLocation;

-- Using MVs

SELECT * FROM Project_Resources;

--------------------------------------------

-- Exercise 3

-- Create stored procedures

DELIMITER $$$
CREATE PROCEDURE sp_update_salary(IN EmpID CHAR(9),
                                  IN IncAmt DECIMAL(5,0))
BEGIN
  UPDATE Employee SET Salary = Salary + IncAmt
  WHERE Ssn = EmpID;
END $$$
DELIMITER ;

-- Call the stored procedure
CALL sp_update_salary('111111112', 1000);

-- A stored procedure to do full refresh
DELIMITER $$$

CREATE PROCEDURE sp_refresh()
BEGIN
  TRUNCATE TABLE Project_Resources;

  INSERT INTO Project_Resources
  SELECT Pnumber AS ProjectNumber, Pname AS ProjectName,
         Plocation AS ProjectLocation, COUNT(*) AS TotalEmployees
  FROM Project JOIN Works_on
  ON Pnumber = Pno
  GROUP BY ProjectNumber, ProjectName, ProjectLocation;
END $$$
DELIMITER ;

-- Call the stored procedure
CALL sp_refresh();

-- Store procedures with transaction

DELIMITER $$$
CREATE PROCEDURE sp_update_salary_advanced(IN EmpID char(9),
                                  IN IncAmt decimal(5,0),
                                  OUT Success int)
BEGIN
  DECLARE emp_sal decimal(5,0);
  DECLARE sup_sal decimal(5,0);
  DECLARE `_rollback` INT DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
  START TRANSACTION;
  
  UPDATE Employee SET Salary = Salary + IncAmt
  WHERE Ssn = EmpID;

  SELECT Emp.Salary, Sup.Salary INTO emp_sal, sup_sal
  FROM Employee Emp JOIN Employee Sup
  ON Emp.Super_ssn = Sup.Ssn
  WHERE Emp.Ssn = EmpID;
  
  IF `_rollback` = 1 THEN
    ROLLBACK;
    SET Success = 0;
  ELSE IF emp_sal >= sup_sal THEN
    ROLLBACK;
    SET success = 0;
  ELSE
    COMMIT;
    SET success = 1;
  END IF;
END $$$
DELIMITER ;

-- Call the stored procedure
SET @outcome = 0;
CALL sp_update_salary_advanced('111111112', 1000, @outcome);
SELECT @outcome;
