CREATE TABLE IF NOT EXISTS history.supplieschanges
(
    log_id           bigserial
        CONSTRAINT pk_supplieschanges PRIMARY KEY,
    supply_id        bigint,
    shop_id          smallint    NOT NULL,
    supplier_id      integer     NOT NULL,
    supply_info      jsonb       NOT NULL,--nm_id, quantity, product_price
    order_dt         TIMESTAMPTZ NOT NULL,
    supply_dt        TIMESTAMPTZ,
    staff_id_ordered INT         NOT NULL,
    staff_id_tooked  INT,
    ch_dt            TIMESTAMPTZ NOT NULL
);