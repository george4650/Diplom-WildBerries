CREATE OR REPLACE FUNCTION supply.take_order(_supply_id bigint, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message varchar(500);
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _supply_info jsonb;
    _shop_id     smallint;
BEGIN

    SELECT 'Данная поставка уже принята'
    INTO _err_message
    FROM supply.supplies s
    WHERE s.supply_id = _supply_id
      and supply_dt is not null;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('supply.take_order', _err_message, null);
    END IF;


    UPDATE supply.supplies s
    SET supply_dt       = _dt,
        staff_id_tooked = _staff_id
    WHERE s.supply_id = _supply_id;


    SELECT s.supply_info, s.shop_id
    INTO _supply_info,_shop_id
    FROM supply.supplies s
    WHERE s.supply_id = _supply_id;


    WITH cte AS (SELECT i.nm_id, i.quantity
                 FROM jsonb_to_recordset(_supply_info) as i (nm_id integer,
                                                             quantity integer
                     ))


    --IF NOT EXISTS (SELECT 1
    --               FROM petshop.storage s
    --                        LEFT JOIN cte cs ON s.nm_id = cs.nm_id
    --               WHERE s.nm_id = cte.nm_id
    --                 AND s.shop_id = _shop_id) THEN
--
    --END IF; -- невозможно обновить количество товара на складе, если товара на складе не существует

    WITH cte_upd AS (
        UPDATE petshop.storage as st
            SET quantity = st.quantity + ci.quantity
            FROM (SELECT ci.nm_id,
                         ci.quantity
                  FROM cte ci) as ci
            WHERE st.shop_id = _shop_id
                AND st.nm_id = ci.nm_id
            RETURNING st.shop_id, st.nm_id, st.quantity)

    INSERT
    INTO history.storagechanges as st (shop_id,
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