CREATE TABLE IF NOT EXISTS history.employeeschanges
(
    log_id      bigserial
        CONSTRAINT pk_employeeschanges PRIMARY KEY,
    employee_id integer,
    shop_id     smallint,
    post_id     smallint,
    first_name  varchar(32) NOT NULL,
    surname     varchar(32) NOT NULL,
    patronymic  varchar(32) NOT NULL,
    phone       varchar(11) NOT NULL,
    email       varchar(50),
    deleted_at  TIMESTAMPTZ,
    ch_staff_id INT         NOT NULL,
    ch_dt       TIMESTAMPTZ NOT NULL
);