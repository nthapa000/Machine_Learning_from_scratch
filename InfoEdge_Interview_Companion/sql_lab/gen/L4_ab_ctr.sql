SELECT variant,
       COUNT(*)                    AS impressions,
       SUM(clicked)                AS clicks,
       ROUND(AVG(clicked * 1.0), 3) AS ctr
FROM impressions
GROUP BY variant;
