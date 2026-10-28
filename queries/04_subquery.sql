-- Exhibitors with at least one activity in the Tabletop Area.
SELECT exhibitor, booth
FROM exhibitors
WHERE exhibitor IN (
    SELECT exhibitor
    FROM activities
    WHERE location = 'Tabletop Area'
)
ORDER BY exhibitor;
