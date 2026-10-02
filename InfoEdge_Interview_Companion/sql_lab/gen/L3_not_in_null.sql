SELECT name FROM employees
WHERE emp_id NOT IN (SELECT manager_id FROM employees);
