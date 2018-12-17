-- Similarity will compute similarity between our searched movie and all the other movies
SELECT movies.id, movies.title,movies.genres,averages.avg_rating, similarity(movies.genres, (

                                    -- This SUBQUERY will return genres best matching movie to a given title (so that we can handle missspellings)
                                    SELECT movies.genres
                                    FROM movies
                                    WHERE 'Star Wars: Episode VI - Return' <% movies.title
                                    ORDER BY word_similarity('Star Wars: Episode VI - Return', movies.title) DESC
                                    LIMIT 1 )) as sml

from movies

-- We join it with the average rating of the movie, so that we can return best rated movie as first
INNER JOIN (
            SELECT DISTINCT ratings.movie_id,
            avg(ratings.rating) OVER(PARTITION by "movie_id") as avg_rating
            FROM "ratings"
          ) as averages ON averages.movie_id = movies.id


-- We order by genre similarity of the two movies, and if they match we then order by average rating
ORDER BY sml DESC, avg_rating DESC
limit 20;
