CREATE OR REPLACE FUNCTION sales.sale_ins(_sale_info jsonb, _shop_id smallint, _employee_id integer,
                                          _card_id integer DEFAULT NULL) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _total_price NUMERIC(8, 2);
    _discount    NUMERIC(8, 2);
BEGIN

    WITH cte AS (SELECT SUM(product_price) as total_price,
                        nm_id,
                        quantity,
                        product_price
                 INTO _total_price
                 FROM jsonb_to_recordset(_sale_info) as s (
                                                           nm_id int,
                                                           quantity int,
                                                           product_price numeric(8, 2)
                     )
                 GROUP BY nm_id, quantity, product_price),

         cte_upd AS (
             UPDATE petshop.storage s
                 SET quantity = s.quantity - c.quantity
                 FROM (SELECT nm_id,
                              quantity
                       FROM cte) as c
                 WHERE s.shop_id = _shop_id
                     AND s.nm_id = c.nm_id
                 RETURNING s.*)


    INSERT INTO history.storagechanges(shop_id,
                                       nm_id,
                                       quantity,
                                       ch_staff_id,
                                       ch_dt)
    SELECT cu.shop_id,
           cu.nm_id,
           cu.quantity,
           _employee_id,
           _dt
    FROM cte_upd cu;

    SELECT ct.discount * _total_price / 100
    INTO _discount
    FROM humanresource.clients c
             INNER JOIN dictionary.cardtypes ct ON c.card_type_id = ct.card_type_id
    WHERE c.card_id = _card_id;

    INSERT INTO sales.sales AS s (sale_id,
                                  card_id,
                                  employee_id,
                                  shop_id,
                                  sale_info,
                                  total_price,
                                  discount,
                                  dt)
    SELECT nextval('sales.sale_sq') as sale_id,
           _card_id,
           _employee_id,
           _shop_id,
           _sale_info,
           _total_price,
           _discount,
           _dt;

    UPDATE humanresource.clients c
    SET ransom_amount = c.ransom_amount + _total_price - _discount,
        card_type_id  = ct.card_type_id
    FROM (SELECT ct.card_type_id
          FROM dictionary.cardtypes ct
          WHERE ct.ransom_amount < c.ransom_amount + _total_price - _discount
          ORDER BY ct.ransom_amount DESC) as ct
    WHERE c.card_id = _card_id;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;