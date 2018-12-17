DROP TABLE IF EXISTS movies, ratings, tags;

CREATE EXTENSION pg_trgm;

CREATE TABLE movies (
    id integer PRIMARY KEY,
    title varchar(255),
    genres text,
    imdbId integer,
    tmdbId integer
);

create index movies_title_trigram on movies using GIST (title gist_trgm_ops);



\copy movies(id,title,genres) FROM '../data/movies.csv' DELIMITER ',' CSV HEADER


CREATE TEMP TABLE links (id integer primary key, imdbId integer, tmdbId integer); -- but see below
\copy links(id,imdbId,tmdbId) FROM '../data/links.csv' DELIMITER ',' CSV HEADER

UPDATE movies
SET    imdbId = links.imdbId,tmdbId=links.tmdbId
FROM   links
WHERE  movies.id = links.id;

DROP TABLE links;


CREATE TABLE ratings (
    user_id integer,
    movie_id integer REFERENCES movies(id),
    rating decimal,
    timestamp integer,
    PRIMARY KEY  (user_id, movie_id)
);
create index user_id on ratings using btree(user_id);
create index movie_id on ratings using btree(movie_id);
create index id on movies using btree(id);


\copy ratings FROM '../data/ratings.csv' DELIMITER ',' CSV HEADER

CREATE TABLE tags (
    user_id integer,
    movie_id integer,
    name varchar(255),
    timestamp integer,
    PRIMARY KEY  (user_id, movie_id, name)

);
\copy tags FROM '../data/tags.csv' DELIMITER ',' CSV HEADER



drop table if exists normalized_scores, user_similarity;


create table normalized_scores as (
SELECT
b."movie_id",
b."user_id",
b."nb_rated_movies",
b."nb_rated_by_user",
b."rating"/SQRT(SUM(b."rating"*b."rating")  OVER (PARTITION BY b."user_id")) AS nb_rated_movies_normed,
b."rating"/SQRT(SUM(b."rating"*b."rating")  OVER (PARTITION BY b."movie_id")) AS nb_rated_by_user_normed

FROM  (SELECT *,
              COUNT(*) OVER(PARTITION BY "user_id") as nb_rated_movies,
              COUNT(*) OVER(PARTITION by "movie_id") as nb_rated_by_user
        FROM ratings
        ) as b
WHERE b.nb_rated_by_user > 15 AND b.nb_rated_movies > 5
ORDER BY 1,2);


create table user_similarity as (
SELECT c1."user_id" AS user_1,
       c2."user_id" AS user_2,
       SUM(c1."nb_rated_movies_normed"*c2."nb_rated_movies_normed") AS similarity_user

FROM "normalized_scores" c1
INNER JOIN "normalized_scores" c2
ON c1."movie_id"=c2."movie_id"

GROUP BY 1, 2
ORDER BY 1, 3 DESC);
