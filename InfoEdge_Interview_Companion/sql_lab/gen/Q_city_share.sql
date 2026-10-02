SELECT COALESCE(city, 'Unknown') AS city,
       COUNT(*) AS n_cands,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM candidates), 1) AS pct
FROM candidates
GROUP BY COALESCE(city, 'Unknown')
ORDER BY n_cands DESC, city;
