SELECT co.name AS company,
       COUNT(a.app_id) AS applications,
       SUM(CASE WHEN a.status = 'offer' THEN 1 ELSE 0 END) AS offers,
       ROUND(1.0 * SUM(CASE WHEN a.status = 'offer' THEN 1 ELSE 0 END)
             / NULLIF(COUNT(a.app_id), 0), 2) AS offer_rate
FROM companies co
LEFT JOIN jobs j          ON j.company_id = co.company_id
LEFT JOIN applications a  ON a.job_id     = j.job_id AND a.app_id <> 22
GROUP BY co.company_id, co.name
ORDER BY offer_rate DESC, company;
