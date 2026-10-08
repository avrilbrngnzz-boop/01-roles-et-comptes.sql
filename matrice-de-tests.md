# TP1 — Matrice de tests

Douze tests. Dans la colonne **Obtenu**, écrivez `OK` (la commande passe et renvoie des lignes)
ou le numéro d'erreur complet, par exemple `ERROR 1142 (42000)`.

Un test se fait **connecté avec le compte concerné** :

```
mysql -u stagiaire -p mediatheque
```

Premier réflexe à chaque connexion : `SELECT CURRENT_ROLE();`. Si la réponse est `NONE`,
les rôles ne sont pas actifs et tous les tests qui suivent vont échouer pour la mauvaise raison.

## `app_media` — l'application web

| # | Commande | Attendu | Obtenu |
|---|---|---|---|
| 1 | `SELECT id, nom, prenom FROM adherent LIMIT 5;` | OK | ok|
| 2 | `SELECT email FROM adherent LIMIT 1;` | refus | ERROR 1143|
| 3 | `UPDATE exemplaire SET disponible = 0 WHERE id = 3;` | OK | ok|
| 4 | `UPDATE exemplaire SET etat = 'use' WHERE id = 3;` | refus | ERROR 1143|
| 5 | `DELETE FROM emprunt WHERE id = 1;` | refus | ERROR 1142|

Les tests 3 et 4 portent sur la **même table** : c'est la colonne qui fait la différence.

## `biblio_marie` — la bibliothécaire

| # | Commande | Attendu | Obtenu |
|---|---|---|---|
| 6 | `SELECT nom, email, telephone FROM adherent LIMIT 3;` | OK | ok|
| 7 | `CREATE USER 'test'@'localhost' IDENTIFIED BY 'Test!2026';` | refus | ERROR 1227|

## `stagiaire`

| # | Commande | Attendu | Obtenu |
|---|---|---|---|
| 8 | `SELECT nom, prenom, ville FROM adherent LIMIT 5;` | OK |ok |
| 9 | `SELECT email FROM adherent LIMIT 1;` | refus | ERROR 1143|
| 10 | `SELECT * FROM adherent LIMIT 1;` | refus | ERROR 1142|

**Question :** les tests 9 et 10 échouent tous les deux, mais pas avec le même numéro d'erreur. Pourquoi ?

> _votre réponse :_ Le test 9 demande une colonne précise (email) sur laquelle le stagiaire n'a pas de droit. Ca renvoie donc l'erreur 1143. Au contraire le test 10 demande toutes les colonnes de la table donc ça renvoie l'erreur 1142.

## `analyste`

| # | Commande | Attendu | Obtenu |
|---|---|---|---|
| 11 | `SELECT COUNT(*) FROM adherent;` | refus | ERROR 1142|
| 12 | `SELECT COUNT(*) FROM reservation;` | après le `GRANT` : OK — après le `REVOKE` : refus | ok ? nb 8 donc incohérence  |

## Conclusion

Une phrase : **parmi les quatre comptes, lequel peut encore faire quelque chose qu'il ne fera jamais — et comment le lui retireriez-vous ?**

>L'analyste possède plus de droit qu'il en a besoin, pour lui retirer ces droits il faudrait retirer le rôle de role_prets et lui donner uniquement un rôle avec des droits de lectures.
