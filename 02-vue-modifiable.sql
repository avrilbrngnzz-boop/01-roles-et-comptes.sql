USE mediatheque;

EXPLAIN SELECT * FROM emprunt WHERE date_emprunt = '2024-03-12';
EXPLAIN SELECT * FROM emprunt WHERE date_retour_reelle IS NULL;
EXPLAIN SELECT id, date_emprunt FROM emprunt WHERE adherent_id = 12 AND date_emprunt >= '2025-01-01';

SELECT COUNT(*) FROM emprunt WHERE date_emprunt = '2024-03-12';
SELECT COUNT(*) FROM emprunt WHERE date_retour_reelle IS NULL;
SELECT COUNT(*) FROM emprunt WHERE adherent_id = 12 AND date_emprunt >= '2025-01-01';

SELECT table_name, ROUND(data_length/1024/1024,1) AS donnees_mo,
       ROUND(index_length/1024/1024,1) AS index_mo
FROM information_schema.tables
WHERE table_schema = 'mediatheque' AND table_name = 'emprunt';

CREATE INDEX idx_emprunt_date ON emprunt (date_emprunt);
ANALYZE TABLE emprunt;
EXPLAIN SELECT * FROM emprunt WHERE date_emprunt = '2024-03-12';

CREATE INDEX idx_emprunt_retour ON emprunt (date_retour_reelle);
ANALYZE TABLE emprunt;
EXPLAIN SELECT * FROM emprunt WHERE date_retour_reelle IS NULL;

CREATE INDEX idx_emprunt_adh_date ON emprunt (adherent_id, date_emprunt);
ANALYZE TABLE emprunt;
EXPLAIN SELECT id, date_emprunt FROM emprunt WHERE adherent_id = 12 AND date_emprunt >= '2025-01-01';

EXPLAIN SELECT id FROM emprunt WHERE adherent_id = 12;

EXPLAIN SELECT id FROM emprunt WHERE date_emprunt >= '2025-01-01';

EXPLAIN SELECT adherent_id, date_emprunt FROM emprunt WHERE adherent_id = 12;
EXPLAIN SELECT adherent_id, date_emprunt, exemplaire_id FROM emprunt WHERE adherent_id = 12;

EXPLAIN SELECT COUNT(*) FROM emprunt WHERE YEAR(date_emprunt) = 2024;   -- fonction sur la colonne : index inutilisable pour filtrer
SELECT COUNT(*) FROM emprunt WHERE YEAR(date_emprunt) = 2024;
EXPLAIN SELECT COUNT(*) FROM emprunt
 WHERE date_emprunt >= '2024-01-01' AND date_emprunt < '2025-01-01';    -- intervalle semi-ouvert : range sur l'index
SELECT COUNT(*) FROM emprunt
 WHERE date_emprunt >= '2024-01-01' AND date_emprunt < '2025-01-01';


SELECT table_name, ROUND(data_length/1024/1024,1) AS donnees_mo,
       ROUND(index_length/1024/1024,1) AS index_mo
FROM information_schema.tables
WHERE table_schema = 'mediatheque' AND table_name = 'emprunt';
