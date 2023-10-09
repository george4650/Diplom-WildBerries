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
            SET good_type = s.good_type, description = s.description, name = s.name
            FROM (SELECT nm_id, good_type, description
                  FROM jsonb_to_record(_src) as s (
                                                   nm_id integer,
                                                   name varchar(100),
                                                   good_type integer,
                                                   description varchar(1500)
                      )) as s
            WHERE nm_id = s.nm_id
            RETURNING *)

    INSERT
    INTO history.goodschanges(nm_id,
                              name,
                              good_type,
                              description,
                              staff_id,
                              ch_dt)
    SELECT cu.nm_id,
           name,
           cu.good_type,
           cu.description,
           _staff_id,
           _dt
    FROM cte_upd cu;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;