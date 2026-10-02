SELECT COUNT(*)        AS n_rows,
       COUNT(salary)   AS n_salary,
       SUM(salary)     AS total,
       AVG(salary)     AS avg_ignores_null,
       SUM(salary) * 1.0 / COUNT(*) AS avg_null_as_zero,
       MIN(salary)     AS min_sal,
       MAX(salary)     AS max_sal
FROM employees;
