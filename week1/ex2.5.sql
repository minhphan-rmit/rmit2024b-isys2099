SELECT DISTINCT Fname
FROM Employee
WHERE Ssn NOT IN
(
  SELECT Essn
  FROM Project JOIN Works_on ON Pnumber = Pno
  WHERE Plocation = 'Houston'
);