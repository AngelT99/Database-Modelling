SELECT * FROM jatan.department;
DESCRIBE department;
SELECT *
FROM department;
SELECT Name, Floor
FROM department;
SELECT *
FROM department
WHERE floor = 2;
SELECT *
FROM department
WHERE name LIKE 'M%';
SELECT *
FROM department;
SELECT *
FROM employee;
SELECT FirstName, LastName, Salary, DepartmentID
FROM employee
WHERE Salary = 45000;
SELECT *
FROM department
WHERE Name LIKE 'M%'
OR ManagerID = 1; 
SELECT *
FROM department
WHERE Floor != 1;
SELECT firstname, lastname, salary
FROM employee
WHERE departmentID = 11
 AND salary > 55000;
SELECT Name, Floor
FROM department
WHERE floor != 5
ORDER BY floor;
SELECT *
FROM department
ORDER BY Floor DESC, departmentID ASC; 
SELECT *
FROM department
ORDER BY Floor DESC, departmentID ASC; 
SELECT *
FROM department
ORDER BY departmentID ASC, Floor DESC;
SELECT Name
FROM department
WHERE Floor = 5
ORDER BY Name ASC
LIMIT 2;
SELECT Name
FROM department
WHERE Floor = 5
ORDER BY Name DESC
LIMIT 2;
SELECT CONCAT(firstname, lastname)
FROM employee;
SELECT CONCAT(firstname, ' ', lastname)
FROM employee;
SELECT CONCAT(FirstName, ' ', LastName, ' works in the ',
 department.Name, ' department') AS info
FROM employee NATURAL JOIN department;
SELECT COUNT(*)
FROM department;
SELECT COUNT(*)
FROM department
WHERE Name LIKE 'M%';
SELECT floor, COUNT(*)
FROM department
GROUP BY floor;
SELECT floor, COUNT(departmentID)
FROM department;
SELECT floor AS dept_floor, COUNT(*) AS dept_count
FROM department
GROUP BY dept_floor
ORDER BY dept_floor;
SELECT departmentID, AVG(salary)
FROM employee
GROUP BY departmentID;
SELECT departmentID, MAX(salary)
FROM employee
GROUP BY departmentID
ORDER BY Max(salary) DESC;
SELECT DepartmentID, AVG(Salary)
FROM employee
GROUP BY DepartmentID
HAVING AVG(Salary) > 55000;
SELECT AVG(Salary) AS AVG_SAL
FROM employee;
SELECT AVG(Salary)
FROM employee;
SELECT FORMAT(AVG(SALARY), 2) AS AVG_SAL
FROM employee;
SELECT FORMAT(AVG(SALARY), 2) AS AVG_SAL
FROM employee;
SELECT ROUND(AVG(SALARY), 2) AS AVG_SAL
FROM employee;
SELECT ROUND(AVG(SALARY), 2) AS AVG_SAL
FROM employee;

SELECT
 emp.FirstName AS employee_first, -- employee first name
 emp.LastName AS employee_last, -- employee last name
 emp.departmentID, -- employee department id
 boss.FirstName AS boss_first, -- boss first name
 boss.LastName AS boss_last -- boss last name
FROM employee AS emp INNER JOIN employee AS boss
 ON emp.BossID = boss.employeeID
 -- join the boss ID in emp to employee ID in boss
ORDER BY departmentID, employee_last;

SELECT
emp.FirstName AS employee_first,
emp.LastName AS employee_last,
emp.departmentID, 
boss.FirstName AS boss_first,
boss.LastName AS boss_last
FROM employee AS emp INNER JOIN employee AS boss
ON emp.BossID = boss.employeeID
ORDER BY departmentID, employee_last;

SELECT
 emp.FirstName AS employee_first,
 emp.LastName AS employee_last,
 emp.departmentID,
 boss.FirstName AS boss_first,
 boss.LastName AS boss_last
FROM employee AS emp LEFT JOIN employee AS boss
 ON emp.BossID = boss.employeeID
ORDER BY departmentID, employee_last;


SELECT
 emp.FirstName AS employee_first,
 emp.LastName AS employee_last,
 emp.departmentID,
 boss.FirstName AS boss_first,
 boss.LastName AS boss_last
FROM employee AS boss RIGHT JOIN employee AS emp
 ON emp.BossID = boss.employeeID
ORDER BY departmentID, employee_last;


SELECT
 CONCAT(emp.FirstName, ' ', emp.LastName) AS employee_name,
 emp.departmentID,
 CONCAT(boss.FirstName, ' ' , boss.LastName) AS boss_name
FROM employee AS boss RIGHT JOIN employee AS emp
 ON emp.BossID = boss.employeeID
ORDER BY departmentID, employee_name;
