SELECT name,
       ctc_lpa,
       ctc_lpa * 100000 / 12 AS monthly_ctc_rs,
       ctc_lpa * 1.30       AS expected_ctc_lpa
FROM candidates
WHERE ctc_lpa IS NOT NULL
ORDER BY expected_ctc_lpa DESC
LIMIT 4;
