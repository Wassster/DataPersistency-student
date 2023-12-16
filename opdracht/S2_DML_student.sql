-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S2: Data Manipulation Language
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
-- ------------------------------------------------------------------------

-- S2.1 Vier-daagse cursussen
DROP VIEW IF EXISTS s2_1;
CREATE OR REPLACE VIEW s2_1 AS
SELECT code, omschrijving
FROM cursussen
WHERE lengte = 4;


-- S2.2 Medewerkersoverzicht
DROP VIEW IF EXISTS s2_2;
CREATE OR REPLACE VIEW s2_2 AS
SELECT *
FROM medewerkers
ORDER BY functie, gbdatum DESC;


-- S2.3 Door het land
DROP VIEW IF EXISTS s2_3;
CREATE OR REPLACE VIEW s2_3 AS
SELECT cursus AS code, begindatum
FROM uitvoeringen
WHERE locatie IN ('UTRECHT', 'MAASTRICHT');


-- S2.4 Namen
DROP VIEW IF EXISTS s2_4;
CREATE OR REPLACE VIEW s2_4 AS
SELECT naam, voorl
FROM medewerkers
WHERE naam != 'JANSEN' OR voorl != 'R';


-- S2.5 Nieuwe SQL-cursus
INSERT INTO uitvoeringen (cursus, begindatum, locatie, docent)
VALUES ('S02', '2024-03-02', 'LEERDAM', 7369) -- Correcte verwijzing naar een bestaande medewerker
    ON CONFLICT DO NOTHING;


-- S2.6 Stagiairs
INSERT INTO medewerkers (mnr, naam, voorl, functie, chef, gbdatum, maandsal, afd)
VALUES (8001, 'STUDENT', 'A', 'STAGIAIR', 7566, '2001-01-01', 800, 20) -- Chef verwijst naar een bestaande manager
    ON CONFLICT DO NOTHING;


-- S2.7 Nieuwe schaal

INSERT INTO cursussen (code, omschrijving, type, lengte)
VALUES ('D&P', 'Data & Persistency', 'ALG', 6)
    ON CONFLICT DO NOTHING;

-- Voeg de uitvoeringen voor de cursus toe
INSERT INTO uitvoeringen (cursus, begindatum, locatie, docent)
VALUES ('D&P', '2024-05-01', 'LEERDAM', 7369), -- Docent 7369 bestaat
       ('D&P', '2024-06-01', 'LEERDAM', 7521) -- Docent 7521 bestaat
    ON CONFLICT DO NOTHING;

-- Voeg inschrijvingen toe voor de cursus
INSERT INTO inschrijvingen (cursist, cursus, begindatum)
VALUES (7369, 'D&P', '2024-05-01'),
       (7499, 'D&P', '2024-05-01'),
       (7521, 'D&P', '2024-06-01')
    ON CONFLICT DO NOTHING;


-- S2.9 Salarisverhoging voor verkoopmedewerkers
UPDATE medewerkers
SET maandsal = maandsal * 1.055
WHERE afd = (SELECT anr FROM afdelingen WHERE naam = 'VERKOOP')
  AND functie != 'MANAGER';

UPDATE medewerkers
SET maandsal = maandsal * 1.07
WHERE afd = (SELECT anr FROM afdelingen WHERE naam = 'VERKOOP')
  AND functie = 'MANAGER';


-- S2.10 Verwijder Martens en Alders
DELETE FROM medewerkers
WHERE naam = 'MARTENS' AND functie = 'VERKOPER';




-- S2.11 Nieuwe afdeling 'FINANCIEN'

INSERT INTO afdelingen (anr, naam, locatie, hoofd)
VALUES (60, 'FINANCIEN', 'LEERDAM', NULL)
    ON CONFLICT DO NOTHING;


INSERT INTO medewerkers (mnr, naam, voorl, functie, chef, gbdatum, maandsal, afd)
VALUES (8002, 'WASSIM ZENASNI', 'A', 'HOOFD', 7839, '1985-02-15', 4000, 60)
    ON CONFLICT DO NOTHING;


UPDATE afdelingen
SET hoofd = 8002
WHERE anr = 60;




-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
SELECT * FROM test_select('S2.1') AS resultaat
UNION
SELECT 'S2.2 wordt niet getest: geen test mogelijk.' AS resultaat
UNION
SELECT * FROM test_select('S2.3') AS resultaat
UNION
SELECT * FROM test_select('S2.4') AS resultaat
UNION
SELECT * FROM test_exists('S2.5', 1) AS resultaat
UNION
SELECT * FROM test_exists('S2.6', 1) AS resultaat
UNION
SELECT * FROM test_exists('S2.7', 6) AS resultaat
ORDER BY resultaat;


UPDATE medewerkers SET afd = NULL WHERE mnr < 7369 OR mnr > 7934;
UPDATE afdelingen SET hoofd = NULL WHERE anr > 40;
DELETE FROM afdelingen WHERE anr > 40;
DELETE FROM medewerkers WHERE mnr < 7369 OR mnr > 7934;
DELETE FROM inschrijvingen WHERE cursus = 'D&P';
DELETE FROM uitvoeringen WHERE cursus = 'D&P';
DELETE FROM cursussen WHERE code = 'D&P';
DELETE FROM uitvoeringen WHERE locatie = 'LEERDAM';
INSERT INTO medewerkers (mnr, naam, voorl, functie, chef, gbdatum, maandsal, comm, afd)
VALUES (7654, 'MARTENS', 'P', 'VERKOPER', 7698, '28-09-1976', 1250, 1400, 30);
UPDATE medewerkers SET maandsal = 1600 WHERE mnr = 7499;
UPDATE medewerkers SET maandsal = 1250 WHERE mnr = 7521;
UPDATE medewerkers SET maandsal = 2850 WHERE mnr = 7698;
UPDATE medewerkers SET maandsal = 1500 WHERE mnr = 7844;
UPDATE medewerkers SET maandsal = 800 WHERE mnr = 7900;



