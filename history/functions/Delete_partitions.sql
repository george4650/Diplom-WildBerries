CREATE OR REPLACE FUNCTION history.delete_partitions(_table_name varchar(50)) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt              timestamptz := now() AT TIME ZONE 'Europe/Moscow';
    _full_table_name varchar(100);
    _result_tables   text[];
    _query           varchar(500);
    _partition_name  text;
BEGIN

    _full_table_name := CONCAT('history.', _table_name);

    select array_agg(CONCAT('history.', partition_name))
    FROM (select res.partition_name as partition_name
          FROM (select pt.relname                                                            as partition_name,
                       split_part(pg_get_expr(pt.relpartbound, pt.oid, true), 'TO', 2)::date as partition_end_date
                from pg_class base_tb
                         join pg_inherits i on i.inhparent = base_tb.oid
                         join pg_class pt on pt.oid = i.inhrelid
                where base_tb.oid = _full_table_name::regclass) res
          where partition_end_date < _dt - interval '3 month') res
    INTO _result_tables;

    IF array_length(_result_tables, 1) IS NOT NULL THEN
        FOREACH _partition_name IN ARRAY _result_tables
            LOOP

                _query := CONCAT('DROP TABLE ', _partition_name);
                EXECUTE _query;

                raise notice 'Deleted table:  %' , _partition_name;
            END LOOP;
    END IF;

    RETURN JSONB_BUILD_OBJECT('data', NULL);

END;
$$;