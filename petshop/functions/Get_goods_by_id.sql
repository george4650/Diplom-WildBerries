CREATE OR REPLACE FUNCTION humanresource.get_goods_by_id(_good_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('good_id', nm_id,
                              'good_name', good_name,
                              'good_type', good_type,
                              'description', description,
                              'shop_address', shop_address,
                              'selling_price', selling_price,
                              'quantity', quantity
        )
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
              WHERE g.nm_id = _good_id
              ORDER BY nm_id) res;

END
$$;