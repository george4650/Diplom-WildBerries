CREATE TABLE IF NOT EXISTS whsync.goodsssync
(
    log_id        bigserial
        CONSTRAINT pk_goodsssync PRIMARY KEY,
    nm_id         integer,
    name          varchar(100)             NOT NULL,
    good_type_id  integer                  NOT NULL,
    description   varchar(1500)            NOT NULL,
    selling_price numeric(8, 2)            NOT NULL,
    ch_staff_id   int,
    dt            timestamptz              NOT NULL,
    ch_dt         timestamptz              NOT NULL,
    sync_dt       TIMESTAMP WITH TIME ZONE NULL
);