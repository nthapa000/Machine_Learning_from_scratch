WITH RECURSIVE chain(emp_id, name, manager_id, level, path) AS (
  SELECT emp_id, name, manager_id, 0, name
  FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.name, e.manager_id, c.level + 1, c.path || ' > ' || e.name
  FROM employees e
  JOIN chain c ON e.manager_id = c.emp_id
)
SELECT level, name, path FROM chain ORDER BY path;
