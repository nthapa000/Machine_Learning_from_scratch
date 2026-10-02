SELECT status, COUNT(*) AS n
FROM applications
GROUP BY status
ORDER BY n DESC;
