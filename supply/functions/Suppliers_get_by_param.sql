CREATE OR REPLACE FUNCTION supply.suppliers_get_by_param(_supplier_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT supplier_id,
                     name,
                     phone,
                     email,
                     deleted_at
              FROM supply.suppliers c
              WHERE c.supplier_id = COALESCE(_supplier_id, c.supplier_id)) res;

END
$$;