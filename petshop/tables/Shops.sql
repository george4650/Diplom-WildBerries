CREATE TABLE IF NOT EXISTS petshop.shops
(
    shop_id smallserial
        CONSTRAINT pk_shops PRIMARY KEY,
    address varchar(300) NOT NULL,
    phone   varchar(11)  NOT NULL
);