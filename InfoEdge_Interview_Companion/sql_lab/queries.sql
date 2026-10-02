-- @L1_select_all
SELECT * FROM companies;

-- @L1_columns
SELECT name, city, exp_yrs
FROM candidates;

-- @L1_where
SELECT name, city, exp_yrs, ctc_lpa
FROM candidates
WHERE city = 'Bengaluru';

-- @L1_and_or
SELECT name, city, exp_yrs
FROM candidates
WHERE city = 'Bengaluru' OR city = 'Mumbai' AND exp_yrs >= 5;

-- @L1_and_or_fixed
SELECT name, city, exp_yrs
FROM candidates
WHERE (city = 'Bengaluru' OR city = 'Mumbai') AND exp_yrs >= 5;

-- @L1_in_between
SELECT name, city, exp_yrs
FROM candidates
WHERE city IN ('Delhi', 'Pune', 'Noida')
  AND exp_yrs BETWEEN 3 AND 10;

-- @L1_like
SELECT job_id, title, city
FROM jobs
WHERE title LIKE 'Data%';

-- @L1_null_wrong
SELECT name, city FROM candidates WHERE city = NULL;

-- @L1_null_right
SELECT name, city FROM candidates WHERE city IS NULL;

-- @L1_not_equal_null
SELECT COUNT(*) AS not_bengaluru
FROM candidates
WHERE city <> 'Bengaluru';

-- @L1_order_limit
SELECT name, ctc_lpa
FROM candidates
ORDER BY ctc_lpa DESC
LIMIT 3;

-- @L1_order_nulls
SELECT name, ctc_lpa
FROM candidates
ORDER BY ctc_lpa ASC
LIMIT 3;

-- @L1_offset
SELECT name, ctc_lpa
FROM candidates
ORDER BY ctc_lpa DESC
LIMIT 3 OFFSET 3;

-- @L1_distinct
SELECT DISTINCT title FROM jobs;

-- @L1_distinct_pair
SELECT DISTINCT title, city FROM jobs ORDER BY title, city;

-- @L1_computed
SELECT name,
       ctc_lpa,
       ctc_lpa * 100000 / 12 AS monthly_ctc_rs,
       ctc_lpa * 1.30       AS expected_ctc_lpa
FROM candidates
WHERE ctc_lpa IS NOT NULL
ORDER BY expected_ctc_lpa DESC
LIMIT 4;

-- @L1_case
SELECT name, exp_yrs,
       CASE
         WHEN exp_yrs = 0  THEN 'Fresher'
         WHEN exp_yrs <= 3 THEN 'Junior'
         WHEN exp_yrs <= 6 THEN 'Mid'
         ELSE 'Senior'
       END AS band
FROM candidates
ORDER BY exp_yrs;

-- @L1_coalesce
SELECT name,
       COALESCE(city, 'Unknown')  AS city,
       COALESCE(ctc_lpa, 0)       AS ctc_lpa_filled
FROM candidates
WHERE city IS NULL OR ctc_lpa IS NULL;

-- @L1_strings
SELECT name,
       UPPER(name)            AS upper_name,
       LENGTH(name)           AS n_chars,
       SUBSTR(name, 1, 3)     AS first3,
       name || ' (' || COALESCE(city, '?') || ')' AS label
FROM candidates
LIMIT 4;

-- @L1_dates
SELECT job_id, posted_date,
       strftime('%Y-%m', posted_date)                  AS month,
       CAST(julianday('2026-03-15') - julianday(posted_date) AS INTEGER) AS days_open,
       date(posted_date, '+30 days')                   AS expires_on
FROM jobs
ORDER BY posted_date
LIMIT 4;

-- @L1_intdiv
SELECT 7 / 2      AS int_div,
       7 * 1.0 / 2 AS real_div,
       ROUND(2.0 / 3, 3) AS rounded;

-- @L2_agg_basic
SELECT COUNT(*)        AS n_rows,
       COUNT(salary)   AS n_salary,
       SUM(salary)     AS total,
       AVG(salary)     AS avg_ignores_null,
       SUM(salary) * 1.0 / COUNT(*) AS avg_null_as_zero,
       MIN(salary)     AS min_sal,
       MAX(salary)     AS max_sal
FROM employees;

