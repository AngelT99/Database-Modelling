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