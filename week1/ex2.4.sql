SELECT Pname, SUM(Hours) AS Total_hour
FROM Project 
JOIN Works_on ON Pnumber = Pno
GROUP BY Pname;