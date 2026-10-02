SELECT e.name FROM employees e
WHERE NOT EXISTS (SELECT 1 FROM employees x WHERE x.manager_id = e.emp_id)
ORDER BY e.emp_id;
