CREATE OR REPLACE FUNCTION humanresource.count_premium(_employee_id INTEGER) RETURNS INTEGER
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _premium INTEGER;
BEGIN
    SELECT count(*) * 100
    INTO _premium
    FROM humanresource.clients c
    WHERE c.employee_id = _employee_id
      AND EXTRACT(MONTH FROM dt) = EXTRACT(MONTH FROM now());

    RETURN _premium;
END
$$;