SELECT (SELECT AVG(salary) FROM employees) AS overall_avg,
       (SELECT AVG(dept_avg)
        FROM (SELECT AVG(salary) AS dept_avg FROM employees GROUP BY dept)) AS avg_of_dept_avgs;
