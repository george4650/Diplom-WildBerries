CREATE OR REPLACE FUNCTION sales.get_sales_by_client_id(_client_id integer, _start_date date DEFAULT NULL,
                                                        _endDate date DEFAULT NULL) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT g.name as good_name,
                     s.price,
                     s.discount,
                     s.quantity,
                     s.dt
              FROM sales.sales s
                       inner join humanresource.clients c on s.client_id = c.client_id
                       inner join petshop.goods g on g.nm_id = s.nm_id
              WHERE c.client_id = _client_id
                AND dt::date >= _start_date
                AND dt::date >= _endDate) res;

END
$$;