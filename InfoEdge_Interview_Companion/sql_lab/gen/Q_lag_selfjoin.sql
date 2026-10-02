SELECT cur.cand_id, cur.login_date,
       MAX(prev.login_date) AS prev_login
FROM (SELECT DISTINCT cand_id, login_date FROM logins) cur
LEFT JOIN (SELECT DISTINCT cand_id, login_date FROM logins) prev
       ON prev.cand_id = cur.cand_id AND prev.login_date < cur.login_date
WHERE cur.cand_id = 101
GROUP BY cur.cand_id, cur.login_date
ORDER BY cur.login_date;
