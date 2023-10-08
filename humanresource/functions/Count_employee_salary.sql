CREATE OR REPLACE FUNCTION humanresource.count_employee_salary(_employee_id integer) returns numeric
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _sales_amount integer;
    _salary       numeric(8, 2);
BEGIN
    select SUM(price) INTO _sales_amount from sales.sales where employee_id = _employee_id;

    select salary + humanresource.count_premium(_employee_id) + salary * humanresource.count_bonus(_sales_amount) / 100
    into _salary
    from humanresource.employees e
    where employee_id = _employee_id and e.deleted_at is null;

    return _salary;
END
$$;