CREATE TABLE IF NOT EXISTS humanresource.employees
(
    employee_id integer
        CONSTRAINT pk_employees PRIMARY KEY,
    shop_id     integer     NOT NULL,
    first_name  varchar(32) NOT NULL,
    surname     varchar(32) NOT NULL,
    patronymic  varchar(32) NOT NULL,
    salary      integer     NOT NULL,
    post        varchar(50) NOT NULL,
    phone       varchar(11) NOT NULL,
    email       varchar(50),
    deleted_at  TIMESTAMPTZ
)