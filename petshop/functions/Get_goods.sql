CREATE OR REPLACE FUNCTION petshop.get_goods() returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT g.nm_id         as nm_id,
                     g.name          as good_name,
                     gt.name         as good_type,
                     g.description   as description,
                     sh.address      as shop_address,
                     s.selling_price as selling_price,
                     s.quantity      as quantity
              FROM petshop.goods g
                       inner join dictionary.goodtypes gt on g.good_type = gt.good_type
                       inner join petshop.storage s on s.nm_id = g.nm_id
                       inner join petshop.shops sh on sh.shop_id = s.shop_id
              ORDER BY nm_id) res;

END
$$;