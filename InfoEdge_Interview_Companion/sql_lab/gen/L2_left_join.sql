SELECT c.name AS company, COUNT(j.job_id) AS n_jobs
FROM companies c
LEFT JOIN jobs j ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
ORDER BY n_jobs DESC, company;
