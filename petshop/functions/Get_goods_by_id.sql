CREATE OR REPLACE FUNCTION humanresource.get_goods_by_id(_good_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('good_id', good_id, 'good_type', good_type, 'description', description)
        FROM (SELECT g.good_id     as good_id,
                     gt.name       as good_type,
                     g.description as description,
                     s.shop_id,
                     s.selling_price,
                     s.quantity
              FROM petshop.goods g
                       inner join dictionary.goodtypes gt on g.good_type = gt.good_type
                       inner join petshop.storage s on s.good_id = g.good_id
              WHERE g.good_id = _good_id
              ORDER BY good_id) res;

END
$$;