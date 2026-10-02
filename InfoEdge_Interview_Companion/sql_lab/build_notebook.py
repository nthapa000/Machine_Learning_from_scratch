"""Build SQL_Lab.ipynb: the MiniNaukri database plus every query from queries.sql, grouped by level,
followed by practice exercises with solutions. Rebuild with:
    python build_notebook.py && jupyter nbconvert --to notebook --execute --inplace SQL_Lab.ipynb
"""
import pathlib, re
import nbformat as nbf

HERE = pathlib.Path(__file__).parent
schema = (HERE / "schema.sql").read_text()
queries = re.findall(r"^-- @(\w+)\n(.*?)(?=^-- @|\Z)", (HERE / "queries.sql").read_text(), re.S | re.M)

TITLES = {
 "L1_select_all": "SELECT * : every column", "L1_columns": "Choosing columns", "L1_where": "WHERE: filtering rows",
 "L1_and_or": "AND/OR precedence bug", "L1_and_or_fixed": "AND/OR fixed with brackets", "L1_in_between": "IN and BETWEEN",
 "L1_like": "LIKE patterns", "L1_null_wrong": "= NULL finds nothing", "L1_null_right": "IS NULL",
 "L1_not_equal_null": "<> silently drops NULL", "L1_order_limit": "ORDER BY + LIMIT", "L1_order_nulls": "Where NULL sorts",
 "L1_offset": "OFFSET (paging)", "L1_distinct": "DISTINCT", "L1_distinct_pair": "DISTINCT on two columns",
 "L1_computed": "Computed columns and aliases", "L1_case": "CASE WHEN binning", "L1_coalesce": "COALESCE (fillna)",
 "L1_strings": "String functions", "L1_dates": "Date functions", "L1_intdiv": "Integer division trap",
 "L2_agg_basic": "Aggregates and NULL", "L2_count_distinct": "COUNT DISTINCT", "L2_groupby": "GROUP BY",
 "L2_groupby_two": "GROUP BY two columns", "L2_having": "HAVING", "L2_where_vs_having": "WHERE and HAVING together",
 "L2_conditional_agg": "Conditional aggregation (rates)", "L2_status_counts": "Status counts", "L2_inner_join": "INNER JOIN",
 "L2_three_join": "Chaining joins", "L2_left_join": "LEFT JOIN with zero counts", "L2_left_count_star": "COUNT(*) trap after LEFT JOIN",
 "L2_anti_join": "Anti-join", "L2_left_where_trap": "LEFT JOIN + WHERE trap", "L2_left_on_filter": "Filter inside ON",
 "L2_full_join": "FULL OUTER JOIN", "L2_self_join": "SELF JOIN (manager)", "L2_referral_self": "SELF JOIN (referrals)",
 "L2_cross_join": "CROSS JOIN grid", "L2_fanout": "Fan-out after join", "L2_fanout_truth": "The true sum",
 "L2_join_eligibility": "Non-equi join", "L2_union": "UNION", "L2_union_all": "UNION ALL", "L2_except": "EXCEPT",
 "L3_scalar_sub": "Scalar subquery", "L3_in_sub": "IN subquery", "L3_not_in_null": "NOT IN with NULL returns nothing",
 "L3_not_exists": "NOT EXISTS", "L3_correlated": "Correlated subquery", "L3_derived_table": "Derived table",
 "L3_cte": "CTEs", "L3_recursive_hier": "Recursive CTE: org chart", "L3_recursive_dates": "Recursive CTE: date spine and DAU",
 "L3_rownum_rank": "ROW_NUMBER vs RANK vs DENSE_RANK", "L3_partition": "PARTITION BY", "L3_groupby_vs_window": "GROUP BY collapses rows",
 "L3_lag_lead": "LAG and LEAD", "L3_running": "Running total and moving average", "L3_pct_total": "Percent of total",
 "L3_ntile_first": "NTILE, FIRST_VALUE, PERCENT_RANK", "L3_frame_trap": "LAST_VALUE frame trap", "L3_dml": "INSERT, UPDATE, DELETE",
 "L3_ddl": "CREATE TABLE with constraints",
 "L4_nth_dense": "Nth highest: DENSE_RANK", "L4_nth_limit": "Nth highest: LIMIT OFFSET", "L4_nth_correlated": "Nth highest: correlated",
 "L4_second_max": "Second highest with MAX", "L4_topn_group": "Top N per group", "L4_dupes_find": "Find duplicates",
 "L4_dupes_delete": "Delete duplicates", "L4_dupes_rownum": "Label duplicates with ROW_NUMBER", "L4_more_than_manager": "Earns more than manager",
 "L4_streaks": "Consecutive-day streaks", "L4_streak_steps": "Gaps-and-islands, step by step", "L4_funnel": "Hiring funnel",
 "L4_ab_ctr": "A/B test CTR", "L4_ctr_daily": "CTR by day and variant", "L4_cohort": "Cohort retention", "L4_mom": "Month-over-month growth",
 "L4_median": "Median", "L4_pivot": "Pivot", "L4_first_app": "First event per entity", "L4_time_to_apply": "Time between events",
 "L4_division": "Applied to all (relational division)", "L4_rolling_users": "Rolling 3-day active users",
 "L4_overqualified": "Non-equi data check", "L4_explain_noindex": "Query plan without index", "L4_explain_index": "Query plan with index",
 "L4_explain_nonsarg": "Non-sargable filter", "L4_explain_sarg": "Sargable range", "L4_feature_table": "ML feature table (correct)",
 "L4_feature_fanout": "ML feature table (fan-out bug)",
 "Q_join_counts": "Join row counts puzzle", "Q_avg_of_avg": "Average of averages", "Q_point_in_time": "Point-in-time features and label",
 "Q_lag_selfjoin": "LAG without window functions", "Q_window_in_where": "Filtering on a window function",
 "Q_city_share": "Share by city", "Q_applied_outside_city": "Applied outside home city", "Q_company_offer_rate": "Offer rate per company",
}
LEVELS = {"L1": "Level 1 (Chapter 45): one table: SELECT, WHERE, NULL, ORDER BY, CASE, strings, dates",
          "L2": "Level 2 (Chapter 46): aggregation, GROUP BY, HAVING, joins, set operations",
          "L3": "Level 3 (Chapter 47): subqueries, CTEs, window functions, changing data",
          "L4": "Level 4 (Chapter 48): interview patterns, ML feature tables, query plans",
          "Q":  "Queries used in the interview answers"}

