-- Assertions over data and constraints. Run with psql -v ON_ERROR_STOP=1.
DO $$
DECLARE
    n integer;
BEGIN
    SELECT count(*) INTO n FROM exhibitors;
    IF n <> 7 THEN RAISE EXCEPTION 'expected 7 exhibitors, found %', n; END IF;

    SELECT count(*) INTO n FROM categories;
    IF n <> 39 THEN RAISE EXCEPTION 'expected 39 categories, found %', n; END IF;

    SELECT count(*) INTO n FROM activities;
    IF n <> 6 THEN RAISE EXCEPTION 'expected 6 activities, found %', n; END IF;

    IF NOT EXISTS (
        SELECT 1 FROM activity_pairs
        WHERE activity_1 = 'Bang Dream CCG Showcase'
          AND activity_2 = 'Cyberpunk CCG Showcase'
    ) THEN
        RAISE EXCEPTION 'expected the Main Stage activity pair';
    END IF;

    -- Lowercase booth labels must be rejected.
    BEGIN
        INSERT INTO exhibitors (exhibitor, booth) VALUES ('Bad Booth Inc', 'tt-1742');
        RAISE EXCEPTION 'booth format check did not fire';
    EXCEPTION WHEN check_violation THEN
        NULL;
    END;

    -- A category in use must not be deletable.
    BEGIN
        DELETE FROM categories WHERE category = 'Action';
        RAISE EXCEPTION 'category delete should have been restricted';
    EXCEPTION WHEN foreign_key_violation THEN
        NULL;
    END;

    -- Activities outside the festival window must be rejected.
    BEGIN
        INSERT INTO activities (title, start_date, end_date, start_time, end_time, location, exhibitor)
        VALUES ('Out of window', '2026-10-12', '2026-10-12', '09:00', '10:00', 'Main Stage', 'SEGA');
        RAISE EXCEPTION 'festival window check did not fire';
    EXCEPTION WHEN check_violation THEN
        NULL;
    END;

    RAISE NOTICE 'all assertions passed';
END $$;
