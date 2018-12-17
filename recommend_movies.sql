SELECT b.movie_id, movies.title, SUM(a.similarity_user) as score_user_product

FROM (SELECT * from user_similarity where user_1=188) as a
INNER JOIN normalized_scores as b
ON a.user_2 = b.user_id

Inner Join movies
on movies.id = b.movie_id

where movies.id not in (

  SELECT ratings.movie_id from ratings
  WHERE ratings.user_id=188


)

GROUP BY a.user_1,movie_id, movies.title
ORDER BY score_user_product DESC
LIMIT 20;
