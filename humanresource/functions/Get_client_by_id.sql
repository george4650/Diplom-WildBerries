CREATE OR REPLACE FUNCTION humanresource.get_client_by_id(_client_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('client_id', client_id,
                              'Имя', first_name,
                              'Фамиилия', surname,
                              'Номер телефона', phone,
                              'Email', email,
                              'Карта', card_name,
                              'Сумма выкупа за всё время', ransom_amount,
                              'Скидка', discount
        )
        FROM (SELECT c.client_id,
                     c.first_name,
                     c.surname,
                     c.phone,
                     c.email,
                     c.ransom_amount,
                     ct.name as card_name,
                     ct.discount
              FROM humanresource.clients c
                       INNER JOIN dictionary.cardtypes ct on c.card_type_id = ct.card_type_id
              WHERE c.client_id = _client_id) res;

END
$$;