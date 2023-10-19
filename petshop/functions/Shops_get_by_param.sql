CREATE OR REPLACE FUNCTION petshop.shops_get_by_param(_shop_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT s.shop_id,
                     s.address,
                     s.phone
              FROM petshop.shops s
              WHERE s.shop_id = COALESCE(_shop_id, s.shop_id)) res;

END
$$;