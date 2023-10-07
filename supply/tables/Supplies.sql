CREATE TABLE IF NOT EXISTS supply.supplies
(
    supply_id      bigint
        constraint pk_supplies PRIMARY KEY,
    shop_id        integer       NOT NULL,
    supplier_id    integer       NOT NULL,
    good_id        bigint        NOT NULL,
    purchase_price numeric(8, 2) NOT NULL,
    quantity       integer       NOT NULL,
    dt             TIMESTAMPTZ   NOT NULL
)