WITH RECURSIVE days(d) AS (
  SELECT '2026-03-01'
  UNION ALL
  SELECT date(d, '+1 day') FROM days WHERE d < '2026-03-07'
)
SELECT days.d AS day, COUNT(DISTINCT l.cand_id) AS dau
FROM days
LEFT JOIN logins l ON l.login_date = days.d
GROUP BY days.d
ORDER BY days.d;
