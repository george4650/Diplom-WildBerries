CREATE OR REPLACE FUNCTION humanresource.card_del(_card_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    UPDATE humanresource.cards
    SET deleted_at = _dt
    WHERE card_id = _card_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;