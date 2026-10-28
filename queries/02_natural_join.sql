-- Each exhibitor, its booth, and every role it holds.
SELECT exhibitor, booth, type
FROM exhibitors
NATURAL JOIN exhibitor_types
ORDER BY exhibitor, type;
