SELECT name, city, exp_yrs
FROM candidates
WHERE (city = 'Bengaluru' OR city = 'Mumbai') AND exp_yrs >= 5;
