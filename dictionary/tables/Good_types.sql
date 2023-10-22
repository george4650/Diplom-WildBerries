CREATE TABLE IF NOT EXISTS dictionary.goodtypes
(
    good_type_id SMALLSERIAL
        CONSTRAINT pk_goodtypes PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    CONSTRAINT uq_goodtypes_name UNIQUE (name)
);