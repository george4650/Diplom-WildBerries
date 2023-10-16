CREATE OR REPLACE FUNCTION humanresource.client_upd(_src jsonb, _employee_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message  VARCHAR(500);
    _dt           TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _client_id    integer;
    _card_id      integer;
    _card_type_id smallint;
    _first_name   varchar(32);
    _surname      varchar(32);
    _phone        varchar(11);
    _email        varchar(50);
BEGIN

    SELECT COALESCE(s.client_id, nextval('humanresource.client_sq')) as client_id,
           nextval('humanresource.card_sq')                          as card_id,
           card_type_id,
           first_name,
           surname,
           phone,
           email
    INTO _client_id,
        _card_id,
        _card_type_id,
        _first_name,
        _surname,
        _phone,
        _email

    FROM jsonb_to_record(_src) as s (
                                     client_id integer,
                                     card_type_id smallint,
                                     first_name varchar(32),
                                     surname varchar(32),
                                     phone varchar(11),
                                     email varchar(50)
        );

    SELECT CASE
               WHEN EXISTS(SELECT 1 FROM humanresource.clients c WHERE c.phone = _phone) AND _client_id is null
                   THEN 'Клиент с таким номером уже существует'

               WHEN EXISTS(SELECT 1 FROM humanresource.clients c WHERE c.phone = _phone)
                   AND NOT EXISTS(SELECT 1 FROM humanresource.clients c WHERE client_id = _client_id AND c.phone = _phone)
                   AND _client_id is not null THEN 'Клиент с таким номером уже существует'
               END
    INTO _err_message;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('humanresource.client_upd', _err_message, NULL);
    END IF;


    WITH cte_ins AS (
        INSERT INTO humanresource.clients as c (client_id,
                                                card_id,
                                                card_type_id,
                                                first_name,
                                                surname,
                                                phone,
                                                email,
                                                employee_id,
                                                dt)
            SELECT _client_id,
                   _card_id,
                   _card_type_id,
                   _first_name,
                   _surname,
                   _phone,
                   _email,
                   _employee_id,
                   _dt
            ON CONFLICT (client_id) DO UPDATE
                SET first_name = excluded.first_name,
                    surname = excluded.surname,
                    phone = excluded.phone,
                    email = excluded.email
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
           _employee_id,
           _dt
    FROM cte_ins ci;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;