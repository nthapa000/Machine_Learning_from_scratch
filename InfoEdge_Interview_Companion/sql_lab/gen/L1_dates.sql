SELECT job_id, posted_date,
       strftime('%Y-%m', posted_date)                  AS month,
       CAST(julianday('2026-03-15') - julianday(posted_date) AS INTEGER) AS days_open,
       date(posted_date, '+30 days')                   AS expires_on
FROM jobs
ORDER BY posted_date
LIMIT 4;
