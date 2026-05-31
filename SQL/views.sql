CREATE OR REPLACE VIEW views.vw_movies_kpis(title, num_ratings, avg_rating, max_rating, min_rating, max_timestamp, min_timestamp) AS (
  SELECT
    dm.title        AS title
    ,COUNT(*)       AS num_ratings
    ,AVG(fr.rating) AS avg_rating
    ,MAX(fr.rating) AS max_rating
    ,MIN(fr.rating) AS min_rating
    ,MAX(fr.tstamp) AS max_timestamp
    ,MIN(fr.tstamp) AS min_timestamp
  FROM
    `analytics.fact_ratings` fr
  INNER JOIN
    `analytics.dim_movies` dm ON fr.movie_id = dm.movie_id
  GROUP BY dm.title
);

CREATE OR REPLACE VIEW views.vw_top_movies (title, avg_rating) AS (
  SELECT
    dm.title        AS title
    ,AVG(fr.rating) AS avg_rating
  FROM
    `analytics.fact_ratings` fr
  INNER JOIN
    `analytics.dim_movies` dm ON fr.movie_id = dm.movie_id
  GROUP BY dm.title
  HAVING COUNT(fr.movie_id) > 50
  ORDER BY avg_rating DESC 
  LIMIT 10
);

CREATE OR REPLACE VIEW views.vw_ratings_heatmap (user_id, year_rating, month_rating, day_rating) AS (
  SELECT
    fr.user_id                     AS user_id
    ,EXTRACT(YEAR  FROM fr.tstamp) AS year_rating
    ,EXTRACT(MONTH FROM fr.tstamp) AS month_rating
    ,EXTRACT(DAY   FROM fr.tstamp) AS day_rating
  FROM
    `analytics.fact_ratings` fr 
);

CREATE OR REPLACE VIEW views.vw_scatter_popularity_vs_quality (title, num_ratings, avg_rating) AS (
  SELECT
    mk.title        AS title
    ,mk.num_ratings AS num_ratings
    ,mk.avg_rating  AS avg_rating
  FROM
    `views.vw_movies_kpis` mk
);

CREATE OR REPLACE VIEW views.vw_user_activity (title, first_rating, last_rating) AS (
  SELECT
    fr.user_id AS user_id
    ,MIN(fr.tstamp) AS first_rating
    ,MAX(fr.tstamp) AS last_rating
  FROM
    `analytics.fact_ratings` fr
  GROUP BY fr.user_id
  HAVING COUNT(user_id) > 50
);

CREATE OR REPLACE VIEW views.genre_performance (genre, avg_rating) AS (
  WITH cte AS (
    SELECT
      rating
      ,genre
    FROM
      `analytics.fact_ratings` fr
    INNER JOIN `analytics.dim_movies` dm ON fr.movie_id = dm.movie_id
    CROSS JOIN UNNEST(SPLIT(COALESCE(genres, ''), '|')) AS genre
  )
  SELECT
    genre AS genre
    ,AVG(rating) AS avg_rating
  FROM
    cte
  WHERE NULLIF(genre, '') IS NOT NULL
    AND NULLIF(genre, '(no genres listed)') IS NOT NULL
  GROUP BY genre
);