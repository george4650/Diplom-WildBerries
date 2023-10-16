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


    WITH cte_upd AS (
        INSERT INTO petshop.storage as st (shop_id, nm_id, quantity)
            SELECT _shop_id, i.nm_id, i.quantity
            FROM jsonb_to_recordset(_supply_info) as i (nm_id integer,
                                                        quantity integer
                )
            ON CONFLICT (shop_id, nm_id) DO UPDATE
                SET quantity = st.quantity + excluded.quantity
            RETURNING st.*)


    INSERT INTO history.storagechanges as stc (shop_id,
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