-- @L2_count_distinct
SELECT COUNT(*)                AS applications,
       COUNT(DISTINCT cand_id) AS candidates_who_applied,
       COUNT(DISTINCT job_id)  AS jobs_with_applications
FROM applications;

-- @L2_groupby
SELECT title,
       COUNT(*)          AS n_jobs,
       AVG(max_ctc_lpa)  AS avg_max_ctc,
       MAX(max_ctc_lpa)  AS best_max_ctc
FROM jobs
GROUP BY title
ORDER BY avg_max_ctc DESC;

-- @L2_groupby_two
SELECT city, title, COUNT(*) AS n_jobs
FROM jobs
GROUP BY city, title
ORDER BY city, title;

-- @L2_having
SELECT cand_id, COUNT(*) AS n_apps
FROM applications
GROUP BY cand_id
HAVING COUNT(*) >= 3
ORDER BY n_apps DESC, cand_id;

-- @L2_where_vs_having
SELECT cand_id, COUNT(*) AS n_rejections
FROM applications
WHERE status = 'rejected'
GROUP BY cand_id
HAVING COUNT(*) >= 1
ORDER BY cand_id;

-- @L2_conditional_agg
SELECT job_id,
       COUNT(*)                                            AS applicants,
       SUM(CASE WHEN status = 'offer'    THEN 1 ELSE 0 END) AS offers,
       SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS rejections,
       ROUND(AVG(CASE WHEN status = 'offer' THEN 1.0 ELSE 0 END), 2) AS offer_rate
FROM applications
GROUP BY job_id
ORDER BY job_id;

-- @L2_status_counts
SELECT status, COUNT(*) AS n
FROM applications
GROUP BY status
ORDER BY n DESC;

-- @L2_inner_join
SELECT j.job_id, j.title, c.name AS company, c.industry
FROM jobs AS j
JOIN companies AS c ON c.company_id = j.company_id
ORDER BY j.job_id
LIMIT 5;

-- @L2_three_join
SELECT a.app_id, ca.name AS candidate, j.title, co.name AS company, a.status
FROM applications a
JOIN candidates ca ON ca.cand_id    = a.cand_id
JOIN jobs       j  ON j.job_id      = a.job_id
JOIN companies  co ON co.company_id = j.company_id
WHERE a.status = 'offer'
ORDER BY a.app_id;

-- @L2_left_join
SELECT c.name AS company, COUNT(j.job_id) AS n_jobs
FROM companies c
LEFT JOIN jobs j ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
ORDER BY n_jobs DESC, company;

-- @L2_left_count_star
SELECT c.name AS company, COUNT(*) AS wrong_n_jobs
FROM companies c
LEFT JOIN jobs j ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
ORDER BY wrong_n_jobs DESC, company;

-- @L2_anti_join
SELECT ca.cand_id, ca.name
FROM candidates ca
LEFT JOIN applications a ON a.cand_id = ca.cand_id
WHERE a.app_id IS NULL;

-- @L2_left_where_trap
SELECT ca.name, a.job_id, a.status
FROM candidates ca
LEFT JOIN applications a ON a.cand_id = ca.cand_id
WHERE a.status = 'offer';

-- @L2_left_on_filter
SELECT ca.name, a.job_id AS offer_job
FROM candidates ca
LEFT JOIN applications a
       ON a.cand_id = ca.cand_id AND a.status = 'offer'
ORDER BY ca.cand_id;

-- @L2_full_join
WITH job_cities AS (
  SELECT city, COUNT(*) AS n_jobs FROM jobs GROUP BY city
),
cand_cities AS (
  SELECT city, COUNT(*) AS n_cands FROM candidates WHERE city IS NOT NULL GROUP BY city
)
SELECT COALESCE(j.city, c.city) AS city, j.n_jobs, c.n_cands
FROM job_cities j
FULL OUTER JOIN cand_cities c ON c.city = j.city
ORDER BY city;

-- @L2_self_join
SELECT e.name AS employee, e.salary, m.name AS manager, m.salary AS manager_salary
FROM employees e
LEFT JOIN employees m ON m.emp_id = e.manager_id
ORDER BY e.emp_id;

-- @L2_referral_self
SELECT c.name AS candidate, r.name AS referred_by
FROM candidates c
JOIN candidates r ON r.cand_id = c.referred_by
ORDER BY c.cand_id;

