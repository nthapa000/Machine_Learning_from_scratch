INSERT INTO applications (app_id, cand_id, job_id, applied_date, status)
VALUES (24, 110, 210, '2026-03-11', 'applied');
UPDATE applications SET status = 'shortlisted' WHERE app_id = 24;
DELETE FROM applications WHERE app_id = 22;
SELECT app_id, cand_id, job_id, status FROM applications WHERE app_id IN (1, 22, 24);
