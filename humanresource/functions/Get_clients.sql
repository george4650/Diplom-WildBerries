CREATE OR REPLACE FUNCTION humanresource.get_clients() returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT c.client_id,
                     c.first_name,
                     c.surname,
                     c.phone,
                     c.email,
                     c.ransom_amount,
                     ct.name as card_name,
                     ct.discount
              FROM humanresource.clients c
                       INNER JOIN dictionary.cardtypes ct on c.card_type_id = ct.card_type_id) res;

END
$$;