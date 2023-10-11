CREATE OR REPLACE FUNCTION humanresource.client_upd(_src jsonb, _staff_id integer) returns json
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


    SELECT client_id,
           first_name,
           surname,
           phone,
           email
    INTO _client_id, _first_name, _surname, _phone, _email
    FROM jsonb_to_record(_src) as s (
                                     client_id bigint,
                                     first_name varchar(32),
                                     surname varchar(32),
                                     phone varchar(11),
                                     email varchar(50)
        );

    SELECT CASE
               WHEN
                           (select c.phone from humanresource.clients c where c.client_id = _client_id) != _phone AND
                           c.phone = _phone THEN 'Клиент с таким номером уже существует'
               END
    INTO _err_message
    FROM humanresource.clients c;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('humanresource.client_upd', _err_message, NULL);
    END IF;

    WITH cte_upd AS (
        UPDATE humanresource.clients
        SET first_name = _first_name AND surname = _surname AND phone = _phone AND email = _email
        WHERE client_id = _client_id
        RETURNING *
        )

    INSERT INTO history.clientschanges (client_id,
                                        first_name,
                                        surname,
                                        phone,
                                        email,
                                        staff_id,
                                        ch_dt)
    SELECT cu.client_id,
           cu.first_name,
           cu.surname,
           cu.phone,
           cu.email,
           _staff_id,
           _dt
    FROM cte_upd cu;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;