CREATE OR REPLACE FUNCTION humanresource.employees_get_by_param(_employee_id INTEGER, _shop_id INTEGER, _post_id SMALLINT) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT e.employee_id,
                     e.shop_id,
                     e.post_id,
                     e.first_name,
                     e.surname,
                     e.patronymic,
                     e.phone,
                     e.email,
                     humanresource.count_employee_bonus(e.employee_id) AS bonus_at_month,
                     humanresource.count_premium(e.employee_id)        AS premium_at_month
              FROM humanresource.employees e
              WHERE e.employee_id = COALESCE(_employee_id, e.employee_id)
                AND e.shop_id     = COALESCE(_shop_id, e.shop_id)
                AND e.post_id     = COALESCE(_post_id, e.post_id)
                AND e.deleted_at IS NULL) res;

END
$$;