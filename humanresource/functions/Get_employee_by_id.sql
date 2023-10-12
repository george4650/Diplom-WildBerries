CREATE OR REPLACE FUNCTION humanresource.get_employee_by_id(_employee_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('employee_id', employee_id,
                              'shop_id', shop_id,
                              'Имя', first_name,
                              'Фамиилия', surname,
                              'Отчество', patronymic,
                              'Зарплата', salary,
                              'Должность', post,
                              'Премия в этом месяце', premium_at_month,
                              'Телефон', phone,
                              'Email', email,
                              'deleted_at', deleted_at)
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
              WHERE e.employee_id = _employee_id) res;

END
$$;