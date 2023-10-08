CREATE OR REPLACE FUNCTION humanresource.count_bonus(_sales_amount integer) returns integer
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    return case
               when _sales_amount < 30000 then 0
               when _sales_amount >= 30000 and _sales_amount < 50000 then 2
               when _sales_amount >= 50000 and _sales_amount < 70000 then 3
               when _sales_amount >= 70000 and _sales_amount < 100000 then 4
               when _sales_amount >= 100000 then 5
        end;
END
$$;
