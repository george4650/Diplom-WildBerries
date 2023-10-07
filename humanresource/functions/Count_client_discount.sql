CREATE OR REPLACE FUNCTION humanresource.count_discount(_client_id integer) returns integer
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _discount integer;
BEGIN
    select case
               when sum(s.price - s.discount) < 30000 then _discount = 0
               when sum(s.price - s.discount) >= 30000 and sum(s.price - s.discount) < 50000 then _discount = 1
               when sum(s.price - s.discount) >= 50000 and sum(s.price - s.discount) < 70000 then _discount = 2
               when sum(s.price - s.discount) >= 70000 and sum(s.price - s.discount) < 100000 then _discount = 3
               when sum(s.price - s.discount) >= 100000 then _discount = 5
               end
    FROM sales.sales s
    WHERE s.client_id = _client_id;

    return _discount;
END
$$;
