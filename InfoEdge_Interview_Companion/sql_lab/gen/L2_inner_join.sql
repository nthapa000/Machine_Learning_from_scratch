SELECT j.job_id, j.title, c.name AS company, c.industry
FROM jobs AS j
JOIN companies AS c ON c.company_id = j.company_id
ORDER BY j.job_id
LIMIT 5;
