SELECT cand_id, job_id, applied_date, COUNT(*) AS copies
FROM applications
GROUP BY cand_id, job_id, applied_date
HAVING COUNT(*) > 1;
