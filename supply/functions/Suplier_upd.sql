CREATE OR REPLACE FUNCTION supply.supplier_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt timestamptz := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH ins_cte AS (
        INSERT INTO supply.suppliers AS e (supplier_id,
                                           name,
                                           phone,
                                           email,
                                           deleted_at
            )
            SELECT COALESCE(s.supplier_id, nextval('supply.supplier_sq')) as supplier_id,
                   s.name,
                   s.phone,
                   s.email,
                   s.deleted_at
            FROM jsonb_to_record(_src) as s (
                                             supplier_id integer,
                                             name varchar(100),
                                             phone varchar(11),
                                             email varchar(50),
                                             deleted_at timestamptz
                )
                     LEFT JOIN supply.suppliers sp ON sp.supplier_id = s.supplier_id
            ON CONFLICT (supplier_id) DO UPDATE
                SET name  = excluded.name,
                    phone = excluded.phone,
                    email = excluded.email,
                    deleted_at = excluded.deleted_at
            RETURNING e.*)


    INSERT
    INTO history.supplierschanges AS ec (supplier_id,
                                         name,
                                         phone,
                                         email,
                                         deleted_at,
                                         ch_staff_id,
                                         ch_dt)
    SELECT ic.supplier_id,
           ic.name,
           ic.phone,
           ic.email,
           ic.deleted_at,
           _staff_id,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;