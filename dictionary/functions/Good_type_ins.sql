CREATE OR REPLACE FUNCTION dictionary.good_type_ins(_good_type_name varchar(50)) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    INSERT INTO dictionary.goodtypes (name) values (_good_type_name);

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;