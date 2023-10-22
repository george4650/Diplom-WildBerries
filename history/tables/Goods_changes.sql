CREATE TABLE IF NOT EXISTS history.goodschanges
(
    log_id        BIGSERIAL
        CONSTRAINT pk_goodschanges PRIMARY KEY,
    nm_id         INTEGER,
    name          VARCHAR(100)  NOT NULL,
    good_type_id  SMALLINT      NOT NULL,
    description   VARCHAR(1500) NOT NULL,
    selling_price NUMERIC(8, 2) NOT NULL,
    dt            TIMESTAMPTZ   NOT NULL,
    ch_staff_id   INTEGER,
    ch_dt         TIMESTAMPTZ   NOT NULL
);