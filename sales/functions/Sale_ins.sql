CREATE OR REPLACE FUNCTION sales.sale_ins(_data jsonb) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message VARCHAR(500);
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT s.good_id, s.card_id, s.employee_id, s.shop_id, s.quantity, SUM(st.quantity) as balance_in_stock
    FROM jsonb_to_recordset(_data) as s (
                                         good_id BIGINT,
                                         card_id INT,
                                         employee_id INT,
                                         shop_id INT,
                                         quantity INT
        )
             INNER JOIN petshop.Storage st on st.good_id = s.good_id AND st.shop_id = s.shop_id
    GROUP BY s.good_id, s.card_id, s.employee_id, s.shop_id, s.quantity;

    SELECT CASE
               WHEN t.quantity IS NULL OR t.quantity <= 0 THEN 'Количество покупаемого товара не может быть равно 0!'
               WHEN t.balance_in_stock IS NULL THEN 'Товара нет в наличии'
               WHEN t.quantity < t.balance_in_stock THEN 'Товара нет в наличии'
               END
    INTO _err_message
    FROM tmp t;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage(' sales.sale_good', _err_message, NULL);
    END IF;

    INSERT INTO sales.sales AS s (sale_id, client_id, good_id, employee_id, shop_id, price, discount, quantity, dt)
    SELECT nextval('sales.sale_sq')      as                                                                sale_id,
           (select client_id from humanresource.cards c where c.card_id = t.card_id),
           t.good_id,
           t.employee_id,
           t.shop_id,
           (select selling_price
            from petshop.storage s
            where s.good_id = t.good_id) as                                                                price,
           (select selling_price * humanresource.count_discount((select client_id from humanresource.cards c where c.card_id = t.card_id)) / 100 from petshop.storage s) discount,
           t.quantity,
           _dt                           as                                                                dt
    FROM tmp t;

    UPDATE petshop.storage
    SET quantity = quantity - t.quantity
    FROM (SELECT shop_id,
                 good_id,
                 quantity
          FROM tmp) as t
    WHERE t.shop_id = shop_id
      AND t.good_id = good_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;