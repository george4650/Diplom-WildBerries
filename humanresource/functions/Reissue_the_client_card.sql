CREATE OR REPLACE FUNCTION humanresource.reissue_the_client_card(_phone_number varchar(11), _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message VARCHAR(500);
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _new_card_id integer;
BEGIN

    SELECT CASE
               WHEN NOT EXISTS(SELECT 1 FROM humanresource.clients c WHERE c.phone = _phone_number)
                   THEN 'Карта привязанная к данному номеру телефона не найдена'
               END
    INTO _err_message
    FROM humanresource.clients c;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('humanresource.reissue_the_client_card', _err_message, NULL);
    END IF;

    WITH cte_upd AS (
        UPDATE humanresource.clients c
            SET card_id = nextval('humanresource.card_sq')
            WHERE phone = _phone_number
            RETURNING c.*)

    INSERT
    INTO history.clientschanges (client_id,
                                 card_id,
                                 card_type_id,
                                 first_name,
                                 surname,
                                 phone,
                                 email,
                                 employee_id,
                                 ransom_amount,
                                 dt,
                                 ch_staff_id,
                                 ch_dt)
    SELECT cu.client_id,
           cu.card_id,
           cu.card_type_id,
           cu.first_name,
           cu.surname,
           cu.phone,
           cu.email,
           cu.employee_id,
           cu.ransom_amount,
           cu.dt,
           _staff_id,
           _dt
    FROM cte_upd cu
    RETURNING card_id INTO _new_card_id;


    RETURN JSONB_BUILD_OBJECT('new_card_id', _new_card_id);
END
$$;