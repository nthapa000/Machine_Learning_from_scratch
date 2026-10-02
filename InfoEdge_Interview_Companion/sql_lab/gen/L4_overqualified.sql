SELECT ca.name, ca.ctc_lpa, j.job_id, j.max_ctc_lpa
FROM applications a
JOIN candidates ca ON ca.cand_id = a.cand_id
JOIN jobs j        ON j.job_id   = a.job_id
WHERE ca.ctc_lpa > j.max_ctc_lpa
ORDER BY ca.name;
