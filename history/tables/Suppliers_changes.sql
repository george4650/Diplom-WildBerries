CREATE TABLE IF NOT EXISTS history.supplierschanges
(
    log_id      BIGSERIAL
        CONSTRAINT pk_supplierschanges PRIMARY KEY,
    supplier_id INTEGER,
    name        VARCHAR(100) NOT NULL,
    phone       VARCHAR(11)  NOT NULL,
    email       VARCHAR(50),
    deleted_at  TIMESTAMPTZ,
    ch_staff_id INTEGER      NOT NULL,
    ch_dt       TIMESTAMPTZ  NOT NULL
);