CREATE TABLE IF NOT EXISTS humanresource.cards
(
    card_id       integer
        CONSTRAINT pk_cards PRIMARY KEY,
    client_id     integer     NOT NULL,
    card_type_id  smallint    NOT NULL,
    employee_id   integer,
    ransom_amount numeric(15, 2),
    dt            TIMESTAMPTZ NOT NULL,
    deleted_at    TIMESTAMPTZ
);