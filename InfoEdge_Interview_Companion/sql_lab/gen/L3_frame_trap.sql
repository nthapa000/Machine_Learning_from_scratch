SELECT name, salary,
       LAST_VALUE(name) OVER (ORDER BY salary)  AS last_default,
       LAST_VALUE(name) OVER (ORDER BY salary
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_full
FROM employees
WHERE dept = 'DataScience'
ORDER BY salary;
