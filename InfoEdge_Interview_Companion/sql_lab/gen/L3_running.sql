WITH daily AS (
  SELECT applied_date AS day, COUNT(*) AS n
  FROM applications
  WHERE applied_date >= '2026-02-01' AND applied_date < '2026-03-01'
  GROUP BY applied_date
)
SELECT day, n,
       SUM(n) OVER (ORDER BY day)                                        AS running_total,
       ROUND(AVG(n) OVER (ORDER BY day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3
FROM daily
ORDER BY day;