-- @L2_cross_join
SELECT v.variant, d.shown_date
FROM (SELECT DISTINCT variant FROM impressions) v
CROSS JOIN (SELECT DISTINCT shown_date FROM impressions) d
ORDER BY v.variant, d.shown_date;

-- @L2_fanout
SELECT SUM(j.max_ctc_lpa) AS sum_after_join, COUNT(*) AS rows_after_join
FROM jobs j
JOIN applications a ON a.job_id = j.job_id;

-- @L2_fanout_truth
SELECT SUM(max_ctc_lpa) AS true_sum, COUNT(*) AS n_jobs FROM jobs;

-- @L2_join_eligibility
SELECT ca.name, j.job_id, j.title, j.min_exp
FROM candidates ca
JOIN jobs j
  ON ca.exp_yrs >= j.min_exp
 AND ca.city = j.city
ORDER BY ca.name, j.job_id;

-- @L2_union
SELECT city FROM companies
UNION
SELECT city FROM candidates WHERE city IS NOT NULL
ORDER BY city;

-- @L2_union_all
SELECT 'company' AS source, city FROM companies WHERE city = 'Bengaluru'
UNION ALL
SELECT 'candidate', city FROM candidates WHERE city = 'Bengaluru';

-- @L2_except
SELECT city FROM candidates
EXCEPT
SELECT city FROM jobs;

-- @L3_scalar_sub
SELECT name, ctc_lpa
FROM candidates
WHERE ctc_lpa > (SELECT AVG(ctc_lpa) FROM candidates)
ORDER BY ctc_lpa DESC;

-- @L3_in_sub
SELECT name
FROM candidates
WHERE cand_id IN (SELECT cand_id FROM applications WHERE status = 'offer')
ORDER BY name;

-- @L3_not_in_null
SELECT name FROM employees
WHERE emp_id NOT IN (SELECT manager_id FROM employees);

-- @L3_not_exists
SELECT e.name FROM employees e
WHERE NOT EXISTS (SELECT 1 FROM employees x WHERE x.manager_id = e.emp_id)
ORDER BY e.emp_id;

-- @L3_correlated
SELECT e.name, e.dept, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(x.salary) FROM employees x WHERE x.dept = e.dept)
ORDER BY e.dept, e.salary DESC;

-- @L3_derived_table
SELECT band, COUNT(*) AS n, AVG(ctc_lpa) AS avg_ctc
FROM (
  SELECT ctc_lpa,
         CASE WHEN exp_yrs <= 3 THEN '0-3' WHEN exp_yrs <= 6 THEN '4-6' ELSE '7+' END AS band
  FROM candidates
) t
GROUP BY band
ORDER BY band;

-- @L3_cte
WITH apps_per_job AS (
  SELECT job_id, COUNT(*) AS n_apps
  FROM applications
  GROUP BY job_id
),
job_info AS (
  SELECT j.job_id, j.title, c.name AS company, COALESCE(p.n_apps, 0) AS n_apps
  FROM jobs j
  JOIN companies c ON c.company_id = j.company_id
  LEFT JOIN apps_per_job p ON p.job_id = j.job_id
)
SELECT * FROM job_info
WHERE n_apps >= (SELECT AVG(n_apps) FROM job_info)
ORDER BY n_apps DESC, job_id;

-- @L3_recursive_hier
WITH RECURSIVE chain(emp_id, name, manager_id, level, path) AS (
  SELECT emp_id, name, manager_id, 0, name
  FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.name, e.manager_id, c.level + 1, c.path || ' > ' || e.name
  FROM employees e
  JOIN chain c ON e.manager_id = c.emp_id
)
SELECT level, name, path FROM chain ORDER BY path;

-- @L3_recursive_dates
WITH RECURSIVE days(d) AS (
  SELECT '2026-03-01'
  UNION ALL
  SELECT date(d, '+1 day') FROM days WHERE d < '2026-03-07'
)
SELECT days.d AS day, COUNT(DISTINCT l.cand_id) AS dau
FROM days
LEFT JOIN logins l ON l.login_date = days.d
GROUP BY days.d
ORDER BY days.d;

-- @L3_rownum_rank
SELECT name, dept, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
       RANK()       OVER (ORDER BY salary DESC) AS rnk,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM employees
WHERE salary IS NOT NULL
ORDER BY salary DESC, name;

