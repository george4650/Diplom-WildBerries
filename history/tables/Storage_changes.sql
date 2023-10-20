CREATE TABLE IF NOT EXISTS history.storagechanges
(
    log_id      bigserial,
    shop_id     smallint,
    nm_id       integer,
    quantity    integer DEFAULT 0,
    ch_staff_id INT,
    ch_dt       TIMESTAMPTZ NOT NULL
) PARTITION BY RANGE (ch_dt);

CREATE TABLE IF NOT EXISTS history.storagechanges_Oct23 PARTITION OF history.storagechanges FOR VALUES FROM ('2023-10-01') TO ('2023-10-31');
CREATE TABLE IF NOT EXISTS history.storagechanges_Nov23 PARTITION OF history.storagechanges FOR VALUES FROM ('2023-11-01') TO ('2023-11-30');
CREATE TABLE IF NOT EXISTS history.storagechanges_Dec23 PARTITION OF history.storagechanges FOR VALUES FROM ('2023-12-01') TO ('2023-12-31');
CREATE TABLE IF NOT EXISTS history.storagechanges_Jun24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-01-01') TO ('2024-01-31');
CREATE TABLE IF NOT EXISTS history.storagechanges_Feb24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-02-01') TO ('2024-02-29');
CREATE TABLE IF NOT EXISTS history.storagechanges_Mar24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-03-01') TO ('2024-03-31');
CREATE TABLE IF NOT EXISTS history.storagechanges_Apr24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-04-01') TO ('2024-04-30');
CREATE TABLE IF NOT EXISTS history.storagechanges_May24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-05-01') TO ('2024-05-31');
CREATE TABLE IF NOT EXISTS history.storagechanges_June24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-06-01') TO ('2024-06-30');
CREATE TABLE IF NOT EXISTS history.storagechanges_Jul24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-07-01') TO ('2024-07-31');
CREATE TABLE IF NOT EXISTS history.storagechanges_Aug24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-08-01') TO ('2024-08-31');
CREATE TABLE IF NOT EXISTS history.storagechanges_Sep24 PARTITION OF history.storagechanges FOR VALUES FROM ('2024-09-01') TO ('2024-09-30');