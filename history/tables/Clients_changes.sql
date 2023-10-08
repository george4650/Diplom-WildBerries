CREATE TABLE IF NOT EXISTS history.clientschanges
(
    log_id        bigserial
        CONSTRAINT pk_clientschanges PRIMARY KEY,
    client_id     integer,
    first_name    varchar(32) NOT NULL,
    surname       varchar(32) NOT NULL,
    phone         varchar(11) NOT NULL,
    email         varchar(50),
    staff_id      INT,
    ch_dt         TIMESTAMPTZ NOT NULL
)