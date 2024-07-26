SELECT s.ID, s.name, d.dept_name, b.build_name, b.address
FROM student s
JOIN department d ON s.dept_name = d.dept_name
JOIN building b ON d.building = b.build_name
ORDER BY s.ID ASC;

