WITH d AS (SELECT DISTINCT cand_id, login_date FROM logins),
days AS (SELECT DISTINCT login_date AS day FROM logins)
SELECT days.day,
       COUNT(DISTINCT d.cand_id) AS users_last_3_days
FROM days
JOIN d ON d.login_date BETWEEN date(days.day, '-2 days') AND days.day
GROUP BY days.day
ORDER BY days.day;
