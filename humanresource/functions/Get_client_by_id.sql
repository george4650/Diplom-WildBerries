CREATE OR REPLACE FUNCTION humanresource.get_client_by_id(_client_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('client_id', client_id, 'first_name', first_name,
                              'surname', surname, 'phone', phone, 'email', email)
        FROM (SELECT c.client_id, first_name, surname, phone, email
              FROM humanresource.clients c
              WHERE c.client_id = _client_id) res;

END
$$;