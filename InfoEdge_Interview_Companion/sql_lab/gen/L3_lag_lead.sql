SELECT cand_id, applied_date,
       LAG(applied_date)  OVER (PARTITION BY cand_id ORDER BY applied_date, app_id) AS prev_app,
       LEAD(applied_date) OVER (PARTITION BY cand_id ORDER BY applied_date, app_id) AS next_app,
       CAST(julianday(applied_date)
            - julianday(LAG(applied_date) OVER (PARTITION BY cand_id ORDER BY applied_date, app_id))
            AS INTEGER) AS days_since_prev
FROM applications
WHERE cand_id IN (101, 102)
ORDER BY cand_id, applied_date, app_id;
