CREATE TABLE IF NOT EXISTS supply.supplies
(
    supply_id        BIGINT
        constraint pk_supplies PRIMARY KEY,
    shop_id          SMALLINT    NOT NULL,
    supplier_id      INTEGER     NOT NULL,
    supply_info      JSONB       NOT NULL,--nm_id, quantity, product_price
    order_dt         TIMESTAMPTZ NOT NULL,
    supply_dt        TIMESTAMPTZ,
    staff_id_ordered INTEGER     NOT NULL,
    staff_id_tooked  INTEGER
);