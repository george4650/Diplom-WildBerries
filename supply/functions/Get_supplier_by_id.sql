CREATE OR REPLACE FUNCTION humanresource.get_supplier_by_id(_supplier_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('supplier_id', supplier_id, 'name', name, 'phone', phone,
                              'email', email, 'deleted_at', deleted_at)
        FROM (SELECT supplier_id, name, phone, email, deleted_at
              FROM supply.suppliers c
              WHERE c.supplier_id = _supplier_id) res;

END
$$;