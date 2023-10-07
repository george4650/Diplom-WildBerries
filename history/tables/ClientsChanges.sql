CREATE TABLE IF NOT EXISTS history.clientschanges
(
    log_id        bigserial
        CONSTRAINT pk_clientschanges PRIMARY KEY,
    client_id     bigint,
    first_name    varchar(32) NOT NULL,
    surname       varchar(32) NOT NULL,
    phone         varchar(11) NOT NULL,
    email         varchar(50),
    ransom_amount integer,
    dt            date        NOT NULL,
    ch_dt         TIMESTAMPTZ NOT NULL
)