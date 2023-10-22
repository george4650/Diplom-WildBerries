CREATE OR REPLACE FUNCTION supply.supplier_upd(_src JSONB, _staff_id INTEGER) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _supplier_id INTEGER;
    _name        VARCHAR(100);
    _phone       VARCHAR(11);
    _email       VARCHAR(50);
    _deleted_at  TIMESTAMPTZ;
BEGIN

    SELECT COALESCE(s.supplier_id, nextval('supply.supplier_sq')) as supplier_id,
           s.name,
           s.phone,
           s.email,
           s.deleted_at
    INTO _supplier_id ,
         _name ,
         _phone ,
         _email ,
         _deleted_at
    FROM jsonb_to_record(_src) as s (
                                     supplier_id INTEGER,
                                     name VARCHAR(100),
                                     phone VARCHAR(11),
                                     email VARCHAR(50),
                                     deleted_at TIMESTAMPTZ
        )
             LEFT JOIN supply.suppliers sp ON sp.supplier_id = s.supplier_id;


    IF _deleted_at IS NOT NULL THEN

        WITH cte_upd AS (
            UPDATE supply.suppliers s SET
                deleted_at = _deleted_at
                WHERE s.supplier_id = _supplier_id
                RETURNING s.*)


        INSERT INTO history.supplierschanges AS ec (supplier_id,
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
        FROM cte_upd ic;

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
                SET name  = excluded.name,
                    phone = excluded.phone,
                    email = excluded.email
            RETURNING e.*)


    INSERT INTO history.supplierschanges AS ec (supplier_id,
                                                name,
                                                phone,
                                                email,
                                                ch_staff_id,
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