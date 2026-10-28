-- Exhibitors holding more than one role, with the role count.
SELECT exhibitor, count(*) AS type_count
FROM exhibitor_types
GROUP BY exhibitor
HAVING count(*) > 1
ORDER BY type_count DESC, exhibitor;
