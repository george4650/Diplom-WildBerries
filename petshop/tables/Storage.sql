CREATE TABLE IF NOT EXISTS petshop.storage
(
    shop_id       integer,
    good_id       integer,
    selling_price integer,
    quantity      integer,
    CONSTRAINT pk_storage_shop_id_animal_id PRIMARY KEY (shop_id, good_id)
)