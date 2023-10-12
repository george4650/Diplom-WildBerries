CREATE OR REPLACE FUNCTION supply.take_order(_supply_id bigint, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _supply_info jsonb;
    _shop_id     smallint;
BEGIN

    UPDATE supply.supplies s
    SET supply_dt       = _dt,
        staff_id_tooked = _staff_id
    WHERE s.supply_id = _supply_id;


    SELECT s.supply_info, s.shop_id
    INTO _supply_info,_shop_id
    FROM supply.supplies s
    WHERE s.supply_id = _supply_id;


    WITH cte AS (SELECT i.nm_id, i.quantity
                 FROM jsonb_to_recordset(_supply_info) as i (
                                                             nm_id integer,
                                                             quantity integer
                     )),

         cte_upd AS (
             UPDATE petshop.storage st
                 SET quantity = quantity + ci.quantity
                 FROM (SELECT nm_id,
                              quantity
                       FROM cte) as ci
                 WHERE st.shop_id = _shop_id
                     AND st.nm_id = ci.nm_id
                 RETURNING *)

    INSERT INTO history.storagechanges (shop_id,
                                        nm_id,
                                        quantity,
                                        ch_staff_id,
                                        ch_dt)
    SELECT cu.shop_id,
           cu.nm_id,
           cu.quantity,
           _staff_id,
           _dt
    FROM cte_upd cu;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;