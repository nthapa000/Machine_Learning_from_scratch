WITH ranked AS (
  SELECT name, dept, salary,
         DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dr
  FROM employees
  WHERE salary IS NOT NULL
)
SELECT dept, name, salary
FROM ranked
WHERE dr <= 2
ORDER BY dept, salary DESC, name;
