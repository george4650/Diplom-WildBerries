CREATE TABLE IF NOT EXISTS history.markupchanges
(
    log_id    bigserial
        CONSTRAINT pk_markupchanges PRIMARY KEY,
    nm_id     integer,
    markup    numeric(6, 2),
    staff_id  INT         NOT NULL,
    ch_dt     TIMESTAMPTZ NOT NULL
)