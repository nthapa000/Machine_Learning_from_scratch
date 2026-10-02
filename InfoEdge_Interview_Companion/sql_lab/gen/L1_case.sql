SELECT name, exp_yrs,
       CASE
         WHEN exp_yrs = 0  THEN 'Fresher'
         WHEN exp_yrs <= 3 THEN 'Junior'
         WHEN exp_yrs <= 6 THEN 'Mid'
         ELSE 'Senior'
       END AS band
FROM candidates
ORDER BY exp_yrs;
