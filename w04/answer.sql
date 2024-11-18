-- Exercise 1

-- First query
SELECT * FROM Employee
WHERE Sex = 'F' AND Dno = 5;

-- Second query
SELECT * FROM Employee
WHERE Sex = 'F' OR Dno = 5;

-- Use EXPLAIN and EXPLAIN ANALYZE to check if your
-- indexes can be used to MySQL to answer a query

-- Note 1: we should create an index on a column 
-- with more unique values
-- An index on (Dno) is better than on (Sex)

-- Note 2: the condition order we specified in
-- WHERE does not matter
-- (condition1 AND condition2) is the same as
-- (condition2 AND condition1) in terms of performance

-- Note 3: The logical OR makes some indexes useless
-- In this case, individual indexes on individual columns work

-- Suggested index:
ALTER TABLE Employee
ADD INDEX idx_dno_sex (Dno, Sex);

--------------------------------------------

-- Exercise 2

SELECT fname, dname, dependent_name
FROM Employee JOIN Department
ON Dno = Dnumber
JOIN Dependent
ON Essn = Ssn;

-- MySQL provides optimizer hints
-- https://dev.mysql.com/doc/refman/8.4/en/optimizer-hints.html
-- where you can add some hints to the optimizer


--------------------------------------------

-- Exercise 3

-- First solution
SELECT Dnumber, Dname
FROM Department
WHERE Dnumber IN (
  SELECT Dno
  FROM Employee
  WHERE Ssn IN (
    SELECT Essn
    FROM Dependent
  )
);

-- Second solution
SELECT Dnumber, Dname
FROM Department
WHERE EXISTS (
  SELECT *
  FROM Employee JOIN Dependent
  ON Ssn = Essn
  WHERE Dno = Dnumber
);

-- With SUB-QUERY, you can control the execution order
-- (join order of tables) more than with JOIN
