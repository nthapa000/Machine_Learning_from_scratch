SELECT title,
       COUNT(*)          AS n_jobs,
       AVG(max_ctc_lpa)  AS avg_max_ctc,
       MAX(max_ctc_lpa)  AS best_max_ctc
FROM jobs
GROUP BY title
ORDER BY avg_max_ctc DESC;
