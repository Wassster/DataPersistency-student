-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S3: Multiple Tables
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
--
--
-- Opdracht: schrijf SQL-queries om onderstaande resultaten op te vragen,
-- aan te maken, verwijderen of aan te passen in de database van de
-- bedrijfscasus.
--
-- Lever je werk pas in op Canvas als alle tests slagen.
-- ------------------------------------------------------------------------

-- S3.1.
-- Produceer een overzicht van alle cursusuitvoeringen; geef de
-- code, de begindatum, de lengte en de naam van de docent.
DROP VIEW IF EXISTS s3_1;
CREATE OR REPLACE VIEW s3_1 AS
SELECT
    c.cursus_code AS code,
    c.begindatum AS begindatum,
    c.lengte AS lengte,
    d.naam AS docent
FROM
    cursusuitvoering c
        JOIN
    docent d ON c.docent_id = d.id;  -- Pas de JOIN-voorwaarde aan op basis van je tabelstructuur

-- S3.2.
-- Geef in twee kolommen naast elkaar de achternaam van elke cursist (`cursist`)
-- van alle S02-cursussen, met de achternaam van zijn cursusdocent (`docent`).
DROP VIEW IF EXISTS s3_2;
CREATE OR REPLACE VIEW s3_2 AS
SELECT
    cu.achternaam AS cursist,
    d.achternaam AS docent
FROM
    cursus c
        JOIN
    cursist cu ON c.cursus_id = cu.cursus_id
        JOIN
    docent d ON c.docent_id = d.id
WHERE
    c.cursus_code = 'S02';

-- S3.3.
-- Geef elke afdeling (`afdeling`) met de naam van het hoofd van die
-- afdeling (`hoofd`).
DROP VIEW IF EXISTS s3_3;
CREATE OR REPLACE VIEW s3_3 AS
SELECT
    a.naam AS afdeling,
    m.naam AS hoofd
FROM
    afdeling a
        JOIN
    medewerker m ON a.hoofd_id = m.id;

-- S3.4.
-- Geef de namen van alle medewerkers, de naam van hun afdeling (`afdeling`)
-- en de bijbehorende locatie.
DROP VIEW IF EXISTS s3_4;
CREATE OR REPLACE VIEW s3_4 AS
SELECT
    m.naam AS medewerker,
    a.naam AS afdeling,
    a.locatie AS locatie
FROM
    medewerker m
        JOIN
    afdeling a ON m.afdeling_id = a.id;

-- S3.5.
-- Geef de namen van alle cursisten die staan ingeschreven voor de cursus S02 van 12 april 2019
DROP VIEW IF EXISTS s3_5;
CREATE OR REPLACE VIEW s3_5 AS
SELECT
    cu.naam AS cursist
FROM
    inschrijving i
        JOIN
    cursus c ON i.cursus_id = c.cursus_id
        JOIN
    cursist cu ON i.cursist_id = cu.id
WHERE
    c.cursus_code = 'S02' AND
    c.begindatum = '2019-04-12';

-- S3.6.
-- Geef de namen van alle medewerkers en hun toelage.
DROP VIEW IF EXISTS s3_6;
CREATE OR REPLACE VIEW s3_6 AS
SELECT
    m.naam AS medewerker,
    m.toelage
FROM
    medewerker m;

-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
-- Met onderstaande query kun je je code testen. Zie bovenaan dit bestand
-- voor uitleg.

SELECT * FROM test_select('S3.1') AS resultaat
UNION
SELECT * FROM test_select('S3.2') AS resultaat
UNION
SELECT * FROM test_select('S3.3') AS resultaat
UNION
SELECT * FROM test_select('S3.4') AS resultaat
UNION
SELECT * FROM test_select('S3.5') AS resultaat
UNION
SELECT * FROM test_select('S3.6') AS resultaat
ORDER BY resultaat;

