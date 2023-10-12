CREATE TABLE IF NOT EXISTS history.storagechanges
(
    log_id      bigserial,
    shop_id     integer,
    nm_id       integer,
    quantity    integer DEFAULT 0,
    ch_staff_id INT,
    ch_dt       TIMESTAMPTZ NOT NULL,
    CONSTRAINT ch_quantity CHECK (quantity >= 0 ),
    CONSTRAINT pk_storagechanges_log_id_ch_dt PRIMARY KEY (log_id, ch_dt)
) PARTITION BY RANGE (ch_dt);

CREATE TABLE history.storagechanges_Oct23 PARTITION OF history.storagechanges FOR VALUES FROM ('2023-10-01') TO ('2023-10-31');
CREATE TABLE history.storagechanges_Nov23 PARTITION OF history.storagechanges FOR VALUES FROM ('2023-11-01') TO ('2023-11-30');
CREATE TABLE history.storagechanges_Dec23 PARTITION OF history.storagechanges FOR VALUES FROM ('2023-12-01') TO ('2023-12-31');
CREATE TABLE history.storagechanges_Jun24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-01-01') TO ('2024-01-31');
CREATE TABLE history.storagechanges_Feb24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-02-01') TO ('2024-02-29');
CREATE TABLE history.storagechanges_Mar24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-03-01') TO ('2024-03-31');
CREATE TABLE history.storagechanges_Apr24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-04-01') TO ('2024-04-30');
CREATE TABLE history.storagechanges_May24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-05-01') TO ('2024-05-31');
CREATE TABLE history.storagechanges_June24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-06-01') TO ('2024-06-30');
CREATE TABLE history.storagechanges_Jul24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-07-01') TO ('2024-07-31');
CREATE TABLE history.storagechanges_Aug24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-08-01') TO ('2024-08-31');
CREATE TABLE history.storagechanges_Sep24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-09-01') TO ('2024-09-30');