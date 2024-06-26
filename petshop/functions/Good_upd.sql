CREATE OR REPLACE FUNCTION petshop.good_upd(_src JSONB, _staff_id INTEGER) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH cte_ins AS (
        INSERT INTO petshop.goods as g (nm_id, name, good_type_id, description, selling_price, dt)
            SELECT COALESCE(s.nm_id, nextval('petshop.nm_sq')) as nm_id,
                   s.name,
                   s.good_type_id,
                   s.description,
                   s.selling_price,
                   _dt
            FROM jsonb_to_record(_src) as s (
                                             nm_id INTEGER,
                                             name VARCHAR(100),
                                             good_type_id INTEGER,
                                             description VARCHAR(1500),
                                             selling_price NUMERIC(8, 2)
                )
                     LEFT JOIN petshop.goods g ON g.nm_id = s.nm_id
            ON CONFLICT (nm_id) DO UPDATE
                SET name = excluded.name,
                    good_type_id = excluded.good_type_id,
                    description = excluded.description,
                    selling_price = excluded.selling_price
            RETURNING g.*),

         cte_history_ins AS (
             INSERT INTO history.goodschanges (nm_id,
                                               name,
                                               good_type_id,
                                               description,
                                               selling_price,
                                               dt,
                                               ch_staff_id,
                                               ch_dt)
                 SELECT ci.nm_id,
                        ci.name,
                        ci.good_type_id,
                        ci.description,
                        ci.selling_price,
                        ci.dt,
                        _staff_id,
                        _dt
                 FROM cte_ins ci
                 RETURNING *)


    INSERT INTO whsync.goodsssync (nm_id,
                                   name,
                                   good_type_id,
                                   description,
                                   selling_price,
                                   dt,
                                   ch_staff_id,
                                   ch_dt,
                                   sync_dt)
    SELECT ch.nm_id,
           ch.name,
           ch.good_type_id,
           ch.description,
           ch.selling_price,
           ch.dt,
           _staff_id,
           _dt,
           _dt
    FROM cte_history_ins ch;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;