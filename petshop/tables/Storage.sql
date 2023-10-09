CREATE TABLE IF NOT EXISTS petshop.storage
(
    shop_id       integer,
    nm_id         integer,
    selling_price integer NOT NULL,
    quantity      integer,
    CONSTRAINT pk_storage_shop_id_good_id PRIMARY KEY (shop_id, nm_id)
)