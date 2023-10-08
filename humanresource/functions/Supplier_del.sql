CREATE OR REPLACE FUNCTION humanresource.supplier_del(_supplier_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    UPDATE humanresource.suppliers
    SET deleted_at = _dt
    WHERE supplier_id = _supplier_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;