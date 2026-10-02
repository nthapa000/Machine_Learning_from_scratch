SELECT ca.cand_id, ca.name
FROM candidates ca
LEFT JOIN applications a ON a.cand_id = ca.cand_id
WHERE a.app_id IS NULL;
