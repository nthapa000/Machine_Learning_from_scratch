CREATE INDEX idx_app_date ON applications(applied_date);
EXPLAIN QUERY PLAN
SELECT * FROM applications WHERE applied_date >= '2026-01-01' AND applied_date < '2027-01-01';
