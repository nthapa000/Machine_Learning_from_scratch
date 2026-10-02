WITH job_cities AS (
  SELECT city, COUNT(*) AS n_jobs FROM jobs GROUP BY city
),
cand_cities AS (
  SELECT city, COUNT(*) AS n_cands FROM candidates WHERE city IS NOT NULL GROUP BY city
)
SELECT COALESCE(j.city, c.city) AS city, j.n_jobs, c.n_cands
FROM job_cities j
FULL OUTER JOIN cand_cities c ON c.city = j.city
ORDER BY city;
