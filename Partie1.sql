--Exercice 0 : liste les tables et colonnes
SELECT name
FROM [tpbdd-movies-db].sys.tables;

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

--Exercice 1 : résultat : 1987
SELECT primaryName, birthYear FROM tArtist WHERE primaryName='Michael B. Jordan';

--Exercice 2 : résultat : 82046
SELECT COUNT(idArtist) AS NbArtists FROM tArtist;

-- Exercice 3 : resultat : David Duchovny, Colin Firth, Julianne Moore, ...
SELECT primaryName
FROM tArtist
WHERE birthYear='1960';

-- resultat : 203
SELECT COUNT(primaryName)
FROM tArtist
WHERE birthYear='1960';

--Exercice 4 : résultat : 477 acteurs nés en 1980
SELECT TOP 1 COUNT(idArtist) AS NbArtists, birthYear FROM tArtist WHERE birthYear!=0 GROUP BY birthYear ORDER BY NbArtists DESC;

--Exercice 5 : résultats : Yogi Babu	22, Eric Roberts	20...
SELECT a.primaryName, COUNT(*) AS nbFilms
FROM dbo.tArtist a
JOIN dbo.tJob j ON a.idArtist = j.idArtist
WHERE j.category = 'acted in'
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(*) > 1
ORDER BY nbFilms DESC;

--Exercice 6 : résultats : Kevin Bacon	2, Luc Besson	2
SELECT primaryName, COUNT(DISTINCT j.category) AS nbRespo
FROM tArtist a
JOIN tJob j ON a.idArtist = j.idArtist
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(DISTINCT j.category) > 1;

--Exercice 8 : résultats : 2	Rami Malek	The Amateur, 2	Mel Gibson	Flight Risk
SELECT COUNT(DISTINCT j.category) AS nbRespo, primaryName, primaryTitle
FROM tArtist a
JOIN tJob j ON a.idArtist = j.idArtist
JOIN tFilm f ON j.idFilm = f.idFilm
GROUP BY a.idArtist, a.primaryName, j.idFilm, f.primaryTitle
HAVING COUNT(DISTINCT j.category) > 1;