SELECT Dname, COUNT(*) No_Emp
FROM Department 
JOIN Employee ON Dnumber = Dno
GROUP BY Dname
HAVING COUNT(*) >= 3;