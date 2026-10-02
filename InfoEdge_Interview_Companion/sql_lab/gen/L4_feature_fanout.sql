SELECT ca.cand_id,
       SUM(CASE WHEN a.status = 'rejected' THEN 1 ELSE 0 END) AS n_rejected_wrong,
       COUNT(l.login_date)                                   AS n_logins_wrong
FROM candidates ca
LEFT JOIN applications a ON a.cand_id = ca.cand_id
LEFT JOIN logins l       ON l.cand_id = ca.cand_id
WHERE ca.cand_id IN (101, 107, 109)
GROUP BY ca.cand_id
ORDER BY ca.cand_id;
