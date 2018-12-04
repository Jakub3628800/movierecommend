DROP TABLE IF EXISTS movies,ratings, tags;

CREATE TABLE movies (
    id integer PRIMARY KEY,
    title varchar(255),
    genres text,
    imdbId integer,
    tmdbId integer
);
\copy movies(id,title,genres) FROM '../data/movies.csv' DELIMITER ',' CSV


CREATE TEMP TABLE links (id integer primary key, imdbId integer, tmdbId integer); -- but see below
\copy links(id,imdbId,tmdbId) FROM '../data/links.csv' DELIMITER ',' CSV

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
\copy ratings FROM '../data/ratings.csv' DELIMITER ',' CSV

CREATE TABLE tags (
    user_id integer,
    movie_id integer,
    name varchar(255),
    timestamp integer,
    PRIMARY KEY  (user_id, movie_id, name)

);
\copy tags FROM '../data/tags.csv' DELIMITER ',' CSV
