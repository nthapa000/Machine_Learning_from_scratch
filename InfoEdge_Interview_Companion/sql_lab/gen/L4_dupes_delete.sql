DELETE FROM applications
WHERE app_id NOT IN (
  SELECT MIN(app_id) FROM applications
  GROUP BY cand_id, job_id, applied_date
);
SELECT COUNT(*) AS rows_left FROM applications;
