CREATE OR REPLACE FUNCTION whsync.goods_sync_import(_src JSONB) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH cte AS (SELECT COALESCE(nm_id, nextval('petshop.nm_sq')) as                nm_id,
                        s.name,
                        s.good_type_id,
                        s.description,
                        s.selling_price,
                        s.dt,
                        ROW_NUMBER() OVER (PARTITION BY s.nm_id ORDER BY s.dt DESC) rn
                 FROM jsonb_to_recordset(_src) as s (
                                                     nm_id INTEGER,
                                                     name VARCHAR(100),
                                                     good_type_id INTEGER,
                                                     description VARCHAR(1500),
                                                     selling_price NUMERIC(8, 2),
                                                     dt TIMESTAMPTZ
                     )),

     cte_ins AS (
        INSERT INTO petshop.goods as g (nm_id,
                                        name,
                                        good_type_id,
                                        description,
                                        selling_price,
                                        dt)
            SELECT c.nm_id,
                   c.name,
                   c.good_type_id,
                   c.description,
                   c.selling_price,
                   c.dt
            FROM cte c
            WHERE c.rn = 1
            ON CONFLICT (nm_id) DO UPDATE
                SET name          = excluded.name,
                    good_type_id  = excluded.good_type_id,
                    description   = excluded.description,
                    selling_price = excluded.selling_price
                WHERE g.dt < excluded.dt
            RETURNING g.*)


    INSERT INTO history.goodschanges (nm_id,
                                      name,
                                      good_type_id,
                                      description,
                                      selling_price,
                                      dt,
                                      ch_dt)
    SELECT ci.nm_id,
           ci.name,
           ci.good_type_id,
           ci.description,
           ci.selling_price,
           ci.dt,
           _dt
    FROM cte_ins ci;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;