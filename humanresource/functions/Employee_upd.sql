CREATE OR REPLACE FUNCTION humanresource.employee_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _employee_id integer;
    _shop_id     integer;
    _post_id     smallint;
    _first_name  varchar(32);
    _surname     varchar(32);
    _patronymic  varchar(32);
    _phone       varchar(11);
    _email       varchar(50);
    _deleted_at  TIMESTAMPTZ;
BEGIN

    SELECT COALESCE(s.employee_id, nextval('humanresource.employee_sq')) as employee_id,
           s.shop_id,
           s.post_id,
           s.first_name,
           s.surname,
           s.patronymic,
           s.phone,
           s.email,
           s.deleted_at
    INTO _employee_id, _shop_id,_post_id, _first_name, _surname, _patronymic, _phone, _email, _deleted_at
    FROM jsonb_to_record(_src) as s (
                                     employee_id integer,
                                     shop_id integer,
                                     post_id smallint,
                                     first_name varchar(32),
                                     surname varchar(32),
                                     patronymic varchar(32),
                                     phone varchar(11),
                                     email varchar(50),
                                     deleted_at TIMESTAMPTZ
        );

    IF _deleted_at IS NOT NULL THEN

        UPDATE humanresource.employees e
        SET deleted_at = _dt
        WHERE e.employee_id = _employee_id;

        RETURN JSONB_BUILD_OBJECT('data', NULL);

    END IF;

    WITH ins_cte AS (
        INSERT INTO humanresource.employees AS e (employee_id,
                                                  shop_id,
                                                  post_id,
                                                  first_name,
                                                  surname,
                                                  patronymic,
                                                  phone,
                                                  email)
            SELECT _employee_id,
                   _shop_id,
                   _post_id,
                   _first_name,
                   _surname,
                   _patronymic,
                   _phone,
                   _email
            ON CONFLICT (employee_id) DO UPDATE
                SET shop_id = excluded.shop_id,
                    post_id = excluded.post_id,
                    first_name = excluded.first_name,
                    surname = excluded.surname,
                    patronymic = excluded.patronymic,
                    phone = excluded.phone,
                    email = excluded.email
            RETURNING e.*)

    INSERT INTO history.employeeschanges AS ec (employee_id,
                                                shop_id,
                                                post_id,
                                                first_name,
                                                surname,
                                                patronymic,
                                                phone,
                                                email,
                                                ch_staff_id,
                                                ch_dt)
    SELECT ic.employee_id,
           ic.shop_id,
           ic.post_id,
           ic.first_name,
           ic.surname,
           ic.patronymic,
           ic.phone,
           ic.email,
           _staff_id,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;