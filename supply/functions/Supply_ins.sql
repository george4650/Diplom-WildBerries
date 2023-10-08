CREATE OR REPLACE FUNCTION supply.supply_ins(_data jsonb) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT s.shop_id, s.supplier_id, s.good_id, s.purchase_price, s.quantity, s.description
    FROM jsonb_to_recordset(_data) as s (
                                         shop_id integer,
                                         supplier_id integer,
                                         good_id bigint,
                                         purchase_price numeric(8, 2),
                                         quantity integer,
                                         description varchar(1500)
        );

    INSERT INTO supply.supplies AS s (supply_id, shop_id, supplier_id, good_id, purchase_price, quantity, dt)
    SELECT nextval('supply.supply_sq') as supply_id,
           shop_id,
           supplier_id,
           good_id,
           purchase_price,
           quantity,
           _dt                         as dt
    FROM tmp t;


    UPDATE petshop.storage
    SET quantity = quantity + t.quantity AND selling_price = t.purchase_price + t.purchase_price * 0.2
    FROM (SELECT shop_id,
                 good_id,
                 purchase_price,
                 quantity
          FROM tmp) as t
    WHERE t.shop_id = shop_id
      AND t.good_id = good_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;