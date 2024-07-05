SELECT Fname, Salary
FROM Employee
WHERE (Dno, Salary) IN
(
  SELECT Dno, Max(Salary)
  FROM Employee
  GROUP BY Dno
);