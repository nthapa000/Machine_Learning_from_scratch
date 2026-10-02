SELECT name, ctc_lpa,
       NTILE(4) OVER (ORDER BY ctc_lpa)                       AS quartile,
       FIRST_VALUE(name) OVER (ORDER BY ctc_lpa DESC)         AS top_earner,
       ROUND(PERCENT_RANK() OVER (ORDER BY ctc_lpa), 3)       AS pct_rank
FROM candidates
WHERE ctc_lpa IS NOT NULL
ORDER BY ctc_lpa;
