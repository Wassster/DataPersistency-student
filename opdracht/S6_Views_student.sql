-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S6: Views
-- ------------------------------------------------------------------------

-- Maak de "personeel" view
DROP VIEW IF EXISTS personeel;
CREATE OR REPLACE VIEW personeel AS
SELECT mnr, voorl, naam AS medewerker, afd, functie
FROM medewerkers;

-- S6.1.
-- 1. Maak de "deelnemers" view
DROP VIEW IF EXISTS deelnemers;
CREATE OR REPLACE VIEW deelnemers AS
SELECT i.cursist, i.cursus, i.begindatum, u.docent, u.locatie
FROM inschrijvingen i
         JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum;

-- 2. Query om de "deelnemers" view te combineren met "personeel" view
SELECT d.cursist, d.cursus, p.voorl, p.medewerker, d.locatie
FROM deelnemers d
         JOIN personeel p ON d.cursist = p.mnr;

-- 3. De view deelnemers is niet aanpasbaar omdat deze informatie uit twee tabellen combineert. Als je iets zou willen veranderen in de view weet de database niet in welke tabel die verandering moet worden opgeslagen daardoor kun je de gegevens in deze view alleen bekijken maar niet aanpassen.

-- S6.2.
-- 1. Maak de "dagcursussen" view
DROP VIEW IF EXISTS dagcursussen;
CREATE OR REPLACE VIEW dagcursussen AS
SELECT c.code, c.omschrijving, c.type
FROM cursussen c
WHERE c.lengte = 1;

-- 2. Maak de "daguitvoeringen" view
DROP VIEW IF EXISTS daguitvoeringen;
CREATE OR REPLACE VIEW daguitvoeringen AS
SELECT u.cursus, u.begindatum, u.docent, u.locatie
FROM uitvoeringen u
         JOIN dagcursussen d ON u.cursus = d.code;

-- 3.
--DROP VIEW dagcursussen CASCADE; Verwijdert dagcursussen en afhankelijke views zoals daguitvoeringen
-- DROP VIEW dagcursussen RESTRICT; Faalt als er afhankelijke views zijn zoals daguitvoeringen

-- Test de viewss
SELECT * FROM dagcursussen;
SELECT * FROM daguitvoeringen;
SELECT * FROM deelnemers;
