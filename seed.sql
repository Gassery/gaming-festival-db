-- Sample data. Safe to run after schema.sql on an empty database.

BEGIN;

INSERT INTO exhibitors (exhibitor, booth) VALUES
    ('Bushiroad', 'TT1742'),
    ('Cyberpunk', 'TT1242'),
    ('D&D', 'TT1012'),
    ('FINAL FANTASY XIV Online', '1020'),
    ('Nintendo', '4420'),
    ('SEGA', '1220'),
    ('Warhammer', 'TT1618');

INSERT INTO types (type) VALUES
    ('Exhibitor'),
    ('Expo Hall'),
    ('PAX Rising'),
    ('Tabletop');

INSERT INTO exhibitor_types (exhibitor, type) VALUES
    ('Bushiroad', 'Exhibitor'),
    ('Bushiroad', 'Expo Hall'),
    ('Bushiroad', 'Tabletop'),
    ('Cyberpunk', 'Exhibitor'),
    ('Cyberpunk', 'Tabletop'),
    ('D&D', 'Exhibitor'),
    ('D&D', 'Tabletop'),
    ('FINAL FANTASY XIV Online', 'Exhibitor'),
    ('Nintendo', 'Exhibitor'),
    ('Nintendo', 'Expo Hall'),
    ('SEGA', 'Exhibitor'),
    ('Warhammer', 'Exhibitor'),
    ('Warhammer', 'Tabletop');

INSERT INTO categories (category) VALUES
    ('Action'), ('Adventure'), ('Apparel'), ('Augmented Reality'),
    ('CCG'), ('Co-op'), ('Components'), ('Deck Builder'), ('Dice'),
    ('Early Access/Demo'), ('Family Friendly'), ('Fighting'), ('First Person'),
    ('Free to Play'), ('Horror/Survival'), ('Indie'), ('JRPG'), ('MMO'),
    ('Merch'), ('Mobile'), ('Multiplayer'), ('Nintendo Switch'),
    ('Notebook/Laptop'), ('PAX Together'), ('PC'), ('Peripherals'), ('Platformer'),
    ('Playstation'), ('Proudly Made in Melbourne'), ('Puzzle'), ('RPG'),
    ('Roguelike'), ('Sandbox'), ('Shooter'), ('Single Player'), ('Strategy'),
    ('Third Person'), ('VR'), ('Xbox');

INSERT INTO product_categories (exhibitor, product_category) VALUES
    ('Bushiroad', 'CCG'),
    ('Bushiroad', 'Deck Builder'),
    ('Bushiroad', 'Early Access/Demo'),
    ('Bushiroad', 'Family Friendly'),
    ('Bushiroad', 'Merch'),
    ('Bushiroad', 'Multiplayer'),
    ('Bushiroad', 'Strategy'),
    ('FINAL FANTASY XIV Online', 'Action'),
    ('FINAL FANTASY XIV Online', 'Adventure'),
    ('FINAL FANTASY XIV Online', 'JRPG'),
    ('FINAL FANTASY XIV Online', 'MMO'),
    ('FINAL FANTASY XIV Online', 'Multiplayer'),
    ('FINAL FANTASY XIV Online', 'Nintendo Switch'),
    ('Warhammer', 'Action'),
    ('Warhammer', 'Apparel'),
    ('Warhammer', 'Family Friendly'),
    ('Warhammer', 'Merch'),
    ('Warhammer', 'Strategy');

INSERT INTO activities (title, start_date, end_date, start_time, end_time, location, exhibitor) VALUES
    ('Bang Dream CCG Showcase', '2026-10-09', '2026-10-09', '09:00', '10:00', 'Main Stage', 'Bushiroad'),
    ('Cyberpunk CCG Showcase', '2026-10-09', '2026-10-09', '10:00', '11:00', 'Main Stage', 'Cyberpunk'),
    ('Indie Showcase', '2026-10-10', '2026-10-10', '11:00', '12:00', 'Main Stage', 'SEGA'),
    ('Cosplay Contest', '2026-10-10', '2026-10-10', '13:00', '14:00', 'Main Stage', 'SEGA'),
    ('D&D Tournament', '2026-10-09', '2026-10-11', '09:00', '18:00', 'Tabletop Area', 'D&D'),
    ('Warhammer Painting Session', '2026-10-10', '2026-10-10', '09:00', '17:00', 'Tabletop Area', 'Warhammer');

COMMIT;
