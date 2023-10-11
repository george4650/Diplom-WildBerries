CREATE TABLE IF NOT EXISTS humanresource.employees
(
    employee_id integer,
    shop_id     smallint,
    post_id     smallint,
    first_name  varchar(32) NOT NULL,
    surname     varchar(32) NOT NULL,
    patronymic  varchar(32) NOT NULL,
    phone       varchar(11) NOT NULL,
    email       varchar(50),
    deleted_at  TIMESTAMPTZ,
    CONSTRAINT pk_employees_employee_id_shop_id PRIMARY KEY (employee_id, shop_id)
);