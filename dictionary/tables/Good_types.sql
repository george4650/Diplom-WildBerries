CREATE TABLE IF NOT EXISTS dictionary.goodtypes
(
    good_type_id smallserial
        CONSTRAINT pk_goodtypes PRIMARY KEY,
    name         varchar(100) NOT NULL,
    CONSTRAINT uq_goodtypes_name UNIQUE (name)
);