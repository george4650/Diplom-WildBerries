CREATE TABLE IF NOT EXISTS humanresource.clients
(
    client_id     INTEGER,
    card_id       INTEGER,
    card_type_id  SMALLINT    NOT NULL,
    first_name    VARCHAR(32) NOT NULL,
    surname       VARCHAR(32) NOT NULL,
    phone         VARCHAR(11) NOT NULL,
    email         VARCHAR(50),
    employee_id   INTEGER,
    ransom_amount NUMERIC(15, 2) DEFAULT 0,
    dt            TIMESTAMPTZ NOT NULL,
    CONSTRAINT pk_clients_client_id UNIQUE (client_id),
    CONSTRAINT pk_clients_client_id PRIMARY KEY (client_id)
);

CREATE INDEX clients_idx ON humanresource.clients (client_id, card_id)