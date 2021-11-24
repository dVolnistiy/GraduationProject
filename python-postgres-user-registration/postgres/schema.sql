CREATE TABLE IF NOT EXISTS "users" (
  id serial PRIMARY KEY,
  first_name VARCHAR (50) NOT NULL,
  email VARCHAR (250) UNIQUE NOT NULL,
  last_name VARCHAR (50) NOT NULL
);
