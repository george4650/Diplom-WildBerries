CREATE OR REPLACE FUNCTION supply.make_order(_data jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH cte_ins AS (
        INSERT INTO supply.supplies AS s (supply_id,
                                          shop_id,
                                          supplier_id,
                                          supply_info,
                                          order_dt,
                                          staff_id_ordered)
            SELECT nextval('supply.supply_sq') as supply_id,
                   shop_id,
                   supplier_id,
                   supply_info,
                   _dt                         as dt,
                   _staff_id                   as staff_id_ordered
            FROM jsonb_to_recordset(_data) as s (
                                                 shop_id integer,
                                                 supplier_id integer,
                                                 supply_info jsonb
                )
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