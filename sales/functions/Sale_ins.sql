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
    SELECT s.nm_id, s.card_id, s.employee_id, s.shop_id, s.quantity, SUM(st.quantity) as balance_in_stock
    FROM jsonb_to_recordset(_data) as s (
                                         nm_id BIGINT,
                                         card_id INT,
                                         employee_id INT,
                                         shop_id INT,
                                         quantity INT
        )
             INNER JOIN petshop.Storage st on st.nm_id = s.nm_id AND st.shop_id = s.shop_id
    GROUP BY s.nm_id, s.card_id, s.employee_id, s.shop_id, s.quantity;

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

    INSERT INTO sales.sales AS s (sale_id, client_id, nm_id, employee_id, shop_id, price, discount, quantity, dt)
    SELECT nextval('sales.sale_sq')    as sale_id,
           (select client_id
            from humanresource.cards c
            where c.card_id = t.card_id
              and (c.deleted_at is null OR c.deleted_at = false)),
           t.nm_id,
           t.employee_id,
           t.shop_id,
           (select selling_price
            from petshop.storage s
            where s.nm_id = t.nm_id
              and shop_id = t.shop_id) as price,
           (select selling_price * humanresource.count_discount((select client_id
                                                                 from humanresource.cards c
                                                                 where c.card_id = t.card_id
                                                                   and (c.deleted_at is null OR c.deleted_at = false))) /
                   100
            from petshop.storage s)    as discount,
           t.quantity,
           _dt                         as dt
    FROM tmp t;


    WITH cte_upd AS (
        UPDATE petshop.storage
            SET quantity = quantity - t.quantity
            FROM (SELECT shop_id,
                         nm_id,
                         quantity
                  FROM tmp) as t
            WHERE t.shop_id = shop_id
                AND t.nm_id = nm_id
            RETURNING *)

    INSERT INTO history.storagechanges(shop_id, nm_id, selling_price, quantity, ch_dt)
    SELECT cu.shop_id, cu.nm_id, cu.selling_price, cu.quantity, _dt
    FROM cte_upd cu;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;