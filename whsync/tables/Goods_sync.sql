CREATE TABLE IF NOT EXISTS whsync.goodsssync
(
    log_id        BIGSERIAL
        CONSTRAINT pk_goodsssync PRIMARY KEY,
    nm_id         INTEGER,
    name          VARCHAR(100)             NOT NULL,
    good_type_id  INTEGER                  NOT NULL,
    description   VARCHAR(1500)            NOT NULL,
    selling_price NUMERIC(8, 2)            NOT NULL,
    ch_staff_id   INTEGER,
    dt            TIMESTAMPTZ              NOT NULL,
    ch_dt         TIMESTAMPTZ              NOT NULL,
    sync_dt       TIMESTAMP WITH TIME ZONE NULL
);