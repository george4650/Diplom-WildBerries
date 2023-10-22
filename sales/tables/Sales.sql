CREATE TABLE IF NOT EXISTS sales.sales
(
    sale_id     BIGINT
        CONSTRAINT pk_sales PRIMARY KEY,
    card_id     INTEGER,
    employee_id INTEGER       NOT NULL,
    shop_id     SMALLINT      NOT NULL,
    sale_info   JSONB         NOT NULL,--nm_id, quantity, product_price
    total_price NUMERIC(8, 2) NOT NULL,
    discount    NUMERIC(8, 2),
    dt          TIMESTAMPTZ   NOT NULL
);

CREATE INDEX sales_idx ON sales.sales (sale_id)