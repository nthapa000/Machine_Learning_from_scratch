SELECT name, salary FROM (
  SELECT name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS dr
  FROM employees
) t
WHERE dr <= 3
ORDER BY salary DESC;
