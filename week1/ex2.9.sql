SELECT Supervisee.Fname, Supervisee.Bdate, Supervisor.Fname, Supervisor.Bdate
FROM Employee Supervisee 
JOIN Employee Supervisor ON Supervisee.Super_ssn = Supervisor.Ssn
WHERE Supervisee.Bdate <= Supervisor.Bdate;