WITH a(x) AS (VALUES (1), (1), (2), (NULL)),
     b(x) AS (VALUES (1), (1), (3), (NULL))
SELECT 'inner' AS join_type, COUNT(*) AS n_rows FROM a INNER JOIN b ON a.x = b.x
UNION ALL
SELECT 'left',  COUNT(*) FROM a LEFT  JOIN b ON a.x = b.x
UNION ALL
SELECT 'right', COUNT(*) FROM a RIGHT JOIN b ON a.x = b.x
UNION ALL
SELECT 'full',  COUNT(*) FROM a FULL  JOIN b ON a.x = b.x
UNION ALL
SELECT 'cross', COUNT(*) FROM a CROSS JOIN b;
