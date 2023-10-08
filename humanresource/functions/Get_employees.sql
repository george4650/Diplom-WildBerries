CREATE OR REPLACE FUNCTION humanresource.get_employees() returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT employee_id,
                     shop_id,
                     first_name,
                     surname,
                     patronymic,
                     salary,
                     post,
                     phone,
                     email,
                     deleted_at
              FROM humanresource.employees e) res;

END
$$;