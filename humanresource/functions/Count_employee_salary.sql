CREATE OR REPLACE FUNCTION humanresource.count_employee_salary(_employee_id integer) returns numeric
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _employee_sales_amount integer;
    _salary       numeric(8, 2);
BEGIN
    SELECT SUM(total_price - discount)
    INTO _employee_sales_amount
    FROM sales.sales
    WHERE employee_id = _employee_id
    AND EXTRACT(MONTH FROM dt) = EXTRACT(MONTH FROM now());

    SELECT p.salary +
           humanresource.count_premium(_employee_id) +
           p.salary * humanresource.count_bonus(_employee_sales_amount) / 100
    INTO _salary
    FROM humanresource.employees e
    INNER JOIN dictionary.posts p ON p.post_id = e.post_id
    WHERE employee_id = _employee_id and e.deleted_at is null;

    return _salary;
END
$$;