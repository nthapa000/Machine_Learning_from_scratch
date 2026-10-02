SELECT e.name AS employee, e.salary, m.name AS manager, m.salary AS manager_salary
FROM employees e
LEFT JOIN employees m ON m.emp_id = e.manager_id
ORDER BY e.emp_id;
