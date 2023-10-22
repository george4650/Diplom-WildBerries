CREATE TABLE IF NOT EXISTS history.supplieschanges
(
    log_id           BIGSERIAL
        CONSTRAINT pk_supplieschanges PRIMARY KEY,
    supply_id        BIGINT,
    shop_id          SMALLINT    NOT NULL,
    supplier_id      INTEGER     NOT NULL,
    supply_info      JSONB       NOT NULL,--nm_id, quantity, product_price
    order_dt         TIMESTAMPTZ NOT NULL,
    supply_dt        TIMESTAMPTZ,
    staff_id_ordered INTEGER     NOT NULL,
    staff_id_tooked  INTEGER,
    ch_dt            TIMESTAMPTZ NOT NULL
);