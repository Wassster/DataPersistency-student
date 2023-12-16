-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S1: Data Definition Language
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
--
-- Opdracht: schrijf SQL-queries om onderstaande resultaten op te vragen,
-- aan te maken, verwijderen of aan te passen in de database van de
-- bedrijfscasus.
-- ------------------------------------------------------------------------

-- S1.1 Geslacht
ALTER TABLE medewerkers
    ADD COLUMN geslacht CHAR(1);

ALTER TABLE medewerkers
    ADD CONSTRAINT m_geslacht_chk
        CHECK (geslacht IN ('M', 'V'));



-- S1.2 Nieuwe afdeling 'ONDERZOEK' en medewerker A DONK toevoegen

INSERT INTO afdelingen (anr, naam, locatie)
VALUES (50, 'ONDERZOEK', 'ZWOLLE');

-- Voeg medewerker A DONK toe
INSERT INTO medewerkers (mnr, naam, voorl, functie, chef, afd, gbdatum, maandsal)
VALUES (8000, 'DONK', 'A', 'ONDERZ.', NULL, 50, '1970-01-01', 3000);


-- S1.3 Verbeteringen aan de afdelingen-tabel
-- a) Maak een sequence voor afdelingsnummers
CREATE SEQUENCE afdelingen_seq
    START WITH 60
    INCREMENT BY 10;

-- b) Voeg nieuwe afdelingen toe
INSERT INTO afdelingen (anr, naam, locatie)
VALUES (nextval('afdelingen_seq'), 'HR', 'UTRECHT');

INSERT INTO afdelingen (anr, naam, locatie)
VALUES (nextval('afdelingen_seq'), 'FINANCE', 'AMSTERDAM');

-- c) Kolom aanpassen als nummers te klein zijn
ALTER TABLE afdelingen
    ALTER COLUMN anr TYPE NUMERIC(3);

-- S1.4 Tabel adressen maken

CREATE TABLE adressen (
                          postcode CHAR(6),
                          huisnummer INTEGER,
                          ingangsdatum DATE,
                          einddatum DATE CHECK (einddatum > ingangsdatum),
                          telefoon CHAR(10) UNIQUE,
                          med_mnr NUMERIC(4) REFERENCES medewerkers(mnr),
                          PRIMARY KEY (postcode, huisnummer, ingangsdatum)
);


INSERT INTO adressen (postcode, huisnummer, ingangsdatum, einddatum, telefoon, med_mnr)
VALUES ('1234AB', 1, '2020-01-01', NULL, '0612345678', 8000)
ON CONFLICT (postcode, huisnummer, ingangsdatum) DO NOTHING;



-- S1.5 Commissie beperkingsregel
ALTER TABLE medewerkers
    ADD CONSTRAINT comm_verkoper_chk
        CHECK ((functie = 'VERKOPER' AND comm IS NOT NULL) OR (functie != 'VERKOPER' AND comm IS NULL));


-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
SELECT * FROM test_exists('S1.1', 1) AS resultaat
UNION
SELECT * FROM test_exists('S1.2', 1) AS resultaat
UNION
SELECT 'S1.3 wordt niet getest: geen test mogelijk.' AS resultaat
UNION
SELECT * FROM test_exists('S1.4', 6) AS resultaat
UNION
SELECT 'S1.5 wordt niet getest: handmatige test beschikbaar.' AS resultaat
ORDER BY resultaat;

-- Draai alle wijzigingen terug om conflicten in komende opdrachten te voorkomen.
DROP TABLE IF EXISTS adressen;
UPDATE medewerkers SET afd = NULL WHERE mnr < 7369 OR mnr > 7934;
UPDATE afdelingen SET hoofd = NULL WHERE anr > 40;
DELETE FROM afdelingen WHERE anr > 40;
DELETE FROM medewerkers WHERE mnr < 7369 OR mnr > 7934;
ALTER TABLE medewerkers DROP CONSTRAINT IF EXISTS m_geslacht_chk;
ALTER TABLE medewerkers DROP COLUMN IF EXISTS geslacht;
