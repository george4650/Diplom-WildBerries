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
            SET good_type = s.good_type,
                description = s.description,
                name = s.name
            FROM (SELECT nm_id,
                         good_type,
                         description
                  FROM jsonb_to_record(_src) as s (
                                                   nm_id integer,
                                                   name varchar(100),
                                                   good_type integer,
                                                   description varchar(1500),
                                                   dt timestamptz
                      )) as s
            WHERE nm_id = s.nm_id
            RETURNING *),

         cte_history_ins AS (
             INSERT INTO history.goodschanges (nm_id,
                                               name,
                                               good_type,
                                               description,
                                               staff_id,
                                               dt,
                                               ch_dt)
                 SELECT cu.nm_id,
                        cu.name,
                        cu.good_type,
                        cu.description,
                        _staff_id,
                        cu.dt,
                        _dt
                 FROM cte_upd cu
                 RETURNING *)


    INSERT INTO whsync.goodsssync (nm_id,
                            name,
                            good_type,
                            description,
                            staff_id,
                            dt,
                            ch_dt)
    SELECT ch.nm_id,
           ch.name,
           ch.good_type,
           ch.description,
           _staff_id,
           ch.dt,
           _dt
    FROM cte_history_ins ch;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;