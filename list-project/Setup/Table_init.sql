-- ADD ROW
-- ALTER TABLE movies_preview
-- ADD COLUMN genre_ids BIGINT[];
-- 

CREATE TABLE movies (
  id INT PRIMARY KEY,
  backdrop_path TEXT,
  budget INT,
  imdb_id TEXT,
  overview TEXT,
  poster_path TEXT,
  original_title TEXT,
  release_date DATE,
  status TEXT,
  title TEXT,
  runtime INT,
  vote_average FLOAT,
  cinematography INT,
  editing INT,
  costume_makeup INT,
  lighting INT,
  staging INT,
  setting_props INT
);

CREATE TABLE movies_preview (
  id INT PRIMARY KEY,
  backdrop_path TEXT,
  budget INT,
  imdb_id TEXT,
  overview TEXT,
  poster_path TEXT,
  original_title TEXT,
  release_date DATE,
  status TEXT,
  title TEXT,
  runtime INT,
  vote_average FLOAT,
  original_language TEXT,
  genre_ids BIGINT[]
);

CREATE TABLE genres (
  id INT PRIMARY KEY,
  name TEXT
);

CREATE TABLE movie_genre (
  movie_id INT,
  genre_id INT
);

CREATE TABLE companies (
  id INT PRIMARY KEY,
  logo_path TEXT,
  name TEXT,
  origin_country TEXT
);

CREATE TABLE movie_company (
  movie_id INT,
  company_id INT
);

CREATE TABLE countries (
  iso_3166_1 VARCHAR PRIMARY KEY,
  name TEXT
);

CREATE TABLE movie_country (
  movie_id INT,
  country_iso VARCHAR
);

CREATE TABLE languages (
  iso_639_1 VARCHAR PRIMARY KEY,
  english_name TEXT,
  name TEXT
);

CREATE TABLE movie_language (
  movie_id INT,
  language_iso VARCHAR
);

CREATE TABLE people (
  id INT PRIMARY KEY,
  original_name TEXT,
  profile_path TEXT,
  known_for_department TEXT
);

CREATE TABLE movie_person (
  movie_id INT,
  person_id INT,
  job TEXT,
  character TEXT,
  department TEXT
);

CREATE TABLE lists (
  id INT PRIMARY KEY,
  name TEXT,
  type TEXT,
  cover TEXT,
  imgs TEXT[]  -- Array of image URLs
);

CREATE TABLE movie_list (
  movie_id INT,
  list_id INT,
  note TEXT,
  PRIMARY KEY (movie_id, list_id)
);
