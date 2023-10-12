CREATE TABLE IF NOT EXISTS history.clientschanges
(
    log_id        bigserial
        CONSTRAINT pk_clientschanges PRIMARY KEY,
    client_id     integer,
    card_id       integer,
    card_type_id  smallint    NOT NULL,
    first_name    varchar(32) NOT NULL,
    surname       varchar(32) NOT NULL,
    phone         varchar(11) NOT NULL,
    email         varchar(50),
    employee_id   integer,
    ransom_amount numeric(15, 2),
    dt            timestamptz NOT NULL,
    is_deleted    boolean default false,
    ch_staff_id   integer,
    ch_dt         timestamptz NOT NULL
);