SELECT name,
       COALESCE(city, 'Unknown')  AS city,
       COALESCE(ctc_lpa, 0)       AS ctc_lpa_filled
FROM candidates
WHERE city IS NULL OR ctc_lpa IS NULL;
