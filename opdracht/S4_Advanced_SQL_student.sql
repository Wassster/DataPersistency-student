-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S4: Advanced SQL
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
-- Codeer je uitwerking onder de regel 'DROP VIEW ...' (bij een SELECT)
-- of boven de regel 'ON CONFLICT DO NOTHING;' (bij een INSERT)
-- Je kunt deze eigen query selecteren en los uitvoeren, en wijzigen tot
-- je tevreden bent.

-- Vervolgens kun je je uitwerkingen testen door de testregels
-- (met [TEST] erachter) te activeren (haal hiervoor de commentaartekens
-- weg) en vervolgens het hele bestand uit te voeren. Hiervoor moet je de
-- testsuite in de database hebben geladen (bedrijf_postgresql_test.sql).
-- NB: niet alle opdrachten hebben testregels.
--
-- Lever je werk pas in op Canvas als alle tests slagen.
-- ------------------------------------------------------------------------


-- S4.1.
-- Geef nummer, functie en geboortedatum van alle medewerkers die vóór 1980
-- geboren zijn, en trainer of verkoper zijn.
-- DROP VIEW IF EXISTS s4_1; CREATE OR REPLACE VIEW s4_1 AS
-- [TEST]
    DROP VIEW IF EXISTS s4_1;
    CREATE OR REPLACE VIEW s4_1 AS
    SELECT medewerker_nummer, functie , geboortedatum
    FROM medewerkers
    WHERE geboortedatum < '1980-01-01'
    AND (Functie= 'Trainer' OR Functie = 'Verkoper')



-- S4.2. 
-- Geef de naam van de medewerkers met een tussenvoegsel (b.v. 'van der').
-- DROP VIEW IF EXISTS s4_2; CREATE OR REPLACE VIEW s4_2 AS                                                     -- [TEST]

    DROP VIEW IF EXISTS s4_2;
    CREATE OR REPLACE VIEW s4_2 AS
    SELECT medewerker_naam
    FROM medewerker
    WHERE tussenvoegsel IS NOT NULL

-- S4.3. 
-- Geef nu code, begindatum en aantal inschrijvingen (`aantal_inschrijvingen`) van alle
-- cursusuitvoeringen in 2019 met minstens drie inschrijvingen.

    DROP VIEW IF EXISTS s4_3;
    CREATE OR REPLACE VIEW s4_3 AS                                                    -- [TEST]
    SELECT code, begindatum , aantal_inschrijvingen
    FROM cursusuitvoeringen
    WHERE EXTRACT(YEAR FROM begindatum) = 2019
    AND aantal_inschrijvingen >= 3

-- S4.4. 
-- Welke medewerkers hebben een bepaalde cursus meer dan één keer gevolgd?
-- Geef medewerkernummer en cursuscode.

    DROP VIEW IF EXISTS s4_4;

    CREATE OR REPLACE VIEW s4_4 AS
    SELECT m.medewerkernummer, c.cursuscode
    FROM medewerker_cursus mc
    JOIN medewerkers m ON mc.medewerkernummer = m.medewerkernummer
    JOIN cursusuitvoeringen c ON mc.cursuscode = c.cursuscode
    GROUP BY m.medewerkernummer, c.cursuscode
    HAVING COUNT(*) > 1;

-- S4.5. 
-- Hoeveel uitvoeringen (`aantal`) zijn er gepland per cursus?
-- Een voorbeeld van het mogelijke resultaat staat hieronder.
--
--   cursus | aantal   
--  --------+-----------
--   ERM    | 1 
--   JAV    | 4 
--   OAG    | 2

    DROP VIEW IF EXISTS s4_5;    -- [TEST]

    CREATE OR REPLACE VIEW s4_5 AS
    SELECT cursuscode AS cursus, COUNT(*) AS aantal
    FROM cursusuitvoeringen
    GROUP BY cursuscode;



-- S4.6. 
-- Bepaal hoeveel jaar leeftijdsverschil er zit tussen de oudste en de 
-- jongste medewerker (`verschil`) en bepaal de gemiddelde leeftijd van
-- de medewerkers (`gemiddeld`).
-- Je mag hierbij aannemen dat elk jaar 365 dagen heeft.

    DROP VIEW IF EXISTS s4_6;

    CREATE OR REPLACE VIEW s4_6 AS
    SELECT
        (EXTRACT(YEAR FROM AGE(MIN(geboortedatum))) - EXTRACT(YEAR FROM AGE(MAX(geboortedatum)))) AS verschil,
        AVG(EXTRACT(YEAR FROM AGE(geboortedatum))) AS gemiddeld
    FROM medewerkers;
                                                       -- [TEST]


-- S4.7. 
-- Geef van het hele bedrijf een overzicht van het aantal medewerkers dat
-- er werkt (`aantal_medewerkers`), de gemiddelde commissie die ze
-- krijgen (`commissie_medewerkers`), en hoeveel dat gemiddeld
-- per verkoper is (`commissie_verkopers`).


    DROP VIEW IF EXISTS s4_7;                                    -- [TEST]

    CREATE OR REPLACE VIEW s4_7 AS
    SELECT
        COUNT(*) AS aantal_medewerkers,
        AVG(commissie) AS commissie_medewerkers,
        AVG(CASE WHEN functie = 'Verkoper' THEN commissie END) AS commissie_verkopers
    FROM medewerkers;




-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
-- Met onderstaande query kun je je code testen. Zie bovenaan dit bestand
-- voor uitleg.

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


