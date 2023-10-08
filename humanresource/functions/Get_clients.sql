CREATE OR REPLACE FUNCTION humanresource.get_clients() returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT c.client_id, first_name, surname, phone, email
              FROM humanresource.clients c) res;

END
$$;