EXERCISES = [
 ("Which companies are in Bengaluru? Show name and industry.",
  "SELECT name, industry FROM companies WHERE city = 'Bengaluru';"),
 ("List candidates with 3 to 6 years of experience, highest CTC first. Put candidates with unknown CTC last.",
  "SELECT name, exp_yrs, ctc_lpa FROM candidates\nWHERE exp_yrs BETWEEN 3 AND 6\nORDER BY ctc_lpa IS NULL, ctc_lpa DESC;"),
 ("How many candidates did not fill in their city? (Answer: 1)",
  "SELECT COUNT(*) - COUNT(city) AS missing_city FROM candidates;"),
 ("For each job title, how many applications were received? Include titles with zero.",
  "SELECT j.title, COUNT(a.app_id) AS n_apps\nFROM jobs j LEFT JOIN applications a ON a.job_id = j.job_id\nGROUP BY j.title ORDER BY n_apps DESC;"),
 ("Which candidates have applied to at least two different companies?",
  "SELECT a.cand_id, COUNT(DISTINCT j.company_id) AS n_companies\nFROM applications a JOIN jobs j ON j.job_id = a.job_id\nGROUP BY a.cand_id HAVING COUNT(DISTINCT j.company_id) >= 2;"),
 ("Rejection rate per candidate (rejections / applications), excluding the duplicate row 22.",
  "SELECT cand_id, COUNT(*) AS apps,\n       ROUND(AVG(CASE WHEN status = 'rejected' THEN 1.0 ELSE 0 END), 2) AS rejection_rate\nFROM applications WHERE app_id <> 22\nGROUP BY cand_id ORDER BY rejection_rate DESC, cand_id;"),
 ("Which jobs received no applications? Write it with NOT EXISTS.",
  "SELECT job_id, title FROM jobs j\nWHERE NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = j.job_id);"),
 ("For each candidate who was referred, show the referrer's name and whether the referrer has an offer.",
  "SELECT c.name AS candidate, r.name AS referrer,\n       CASE WHEN EXISTS (SELECT 1 FROM applications a WHERE a.cand_id = r.cand_id AND a.status = 'offer')\n            THEN 'yes' ELSE 'no' END AS referrer_has_offer\nFROM candidates c JOIN candidates r ON r.cand_id = c.referred_by;"),
 ("Highest-paid employee in each department (all of them if tied).",
  "SELECT dept, name, salary FROM (\n  SELECT *, RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS r FROM employees WHERE salary IS NOT NULL\n) t WHERE r = 1 ORDER BY dept;"),
 ("Each candidate's most recent application (one row per candidate).",
  "SELECT cand_id, job_id, applied_date, status FROM (\n  SELECT a.*, ROW_NUMBER() OVER (PARTITION BY cand_id ORDER BY applied_date DESC, app_id DESC) AS rn\n  FROM applications a\n) t WHERE rn = 1 ORDER BY cand_id;"),
 ("Number of days between each candidate's signup and their first application.",
  "SELECT c.cand_id, c.signup_date, MIN(a.applied_date) AS first_app,\n       CAST(julianday(MIN(a.applied_date)) - julianday(c.signup_date) AS INTEGER) AS days_to_first_app\nFROM candidates c JOIN applications a ON a.cand_id = c.cand_id\nGROUP BY c.cand_id, c.signup_date ORDER BY days_to_first_app;"),
 ("Each employee's salary as a percentage of their department's total.",
  "SELECT name, dept, salary,\n       ROUND(100.0 * salary / SUM(salary) OVER (PARTITION BY dept), 1) AS pct_of_dept\nFROM employees WHERE salary IS NOT NULL ORDER BY dept, pct_of_dept DESC;"),
 ("Longest login streak of every candidate who logged in at all.",
  "WITH d AS (SELECT DISTINCT cand_id, login_date FROM logins),\ng AS (SELECT cand_id, julianday(login_date) - ROW_NUMBER() OVER (PARTITION BY cand_id ORDER BY login_date) AS grp FROM d),\ns AS (SELECT cand_id, grp, COUNT(*) AS len FROM g GROUP BY cand_id, grp)\nSELECT cand_id, MAX(len) AS longest_streak FROM s GROUP BY cand_id ORDER BY longest_streak DESC, cand_id;"),
 ("Applications per company per month as a pivot (months as columns).",
  "SELECT co.name,\n  SUM(CASE WHEN strftime('%m', a.applied_date) = '01' THEN 1 ELSE 0 END) AS jan,\n  SUM(CASE WHEN strftime('%m', a.applied_date) = '02' THEN 1 ELSE 0 END) AS feb,\n  SUM(CASE WHEN strftime('%m', a.applied_date) = '03' THEN 1 ELSE 0 END) AS mar\nFROM companies co\nLEFT JOIN jobs j ON j.company_id = co.company_id\nLEFT JOIN applications a ON a.job_id = j.job_id AND a.app_id <> 22\nGROUP BY co.company_id, co.name;"),
 ("Click-through rate per candidate in the A/B test, and the variant each candidate was in. Was assignment per candidate or per impression?",
  "SELECT cand_id, COUNT(DISTINCT variant) AS n_variants, MIN(variant) AS variant,\n       ROUND(AVG(clicked * 1.0), 2) AS ctr\nFROM impressions GROUP BY cand_id ORDER BY cand_id;  -- n_variants = 1 for all: per candidate"),
]

