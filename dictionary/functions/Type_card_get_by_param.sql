CREATE OR REPLACE FUNCTION dictionary.type_card_get_by_param_id(_type_card_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res))) FROM (SELECT ct.card_type_id,
                                                                               ct.name,
                                                                               ct.ransom_amount,
                                                                               ct.discount
                                                                        FROM dictionary.cardtypes ct
                                                                        WHERE card_type_id = COALESCE(_type_card_id, ct.card_type_id)) res;
END
$$;