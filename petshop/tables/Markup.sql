CREATE TABLE IF NOT EXISTS petshop.markup
(
    nm_id  integer
        CONSTRAINT pk_markup PRIMARY KEY,
    markup numeric(6, 2)
);