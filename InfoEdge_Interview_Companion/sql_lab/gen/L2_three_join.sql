SELECT a.app_id, ca.name AS candidate, j.title, co.name AS company, a.status
FROM applications a
JOIN candidates ca ON ca.cand_id    = a.cand_id
JOIN jobs       j  ON j.job_id      = a.job_id
JOIN companies  co ON co.company_id = j.company_id
WHERE a.status = 'offer'
ORDER BY a.app_id;
