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

-- S3.1 Overzicht van alle cursusuitvoeringen
DROP VIEW IF EXISTS s3_1;
CREATE OR REPLACE VIEW s3_1 AS
SELECT
    u.cursus AS code,
    u.begindatum AS begindatum,
    c.lengte AS lengte,
    m.naam AS docent
FROM
    uitvoeringen u
        JOIN
    cursussen c ON u.cursus = c.code
        JOIN
    medewerkers m ON u.docent = m.mnr;

-- S3.2 Achternaam cursist en docent
DROP VIEW IF EXISTS s3_2;
CREATE OR REPLACE VIEW s3_2 AS
SELECT
    cu.naam AS cursist,
    m.naam AS docent
FROM
    inschrijvingen i
        JOIN
    uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum
        JOIN
    medewerkers cu ON i.cursist = cu.mnr
        JOIN
    medewerkers m ON u.docent = m.mnr
WHERE
    u.cursus = 'S02';

-- S3.3 Afdeling en hoofd
DROP VIEW IF EXISTS s3_3;
CREATE OR REPLACE VIEW s3_3 AS
SELECT
    a.naam AS afdeling,
    m.naam AS hoofd
FROM
    afdelingen a
        JOIN
    medewerkers m ON a.hoofd = m.mnr;

-- S3.4 Medewerker, afdeling, locatie
DROP VIEW IF EXISTS s3_4;
CREATE OR REPLACE VIEW s3_4 AS
SELECT
    m.naam AS medewerker,
    a.naam AS afdeling,
    a.locatie AS locatie
FROM
    medewerkers m
        JOIN
    afdelingen a ON m.afd = a.anr;

-- S3.5 Cursisten voor S02
DROP VIEW IF EXISTS s3_5;
CREATE OR REPLACE VIEW s3_5 AS
SELECT
    m.naam AS cursist
FROM
    inschrijvingen i
        JOIN
    uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum
        JOIN
    medewerkers m ON i.cursist = m.mnr
WHERE
    u.cursus = 'S02' AND
    u.begindatum = '2019-04-12';

-- S3.6 Medewerkers en toelage
DROP VIEW IF EXISTS s3_6;
CREATE OR REPLACE VIEW s3_6 AS
SELECT
    m.naam AS medewerker,
    s.toelage
FROM
    medewerkers m
        JOIN
    schalen s ON m.maandsal BETWEEN s.ondergrens AND s.bovengrens;


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