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
