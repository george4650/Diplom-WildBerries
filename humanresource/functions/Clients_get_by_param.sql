CREATE OR REPLACE FUNCTION humanresource.clients_get_by_param(_client_id integer, _card_id integer, _phone varchar(11)) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT c.client_id,
                     c.card_id,
                     c.card_type_id,
                     c.first_name,
                     c.surname,
                     c.phone,
                     c.email,
                     c.employee_id,
                     c.ransom_amount,
                     c.dt
              FROM humanresource.clients c
              WHERE c.client_id = COALESCE(_client_id, c.client_id)
                AND c.card_id   = COALESCE(_card_id, c.card_id)
                AND c.phone     = COALESCE(_phone, c.phone)) res;
END
$$;