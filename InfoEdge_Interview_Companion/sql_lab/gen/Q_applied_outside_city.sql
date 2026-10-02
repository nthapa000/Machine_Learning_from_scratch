SELECT ca.name, ca.city AS home_city, j.city AS job_city, j.title
FROM applications a
JOIN candidates ca ON ca.cand_id = a.cand_id
JOIN jobs j        ON j.job_id   = a.job_id
WHERE ca.city <> j.city
  AND a.app_id <> 22
ORDER BY ca.name, j.job_id;