-- @L3_partition
SELECT name, dept, salary,
       DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS rank_in_dept,
       AVG(salary)  OVER (PARTITION BY dept)                      AS dept_avg,
       salary - AVG(salary) OVER (PARTITION BY dept)              AS diff_from_avg
FROM employees
WHERE salary IS NOT NULL
ORDER BY dept, salary DESC, name;

-- @L3_groupby_vs_window
SELECT dept, AVG(salary) AS dept_avg
FROM employees
GROUP BY dept
ORDER BY dept;

-- @L3_lag_lead
SELECT cand_id, applied_date,
       LAG(applied_date)  OVER (PARTITION BY cand_id ORDER BY applied_date, app_id) AS prev_app,
       LEAD(applied_date) OVER (PARTITION BY cand_id ORDER BY applied_date, app_id) AS next_app,
       CAST(julianday(applied_date)
            - julianday(LAG(applied_date) OVER (PARTITION BY cand_id ORDER BY applied_date, app_id))
            AS INTEGER) AS days_since_prev
FROM applications
WHERE cand_id IN (101, 102)
ORDER BY cand_id, applied_date, app_id;

-- @L3_running
WITH daily AS (
  SELECT applied_date AS day, COUNT(*) AS n
  FROM applications
  WHERE applied_date >= '2026-02-01' AND applied_date < '2026-03-01'
  GROUP BY applied_date
)
SELECT day, n,
       SUM(n) OVER (ORDER BY day)                                        AS running_total,
       ROUND(AVG(n) OVER (ORDER BY day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3
FROM daily
ORDER BY day;

-- @L3_pct_total
SELECT title, COUNT(*) AS n_jobs,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_jobs
FROM jobs
GROUP BY title
ORDER BY n_jobs DESC;

-- @L3_ntile_first
SELECT name, ctc_lpa,
       NTILE(4) OVER (ORDER BY ctc_lpa)                       AS quartile,
       FIRST_VALUE(name) OVER (ORDER BY ctc_lpa DESC)         AS top_earner,
       ROUND(PERCENT_RANK() OVER (ORDER BY ctc_lpa), 3)       AS pct_rank
FROM candidates
WHERE ctc_lpa IS NOT NULL
ORDER BY ctc_lpa;

-- @L3_frame_trap
SELECT name, salary,
       LAST_VALUE(name) OVER (ORDER BY salary)  AS last_default,
       LAST_VALUE(name) OVER (ORDER BY salary
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_full
FROM employees
WHERE dept = 'DataScience'
ORDER BY salary;

-- @L3_dml
INSERT INTO applications (app_id, cand_id, job_id, applied_date, status)
VALUES (24, 110, 210, '2026-03-11', 'applied');
UPDATE applications SET status = 'shortlisted' WHERE app_id = 24;
DELETE FROM applications WHERE app_id = 22;
SELECT app_id, cand_id, job_id, status FROM applications WHERE app_id IN (1, 22, 24);

-- @L3_ddl
CREATE TABLE skills (
  cand_id INTEGER NOT NULL REFERENCES candidates(cand_id),
  skill   VARCHAR(20) NOT NULL,
  level   INTEGER CHECK (level BETWEEN 1 AND 5),
  PRIMARY KEY (cand_id, skill)
);
INSERT INTO skills VALUES (101,'python',4),(101,'sql',3),(102,'sql',5);
SELECT * FROM skills;

-- @L4_nth_dense
SELECT DISTINCT salary
FROM (SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS dr
      FROM employees WHERE salary IS NOT NULL) t
WHERE dr = 3;

-- @L4_nth_limit
SELECT DISTINCT salary
FROM employees
WHERE salary IS NOT NULL
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

-- @L4_nth_correlated
SELECT DISTINCT e.salary
FROM employees e
WHERE 2 = (SELECT COUNT(DISTINCT x.salary) FROM employees x WHERE x.salary > e.salary);

-- @L4_second_max
SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- @L4_topn_group
WITH ranked AS (
  SELECT name, dept, salary,
         DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dr
  FROM employees
  WHERE salary IS NOT NULL
)
SELECT dept, name, salary
FROM ranked
WHERE dr <= 2
ORDER BY dept, salary DESC, name;

-- @L4_dupes_find
SELECT cand_id, job_id, applied_date, COUNT(*) AS copies
FROM applications
GROUP BY cand_id, job_id, applied_date
HAVING COUNT(*) > 1;

-- @L4_dupes_delete
DELETE FROM applications
WHERE app_id NOT IN (
  SELECT MIN(app_id) FROM applications
  GROUP BY cand_id, job_id, applied_date
);
SELECT COUNT(*) AS rows_left FROM applications;

-- @L4_dupes_rownum
WITH r AS (
  SELECT app_id, cand_id, job_id,
         ROW_NUMBER() OVER (PARTITION BY cand_id, job_id, applied_date ORDER BY app_id) AS rn
  FROM applications
)
SELECT app_id, cand_id, job_id, rn FROM r WHERE cand_id = 101 ORDER BY app_id;

-- @L4_more_than_manager
SELECT e.name AS employee, e.salary, m.name AS manager, m.salary AS manager_salary
FROM employees e
JOIN employees m ON m.emp_id = e.manager_id
WHERE e.salary > m.salary;

-- @L4_streaks
WITH d AS (SELECT DISTINCT cand_id, login_date FROM logins),
g AS (
  SELECT cand_id, login_date,
         julianday(login_date)
           - ROW_NUMBER() OVER (PARTITION BY cand_id ORDER BY login_date) AS grp
  FROM d
)
SELECT cand_id, MIN(login_date) AS streak_start, MAX(login_date) AS streak_end,
       COUNT(*) AS streak_len
FROM g
GROUP BY cand_id, grp
HAVING COUNT(*) >= 3
ORDER BY streak_len DESC, cand_id;

-- @L4_streak_steps
WITH d AS (SELECT DISTINCT cand_id, login_date FROM logins WHERE cand_id = 101)
SELECT login_date,
       ROW_NUMBER() OVER (ORDER BY login_date) AS rn,
       date(login_date, '-' || ROW_NUMBER() OVER (ORDER BY login_date) || ' days') AS grp_date
FROM d ORDER BY login_date;

-- @L4_funnel
WITH stage AS (
  SELECT app_id,
         CASE status WHEN 'applied' THEN 1 WHEN 'rejected' THEN 1
                     WHEN 'shortlisted' THEN 2 WHEN 'interview' THEN 3
                     WHEN 'offer' THEN 4 END AS reached
  FROM applications
  WHERE app_id <> 22
)
SELECT SUM(reached >= 1) AS applied,
       SUM(reached >= 2) AS shortlisted,
       SUM(reached >= 3) AS interviewed,
       SUM(reached >= 4) AS offered,
       ROUND(1.0 * SUM(reached >= 2) / SUM(reached >= 1), 3) AS apply_to_short,
       ROUND(1.0 * SUM(reached >= 4) / SUM(reached >= 3), 3) AS interview_to_offer
FROM stage;

-- @L4_ab_ctr
SELECT variant,
       COUNT(*)                    AS impressions,
       SUM(clicked)                AS clicks,
       ROUND(AVG(clicked * 1.0), 3) AS ctr
FROM impressions
GROUP BY variant;

-- @L4_ctr_daily
SELECT shown_date, variant, COUNT(*) AS imps, SUM(clicked) AS clicks,
       ROUND(1.0 * SUM(clicked) / COUNT(*), 2) AS ctr
FROM impressions
GROUP BY shown_date, variant
ORDER BY shown_date, variant;

-- @L4_cohort
WITH cohort AS (
  SELECT cand_id, strftime('%Y-%m', signup_date) AS signup_month FROM candidates
),
active AS (
  SELECT DISTINCT cand_id FROM logins
  WHERE login_date BETWEEN '2026-03-01' AND '2026-03-07'
)
SELECT c.signup_month,
       COUNT(*)                         AS signed_up,
       COUNT(a.cand_id)                 AS active_first_week_march,
       ROUND(1.0 * COUNT(a.cand_id) / COUNT(*), 2) AS retention
FROM cohort c
LEFT JOIN active a ON a.cand_id = c.cand_id
GROUP BY c.signup_month
ORDER BY c.signup_month;

-- @L4_mom
WITH monthly AS (
  SELECT strftime('%Y-%m', applied_date) AS month, COUNT(*) AS n_apps
  FROM applications
  GROUP BY 1
)
SELECT month, n_apps,
       LAG(n_apps) OVER (ORDER BY month) AS prev_month,
       ROUND(100.0 * (n_apps - LAG(n_apps) OVER (ORDER BY month))
                   / LAG(n_apps) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- @L4_median
WITH s AS (
  SELECT ctc_lpa,
         ROW_NUMBER() OVER (ORDER BY ctc_lpa) AS rn,
         COUNT(*)     OVER ()                 AS n
  FROM candidates
  WHERE ctc_lpa IS NOT NULL
)
SELECT AVG(ctc_lpa) AS median_ctc
FROM s
WHERE rn IN ((n + 1) / 2, (n + 2) / 2);

-- @L4_pivot
SELECT co.name AS company,
       SUM(CASE WHEN j.title = 'Data Scientist' THEN 1 ELSE 0 END) AS data_scientist,
       SUM(CASE WHEN j.title = 'Data Analyst'   THEN 1 ELSE 0 END) AS data_analyst,
       SUM(CASE WHEN j.title = 'ML Engineer'    THEN 1 ELSE 0 END) AS ml_engineer
FROM companies co
LEFT JOIN jobs j ON j.company_id = co.company_id
GROUP BY co.company_id, co.name
ORDER BY co.company_id;

-- @L4_first_app
SELECT cand_id, job_id, applied_date
FROM (
  SELECT a.*, ROW_NUMBER() OVER (PARTITION BY cand_id ORDER BY applied_date, app_id) AS rn
  FROM applications a
) t
WHERE rn = 1
ORDER BY cand_id;

-- @L4_time_to_apply
SELECT j.title,
       ROUND(AVG(julianday(a.applied_date) - julianday(j.posted_date)), 2) AS avg_days_to_apply,
       COUNT(*) AS n_apps
FROM applications a
JOIN jobs j ON j.job_id = a.job_id
WHERE a.app_id <> 22
GROUP BY j.title
ORDER BY avg_days_to_apply;

-- @L4_division
SELECT a.cand_id
FROM applications a
JOIN jobs j ON j.job_id = a.job_id
WHERE j.title = 'Data Analyst'
GROUP BY a.cand_id
HAVING COUNT(DISTINCT a.job_id) = (SELECT COUNT(*) FROM jobs WHERE title = 'Data Analyst');

-- @L4_rolling_users
WITH d AS (SELECT DISTINCT cand_id, login_date FROM logins),
days AS (SELECT DISTINCT login_date AS day FROM logins)
SELECT days.day,
       COUNT(DISTINCT d.cand_id) AS users_last_3_days
FROM days
JOIN d ON d.login_date BETWEEN date(days.day, '-2 days') AND days.day
GROUP BY days.day
ORDER BY days.day;

-- @L4_overqualified
SELECT ca.name, ca.ctc_lpa, j.job_id, j.max_ctc_lpa
FROM applications a
JOIN candidates ca ON ca.cand_id = a.cand_id
JOIN jobs j        ON j.job_id   = a.job_id
WHERE ca.ctc_lpa > j.max_ctc_lpa
ORDER BY ca.name;

-- @L4_explain_noindex
EXPLAIN QUERY PLAN
SELECT * FROM applications WHERE cand_id = 105;

-- @L4_explain_index
CREATE INDEX idx_app_cand ON applications(cand_id);
EXPLAIN QUERY PLAN
SELECT * FROM applications WHERE cand_id = 105;

-- @L4_explain_nonsarg
CREATE INDEX idx_app_date ON applications(applied_date);
EXPLAIN QUERY PLAN
SELECT * FROM applications WHERE strftime('%Y', applied_date) = '2026';

-- @L4_explain_sarg
CREATE INDEX idx_app_date ON applications(applied_date);
EXPLAIN QUERY PLAN
SELECT * FROM applications WHERE applied_date >= '2026-01-01' AND applied_date < '2027-01-01';

-- @L4_feature_table
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

-- @L4_feature_fanout
SELECT ca.cand_id,
       SUM(CASE WHEN a.status = 'rejected' THEN 1 ELSE 0 END) AS n_rejected_wrong,
       COUNT(l.login_date)                                   AS n_logins_wrong
FROM candidates ca
LEFT JOIN applications a ON a.cand_id = ca.cand_id
LEFT JOIN logins l       ON l.cand_id = ca.cand_id
WHERE ca.cand_id IN (101, 107, 109)
GROUP BY ca.cand_id
ORDER BY ca.cand_id;

-- @Q_join_counts
WITH a(x) AS (VALUES (1), (1), (2), (NULL)),
     b(x) AS (VALUES (1), (1), (3), (NULL))
SELECT 'inner' AS join_type, COUNT(*) AS n_rows FROM a INNER JOIN b ON a.x = b.x
UNION ALL
SELECT 'left',  COUNT(*) FROM a LEFT  JOIN b ON a.x = b.x
UNION ALL
SELECT 'right', COUNT(*) FROM a RIGHT JOIN b ON a.x = b.x
UNION ALL
SELECT 'full',  COUNT(*) FROM a FULL  JOIN b ON a.x = b.x
UNION ALL
SELECT 'cross', COUNT(*) FROM a CROSS JOIN b;

-- @Q_avg_of_avg
SELECT (SELECT AVG(salary) FROM employees) AS overall_avg,
       (SELECT AVG(dept_avg)
        FROM (SELECT AVG(salary) AS dept_avg FROM employees GROUP BY dept)) AS avg_of_dept_avgs;

-- @Q_point_in_time
WITH params AS (SELECT '2026-02-15' AS cutoff),
feat AS (                -- features: only rows strictly before the cutoff
  SELECT a.cand_id,
         COUNT(*) AS apps_before,
         SUM(CASE WHEN a.status = 'rejected' THEN 1 ELSE 0 END) AS rejections_before
  FROM applications a, params p
  WHERE a.applied_date < p.cutoff
  GROUP BY a.cand_id
),
label AS (               -- label: what happened on or after the cutoff
  SELECT a.cand_id,
         MAX(CASE WHEN a.status = 'offer' THEN 1 ELSE 0 END) AS offer_after
  FROM applications a, params p
  WHERE a.applied_date >= p.cutoff
  GROUP BY a.cand_id
)
SELECT c.cand_id,
       COALESCE(f.apps_before, 0)       AS apps_before,
       COALESCE(f.rejections_before, 0) AS rejections_before,
       COALESCE(l.offer_after, 0)       AS label_offer_after
FROM candidates c
LEFT JOIN feat  f ON f.cand_id = c.cand_id
LEFT JOIN label l ON l.cand_id = c.cand_id
WHERE c.signup_date < (SELECT cutoff FROM params)
ORDER BY c.cand_id;

-- @Q_lag_selfjoin
SELECT cur.cand_id, cur.login_date,
       MAX(prev.login_date) AS prev_login
FROM (SELECT DISTINCT cand_id, login_date FROM logins) cur
LEFT JOIN (SELECT DISTINCT cand_id, login_date FROM logins) prev
       ON prev.cand_id = cur.cand_id AND prev.login_date < cur.login_date
WHERE cur.cand_id = 101
GROUP BY cur.cand_id, cur.login_date
ORDER BY cur.login_date;

-- @Q_window_in_where
SELECT name, salary FROM (
  SELECT name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS dr
  FROM employees
) t
WHERE dr <= 3
ORDER BY salary DESC;

-- @Q_city_share
SELECT COALESCE(city, 'Unknown') AS city,
       COUNT(*) AS n_cands,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM candidates), 1) AS pct
FROM candidates
GROUP BY COALESCE(city, 'Unknown')
ORDER BY n_cands DESC, city;

-- @Q_applied_outside_city
SELECT ca.name, ca.city AS home_city, j.city AS job_city, j.title
FROM applications a
JOIN candidates ca ON ca.cand_id = a.cand_id
JOIN jobs j        ON j.job_id   = a.job_id
WHERE ca.city <> j.city
  AND a.app_id <> 22
ORDER BY ca.name, j.job_id;

-- @Q_company_offer_rate
SELECT co.name AS company,
       COUNT(a.app_id) AS applications,
       SUM(CASE WHEN a.status = 'offer' THEN 1 ELSE 0 END) AS offers,
       ROUND(1.0 * SUM(CASE WHEN a.status = 'offer' THEN 1 ELSE 0 END)
             / NULLIF(COUNT(a.app_id), 0), 2) AS offer_rate
FROM companies co
LEFT JOIN jobs j          ON j.company_id = co.company_id
LEFT JOIN applications a  ON a.job_id     = j.job_id AND a.app_id <> 22
GROUP BY co.company_id, co.name
ORDER BY offer_rate DESC, company;
