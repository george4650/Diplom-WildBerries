CREATE TABLE IF NOT EXISTS supply.suppliers
(
    supplier_id INTEGER
        CONSTRAINT pk_suppliers PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    phone       VARCHAR(11)  NOT NULL,
    email       VARCHAR(50),
    deleted_at  TIMESTAMPTZ
);