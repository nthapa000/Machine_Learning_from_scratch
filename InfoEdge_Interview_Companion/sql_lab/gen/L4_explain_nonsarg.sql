CREATE INDEX idx_app_date ON applications(applied_date);
EXPLAIN QUERY PLAN
SELECT * FROM applications WHERE strftime('%Y', applied_date) = '2026';
