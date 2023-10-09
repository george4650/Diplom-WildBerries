CREATE OR REPLACE FUNCTION petshop.get_goods() returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT g.nm_id       as nm_id,
                     gt.name       as good_type,
                     g.description as description,
                     s.shop_id,
                     s.selling_price,
                     s.quantity
              FROM petshop.goods g
                       inner join dictionary.goodtypes gt on g.good_type = gt.good_type
                       inner join petshop.storage s on s.good_id = g.nm_id
              ORDER BY good_id) res;

END
$$;