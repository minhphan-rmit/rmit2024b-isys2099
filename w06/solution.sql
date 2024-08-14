-- Exercise 1
START TRANSACTION;

UPDATE Department
SET Mgr_ssn = '123456789', Mgr_start_date = CURDATE()
WHERE Dnumber = 5;

UPDATE Employee
SET Salary = Salary + 2000
WHERE Ssn = '123456789';

COMMIT;

-- Exercise 2.1
-- Session #1
-- T1
START TRANSACTION;

-- T3
SELECT * FROM Employee
WHERE Ssn = '123456789' FOR SHARE;

-- T6
COMMIT;

-- Session #2
-- T2
START TRANSACTION;

-- T4
SELECT * FROM Employee
WHERE Ssn = '123456789' FOR SHARE;

-- T5
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- T7
COMMIT;

-- Exercise 2.1
-- Session #1
-- T1
START TRANSACTION;

-- T3
SELECT * FROM Employee
WHERE Ssn = '123456789' FOR SHARE;

-- T5
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '333445555';

-- T7
COMMIT;

-- Session #2
-- T2
START TRANSACTION;

-- T4
SELECT * FROM Employee
WHERE Ssn = '333445555' FOR SHARE;

-- T6
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- T8
COMMIT;

-- Exercise 3.1 (Repeatable Read)
-- Session #1
-- T1
START TRANSACTION;

-- T3
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- T6
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- T7
COMMIT;

-- Session #2
-- T2
START TRANSACTION;

-- T4
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- T5
COMMIT;

-- Exercise 3.2 (Read Uncommitted)
-- Session #1
SET SESSION TRANSACTION ISOLATION LEVEL Read Uncommitted;
-- T1
START TRANSACTION;

-- T3
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- T6
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- T7
COMMIT;

-- Session #2
SET SESSION TRANSACTION ISOLATION LEVEL Read Uncommitted;
-- T2
START TRANSACTION;

-- T4
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- T5
COMMIT;
