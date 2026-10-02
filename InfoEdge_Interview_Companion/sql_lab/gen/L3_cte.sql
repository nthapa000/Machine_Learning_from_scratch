WITH apps_per_job AS (
  SELECT job_id, COUNT(*) AS n_apps
  FROM applications
  GROUP BY job_id
),
job_info AS (
  SELECT j.job_id, j.title, c.name AS company, COALESCE(p.n_apps, 0) AS n_apps
  FROM jobs j
  JOIN companies c ON c.company_id = j.company_id
  LEFT JOIN apps_per_job p ON p.job_id = j.job_id
)
SELECT * FROM job_info
WHERE n_apps >= (SELECT AVG(n_apps) FROM job_info)
ORDER BY n_apps DESC, job_id;
