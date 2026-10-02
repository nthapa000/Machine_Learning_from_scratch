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
