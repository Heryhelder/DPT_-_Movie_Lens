CREATE OR REPLACE TABLE `analytics.dim_movies` AS (
  SELECT
     SAFE_CAST(movie_id AS INT)                                          AS movie_id
    ,SAFE_CAST(title AS STRING)                                          AS title
    ,SAFE_CAST(genres AS STRING)                                         AS genres
    ,SAFE_CAST(SUBSTR(REGEXP_EXTRACT(title, r'\(\d{4}\)'), 2, 4) AS INT) AS release_year
  FROM `raw.movies`
);

CREATE OR REPLACE TABLE `analytics.fact_ratings` AS (
  SELECT
     SAFE_CAST(user_id AS INT)      AS user_id
    ,SAFE_CAST(movie_id AS INT)     AS movie_id
    ,SAFE_CAST(rating AS NUMERIC)   AS rating
    ,SAFE_CAST(tstamp AS TIMESTAMP) AS tstamp
  FROM `raw.user_rating_history`
  UNION DISTINCT
  SELECT
     SAFE_CAST(user_id AS INT)      AS user_id
    ,SAFE_CAST(movie_id AS INT)     AS movie_id
    ,SAFE_CAST(rating AS NUMERIC)   AS rating
    ,SAFE_CAST(tstamp AS TIMESTAMP) AS tstamp
  FROM `raw.ratings_for_additional_users`
);