CREATE OR REPLACE FUNCTION whsync.goods_sync_import(_src jsonb) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$

BEGIN

    INSERT INTO petshop.goods as g (nm_id, name, good_type_id, description, selling_price, dt)
    SELECT COALESCE(nm_id, nextval('petshop.nm_sq')) as nm_id,
           s.name,
           s.good_type,
           s.description,
           s.selling_price,
           s.dt
    FROM jsonb_to_recordset(_src) as s (
                                        nm_id integer,
                                        name varchar(100),
                                        good_type integer,
                                        description varchar(1500),
                                        selling_price numeric(8, 2),
                                        dt timestamptz
        )
    ON CONFLICT (nm_id) DO UPDATE
        SET name          =excluded.name,
            good_type     =excluded.good_type_id,
            description   =excluded.description,
            selling_price =excluded.description
    WHERE g.dt < excluded.dt;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;