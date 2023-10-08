CREATE TABLE IF NOT EXISTS dictionary.goodtypes
(
    good_type serial
        CONSTRAINT pk_goodtypes PRIMARY KEY,
    name      varchar(100) NOT NULL
)