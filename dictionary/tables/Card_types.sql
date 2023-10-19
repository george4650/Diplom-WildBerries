CREATE TABLE IF NOT EXISTS dictionary.cardtypes
(
    card_type_id  smallserial
        CONSTRAINT pk_cardtypes PRIMARY KEY,
    name          varchar(100) NOT NULL,
    ransom_amount integer      NOT NULL,
    discount      smallint     NOT NULL,
    CONSTRAINT uq_cardtypes_name UNIQUE (name)
);