nb = nbf.v4.new_notebook()
cells = [nbf.v4.new_markdown_cell(
"""# SQL Lab: MiniNaukri (companion to Part IX, Chapters 45-48)

Every query printed in the book's SQL chapters, runnable in Google Colab with **no installation**: SQLite ships with Python.

* Run all cells once (Runtime -> Run all). Each query runs on a **fresh copy** of the database, so the INSERT/UPDATE/DELETE examples
  never affect later queries.
* Before running a query, predict its output (number of rows, the first row). Then run it and compare with the book.
* The exercises at the end have solutions in the last section: try them first.

The database: `companies`, `candidates`, `jobs`, `applications`, `logins`, `impressions`, `employees` (see Chapter 45 for the diagram)."""),
 nbf.v4.new_code_cell("import sqlite3, re\nimport pandas as pd\npd.set_option('display.width', 160)\n\nSCHEMA = r'''" + schema + "'''"),
 nbf.v4.new_code_cell(
'''def fresh_db():
    """A new in-memory database with the MiniNaukri tables."""
    con = sqlite3.connect(":memory:")
    con.executescript(SCHEMA)
    return con

def run(sql, con=None):
    """Run one or more SQL statements; return the result of the last one as a DataFrame."""
    con = con or fresh_db()
    stmts = [s.strip() for s in re.split(r";\\s*\\n", sql.strip().rstrip(";") + ";\\n") if s.strip()]
    for s in stmts[:-1]:
        con.execute(s)
    cur = con.execute(stmts[-1])
    if cur.description is None:
        return "statement executed"
    return pd.DataFrame(cur.fetchall(), columns=[d[0] for d in cur.description])

db = fresh_db()   # a database you can play with freely: run("SELECT ...", db)
for t in ["companies", "candidates", "jobs", "applications", "logins", "impressions", "employees"]:
    print(t, run(f"SELECT COUNT(*) AS n FROM {t}", db).n[0])'''),
 nbf.v4.new_markdown_cell("## Look at the main tables first"),
 nbf.v4.new_code_cell('run("SELECT * FROM candidates")'),
 nbf.v4.new_code_cell('run("SELECT * FROM jobs")'),
 nbf.v4.new_code_cell('run("SELECT * FROM applications")'),
]
current = None
for qid, sql in queries:
    lev = qid.split("_")[0]
    if lev != current:
        current = lev
        cells.append(nbf.v4.new_markdown_cell(f"# {LEVELS[lev]}"))
    cells.append(nbf.v4.new_markdown_cell(f"### `{qid}`: {TITLES.get(qid, qid)}"))
    sql = sql.strip()
    cells.append(nbf.v4.new_code_cell(f'run("""\n{sql}\n""")'))

cells.append(nbf.v4.new_markdown_cell("# Practice exercises\nWrite your query in each cell (replace the `...`), run it, then compare with the solutions section."))
for i, (q, _) in enumerate(EXERCISES, 1):
    cells.append(nbf.v4.new_markdown_cell(f"**Exercise {i}.** {q}"))
    cells.append(nbf.v4.new_code_cell(f'# run("""\n# ... your query ...\n# """)'))
cells.append(nbf.v4.new_markdown_cell("# Solutions"))
for i, (q, s) in enumerate(EXERCISES, 1):
    cells.append(nbf.v4.new_markdown_cell(f"**Solution {i}.** {q}"))
    cells.append(nbf.v4.new_code_cell(f'run("""\n{s}\n""")'))

nb["cells"] = cells
nb["metadata"]["kernelspec"] = {"name": "python3", "display_name": "Python 3", "language": "python"}
nbf.write(nb, HERE / "SQL_Lab.ipynb")
print(len(cells), "cells")
