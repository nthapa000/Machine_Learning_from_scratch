WITH d AS (SELECT DISTINCT cand_id, login_date FROM logins),
g AS (
  SELECT cand_id, login_date,
         julianday(login_date)
           - ROW_NUMBER() OVER (PARTITION BY cand_id ORDER BY login_date) AS grp
  FROM d
)
SELECT cand_id, MIN(login_date) AS streak_start, MAX(login_date) AS streak_end,
       COUNT(*) AS streak_len
FROM g
GROUP BY cand_id, grp
HAVING COUNT(*) >= 3
ORDER BY streak_len DESC, cand_id;
