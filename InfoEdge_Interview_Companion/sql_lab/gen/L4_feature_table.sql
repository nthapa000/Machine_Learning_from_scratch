WITH apps AS (                      -- one row per candidate from applications
  SELECT cand_id,
         COUNT(DISTINCT job_id)                         AS n_jobs_applied,
         SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS n_rejected,
         MAX(CASE WHEN status = 'offer'    THEN 1 ELSE 0 END) AS got_offer
  FROM (SELECT DISTINCT cand_id, job_id, applied_date, status FROM applications) a
  GROUP BY cand_id
),
act AS (                            -- one row per candidate from logins
  SELECT cand_id, COUNT(DISTINCT login_date) AS n_login_days
  FROM logins
  GROUP BY cand_id
)
SELECT ca.cand_id,
       ca.exp_yrs,
       COALESCE(ca.ctc_lpa, 0)                 AS ctc_lpa,
       CASE WHEN ca.ctc_lpa IS NULL THEN 1 ELSE 0 END AS ctc_missing,
       COALESCE(ap.n_jobs_applied, 0)          AS n_jobs_applied,
       COALESCE(ap.n_rejected, 0)              AS n_rejected,
       COALESCE(ac.n_login_days, 0)            AS n_login_days,
       COALESCE(ap.got_offer, 0)               AS got_offer
FROM candidates ca
LEFT JOIN apps ap ON ap.cand_id = ca.cand_id
LEFT JOIN act  ac ON ac.cand_id = ca.cand_id
ORDER BY ca.cand_id;
