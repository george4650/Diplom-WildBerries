CREATE OR REPLACE FUNCTION petshop.good_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN


    WITH cte_upd AS (
        UPDATE petshop.goods
            SET good_type = s.good_type AND description = s.description
            FROM (SELECT good_id, good_type, description
                  FROM jsonb_to_record(_src) as s (
                                                   good_id integer,
                                                   good_type integer,
                                                   description varchar(1500)
                      )) as s
            WHERE good_id = s.good_id
            RETURNING *)

    INSERT INTO history.goodschanges(good_id, good_type, description, staff_id, ch_dt)
    SELECT cu.good_id, cu.good_type, cu.description, _staff_id, _dt
    FROM cte_upd cu;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;