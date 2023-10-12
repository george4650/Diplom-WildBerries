CREATE TABLE IF NOT EXISTS sales.sales
(
    sale_id     bigint
        CONSTRAINT pk_sales PRIMARY KEY,
    card_id     integer,
    employee_id integer      NOT NULL,
    shop_id     smallint      NOT NULL,
    sale_info   jsonb         NOT NULL,--nm_id, quantity, product_price
    total_price numeric(8, 2) NOT NULL,
    discount    numeric(8, 2),
    dt          TIMESTAMPTZ   NOT NULL
);