CREATE OR REPLACE FUNCTION supply.supplier_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          timestamptz := now() AT TIME ZONE 'Europe/Moscow';
    _supplier_id integer;
    _name        varchar(100);
    _phone       varchar(11);
    _email       varchar(50);
    _deleted_at  timestamptz;
BEGIN

    SELECT COALESCE(supplier_id, nextval('supply.supplier_sq')) as supplier_id,
           s.name,
           s.phone,
           s.email,
           s.deleted_at
    INTO _supplier_id, _name, _phone, _email, _deleted_at
    FROM jsonb_to_record(_src) as s (
                                     supplier_id integer,
                                     name varchar(100),
                                     phone varchar(11),
                                     email varchar(50),
                                     deleted_at timestamptz
        );

    IF _deleted_at IS NOT NULL THEN

        UPDATE supply.suppliers
        SET deleted_at = _dt
        WHERE supplier_id = _supplier_id;

        RETURN JSONB_BUILD_OBJECT('data', NULL);

    END IF;

    WITH ins_cte AS (
        INSERT INTO supply.suppliers AS e (supplier_id,
                                           name,
                                           phone,
                                           email
            )
            SELECT _supplier_id,
                   _name,
                   _phone,
                   _email
            ON CONFLICT (supplier_id) DO UPDATE
                SET name = excluded.name,
                    phone = excluded.phone,
                    email = excluded.email
            RETURNING e.*)


    INSERT INTO history.supplierschanges AS ec (supplier_id,
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