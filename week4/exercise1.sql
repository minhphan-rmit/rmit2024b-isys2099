-- Explanation: 
-- This script demonstrates how to use the EXPLAIN statement to analyze the execution plans for different queries
-- in both 'company_with_key' and 'company_without_key' databases. The focus is on comparing AND and OR conditions
-- and observing the impact of condition order on the execution plan.

-- Using the 'company_with_key' database
USE company_with_key;

-- Get all female employees who are in department #5
EXPLAIN SELECT * FROM Employee WHERE Sex = 'F' AND Dno = 5;

-- Get all female employees who are in department #5 (reversed conditions)
EXPLAIN SELECT * FROM Employee WHERE Dno = 5 AND Sex = 'F';

-- Get all female employees and employees in department #5
EXPLAIN SELECT * FROM Employee WHERE Sex = 'F' OR Dno = 5;

-- Get all female employees and employees in department #5 (reversed conditions)
EXPLAIN SELECT * FROM Employee WHERE Dno = 5 OR Sex = 'F';

-- Explanation:
-- In 'company_with_key', the optimizer will likely use indexes on columns with PRIMARY KEY or UNIQUE constraints.
-- The 'EXPLAIN' output will show the key usage, type of access (e.g., ref, range), and estimated number of rows.

-- Using the 'company_without_key' database
USE company_without_key;

DROP INDEX idx_dno_sex ON EMPLOYEE;
CREATE INDEX idx_dno_sex
ON EMPLOYEE (dno, sex);

-- Get all female employees who are in department #5
EXPLAIN ANALYZE SELECT * FROM Employee WHERE Sex = 'F' AND Dno = 5;

-- Get all female employees who are in department #5 (reversed conditions)
EXPLAIN SELECT * FROM Employee WHERE Dno = 5 AND Sex = 'F';

-- Get all female employees and employees in department #5
EXPLAIN SELECT * FROM Employee WHERE Sex = 'F' OR Dno = 5;

-- Get all female employees and employees in department #5 (reversed conditions)
EXPLAIN SELECT * FROM Employee WHERE Dno = 5 OR Sex = 'F';

-- Explanation:
-- In 'company_without_key', there are no primary keys, so the optimizer may use full table scans or any available indexes.
-- The 'EXPLAIN' output will help observe the differences in execution plans compared to 'company_with_key'.
-- Specifically, look for 'type' (e.g., ALL, index), 'key' usage, and estimated 'rows' to understand the impact.
