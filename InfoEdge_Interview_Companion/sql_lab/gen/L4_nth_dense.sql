SELECT DISTINCT salary
FROM (SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS dr
      FROM employees WHERE salary IS NOT NULL) t
WHERE dr = 3;
