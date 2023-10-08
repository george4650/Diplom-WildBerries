CREATE OR REPLACE FUNCTION humanresource.employee_del(_employee_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    UPDATE humanresource.employees
    SET deleted_at = _dt
    WHERE employee_id = _employee_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;