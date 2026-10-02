SELECT 'company' AS source, city FROM companies WHERE city = 'Bengaluru'
UNION ALL
SELECT 'candidate', city FROM candidates WHERE city = 'Bengaluru';
