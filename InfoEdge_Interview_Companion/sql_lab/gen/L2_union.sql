SELECT city FROM companies
UNION
SELECT city FROM candidates WHERE city IS NOT NULL
ORDER BY city;
