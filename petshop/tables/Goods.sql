CREATE TABLE IF NOT EXISTS petshop.goods
(
    nm_id         integer
        CONSTRAINT pk_goods PRIMARY KEY,
    name          varchar(100)  NOT NULL,
    good_type_id  smallint      NOT NULL,
    description   varchar(1500) NOT NULL,
    selling_price numeric(8, 2) NOT NULL,
    dt            timestamptz   NOT NULL
);

CREATE INDEX goods_idx ON  petshop.goods (nm_id)