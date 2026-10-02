SELECT name, city, exp_yrs
FROM candidates
WHERE city IN ('Delhi', 'Pune', 'Noida')
  AND exp_yrs BETWEEN 3 AND 10;
