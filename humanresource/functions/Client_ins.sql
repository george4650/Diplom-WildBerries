CREATE OR REPLACE FUNCTION humanresource.client_ins(_src jsonb, _employee_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message VARCHAR(500);
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _client_id   bigint;
    _first_name  varchar(32);
    _surname     varchar(32);
    _phone       varchar(11);
    _email       varchar(50);
BEGIN

    SELECT first_name, surname, phone, email
    INTO _first_name, _surname, _phone, _email
    FROM jsonb_to_record(_src) as s (
                                     first_name varchar(32),
                                     surname varchar(32),
                                     phone varchar(11),
                                     email varchar(50)
        );

    SELECT CASE
               WHEN c.phone = _phone THEN 'Клиент с таким номером уже существует'
               END
    INTO _err_message
    FROM humanresource.clients c;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('humanresource.client_ins', _err_message, NULL);
    END IF;


    INSERT INTO humanresource.clients (client_id,
                                       first_name,
                                       surname,
                                       phone,
                                       email)
    SELECT nextval('humanresource.client_sq') as client_id,
           _first_name,
           _surname,
           _phone,
           _email
    RETURNING client_id INTO _client_id;

    INSERT INTO humanresource.cards (card_id,
                                     client_id,
                                     employee_id,
                                     dt)
    SELECT nextval('humanresource.card_sq') as card_id,
           _client_id,
           _employee_id,
           _dt;

    INSERT INTO history.clientschanges (client_id,
                                        first_name,
                                        surname,
                                        phone,
                                        email,
                                        staff_id,
                                        ch_dt)
    SELECT _client_id,
           _first_name,
           _surname,
           _phone,
           _email,
           _employee_id,
           _dt;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;