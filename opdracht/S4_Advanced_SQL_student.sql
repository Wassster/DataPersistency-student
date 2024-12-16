-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S4: Advanced SQL
-- ------------------------------------------------------------------------

-- S4.1.
DROP VIEW IF EXISTS s4_1;
CREATE OR REPLACE VIEW s4_1 AS
SELECT mnr AS medewerker_nummer, functie, gbdatum AS geboortedatum
FROM medewerkers
WHERE gbdatum < '1980-01-01'
  AND (functie = 'Trainer' OR functie = 'Verkoper');

-- S4.2.
DROP VIEW IF EXISTS s4_2;
CREATE OR REPLACE VIEW s4_2 AS
SELECT naam AS medewerker_naam
FROM medewerkers
WHERE naam LIKE '% %';

-- S4.3.
DROP VIEW IF EXISTS s4_3;
CREATE OR REPLACE VIEW s4_3 AS
SELECT u.cursus AS code, u.begindatum, COUNT(i.cursist) AS aantal_inschrijvingen
FROM uitvoeringen u
         JOIN inschrijvingen i ON u.cursus = i.cursus AND u.begindatum = i.begindatum
WHERE EXTRACT(YEAR FROM u.begindatum) = 2019
GROUP BY u.cursus, u.begindatum
HAVING COUNT(i.cursist) >= 3;

-- S4.4.
DROP VIEW IF EXISTS s4_4;
CREATE OR REPLACE VIEW s4_4 AS
SELECT i.cursist AS medewerkernummer, i.cursus
FROM inschrijvingen i
GROUP BY i.cursist, i.cursus
HAVING COUNT(*) > 1;

-- S4.5.
DROP VIEW IF EXISTS s4_5;
CREATE OR REPLACE VIEW s4_5 AS
SELECT u.cursus, COUNT(*) AS aantal
FROM uitvoeringen u
GROUP BY u.cursus;

-- S4.6.
DROP VIEW IF EXISTS s4_6;
CREATE OR REPLACE VIEW s4_6 AS
SELECT
    EXTRACT(YEAR FROM AGE(MIN(gbdatum))) - EXTRACT(YEAR FROM AGE(MAX(gbdatum))) AS verschil,
    AVG(EXTRACT(YEAR FROM AGE(gbdatum))) AS gemiddeld
FROM medewerkers;

-- S4.7.
DROP VIEW IF EXISTS s4_7;
CREATE OR REPLACE VIEW s4_7 AS
SELECT
    COUNT(*) AS aantal_medewerkers,
    AVG(comm) AS commissie_medewerkers,
    AVG(CASE WHEN functie = 'Verkoper' THEN comm END) AS commissie_verkopers
FROM medewerkers;

-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
SELECT * FROM test_select('S4.1') AS resultaat
UNION
SELECT * FROM test_select('S4.2') AS resultaat
UNION
SELECT * FROM test_select('S4.3') AS resultaat
UNION
SELECT * FROM test_select('S4.4') AS resultaat
UNION
SELECT * FROM test_select('S4.5') AS resultaat
UNION
SELECT 'S4.6 wordt niet getest: geen test mogelijk.' AS resultaat
UNION
SELECT * FROM test_select('S4.7') AS resultaat
ORDER BY resultaat;


