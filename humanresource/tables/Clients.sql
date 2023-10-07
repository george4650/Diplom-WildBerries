CREATE TABLE IF NOT EXISTS humanresource.clients
(
    client_id  bigint
        CONSTRAINT pk_clients PRIMARY KEY,
    first_name varchar(32) NOT NULL,
    surname    varchar(32) NOT NULL,
    phone      varchar(11) NOT NULL,
    email      varchar(50)
)