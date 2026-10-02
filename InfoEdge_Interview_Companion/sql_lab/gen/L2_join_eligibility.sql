SELECT ca.name, j.job_id, j.title, j.min_exp
FROM candidates ca
JOIN jobs j
  ON ca.exp_yrs >= j.min_exp
 AND ca.city = j.city
ORDER BY ca.name, j.job_id;
