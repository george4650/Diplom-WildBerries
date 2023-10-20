CREATE TABLE IF NOT EXISTS humanresource.clients
(
    client_id     integer,
    card_id       integer,
    card_type_id  smallint    NOT NULL,
    first_name    varchar(32) NOT NULL,
    surname       varchar(32) NOT NULL,
    phone         varchar(11) NOT NULL,
    email         varchar(50),
    employee_id   integer,
    ransom_amount numeric(15, 2) default 0,
    dt            timestamptz NOT NULL,
    CONSTRAINT pk_clients_client_id UNIQUE (client_id),
    CONSTRAINT pk_clients_client_id PRIMARY KEY (client_id)
);

CREATE INDEX clients_idx ON humanresource.clients (client_id, card_id)