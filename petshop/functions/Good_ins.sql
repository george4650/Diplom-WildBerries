CREATE OR REPLACE FUNCTION petshop.good_ins(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH cte_ins AS (
        INSERT INTO petshop.goods (good_id, good_type, description)
            SELECT nextval('petshop.good_sq') as good_id,
                   s.description,
                   s.good_type
            FROM jsonb_to_record(_src) as s (
                                             description varchar(1500),
                                             good_type integer
                )
            RETURNING *)

    INSERT INTO history.goodschanges(good_id, good_type, description, staff_id, ch_dt)
    SELECT ci.good_id, ci.good_type, ci.description, _staff_id, _dt
    FROM cte_ins ci;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;