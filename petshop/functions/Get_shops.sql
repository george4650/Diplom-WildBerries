CREATE OR REPLACE FUNCTION petshop.get_shops() returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT s.shop_id,
                     s.address,
                     s.phone
              FROM petshop.shops s) res;

END
$$;