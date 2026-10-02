WITH r AS (
  SELECT app_id, cand_id, job_id,
         ROW_NUMBER() OVER (PARTITION BY cand_id, job_id, applied_date ORDER BY app_id) AS rn
  FROM applications
)
SELECT app_id, cand_id, job_id, rn FROM r WHERE cand_id = 101 ORDER BY app_id;
