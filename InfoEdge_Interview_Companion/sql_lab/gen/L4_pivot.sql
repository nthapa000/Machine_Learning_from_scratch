SELECT co.name AS company,
       SUM(CASE WHEN j.title = 'Data Scientist' THEN 1 ELSE 0 END) AS data_scientist,
       SUM(CASE WHEN j.title = 'Data Analyst'   THEN 1 ELSE 0 END) AS data_analyst,
       SUM(CASE WHEN j.title = 'ML Engineer'    THEN 1 ELSE 0 END) AS ml_engineer
FROM companies co
LEFT JOIN jobs j ON j.company_id = co.company_id
GROUP BY co.company_id, co.name
ORDER BY co.company_id;
