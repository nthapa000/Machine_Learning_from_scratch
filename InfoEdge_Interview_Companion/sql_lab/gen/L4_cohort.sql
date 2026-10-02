WITH cohort AS (
  SELECT cand_id, strftime('%Y-%m', signup_date) AS signup_month FROM candidates
),
active AS (
  SELECT DISTINCT cand_id FROM logins
  WHERE login_date BETWEEN '2026-03-01' AND '2026-03-07'
)
SELECT c.signup_month,
       COUNT(*)                         AS signed_up,
       COUNT(a.cand_id)                 AS active_first_week_march,
       ROUND(1.0 * COUNT(a.cand_id) / COUNT(*), 2) AS retention
FROM cohort c
LEFT JOIN active a ON a.cand_id = c.cand_id
GROUP BY c.signup_month
ORDER BY c.signup_month;
