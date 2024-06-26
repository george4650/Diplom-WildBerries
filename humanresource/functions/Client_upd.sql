CREATE OR REPLACE FUNCTION humanresource.client_upd(_src JSONB, _staff_id INTEGER) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _err_message  VARCHAR(500);
    _dt           TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _client_id    INTEGER;
    _card_id      INTEGER;
    _card_type_id SMALLINT;
    _first_name   VARCHAR(32);
    _surname      VARCHAR(32);
    _phone        VARCHAR(11);
    _email        VARCHAR(50);
BEGIN

    SELECT COALESCE(cl.client_id, nextval('humanresource.client_sq')) as client_id,
           COALESCE(cd.card_id, nextval('humanresource.card_sq'))     as card_id,
           s.card_type_id,
           s.first_name,
           s.surname,
           s.phone,
           s.email
    INTO _client_id,
        _card_id,
        _card_type_id,
        _first_name,
        _surname,
        _phone,
        _email

    FROM jsonb_to_record(_src) as s (
                                     client_id INTEGER,
                                     card_id INTEGER,
                                     card_type_id SMALLINT,
                                     first_name VARCHAR(32),
                                     surname VARCHAR(32),
                                     phone VARCHAR(11),
                                     email VARCHAR(50)
        )
             LEFT JOIN humanresource.clients cl ON cl.client_id = s.client_id
             LEFT JOIN humanresource.clients cd ON cd.card_id = s.card_id;

    SELECT CASE
               WHEN EXISTS(SELECT 1
                           FROM humanresource.clients c
                           WHERE c.phone = _phone
                             AND c.client_id != _client_id
                             AND c.card_id != _card_id)
                   THEN 'Клиент с таким номером уже учавствует в программе лояльности'
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
               _staff_id,
               _dt
        ON CONFLICT (client_id) DO UPDATE
            SET card_id    = excluded.card_id,
                first_name = excluded.first_name,
                surname    = excluded.surname,
                phone      = excluded.phone,
                email      = excluded.email
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

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;