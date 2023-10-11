CREATE OR REPLACE FUNCTION whsync.goods_sync_export(_log_id BIGINT) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt  TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _res JSONB;
BEGIN
    DELETE
    FROM whsync.goodsssync gs
    WHERE gs.log_id <= _log_id
      AND gs.sync_dt IS NOT NULL;

    WITH sync_cte AS (SELECT gs.log_id,
                             gs.nm_id,
                             gs.name,
                             gs.good_type,
                             gs.description,
                             gs.staff_id,
                             gs.dt,
                             gs.ch_dt
                      FROM whsync.goodsssync gs
                      ORDER BY gs.log_id
                      LIMIT 1000)

       , cte_upd AS (
        UPDATE whsync.goodsssync es
            SET sync_dt = _dt
            FROM sync_cte sc
            WHERE es.log_id = sc.log_id)

    SELECT JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(sc)))
    INTO _res
    FROM sync_cte sc;

    RETURN _res;
END
$$;