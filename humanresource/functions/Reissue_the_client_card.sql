CREATE OR REPLACE FUNCTION humanresource.reissue_the_client_card(_phone_number varchar(11), _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message   VARCHAR(500);
    _dt            TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _client_id     integer;
    _card_id       integer;
    _card_type_id  smallint ;
    _first_name    varchar(32);
    _surname       varchar(32);
    _phone         varchar(11);
    _email         varchar(50);
    _employee_id   integer;
    _ransom_amount numeric(15, 2);
    _card_dt       timestamptz;
BEGIN

    SELECT c.card_id,
           c.client_id,
           c.card_type_id,
           c.first_name,
           c.surname,
           c.phone,
           c.email,
           c.employee_id,
           c.ransom_amount,
           c.dt
    INTO _card_id,
        _client_id,
        _card_type_id,
        _first_name,
        _surname,
        _phone,
        _email,
        _employee_id,
        _ransom_amount,
        _card_dt
    FROM humanresource.clients c
    WHERE c.phone = _phone_number
      AND c.is_deleted = false;

    SELECT CASE
               WHEN _card_id IS NULL THEN 'Карта привязанная к данному номеру телефона не найдена'
               END
    INTO _err_message
    FROM humanresource.clients c;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('humanresource.reissue_the_client_card', _err_message, NULL);
    END IF;

    UPDATE humanresource.clients
    SET is_deleted = true
    WHERE card_id = _card_id;

    INSERT INTO history.clientschanges (client_id,
                                        card_id,
                                        card_type_id,
                                        first_name,
                                        surname,
                                        phone,
                                        email,
                                        employee_id,
                                        dt,
                                        is_deleted,
                                        ch_staff_id,
                                        ch_dt)
    SELECT _client_id,
           _card_id,
           _card_type_id,
           _first_name,
           _surname,
           _phone,
           _email,
           _employee_id,
           _card_dt,
           true,
           _staff_id,
           _dt;


    WITH cte_ins AS (
        INSERT INTO humanresource.clients as c (card_id,
                                                client_id,
                                                card_type_id,
                                                first_name,
                                                surname,
                                                phone,
                                                email,
                                                employee_id,
                                                ransom_amount,
                                                dt)
            SELECT nextval('humanresource.card_sq') as card_id,
                   _client_id,
                   _card_type_id,
                   _first_name,
                   _surname,
                   _phone,
                   _email,
                   _employee_id,
                   _ransom_amount,
                   _card_dt
            RETURNING c.*)

    INSERT INTO history.clientschanges (client_id,
                                        card_id,
                                        card_type_id,
                                        first_name,
                                        surname,
                                        phone,
                                        email,
                                        employee_id,
                                        dt,
                                        ch_staff_id,
                                        ch_dt)
    SELECT ci.client_id,
           ci.card_id,
           ci.card_type_id,
           ci.first_name,
           ci.surname,
           ci.phone,
           ci.email,
           ci.employee_id,
           ci.dt,
           _staff_id,
           _dt
    FROM cte_ins ci;


    RETURN JSONB_BUILD_OBJECT('data', null);
END
$$;