CREATE OR REPLACE FUNCTION supply.supplies_get_by_param(_supply_id INTEGER, _shop_id INTEGER, _supplier_id INTEGER,
                                                        _start_date DATE, _end_date DATE) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT s.supply_id,
                     s.shop_id,
                     s.supplier_id,
                     s.supply_info,
                     s.order_dt,
                     s.supply_dt,
                     s.staff_id_ordered,
                     s.staff_id_tooked
              FROM supply.supplies s
              WHERE s.supply_id    = COALESCE(_supply_id, s.supply_id)
                AND s.shop_id      = COALESCE(_shop_id, s.shop_id)
                AND s.supplier_id  = COALESCE(_supplier_id, s.supplier_id)
                AND s.order_dt    >= COALESCE(_start_date::timestamptz, s.order_dt)
                AND s.order_dt    <= COALESCE(_end_date::timestamptz + interval '1 day', s.order_dt)) res;

END
$$;