CREATE OR REPLACE FUNCTION humanresource.get_employee_by_id(_employee_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('employee_id', employee_id, 'shop_id', shop_id, 'first_name', first_name,
                              'surname', surname, 'patronymic', patronymic, 'salary', salary, 'post', post,
                              'phone', phone, 'email', email, 'deleted_at', deleted_at)
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
              FROM humanresource.employees e
              WHERE e.employee_id = _employee_id) res;

END
$$;