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

    WITH supplies_upd AS (
        UPDATE supply.supplies s
            SET supply_dt = _dt,
                staff_id_tooked = _staff_id
            WHERE s.supply_id   = _supply_id
            RETURNING s.*)

    INSERT INTO history.supplieschanges as stc (supply_id,
                                                shop_id,
                                                supplier_id,
                                                supply_info,
                                                order_dt,
                                                supply_dt,
                                                staff_id_ordered,
                                                staff_id_tooked,
                                                ch_dt)
    SELECT cu.supply_id,
           cu.shop_id,
           cu.supplier_id,
           cu.supply_info,
           cu.order_dt,
           cu.supply_dt,
           cu.staff_id_ordered,
           cu.staff_id_tooked,
           _dt
    FROM supplies_upd cu;


    SELECT s.supply_info, s.shop_id
    INTO _supply_info, _shop_id
    FROM supply.supplies s
    WHERE s.supply_id = _supply_id;


    WITH storage_upd AS (
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
    FROM storage_upd cu;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;