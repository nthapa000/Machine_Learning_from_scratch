SELECT title, COUNT(*) AS n_jobs,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_jobs
FROM jobs
GROUP BY title
ORDER BY n_jobs DESC;
