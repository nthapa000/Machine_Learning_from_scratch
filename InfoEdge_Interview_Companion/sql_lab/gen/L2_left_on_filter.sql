SELECT ca.name, a.job_id AS offer_job
FROM candidates ca
LEFT JOIN applications a
       ON a.cand_id = ca.cand_id AND a.status = 'offer'
ORDER BY ca.cand_id;
