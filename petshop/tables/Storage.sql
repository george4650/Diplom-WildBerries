CREATE TABLE IF NOT EXISTS petshop.storage
(
    shop_id  smallint,
    nm_id    integer,
    quantity integer,
    CONSTRAINT pk_storage_shop_id_nm_id PRIMARY KEY (shop_id, nm_id)
)