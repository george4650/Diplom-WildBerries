CREATE OR REPLACE FUNCTION supply.make_order(_data jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message varchar(500);
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _supply_id   bigint;
    _shop_id     integer;
    _supplier_id integer;
    _supply_info jsonb;

BEGIN

    SELECT COALESCE(d.supply_id, nextval('supply.supply_sq')) as supply_id,
           d.shop_id,
           d.supplier_id,
           d.supply_info
    INTO _supply_id, _shop_id, _supplier_id, _supply_info
    FROM jsonb_to_record(_data) as d (supply_id bigint,
                                      shop_id integer,
                                      supplier_id integer,
                                      supply_info jsonb
        );


    SELECT 'Данная поставка уже принята'
    INTO _err_message
    FROM supply.supplies s
    WHERE s.supply_id = _supply_id
      and supply_dt is not null;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('supply.make_order', _err_message, null);
    END IF;


    WITH cte_ins AS (
        INSERT INTO supply.supplies AS s (supply_id,
                                          shop_id,
                                          supplier_id,
                                          supply_info,
                                          order_dt,
                                          staff_id_ordered)
            SELECT _supply_id, _shop_id, _supplier_id, _supply_info, _dt, _staff_id
            ON CONFLICT (supply_id) DO UPDATE
                SET supply_info      = excluded.supply_info,
                    staff_id_ordered = excluded.staff_id_ordered
            RETURNING s.*)

    INSERT INTO history.supplieschanges AS ec (supply_id,
                                               shop_id,
                                               supplier_id,
                                               supply_info,
                                               order_dt,
                                               staff_id_ordered,
                                               ch_dt)
    SELECT ci.supply_id,
           ci.shop_id,
           ci.supplier_id,
           ci.supply_info,
           ci.order_dt,
           ci.staff_id_ordered,
           _dt
    FROM cte_ins ci;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;