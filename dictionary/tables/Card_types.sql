CREATE TABLE IF NOT EXISTS dictionary.cardtypes
(
    card_type_id  SMALLSERIAL
        CONSTRAINT pk_cardtypes PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    ransom_amount INTEGER      NOT NULL,
    discount      SMALLINT     NOT NULL,
    CONSTRAINT uq_cardtypes_name UNIQUE (name)
);