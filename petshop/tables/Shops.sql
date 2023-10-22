CREATE TABLE IF NOT EXISTS petshop.shops
(
    shop_id SMALLSERIAL
        CONSTRAINT pk_shops PRIMARY KEY,
    address VARCHAR(300) NOT NULL,
    phone   VARCHAR(11)  NOT NULL
);