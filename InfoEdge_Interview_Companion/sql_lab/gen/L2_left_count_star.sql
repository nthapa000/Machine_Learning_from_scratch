SELECT c.name AS company, COUNT(*) AS wrong_n_jobs
FROM companies c
LEFT JOIN jobs j ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
ORDER BY wrong_n_jobs DESC, company;
