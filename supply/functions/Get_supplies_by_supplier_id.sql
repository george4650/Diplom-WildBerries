CREATE OR REPLACE FUNCTION supply.get_supplies_by_supplier_id(_supplier_id integer, _start_date date DEFAULT NULL,
                                                              _endDate date DEFAULT NULL) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT supply_id,
                     shop_id,
                     supplier_id,
                     nm_id,
                     purchase_price,
                     quantity,
                     dt
              FROM supply.supplies s
              WHERE s.supplier_id = _supplier_id
                AND dt::date >= COALESCE(_start_date, (now() - interval '100' YEAR))
                AND dt::date <= COALESCE(_endDate, (now() + interval '100' YEAR))) res;

END
$$;