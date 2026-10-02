CREATE INDEX idx_app_cand ON applications(cand_id);
EXPLAIN QUERY PLAN
SELECT * FROM applications WHERE cand_id = 105;
