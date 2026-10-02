WITH s AS (
  SELECT ctc_lpa,
         ROW_NUMBER() OVER (ORDER BY ctc_lpa) AS rn,
         COUNT(*)     OVER ()                 AS n
  FROM candidates
  WHERE ctc_lpa IS NOT NULL
)
SELECT AVG(ctc_lpa) AS median_ctc
FROM s
WHERE rn IN ((n + 1) / 2, (n + 2) / 2);
