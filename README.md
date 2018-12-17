# movierecommend
Designing a database system for recommending movies



How to Run
download movielens dataset from https://grouplens.org/datasets/movielens/latest/ .

open a psql terminal
create a database

execute script create_tables.sql on the database
in the script there is a default path to the dataset set to '../data/movies.csv', when loading the files, change if necessarry


example scripts
incorrect input example.sql
Shows how to query for a movie with a search string.

similar_genres.sql
shows how to get similar movies to a given movie based on genres

recommend_movies.slq
recommend movies based on what other users have seen (colaborative filtering)
