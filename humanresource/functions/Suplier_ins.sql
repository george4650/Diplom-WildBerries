CREATE OR REPLACE FUNCTION humanresource.supplier_ins(_src jsonb) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    INSERT INTO humanresource.suppliers(supplier_id, name, phone, email, dt)
    SELECT nextval('humanresource.supplier_sq') as supplier_id,
           s.name,
           s.phone,
           s.email,
           _dt                                  as dt
    FROM jsonb_to_record(_src) as s (
                                     name varchar(100),
                                     phone VARCHAR(11),
                                     email varchar(50)
        );

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;