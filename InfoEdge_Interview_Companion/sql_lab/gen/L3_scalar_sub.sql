SELECT name, ctc_lpa
FROM candidates
WHERE ctc_lpa > (SELECT AVG(ctc_lpa) FROM candidates)
ORDER BY ctc_lpa DESC;
