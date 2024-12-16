-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S5: Subqueries
-- ------------------------------------------------------------------------

-- S5.1.
-- Welke medewerkers hebben zowel de Java als de XML cursus gevolgd?
DROP VIEW IF EXISTS s5_1;
CREATE OR REPLACE VIEW s5_1 AS
SELECT m.mnr AS personeelsnummer
FROM medewerkers m
WHERE EXISTS (
    SELECT 1
    FROM inschrijvingen i
             JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum
    WHERE i.cursist = m.mnr AND u.cursus = 'JAV'
)
  AND EXISTS (
    SELECT 1
    FROM inschrijvingen i
             JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum
    WHERE i.cursist = m.mnr AND u.cursus = 'XML'
);

-- S5.2.
-- Geef de nummers van alle medewerkers die niet aan de afdeling 'OPLEIDINGEN' zijn verbonden.
DROP VIEW IF EXISTS s5_2;
CREATE OR REPLACE VIEW s5_2 AS
SELECT m.mnr
FROM medewerkers m
WHERE m.afd NOT IN (
    SELECT anr
    FROM afdelingen
    WHERE naam = 'OPLEIDINGEN'
);

-- S5.3.
-- Geef de nummers van alle medewerkers die de Java-cursus niet hebben gevolgd.
DROP VIEW IF EXISTS s5_3;
CREATE OR REPLACE VIEW s5_3 AS
SELECT m.mnr
FROM medewerkers m
WHERE NOT EXISTS (
    SELECT 1
    FROM inschrijvingen i
             JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum
    WHERE i.cursist = m.mnr AND u.cursus = 'JAV'
);

-- S5.4a.
-- Welke medewerkers hebben ondergeschikten? Geef hun naam.
DROP VIEW IF EXISTS s5_4a;
CREATE OR REPLACE VIEW s5_4a AS
SELECT m.naam
FROM medewerkers m
WHERE EXISTS (
    SELECT 1
    FROM medewerkers o
    WHERE o.chef = m.mnr
);

-- S5.4b.
-- Welke medewerkers hebben geen ondergeschikten? Geef hun naam.
DROP VIEW IF EXISTS s5_4b;
CREATE OR REPLACE VIEW s5_4b AS
SELECT m.naam
FROM medewerkers m
WHERE NOT EXISTS (
    SELECT 1
    FROM medewerkers o
    WHERE o.chef = m.mnr
);

-- S5.5.
-- Geef cursuscode en begindatum van alle uitvoeringen van programmeercursussen ('BLD') in 2020.
DROP VIEW IF EXISTS s5_5;
CREATE OR REPLACE VIEW s5_5 AS
SELECT u.cursus, u.begindatum
FROM uitvoeringen u
WHERE u.cursus IN (
    SELECT code
    FROM cursussen
    WHERE type = 'BLD'
)
  AND EXTRACT(YEAR FROM u.begindatum) = 2020;

-- S5.6.
-- Geef van alle cursusuitvoeringen: de cursuscode, de begindatum en het aantal inschrijvingen (`aantal_inschrijvingen`).
DROP VIEW IF EXISTS s5_6;
CREATE OR REPLACE VIEW s5_6 AS
SELECT u.cursus, u.begindatum, (
    SELECT COUNT(*)
    FROM inschrijvingen i
    WHERE i.cursus = u.cursus AND i.begindatum = u.begindatum
) AS aantal_inschrijvingen
FROM uitvoeringen u
ORDER BY u.begindatum;

-- S5.7.
-- Geef voorletter(s) en achternaam van alle trainers die ooit tijdens een algemene ('ALG') cursus hun eigen chef als cursist hebben gehad.
DROP VIEW IF EXISTS s5_7;
CREATE OR REPLACE VIEW s5_7 AS
SELECT DISTINCT m.voorl, m.naam
FROM medewerkers m
WHERE EXISTS (
    SELECT 1
    FROM inschrijvingen i
             JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum
             JOIN cursussen c ON u.cursus = c.code
    WHERE u.docent = m.mnr AND c.type = 'ALG' AND i.cursist = m.chef
);

-- S5.8.
-- Geef de naam van de medewerkers die nog nooit een cursus hebben gegeven.
DROP VIEW IF EXISTS s5_8;
CREATE OR REPLACE VIEW s5_8 AS
SELECT m.naam
FROM medewerkers m
WHERE NOT EXISTS (
    SELECT 1
    FROM uitvoeringen u
    WHERE u.docent = m.mnr
);

-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
SELECT * FROM test_select('S5.1') AS resultaat
UNION
SELECT * FROM test_select('S5.2') AS resultaat
UNION
SELECT * FROM test_select('S5.3') AS resultaat
UNION
SELECT * FROM test_select('S5.4a') AS resultaat
UNION
SELECT * FROM test_select('S5.4b') AS resultaat
UNION
SELECT * FROM test_select('S5.5') AS resultaat
UNION
SELECT * FROM test_select('S5.6') AS resultaat
UNION
SELECT * FROM test_select('S5.7') AS resultaat
UNION
SELECT * FROM test_select('S5.8') AS resultaat
ORDER BY resultaat;
