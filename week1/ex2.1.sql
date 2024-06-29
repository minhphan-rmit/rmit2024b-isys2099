SELECT E.Fname, E.Minit, E.Lname
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
JOIN PROJECT P ON W.Pno = P.Pnumber
JOIN DEPARTMENT D ON E.Dno = D.Dnumber
WHERE D.Dname = 'Research'
  AND W.Hours >= 10;

