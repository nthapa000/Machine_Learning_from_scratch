SELECT c.name AS candidate, r.name AS referred_by
FROM candidates c
JOIN candidates r ON r.cand_id = c.referred_by
ORDER BY c.cand_id;
