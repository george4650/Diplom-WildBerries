CREATE TABLE IF NOT EXISTS petshop.goods
(
    nm_id         INTEGER
        CONSTRAINT pk_goods PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL,
    good_type_id  SMALLINT      NOT NULL,
    description   VARCHAR(1500) NOT NULL,
    selling_price NUMERIC(8, 2) NOT NULL,
    dt            TIMESTAMPTZ   NOT NULL
);

CREATE INDEX goods_idx ON petshop.goods (nm_id)