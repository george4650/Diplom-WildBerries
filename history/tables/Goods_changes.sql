CREATE TABLE IF NOT EXISTS history.goodschanges
(
    log_id        bigserial
        CONSTRAINT pk_goodschanges PRIMARY KEY,
    nm_id         integer,
    name          varchar(100)  NOT NULL,
    good_type_id  smallint      NOT NULL,
    description   varchar(1500) NOT NULL,
    selling_price numeric(8, 2) NOT NULL,
    dt            timestamptz   NOT NULL,
    ch_staff_id   INT,
    ch_dt         timestamptz   NOT NULL
);