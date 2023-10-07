CREATE TABLE IF NOT EXISTS history.supplierschanges
(
    log_id      bigserial
        CONSTRAINT pk_supplierschanges PRIMARY KEY,
    supplier_id integer,
    name        varchar(100) NOT NULL,
    phone       VARCHAR(11)  NOT NULL,
    email       varchar(50),
    ch_dt       TIMESTAMPTZ  NOT NULL
)