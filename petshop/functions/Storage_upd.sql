CREATE OR REPLACE FUNCTION petshop.storage_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';

BEGIN

    WITH cte_upd AS (
        UPDATE petshop.storage
            SET selling_price = s.selling_price AND quantity = s.quantity
            FROM (SELECT shop_id, good_id, selling_price, quantity
                  FROM jsonb_to_record(_src) as s (
                                                   shop_id integer,
                                                   good_id integer,
                                                   selling_price integer,
                                                   quantity integer
                      )) as s
            WHERE shop_id = s.shop_id
                AND good_id = s.good_id
            RETURNING *)

    INSERT INTO history.storagechanges(shop_id, good_id, selling_price, quantity, staff_id, ch_dt)
    SELECT cu.shop_id, cu.good_id, cu.selling_price, cu.quantity, _staff_id, _dt
    FROM cte_upd cu;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;