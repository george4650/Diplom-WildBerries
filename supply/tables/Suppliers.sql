CREATE TABLE IF NOT EXISTS supply.suppliers
(
    supplier_id integer
        CONSTRAINT pk_suppliers PRIMARY KEY,
    name        varchar(100) NOT NULL,
    phone       VARCHAR(11)  NOT NULL,
    email       varchar(50),
    deleted_at  TIMESTAMPTZ
);