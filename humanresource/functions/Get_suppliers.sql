CREATE OR REPLACE FUNCTION humanresource.get_suppliers( integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT supplier_id, name, phone, email, deleted_at
              FROM humanresource.suppliers c) res;

END
$$;