SELECT j.title,
       ROUND(AVG(julianday(a.applied_date) - julianday(j.posted_date)), 2) AS avg_days_to_apply,
       COUNT(*) AS n_apps
FROM applications a
JOIN jobs j ON j.job_id = a.job_id
WHERE a.app_id <> 22
GROUP BY j.title
ORDER BY avg_days_to_apply;
