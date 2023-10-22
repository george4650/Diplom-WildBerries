CREATE TABLE IF NOT EXISTS history.employeeschanges
(
    log_id      BIGSERIAL
        CONSTRAINT pk_employeeschanges PRIMARY KEY,
    employee_id INTEGER,
    shop_id     SMALLINT,
    post_id     SMALLINT,
    first_name  VARCHAR(32) NOT NULL,
    surname     VARCHAR(32) NOT NULL,
    patronymic  VARCHAR(32) NOT NULL,
    phone       VARCHAR(11) NOT NULL,
    email       VARCHAR(50),
    deleted_at  TIMESTAMPTZ,
    ch_staff_id INTEGER     NOT NULL,
    ch_dt       TIMESTAMPTZ NOT NULL
);