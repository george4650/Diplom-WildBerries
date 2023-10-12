CREATE OR REPLACE FUNCTION sales.get_sales_by_card_id(_card_id integer, _start_date date DEFAULT NULL,
                                                      _endDate date DEFAULT NULL) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT c.card_id,
                     sh.shop_id,
                     sh.address,
                     s.sale_info,
                     s.total_price,
                     s.discount,
                     s.dt
              FROM sales.sales s
                       inner join humanresource.cards c on s.card_id = c.card_id
                       inner join petshop.shops sh on sh.shop_id = s.shop_id
              WHERE c.card_id = _card_id
                AND s.dt::date >= COALESCE(_start_date, (now() - interval '100' YEAR))
                AND s.dt::date <= COALESCE(_endDate, (now() + interval '100' YEAR))) res;

END
$$;