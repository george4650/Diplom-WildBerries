CREATE OR REPLACE FUNCTION humanresource.supplier_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _supplier_id integer;
    _name        varchar(100);
    _phone       VARCHAR(11);
    _email       varchar(50);
BEGIN


    SELECT COALESCE(supplier_id, nextval('humanresource.supplier_sq')) as supplier_id,
           s.name,
           s.phone,
           s.email
    INTO _supplier_id, _name , _phone , _email
    FROM jsonb_to_record(_src) as s (
                                     supplier_id integer,
                                     name varchar(100),
                                     phone VARCHAR(11),
                                     email varchar(50)
        );

    WITH ins_cte AS (
        INSERT INTO humanresource.suppliers AS e (supplier_id,
                                                  name,
                                                  phone,
                                                  email
            )
            SELECT _supplier_id,
                   _name,
                   _phone,
                   _email
            ON CONFLICT (supplier_id) DO UPDATE
                SET supplier_id = excluded.supplier_id,
                    name = excluded.name,
                    phone = excluded.phone,
                    email = excluded.email
            RETURNING e.*)

    INSERT
    INTO history.supplierschanges AS ec (supplier_id,
                                         name,
                                         phone,
                                         email,
                                         staff_id,
                                         ch_dt)
    SELECT ic.supplier_id,
           ic.name,
           ic.phone,
           ic.email,
           _staff_id,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;