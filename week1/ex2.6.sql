SELECT DISTINCT Fname
FROM Employee 
JOIN Works_on w_out ON Ssn = Essn
WHERE NOT EXISTS
(
  SELECT Pnumber
  FROM Project LEFT JOIN 
  (
    SELECT * FROM Works_on w_in 
    WHERE w_out.Essn = W_in.Essn
  ) AS Prj_Emp
  ON Pnumber = Prj_Emp.Pno
  WHERE Plocation = 'Houston' AND Prj_Emp.Pno IS NULL
);