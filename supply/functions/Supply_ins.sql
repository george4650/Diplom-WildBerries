CREATE OR REPLACE FUNCTION supply.supply_ins(_data jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH cte_ins AS (
        INSERT INTO supply.supplies AS s (supply_id,
                                          shop_id,
                                          supplier_id,
                                          nm_id,
                                          purchase_price,
                                          quantity,
                                          dt)
            SELECT nextval('supply.supply_sq') as supply_id,
                   shop_id,
                   supplier_id,
                   nm_id,
                   purchase_price,
                   quantity,
                   _dt                         as dt
            FROM jsonb_to_recordset(_data) as s (
                                                 shop_id integer,
                                                 supplier_id integer,
                                                 nm_id bigint,
                                                 purchase_price numeric(8, 2),
                                                 quantity integer
                )
            RETURNING s.*),

         cte_upd AS (
             UPDATE petshop.storage
                 SET quantity = quantity + ci.quantity,
                     selling_price = ci.purchase_price + ci.purchase_price * m.markup
                 FROM (SELECT shop_id,
                              nm_id,
                              purchase_price,
                              quantity
                       FROM cte_ins) as ci
                     INNER JOIN petshop.markup m on m.nm_id = ci.nm_id
                 WHERE ci.shop_id = shop_id
                     AND ci.nm_id = nm_id
                 RETURNING *)

    INSERT
    INTO history.storagechanges(shop_id,
                                nm_id,
                                selling_price,
                                quantity,
                                staff_id,
                                ch_dt)
    SELECT cu.shop_id,
           cu.nm_id,
           cu.selling_price,
           cu.quantity,
           _staff_id,
           _dt
    FROM cte_upd cu;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;