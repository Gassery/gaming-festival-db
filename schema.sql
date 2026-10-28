-- Gaming festival database — schema
-- PostgreSQL 16. Apply before seed.sql.

BEGIN;

DROP VIEW IF EXISTS activity_pairs;
DROP TABLE IF EXISTS activities, product_categories, exhibitor_types, categories, types, exhibitors CASCADE;

-- Booth labels are printed on the venue floor plan: uppercase letters and digits only.
CREATE TABLE exhibitors (
    exhibitor text PRIMARY KEY,
    booth     text NOT NULL,

    CONSTRAINT exhibitors_booth_format CHECK (booth ~ '^[A-Z0-9]+$'),
    CONSTRAINT exhibitors_booth_unique UNIQUE (booth)
);

CREATE TABLE types (
    type text PRIMARY KEY
);

-- An exhibitor can hold several roles (exhibitor, tabletop, PAX Rising, ...).
CREATE TABLE exhibitor_types (
    exhibitor text NOT NULL,
    type      text NOT NULL,

    PRIMARY KEY (exhibitor, type),

    CONSTRAINT exhibitor_types_exhibitor_fk
        FOREIGN KEY (exhibitor) REFERENCES exhibitors (exhibitor)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT exhibitor_types_type_fk
        FOREIGN KEY (type) REFERENCES types (type)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE categories (
    category text PRIMARY KEY
);

-- Product categories are a shared vocabulary, so many exhibitors map to many categories.
CREATE TABLE product_categories (
    exhibitor        text NOT NULL,
    product_category text NOT NULL,

    PRIMARY KEY (exhibitor, product_category),

    CONSTRAINT product_categories_exhibitor_fk
        FOREIGN KEY (exhibitor) REFERENCES exhibitors (exhibitor)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT product_categories_category_fk
        FOREIGN KEY (product_category) REFERENCES categories (category)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- No natural key: two exhibitors may run identically titled sessions at the same time.
CREATE TABLE activities (
    activity_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title       text NOT NULL,
    start_date  date NOT NULL,
    end_date    date NOT NULL,
    start_time  time NOT NULL,
    end_time    time NOT NULL,
    location    text NOT NULL,
    exhibitor   text NOT NULL,

    CONSTRAINT activities_exhibitor_fk
        FOREIGN KEY (exhibitor) REFERENCES exhibitors (exhibitor)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT activities_inside_festival CHECK (
        start_date BETWEEN DATE '2026-10-09' AND DATE '2026-10-11'
        AND end_date BETWEEN DATE '2026-10-09' AND DATE '2026-10-11'
    ),

    CONSTRAINT activities_end_after_start CHECK (
        end_date > start_date
        OR (end_date = start_date AND end_time > start_time)
    )
);

CREATE INDEX activities_location_idx ON activities (location);

-- Unordered pairs of activities sharing a room.
CREATE VIEW activity_pairs AS
SELECT a1.title AS activity_1,
       a2.title AS activity_2,
       a1.location
FROM activities a1
JOIN activities a2
  ON a1.location = a2.location
 AND a1.activity_id < a2.activity_id
ORDER BY a1.location, a1.title, a2.title;

COMMIT;
