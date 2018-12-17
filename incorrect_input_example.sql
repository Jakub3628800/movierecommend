
-- We are using trigram index on movies.title column


-- This query returns movies which are most similar to the given string
-- Will not work well if the searched word is in a 

SELECT *, similarity(movies.title, 'star') AS sml
FROM movies
WHERE movies.title % 'star'
ORDER BY sml DESC
LIMIT 20;



-- This query returns movies which match best the selected string only in a part of the title
SELECT movies.title, word_similarity('star', movies.title) AS sml
FROM movies
WHERE 'star' <% movies.title
ORDER BY sml DESC, movies.title
LIMIT 20;
