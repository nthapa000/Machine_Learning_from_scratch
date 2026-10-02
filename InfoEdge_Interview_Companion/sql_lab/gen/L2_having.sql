SELECT cand_id, COUNT(*) AS n_apps
FROM applications
GROUP BY cand_id
HAVING COUNT(*) >= 3
ORDER BY n_apps DESC, cand_id;
