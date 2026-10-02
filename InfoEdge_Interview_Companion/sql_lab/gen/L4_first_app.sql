SELECT cand_id, job_id, applied_date
FROM (
  SELECT a.*, ROW_NUMBER() OVER (PARTITION BY cand_id ORDER BY applied_date, app_id) AS rn
  FROM applications a
) t
WHERE rn = 1
ORDER BY cand_id;
