CREATE OR REPLACE FUNCTION humanresource.client_ins(_src jsonb, _employee_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message VARCHAR(500);
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
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
               WHEN c.phone = _phone AND c.is_deleted = false THEN 'Клиент с таким номером уже существует'
               END
    INTO _err_message
    FROM humanresource.clients c;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('humanresource.client_ins', _err_message, NULL);
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
            SELECT nextval('humanresource.client_sq') as client_id,
                   nextval('humanresource.card_sq')   as card_id,
                   1,
                   _first_name,
                   _surname,
                   _phone,
                   _email,
                   _employee_id,
                   _dt
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
           _employee_id,
           _dt
    FROM cte_ins ci;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;