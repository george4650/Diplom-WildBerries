CREATE TABLE IF NOT EXISTS humanresource.cards
(
    card_id     integer,
    client_id   integer     NOT NULL,
    employee_id integer,
    dt          TIMESTAMPTZ NOT NULL,
    deleted_at  TIMESTAMPTZ,
    CONSTRAINT pk_cards_card_id_client_id PRIMARY KEY (card_id, client_id)
)