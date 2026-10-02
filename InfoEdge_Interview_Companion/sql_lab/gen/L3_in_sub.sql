SELECT name
FROM candidates
WHERE cand_id IN (SELECT cand_id FROM applications WHERE status = 'offer')
ORDER BY name;
