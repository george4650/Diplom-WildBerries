CREATE TABLE IF NOT EXISTS history.clientschanges
(
    log_id        BIGSERIAL
        CONSTRAINT pk_clientschanges PRIMARY KEY,
    client_id     INTEGER,
    card_id       INTEGER,
    card_type_id  SMALLINT    NOT NULL,
    first_name    VARCHAR(32) NOT NULL,
    surname       VARCHAR(32) NOT NULL,
    phone         VARCHAR(11) NOT NULL,
    email         VARCHAR(50),
    employee_id   INTEGER,
    ransom_amount NUMERIC(15, 2),
    dt            TIMESTAMPTZ NOT NULL,
    ch_staff_id   INTEGER,
    ch_dt         TIMESTAMPTZ NOT NULL
);