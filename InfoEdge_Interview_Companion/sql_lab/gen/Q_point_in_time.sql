WITH params AS (SELECT '2026-02-15' AS cutoff),
feat AS (                -- features: only rows strictly before the cutoff
  SELECT a.cand_id,
         COUNT(*) AS apps_before,
         SUM(CASE WHEN a.status = 'rejected' THEN 1 ELSE 0 END) AS rejections_before
  FROM applications a, params p
  WHERE a.applied_date < p.cutoff
  GROUP BY a.cand_id
),
label AS (               -- label: what happened on or after the cutoff
  SELECT a.cand_id,
         MAX(CASE WHEN a.status = 'offer' THEN 1 ELSE 0 END) AS offer_after
  FROM applications a, params p
  WHERE a.applied_date >= p.cutoff
  GROUP BY a.cand_id
)
SELECT c.cand_id,
       COALESCE(f.apps_before, 0)       AS apps_before,
       COALESCE(f.rejections_before, 0) AS rejections_before,
       COALESCE(l.offer_after, 0)       AS label_offer_after
FROM candidates c
LEFT JOIN feat  f ON f.cand_id = c.cand_id
LEFT JOIN label l ON l.cand_id = c.cand_id
WHERE c.signup_date < (SELECT cutoff FROM params)
ORDER BY c.cand_id;
