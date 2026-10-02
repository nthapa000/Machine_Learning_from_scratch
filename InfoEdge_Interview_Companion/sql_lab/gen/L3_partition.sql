SELECT name, dept, salary,
       DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS rank_in_dept,
       AVG(salary)  OVER (PARTITION BY dept)                      AS dept_avg,
       salary - AVG(salary) OVER (PARTITION BY dept)              AS diff_from_avg
FROM employees
WHERE salary IS NOT NULL
ORDER BY dept, salary DESC, name;
