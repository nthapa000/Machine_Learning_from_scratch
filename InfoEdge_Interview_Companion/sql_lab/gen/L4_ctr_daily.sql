SELECT shown_date, variant, COUNT(*) AS imps, SUM(clicked) AS clicks,
       ROUND(1.0 * SUM(clicked) / COUNT(*), 2) AS ctr
FROM impressions
GROUP BY shown_date, variant
ORDER BY shown_date, variant;
