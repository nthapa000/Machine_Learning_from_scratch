SELECT v.variant, d.shown_date
FROM (SELECT DISTINCT variant FROM impressions) v
CROSS JOIN (SELECT DISTINCT shown_date FROM impressions) d
ORDER BY v.variant, d.shown_date;
