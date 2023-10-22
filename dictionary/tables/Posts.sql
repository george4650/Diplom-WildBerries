CREATE TABLE IF NOT EXISTS dictionary.posts
(
    post_id SMALLSERIAL
        CONSTRAINT pk_posts PRIMARY KEY,
    name    VARCHAR(100)  NOT NULL,
    salary  NUMERIC(8, 2) NOT NULL
);