CREATE OR REPLACE FUNCTION humanresource.reissue_the_client_card(_phone_number varchar(11)) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message   VARCHAR(500);
    _dt            TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _card_id       integer;
    _client_id     integer;
    _ransom_amount integer;
    _new_card_id   integer;
BEGIN

    SELECT c.card_id, cs.client_id, c.ransom_amount
    INTO _card_id, _client_id, _ransom_amount
    FROM humanresource.cards c
             INNER JOIN humanresource.clients cs on c.client_id = cs.client_id
    WHERE cs.phone = _phone_number
      AND c.deleted_at IS NULL;

    SELECT CASE
               WHEN _card_id IS NULL THEN 'Карта привязанная к данному номеру телефона не найдена'
               END
    INTO _err_message
    FROM humanresource.clients c;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('humanresource.reissue_the_client_card', _err_message, NULL);
    END IF;

    UPDATE humanresource.cards
    SET deleted_at = _dt
    WHERE card_id = _card_id;

    INSERT INTO humanresource.cards (card_id,
                                     client_id,
                                     card_type_id,
                                     ransom_amount,
                                     dt)
    SELECT nextval('humanresource.card_sq') as card_id,
           _client_id,
           1,
           _ransom_amount,
           _dt
    RETURNING card_id INTO _new_card_id;

    RETURN JSONB_BUILD_OBJECT('card_id', _new_card_id);
END
$$;