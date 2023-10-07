CREATE TABLE IF NOT EXISTS petshop.goods
(
    good_id   bigint
        CONSTRAINT pk_goods PRIMARY KEY,
    description varchar(1500) NOT NULL,
    dt          TIMESTAMPTZ   NOT NULL
)