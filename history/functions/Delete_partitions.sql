CREATE OR REPLACE FUNCTION history.delete_partitions(_table_name VARCHAR(50)) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt              TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _full_table_name VARCHAR(100);
    _result_tables   TEXT[];
    _query           VARCHAR(500);
    _partition_name  TEXT;
BEGIN

    _full_table_name := CONCAT('history.', _table_name);

    SELECT array_agg(CONCAT('history.', partition_name))
    FROM (SELECT res.partition_name AS partition_name
          FROM (SELECT pt.relname                                                            AS partition_name,
                       split_part(pg_get_expr(pt.relpartbound, pt.oid, true), 'TO', 2)::DATE AS partition_end_date
                FROM pg_class base_tb
                         JOIN pg_inherits i ON i.inhparent = base_tb.oid
                         JOIN pg_class pt ON pt.oid = i.inhrelid
                WHERE base_tb.oid = _full_table_name::regclass) res
          WHERE partition_end_date < _dt - interval '3 month') res
    INTO _result_tables;

    IF array_length(_result_tables, 1) IS NOT NULL THEN
        FOREACH _partition_name IN ARRAY _result_tables
            LOOP

                _query := CONCAT('DROP TABLE ', _partition_name);
                EXECUTE _query;

                RAISE NOTICE 'Deleted table:  %' , _partition_name;
            END LOOP;
    END IF;

    RETURN JSONB_BUILD_OBJECT('data', NULL);

END;
$$;