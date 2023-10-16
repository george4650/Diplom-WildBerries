CREATE OR REPLACE FUNCTION petshop.goods_get_by_param(_nm_id integer, _good_type_id integer, _min_selling_price numeric,
                                                      _max_selling_price numeric) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN


    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT g.nm_id,
                     s.shop_id,
                     g.name,
                     g.good_type_id,
                     g.description,
                     g.selling_price,
                     g.dt,
                     s.quantity as quantity_at_storage
              FROM petshop.goods g
                       LEFT JOIN petshop.storage s on s.nm_id = g.nm_id
              WHERE g.nm_id = COALESCE(_nm_id, g.nm_id)
                AND g.good_type_id = COALESCE(_good_type_id, g.good_type_id)
                AND g.selling_price >= COALESCE(_min_selling_price, g.selling_price)
                AND g.selling_price <= COALESCE(_max_selling_price, g.selling_price)

              ORDER BY nm_id) res;

END
$$;