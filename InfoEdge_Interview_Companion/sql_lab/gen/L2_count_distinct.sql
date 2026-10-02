SELECT COUNT(*)                AS applications,
       COUNT(DISTINCT cand_id) AS candidates_who_applied,
       COUNT(DISTINCT job_id)  AS jobs_with_applications
FROM applications;
