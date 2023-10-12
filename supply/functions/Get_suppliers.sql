CREATE OR REPLACE FUNCTION supply.get_suppliers() returns json
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
              FROM supply.suppliers c) res;

END
$$;