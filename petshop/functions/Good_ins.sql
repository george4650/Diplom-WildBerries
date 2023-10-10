CREATE OR REPLACE FUNCTION petshop.good_ins(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH cte_ins AS (
        INSERT INTO petshop.goods (nm_id, name, good_type, description, dt)
            SELECT nextval('petshop.good_sq') as nm_id,
                   s.name,
                   s.good_type,
                   s.description,
                   s.dt
            FROM jsonb_to_record(_src) as s (
                                             name varchar(100),
                                             good_type integer,
                                             description varchar(1500),
                                             dt timestamptz
                )
            RETURNING *)

    INSERT
    INTO history.goodschanges(nm_id,
                              name,
                              good_type,
                              description,
                              staff_id,
                              dt,
                              ch_dt)
    SELECT ci.nm_id,
           name,
           ci.good_type,
           ci.description,
           _staff_id,
           _dt,
           _dt
    FROM cte_ins ci;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;