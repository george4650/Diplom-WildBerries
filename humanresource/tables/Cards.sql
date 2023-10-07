CREATE TABLE IF NOT EXISTS humanresource.cards
(
    card_id     bigint
        CONSTRAINT pk_cards PRIMARY KEY,
    client_id   bigint      NOT NULL,
    employee_id integer,
    deleted_at  TIMESTAMPTZ,
    dt          TIMESTAMPTZ NOT NULL
)