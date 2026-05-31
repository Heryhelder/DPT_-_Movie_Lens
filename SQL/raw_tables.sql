-- Belief data
CREATE OR REPLACE EXTERNAL TABLE `raw.belief_data` (
  user_id               STRING,
  movie_id              STRING,
  is_seen               STRING,
  watch_date            STRING,
  user_elicit_rating    STRING,
  user_predict_rating   STRING,
  user_certainty        STRING,
  tstamp                STRING,
  movie_idx             STRING,
  source                STRING,
  system_predict_rating STRING
) OPTIONS (
  format = 'CSV',
  uris = ['gs://desafio-tecnico-dpt-movielens/bronze/belief_data.csv'],
  skip_leading_rows = 1
);

-- Movie elicitation set
CREATE OR REPLACE EXTERNAL TABLE `raw.movie_elicitation_set` (
  movie_id  STRING,
  month_idx STRING,
  source    STRING,
  tstamp    STRING
) OPTIONS (
  format = 'CSV',
  uris = ['gs://desafio-tecnico-dpt-movielens/bronze/movie_elicitation_set.csv'],
  skip_leading_rows = 1
);

-- Movies
CREATE OR REPLACE EXTERNAL TABLE `raw.movies` (
  movie_id STRING,
  title    STRING,
  genres   STRING
) OPTIONS (
  format = 'CSV',
  uris = ['gs://desafio-tecnico-dpt-movielens/bronze/movies.csv'],
  skip_leading_rows = 1
);

-- Ratings for additional users
CREATE OR REPLACE EXTERNAL TABLE `raw.ratings_for_additional_users` (
  user_id  STRING,
  movie_id STRING,
  rating   STRING,
  tstamp   STRING
) OPTIONS (
  format = 'CSV',
  uris = ['gs://desafio-tecnico-dpt-movielens/bronze/ratings_for_additional_users.csv'],
  skip_leading_rows = 1
);

-- User rating history
CREATE OR REPLACE EXTERNAL TABLE `raw.user_rating_history` (
  user_id  STRING,
  movie_id STRING,
  rating   STRING,
  tstamp   STRING
) OPTIONS (
  format = 'CSV',
  uris = ['gs://desafio-tecnico-dpt-movielens/bronze/user_rating_history.csv'],
  skip_leading_rows = 1
);

-- User recommendation history
CREATE OR REPLACE EXTERNAL TABLE `raw.user_recommendation_history` (
  user_id          STRING,
  tstamp           STRING,
  movie_id         STRING,
  predicted_rating STRING
) OPTIONS (
  format = 'CSV',
  uris = ['gs://desafio-tecnico-dpt-movielens/bronze/user_recommendation_history.csv'],
  skip_leading_rows = 1
);