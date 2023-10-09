CREATE TABLE IF NOT EXISTS sales.sales
(
    sale_id     bigint
        CONSTRAINT pk_sales PRIMARY KEY,
    client_id   integer,
    nm_id     integer       NOT NULL,
    employee_id integer       NOT NULL,
    shop_id     integer       NOT NULL,
    price       numeric(8, 2) NOT NULL,
    discount    integer,
    quantity    integer       NOT NULL,
    dt          TIMESTAMPTZ   NOT NULL
)