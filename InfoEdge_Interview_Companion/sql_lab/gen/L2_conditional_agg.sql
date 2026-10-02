SELECT job_id,
       COUNT(*)                                            AS applicants,
       SUM(CASE WHEN status = 'offer'    THEN 1 ELSE 0 END) AS offers,
       SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS rejections,
       ROUND(AVG(CASE WHEN status = 'offer' THEN 1.0 ELSE 0 END), 2) AS offer_rate
FROM applications
GROUP BY job_id
ORDER BY job_id;
