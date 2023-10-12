CREATE OR REPLACE FUNCTION humanresource.get_employees() returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT e.employee_id,
                     e.shop_id,
                     e.first_name,
                     e.surname,
                     e.patronymic,
                     p.salary,
                     humanresource.count_employee_salary(e.employee_id) as premium_at_month,
                     p.name                                             as post,
                     e.phone,
                     e.email,
                     e.deleted_at
              FROM humanresource.employees e
                       INNER JOIN dictionary.posts p ON p.post_id = e.post_id
              WHERE e.deleted_at IS NULL) res;

END
$$;