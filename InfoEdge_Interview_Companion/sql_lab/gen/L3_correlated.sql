SELECT e.name, e.dept, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(x.salary) FROM employees x WHERE x.dept = e.dept)
ORDER BY e.dept, e.salary DESC;
