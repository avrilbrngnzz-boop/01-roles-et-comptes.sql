USE mediatheque;

CREATE OR REPLACE VIEW v_catalogue AS
SELECT
    o.titre,
    o.auteur,
    o.annee_publication,
    c.libelle AS categorie,
    COUNT(e.id) AS nb_exemplaires,
    COALESCE(SUM(e.disponible = 1), 0) AS nb_disponibles
FROM ouvrage o
JOIN categorie c ON o.categorie_id = c.id
LEFT JOIN exemplaire e ON o.id = e.ouvrage_id
GROUP BY o.id, o.titre, o.auteur, o.annee_publication, c.libelle;
 
CREATE OR REPLACE VIEW v_adherent_public AS
SELECT
    id,
    nom,
    prenom,
    ville,
    date_inscription,
    actif
FROM adherent;
 
CREATE OR REPLACE VIEW v_emprunt_en_cours AS
SELECT
    em.id,
    em.date_emprunt,
    em.date_retour_prevue,
    DATEDIFF(CURDATE(), em.date_retour_prevue) AS jours_retard,
    CONCAT(a.prenom, ' ', a.nom) AS adherent,
    o.titre,
    ex.code_barre
FROM emprunt em
JOIN adherent a ON em.adherent_id = a.id
JOIN exemplaire ex ON em.exemplaire_id = ex.id
JOIN ouvrage o ON ex.ouvrage_id = o.id
WHERE em.date_retour_reelle IS NULL;
 
CREATE OR REPLACE VIEW v_retard AS
SELECT id, date_emprunt, date_retour_prevue, jours_retard,
       adherent, titre, code_barre
FROM v_emprunt_en_cours
WHERE jours_retard > 0;

 REVOKE SELECT (id, nom, prenom, actif)
    ON mediatheque.adherent FROM 'stagiaire'@'localhost';
 
REVOKE role_catalogue FROM 'stagiaire'@'localhost';
 
GRANT SELECT ON mediatheque.v_adherent_public  TO 'stagiaire'@'localhost';
GRANT SELECT ON mediatheque.v_catalogue        TO 'stagiaire'@'localhost';
GRANT SELECT ON mediatheque.v_emprunt_en_cours TO 'stagiaire'@'localhost';
GRANT SELECT ON mediatheque.adherent           TO 'stagiaire`@`localhost';
 
SHOW GRANTS FOR 'stagiaire'@'localhost';
 
-- Test en connexion stagiaire :
--   SELECT * FROM v_adherent_public;  -- OK
--   SELECT * FROM adherent;           -- ERROR 1142 (refusé)
--
-- Pourquoi ça marche : une vue s'exécute par défaut en SQL SECURITY DEFINER,
-- donc avec les droits de son créateur, pas ceux de l'utilisateur qui l'interroge.
