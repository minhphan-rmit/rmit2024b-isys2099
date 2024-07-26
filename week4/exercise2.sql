-- Using company_with_key database
USE company_with_key;

-- Join order: (Employee JOIN Department) JOIN Dependent
EXPLAIN ANALYZE
SELECT e.Fname, e.Lname, d.Dname, dep.Dependent_name
FROM Employee e
INNER JOIN Department d ON e.Dno = d.Dnumber
INNER JOIN Dependent dep ON e.Ssn = dep.Essn;

-- Using company_without_key database
USE company_without_key;

-- Join order: (Employee JOIN Department) JOIN Dependent
EXPLAIN ANALYZE
SELECT e.Fname, e.Lname, d.Dname, dep.Dependent_name
FROM Employee e
INNER JOIN Department d ON e.Dno = d.Dnumber
INNER JOIN Dependent dep ON e.Ssn = dep.Essn;

-- Using company_with_key database
USE company_with_key;

-- Join order: (Employee JOIN Dependent) JOIN Department
EXPLAIN 
SELECT e.Fname, e.Lname, d.Dname, dep.Dependent_name
FROM Employee e
JOIN Dependent dep ON e.Ssn = dep.Essn
JOIN Department d ON e.Dno = d.Dnumber;

-- Using company_without_key database
USE company_without_key;

-- Join order: (Employee JOIN Dependent) JOIN Department
EXPLAIN 
SELECT e.Fname, e.Lname, d.Dname, dep.Dependent_name
FROM Employee e
JOIN Dependent dep ON e.Ssn = dep.Essn
JOIN Department d ON e.Dno = d.Dnumber;
