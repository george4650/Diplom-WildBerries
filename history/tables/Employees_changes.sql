CREATE TABLE IF NOT EXISTS history.employeeschanges
(
    log_id      bigserial
        CONSTRAINT pk_employeeschanges PRIMARY KEY,
    employee_id integer,
    shop_id     integer     NOT NULL,
    first_name  varchar(32) NOT NULL,
    surname     varchar(32) NOT NULL,
    patronymic  varchar(32) NOT NULL,
    salary      integer     NOT NULL,
    post        varchar(50) NOT NULL,
    phone       varchar(11) NOT NULL,
    email       varchar(50),
    is_deleted  BOOLEAN,
    staff_id    INT         NOT NULL,
    ch_dt       TIMESTAMPTZ NOT NULL
)