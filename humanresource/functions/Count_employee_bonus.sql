CREATE OR REPLACE FUNCTION humanresource.count_employee_bonus(_employee_id INTEGER) RETURNS INTEGER
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _employee_sales_amount INTEGER;
BEGIN

    SELECT SUM(total_price - discount)
    INTO _employee_sales_amount
    FROM sales.sales
    WHERE employee_id = _employee_id
      AND EXTRACT(MONTH FROM dt) = EXTRACT(MONTH FROM now());


    RETURN CASE
               WHEN _employee_sales_amount < 30000 THEN 1000
               WHEN _employee_sales_amount >= 30000 AND _employee_sales_amount < 50000 THEN 2000
               WHEN _employee_sales_amount >= 50000 AND _employee_sales_amount < 70000 THEN 3000
               WHEN _employee_sales_amount >= 70000 AND _employee_sales_amount < 100000 THEN 4000
               WHEN _employee_sales_amount >= 100000 THEN 5000
        END;
END
$$;