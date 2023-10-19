CREATE OR REPLACE FUNCTION humanresource.count_employee_bonus(_employee_id integer) returns integer
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _employee_sales_amount integer;
BEGIN

    SELECT SUM(total_price - discount)
    INTO _employee_sales_amount
    FROM sales.sales
    WHERE employee_id = _employee_id
      AND EXTRACT(MONTH FROM dt) = EXTRACT(MONTH FROM now());


    return case
               when _employee_sales_amount < 30000 then 1000
               when _employee_sales_amount >= 30000 and _employee_sales_amount < 50000 then 2000
               when _employee_sales_amount >= 50000 and _employee_sales_amount < 70000 then 3000
               when _employee_sales_amount >= 70000 and _employee_sales_amount < 100000 then 4000
               when _employee_sales_amount >= 100000 then 5000
        end;
END
$$;