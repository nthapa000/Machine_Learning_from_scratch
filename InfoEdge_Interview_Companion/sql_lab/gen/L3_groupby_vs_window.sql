SELECT dept, AVG(salary) AS dept_avg
FROM employees
GROUP BY dept
ORDER BY dept;
