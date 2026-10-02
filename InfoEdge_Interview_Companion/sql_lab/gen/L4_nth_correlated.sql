SELECT DISTINCT e.salary
FROM employees e
WHERE 2 = (SELECT COUNT(DISTINCT x.salary) FROM employees x WHERE x.salary > e.salary);
