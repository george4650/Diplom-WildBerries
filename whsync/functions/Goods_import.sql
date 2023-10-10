CREATE OR REPLACE FUNCTION whsync.goods_import(_src jsonb) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$

BEGIN

    INSERT INTO petshop.goods as g (nm_id, name, good_type, description, dt)
    SELECT COALESCE(nm_id, nextval('petshop.good_sq')) as nm_id,
           s.name,
           s.good_type,
           s.description,
           s.dt
    FROM jsonb_to_recordset(_src) as s (
                                        nm_id integer,
                                        name varchar(100),
                                        good_type integer,
                                        description varchar(1500),
                                        dt timestamptz
        )
    ON CONFLICT (nm_id) DO UPDATE
        SET name        =excluded.name,
            good_type   =excluded.good_type,
            description =excluded.description
    WHERE g.dt < excluded.dt;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;