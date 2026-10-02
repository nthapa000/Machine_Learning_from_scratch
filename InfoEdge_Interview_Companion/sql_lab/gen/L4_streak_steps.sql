WITH d AS (SELECT DISTINCT cand_id, login_date FROM logins WHERE cand_id = 101)
SELECT login_date,
       ROW_NUMBER() OVER (ORDER BY login_date) AS rn,
       date(login_date, '-' || ROW_NUMBER() OVER (ORDER BY login_date) || ' days') AS grp_date
FROM d ORDER BY login_date;
