SELECT cand_id, COUNT(*) AS n_rejections
FROM applications
WHERE status = 'rejected'
GROUP BY cand_id
HAVING COUNT(*) >= 1
ORDER BY cand_id;
