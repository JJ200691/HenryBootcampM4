-- Buscá todas las películas filmadas en el año que naciste.
SELECT *
FROM movies
WHERE year = 1991;

-- Cuantas películas hay en la DB que sean del año 1982?
SELECT COUNT(*)
FROM movies
WHERE year = 1982;
-- Buscá actores que tengan el substring stack en su apellido.
SELECT *
FROM actors
WHERE last_name LIKE '%stack%';

-- Buscá los 10 nombres y apellidos más populares entre los actores. 
-- Cuantos actores tienen cada uno de esos nombres y apellidos?
SELECT first_name,
    last_name,
    COUNT(*)
FROM actors
GROUP BY first_name,
    last_name
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Listá el top 100 de actores más activos junto con el número de roles que haya realizado.
SELECT actor_id,
    COUNT(*) AS roles_totales
FROM roles
GROUP BY actor_id
ORDER BY roles_totales DESC
LIMIT 100;
-- Cuantas películas tiene IMDB por género? Ordená la lista por el género menos popular.
SELECT genre,
    COUNT(*) AS movies_totales
FROM movies_genres
GROUP BY genre
ORDER BY movies_totales;

-- Listá el nombre y apellido de todos los actores que trabajaron en la película 
-- "Braveheart" de 1995, ordená la lista alfabéticamente por apellido.
SELECT first_name,
    last_name
FROM actors
    JOIN roles ON actors.id = roles.actor_id
    JOIN movies ON movies.id = roles.movie_id
WHERE movies.name = 'Braveheart'
    AND movies.year = 1995
ORDER BY last_name ASC;

-- Listá todos los directores que dirigieron una película de género 'Film-Noir' 
-- en un año bisiesto (para reducir la complejidad, asumí que cualquier año divisible 
-- por cuatro es bisiesto). Tu consulta debería devolver el nombre del director, el nombre 
-- de la peli y el año. Todo ordenado por el nombre de la película.
SELECT d.first_name,
    d.last_name,
    m.name,
    m.year
FROM directors AS d
    JOIN movies_directors AS md ON d.id = md.director_id
    JOIN movies_genres AS mg ON md.movie_id = mg.movie_id
    JOIN movies AS m ON mg.movie_id = m.id
WHERE genre = 'Film-Noir'
    AND m.year % 4 = 0
ORDER BY m.name;

-- Listá todos los actores que hayan trabajado con Kevin Bacon en películas de Drama 
-- (incluí el título de la peli). Excluí al señor Bacon de los resultados.
SELECT a.first_name,
    a.last_name,
    m.name
FROM actors AS a
    JOIN roles AS r ON a.id = r.actor_id
    JOIN movies AS m ON r.movie_id = m.id
    JOIN movies_genres AS mg ON m.id = mg.movie_id
WHERE genre = 'Drama'
    AND m.id IN (
        SELECT movie_id
        FROM roles
            JOIN actors ON roles.actor_id = actors.id
        WHERE first_name = 'Kevin'
            AND last_name = 'Bacon'
    )
    AND (first_name || last_name) != 'Kevin Bacon';