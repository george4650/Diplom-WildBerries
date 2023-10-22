CREATE OR REPLACE FUNCTION dictionary.good_type_ins(_good_type_name VARCHAR(50)) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    INSERT INTO dictionary.goodtypes (name) VALUES (_good_type_name) ON CONFLICT (name) DO NOTHING;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;