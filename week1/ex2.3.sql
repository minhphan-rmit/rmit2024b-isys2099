SELECT Fname 
FROM Employee 
JOIN Department ON Mgr_ssn = Ssn
WHERE Ssn NOT IN (
    SELECT Essn FROM works_on
);