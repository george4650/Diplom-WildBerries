CREATE TABLE IF NOT EXISTS petshop.storage
(
    shop_id  SMALLINT,
    nm_id    INTEGER,
    quantity INTEGER DEFAULT 0,
    CONSTRAINT ch_quantity CHECK (quantity >= 0),
    CONSTRAINT pk_storage_shop_id_nm_id PRIMARY KEY (shop_id, nm_id)
);