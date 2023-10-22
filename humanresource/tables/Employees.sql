CREATE TABLE IF NOT EXISTS humanresource.employees
(
    employee_id INTEGER,
    shop_id     SMALLINT,
    post_id     SMALLINT,
    first_name  VARCHAR(32) NOT NULL,
    surname     VARCHAR(32) NOT NULL,
    patronymic  VARCHAR(32) NOT NULL,
    phone       VARCHAR(11) NOT NULL,
    email       VARCHAR(50),
    deleted_at  TIMESTAMPTZ,
    CONSTRAINT pk_employees_employee_id_shop_id PRIMARY KEY (employee_id, shop_id)
);