CREATE OR REPLACE FUNCTION dictionary.good_type_get_by_param(_good_type_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res))) FROM (SELECT gt.good_type_id,
                                                                               gt.name
                                                                        FROM dictionary.goodtypes gt
                                                                        WHERE good_type_id = COALESCE(_good_type_id, gt.good_type_id)) res;

END
$$;