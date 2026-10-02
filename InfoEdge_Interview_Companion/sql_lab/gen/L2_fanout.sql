SELECT SUM(j.max_ctc_lpa) AS sum_after_join, COUNT(*) AS rows_after_join
FROM jobs j
JOIN applications a ON a.job_id = j.job_id;
