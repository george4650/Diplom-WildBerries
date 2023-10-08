CREATE TABLE IF NOT EXISTS history.goodschanges
(
    log_id      bigserial
        CONSTRAINT pk_goodschanges PRIMARY KEY,
    good_id     integer,
    good_type   integer       NOT NULL,
    description varchar(1500) NOT NULL,
    staff_id    INT,
    ch_dt       TIMESTAMPTZ   NOT NULL
)