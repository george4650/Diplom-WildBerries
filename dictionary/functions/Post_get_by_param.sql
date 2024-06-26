CREATE OR REPLACE FUNCTION dictionary.post_get_by_param(_post_id INTEGER) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res))) FROM
        (SELECT p.post_id,
                p.name,
                p.salary
         FROM dictionary.posts p
         WHERE post_id = COALESCE(_post_id, p.post_id)) res;

END
$$;