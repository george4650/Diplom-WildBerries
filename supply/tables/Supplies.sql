CREATE TABLE IF NOT EXISTS supply.supplies
(
    supply_id        bigint
        constraint pk_supplies PRIMARY KEY,
    shop_id          smallint    NOT NULL,
    supplier_id      integer     NOT NULL,
    supply_info      jsonb       NOT NULL,--nm_id, quantity, product_price
    order_dt         TIMESTAMPTZ NOT NULL,
    supply_dt        TIMESTAMPTZ,
    staff_id_ordered INT         NOT NULL,
    staff_id_tooked  INT
);