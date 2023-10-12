CREATE OR REPLACE FUNCTION supply.get_supplies_by_supplier_id(_supplier_id integer, _start_date date DEFAULT NULL,
                                                              _endDate date DEFAULT NULL) returns json
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
              WHERE s.supplier_id = _supplier_id
                AND s.order_dt::date >= COALESCE(_start_date, (now() - interval '100' YEAR))
                AND s.order_dt::date <= COALESCE(_endDate, (now() + interval '100' YEAR))) res;

END
$$;