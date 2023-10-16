CREATE OR REPLACE FUNCTION sales.sales_get_by_param(_sale_id integer, _card_id integer, _employee_id integer,
                                                    _start_date date, _endDate date) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT s.sale_id,
                     s.card_id,
                     s.employee_id,
                     s.shop_id,
                     s.sale_info,
                     s.total_price,
                     s.discount,
                     s.dt
              FROM sales.sales s
              WHERE s.sale_id = COALESCE(_sale_id, s.sale_id)
                AND s.card_id = COALESCE(_card_id, s.card_id)
                AND s.employee_id = COALESCE(_employee_id, s.employee_id)
                AND s.dt >= COALESCE(_start_date, s.dt)
                AND s.dt <= COALESCE(_endDate, s.dt)) res;

END
$$;