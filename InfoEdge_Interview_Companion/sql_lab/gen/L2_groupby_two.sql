SELECT city, title, COUNT(*) AS n_jobs
FROM jobs
GROUP BY city, title
ORDER BY city, title;
