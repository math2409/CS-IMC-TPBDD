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