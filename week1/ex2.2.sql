SELECT Emp.Ssn as Emp_SSN, Emp.Fname as Emp_FirstName, Emp.Lname as Emp_LastName,
Sup.Fname as Sup_FirstName, Sup.Lname as Sup_LastName, Sup.Ssn as Sup_SSN,
Dept.Dname as Sup_Department
FROM EMPLOYEE Emp
JOIN EMPLOYEE Sup ON Emp.Super_ssn = Sup.Ssn
JOIN DEPARTMENT Dept ON Sup.Dno = Dept.Dnumber
WHERE Dept.Dname = 'Research';