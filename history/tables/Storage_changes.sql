CREATE TABLE IF NOT EXISTS history.storagechanges
(
    log_id        bigserial
        CONSTRAINT pk_storagechanges PRIMARY KEY,
    shop_id       integer,
    nm_id       integer,
    selling_price integer NOT NULL,
    quantity      integer,
    staff_id      INT,
    ch_dt         TIMESTAMPTZ NOT NULL
)