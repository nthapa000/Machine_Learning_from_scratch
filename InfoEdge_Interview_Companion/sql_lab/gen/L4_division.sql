SELECT a.cand_id
FROM applications a
JOIN jobs j ON j.job_id = a.job_id
WHERE j.title = 'Data Analyst'
GROUP BY a.cand_id
HAVING COUNT(DISTINCT a.job_id) = (SELECT COUNT(*) FROM jobs WHERE title = 'Data Analyst');
