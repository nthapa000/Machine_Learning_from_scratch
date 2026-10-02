SELECT band, COUNT(*) AS n, AVG(ctc_lpa) AS avg_ctc
FROM (
  SELECT ctc_lpa,
         CASE WHEN exp_yrs <= 3 THEN '0-3' WHEN exp_yrs <= 6 THEN '4-6' ELSE '7+' END AS band
  FROM candidates
) t
GROUP BY band
ORDER BY band;
