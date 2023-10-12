CREATE OR REPLACE FUNCTION petshop.get_goods_by_id(_good_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('nm_id', nm_id,
                              'Название товара', good_name,
                              'Тип товара', good_type,
                              'Описание', description,
                              'shop_id', shop_id,
                              'Адрес магазина', shop_address,
                              'Цена', selling_price,
                              'Количество', quantity
        )
        FROM (SELECT g.nm_id         as nm_id,
                     g.name          as good_name,
                     gt.name         as good_type,
                     g.description   as description,
                     sh.shop_id      as shop_id,
                     sh.address      as shop_address,
                     g.selling_price as selling_price,
                     s.quantity      as quantity
              FROM petshop.goods g
                       INNER JOIN dictionary.goodtypes gt on g.good_type_id = gt.good_type_id
                       INNER JOIN petshop.storage s on s.nm_id = g.nm_id
                       INNER JOIN petshop.shops sh on sh.shop_id = s.shop_id
              WHERE g.nm_id = _good_id) res;

END
$$;