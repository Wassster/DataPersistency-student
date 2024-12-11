-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S6: Views
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
-- ------------------------------------------------------------------------


-- S6.1.
--
-- 1. Maak een view met de naam "deelnemers" waarmee je de volgende gegevens uit de tabellen inschrijvingen en uitvoering combineert:
--    inschrijvingen.cursist, inschrijvingen.cursus, inschrijvingen.begindatum, uitvoeringen.docent, uitvoeringen.locatie
-- 2. Gebruik de view in een query waarbij je de "deelnemers" view combineert met de "personeels" view (behandeld in de les):
--     CREATE OR REPLACE VIEW personeel AS
-- 	     SELECT mnr, voorl, naam as medewerker, afd, functie
--       FROM medewerkers;
-- 3. Is de view "deelnemers" updatable ? Waarom ?

DROP VIEW IF EXISTS deelnemers;
CREATE OR REPLACE VIEW deelnemers AS
SELECT i.cursist, i.cursus, i.begindatum, u.docent, u.locatie
FROM inschrijvingen i
JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum;

-- Query om de "deelnemers" view te combineren met "personeels" view
SELECT d.cursist, d.cursus, p.voorl, p.medewerker, d.locatie
FROM deelnemers d
JOIN personeel p ON d.cursist = p.mnr;

-- Antwoord op vraag 3: De view "deelnemers" is niet updatable omdat deze een join bevat, en wijzigingen in een view met meerdere tabellen kunnen niet eenduidig naar een specifieke bron worden doorgevoerd.


-- S6.2.
--
-- 1. Maak een view met de naam "dagcursussen". Deze view dient de gegevens op te halen: 
--      code, omschrijving en type uit de tabel curssussen met als voorwaarde dat de lengte = 1. Toon aan dat de view werkt. 
-- 2. Maak een tweede view met de naam "daguitvoeringen". 
--    Deze view dient de uitvoeringsgegevens op te halen voor de "dagcurssussen" (gebruik ook de view "dagcursussen"). Toon aan dat de view werkt
-- 3. Verwijder de views en laat zien wat de verschillen zijn bij DROP view <viewnaam> CASCADE en bij DROP view <viewnaam> RESTRICT

DROP VIEW IF EXISTS dagcursussen;
CREATE OR REPLACE VIEW dagcursussen AS
SELECT c.code, c.omschrijving, c.type
FROM cursussen c
WHERE LENGTH(c.type) = 1;

DROP VIEW IF EXISTS daguitvoeringen;
CREATE OR REPLACE VIEW daguitvoeringen AS
SELECT u.cursus, u.begindatum, u.docent, u.locatie
FROM uitvoeringen u
JOIN dagcursussen d ON u.cursus = d.code;

-- Demonstratie van verschillen tussen DROP CASCADE en RESTRICT
-- DROP VIEW dagcursussen CASCADE; -- Hiermee worden "dagcursussen" én afhankelijke views zoals "daguitvoeringen" verwijderd
-- DROP VIEW dagcursussen RESTRICT; -- Dit faalt als er afhankelijke views zijn, zoals "daguitvoeringen"
