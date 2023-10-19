CREATE OR REPLACE FUNCTION sales.sale_ins(_sale_info json, _shop_id integer,
                                          _staff_id integer, _card_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message       varchar(500);
    _dt                TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _total_price       NUMERIC(8,2);
    _discount          NUMERIC(8,2);
    _new_ransom_amount NUMERIC(15,2);
    _new_card_type     SMALLINT;
BEGIN


    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT s.nm_id,
           s.quantity,
           s.product_price
    FROM json_to_recordset(_sale_info) AS s (
                                             nm_id int,
                                             quantity int,
                                             product_price numeric(8, 2)
        );


    SELECT CASE
               WHEN NOT EXISTS(SELECT 1
                               FROM petshop.storage st
                                        INNER JOIN tmp t on st.nm_id = t.nm_id
                               WHERE st.shop_id = _shop_id)
                   THEN 'товара нет в данном магазине'

               WHEN EXISTS(SELECT 1
                           FROM petshop.storage s
                                    INNER JOIN tmp ON tmp.nm_id = s.nm_id
                           WHERE s.quantity - tmp.quantity < 0
                             AND s.shop_id = _shop_id)
                   THEN 'товара нет в наличии в данном магазине'
               END
    INTO _err_message;


    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('sales.sale_ins', _err_message, NULL);
    END IF;


    WITH cte_upd AS (
        UPDATE petshop.storage s
            SET quantity = s.quantity - t.quantity
            FROM (SELECT nm_id,
                         quantity
                  FROM tmp) as t
            WHERE s.shop_id = _shop_id
                AND s.nm_id = t.nm_id
            RETURNING s.*)


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


    SELECT SUM(product_price * quantity)
    INTO _total_price
    FROM tmp;

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
           _staff_id,
           _shop_id,
           _sale_info,
           _total_price,
           _discount,
           _dt;

    SELECT c.ransom_amount + _total_price - _discount
    INTO _new_ransom_amount
    FROM humanresource.clients c
    WHERE c.card_id = _card_id;

    SELECT ct.card_type_id
    INTO _new_card_type
    FROM dictionary.cardtypes ct
    WHERE ct.ransom_amount <= _new_ransom_amount::integer
    ORDER BY ct.ransom_amount DESC;

    WITH cte_upd AS (
        UPDATE humanresource.clients c
            SET ransom_amount = _new_ransom_amount,
                card_type_id  = _new_card_type
            WHERE c.card_id   = _card_id
            RETURNING c.*)

    INSERT INTO history.clientschanges (client_id,
                                        card_id,
                                        card_type_id,
                                        first_name,
                                        surname,
                                        phone,
                                        email,
                                        employee_id,
                                        ransom_amount,
                                        dt,
                                        ch_staff_id,
                                        ch_dt)
    SELECT cu.client_id,
           cu.card_id,
           cu.card_type_id,
           cu.first_name,
           cu.surname,
           cu.phone,
           cu.email,
           cu.employee_id,
           cu.ransom_amount,
           cu.dt,
           _staff_id,
           _dt
    FROM cte_upd cu;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;