SELECT name,
       UPPER(name)            AS upper_name,
       LENGTH(name)           AS n_chars,
       SUBSTR(name, 1, 3)     AS first3,
       name || ' (' || COALESCE(city, '?') || ')' AS label
FROM candidates
LIMIT 4;
