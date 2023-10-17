CREATE OR REPLACE FUNCTION petshop.storage_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt       TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _shop_id  integer;
    _nm_id    integer;
    _quantity integer;
BEGIN

    SELECT s.shop_id,
           s.nm_id,
           s.quantity
    INTO _shop_id,
         _nm_id,
         _quantity

    FROM jsonb_to_record(_src) as s (shop_id integer,
                                     nm_id integer,
                                     quantity integer
        );

    IF NOT EXISTS(SELECT 1 FROM petshop.storage st WHERE st.shop_id = _shop_id and st.nm_id = _nm_id) THEN

        INSERT INTO petshop.storage (shop_id, nm_id, quantity) VALUES (_shop_id, _nm_id, _quantity);

        INSERT INTO history.storagechanges (shop_id,
                                            nm_id,
                                            quantity,
                                            ch_staff_id,
                                            ch_dt)
        SELECT _shop_id,
               _nm_id,
               _quantity,
               _staff_id,
               _dt;

        RETURN JSONB_BUILD_OBJECT('data', NULL);
    END IF;


    WITH cte_upd AS (
        UPDATE petshop.storage st
            SET quantity = _quantity
            WHERE st.shop_id = _shop_id
                AND st.nm_id = _nm_id
            RETURNING st.*)

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