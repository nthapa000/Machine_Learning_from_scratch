SELECT ca.name, a.job_id, a.status
FROM candidates ca
LEFT JOIN applications a ON a.cand_id = ca.cand_id
WHERE a.status = 'offer';
