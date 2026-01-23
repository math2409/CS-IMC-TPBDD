--Exercice 0 : liste les tables et colonnes
-- On récupère d'abord la liste des tables de la base
SELECT name
FROM [tpbdd-movies-db].sys.tables;

-- Ensuite, pour chaque table, on récupère les colonnes associées

SELECT name
FROM sys.columns
WHERE object_id = OBJECT_ID('tFilm');

SELECT name
FROM sys.columns
WHERE object_id = OBJECT_ID('tJob');

SELECT name
FROM sys.columns
WHERE object_id = OBJECT_ID('tGenre');

SELECT name
FROM sys.columns
WHERE object_id = OBJECT_ID('tFilmGenre');

SELECT name
FROM sys.columns
WHERE object_id = OBJECT_ID('tArtist');

--Exercice 1 : Filtre la table tArtist sur le nom 'Michael B. Jordan'
-- puis affiche la propriété birthYear. résultat : 1987
SELECT primaryName, birthYear FROM tArtist WHERE primaryName='Michael B. Jordan';

--Exercice 2 : On utilise COUNT sur l'identifiant idArtist. résultat : 82046
SELECT COUNT(idArtist) AS NbArtists FROM tArtist;

-- Exercice 3 : On filtre birthYear=1960 et récupère leur nom
-- resultat : David Duchovny, Colin Firth, Julianne Moore, ...
SELECT primaryName
FROM tArtist
WHERE birthYear='1960';

-- on compte les noms obtenus. resultat : 203
SELECT COUNT(primaryName)
FROM tArtist
WHERE birthYear='1960';

--Exercice 4 : On groupe par birthYear et on compte le nombre d'acteurs
-- On exclut les années à 0 et on ordonne par le nombre décroissant
-- On récupère le top 1. résultat : 477 acteurs nés en 1980
SELECT TOP 1 COUNT(idArtist) AS NbArtists, birthYear FROM tArtist WHERE birthYear!=0 GROUP BY birthYear ORDER BY NbArtists DESC;

--Exercice 5 : On joint tArtist et tJob via idArtist
-- On filtre les jobs de type 'acted in'
-- On groupe par artiste et on garde ceux ayant COUNT(*)>1. résultats : Yogi Babu	22, Eric Roberts	20...
SELECT a.primaryName, COUNT(*) AS nbFilms
FROM dbo.tArtist a
JOIN dbo.tJob j ON a.idArtist = j.idArtist
WHERE j.category = 'acted in'
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(*) > 1
ORDER BY nbFilms DESC;

--Exercice 6 : On compte le nombre de categories différentes pour chaque artiste
-- On garde ceux ayant plus d'une catégorie distincte. résultats : Kevin Bacon	2, Luc Besson	2
SELECT primaryName, COUNT(DISTINCT j.category) AS nbRespo
FROM tArtist a
JOIN tJob j ON a.idArtist = j.idArtist
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(DISTINCT j.category) > 1;

--Exercice 7 : On compte le nombre d'artistes distincts par film ayant category='acted in'
-- On récupère ensuite les films dont le nombre d'acteurs = maximum. résultats : 825 Forest Road	10, Snow White and the 7 Dwarfs	10
WITH nbActorByFilm (nbActors, idFilm)
AS (
    SELECT COUNT(DISTINCT idArtist), idFilm
    FROM tJob
    WHERE category='acted in'
    GROUP BY idFilm
)
SELECT f.primaryTitle, nb.nbActors
FROM tFilm AS f
JOIN nbActorByFilm AS nb ON f.idFilm = nb.idFilm
WHERE nb.nbActors = (SELECT MAX(nbActors) FROM nbActorByFilm)

--Exercice 8 : On joint tArtist, tJob et tFilm
-- On groupe par artiste et film, on compte les catégories distinctes
-- On garde ceux ayant plus d'une catégorie. résultats : 2	Rami Malek	The Amateur, 2	Mel Gibson	Flight Risk
SELECT COUNT(DISTINCT j.category) AS nbRespo, primaryName, primaryTitle
FROM tArtist a
JOIN tJob j ON a.idArtist = j.idArtist
JOIN tFilm f ON j.idFilm = f.idFilm
GROUP BY a.idArtist, a.primaryName, j.idFilm, f.primaryTitle
HAVING COUNT(DISTINCT j.category) > 1;