DROP TABLE petshop.goods

CREATE TABLE IF NOT EXISTS petshop.goods
(
    good_id integer
        CONSTRAINT pk_goods PRIMARY KEY,
    good_type   integer       NOT NULL,
    description varchar(1500) NOT NULL
)