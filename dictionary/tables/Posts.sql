CREATE TABLE IF NOT EXISTS dictionary.posts
(
    post_id smallserial
        CONSTRAINT pk_posts PRIMARY KEY,
    name    varchar(100)  NOT NULL,
    salary  numeric(8, 2) NOT NULL
);