CREATE OR REPLACE FUNCTION humanresource.employee_upd(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _employee_id integer;
    _shop_id     integer;
    _first_name  varchar(32);
    _surname     varchar(32);
    _patronymic  varchar(32);
    _salary      integer;
    _post        varchar(50);
    _phone       varchar(11);
    _email       varchar(50);
BEGIN

    SELECT COALESCE(s.employee_id, nextval('humanresource.employee_sq')) as employee_id,
           s.shop_id,
           s.first_name,
           s.surname,
           s.patronymic,
           s.salary,
           s.post,
           s.phone,
           s.email
    INTO _employee_id, _shop_id, _first_name, _surname, _patronymic, _salary, _post, _phone, _email
    FROM jsonb_to_record(_src) as s (
                                     employee_id integer,
                                     shop_id integer,
                                     first_name varchar(32),
                                     surname varchar(32),
                                     patronymic varchar(32),
                                     salary integer,
                                     post varchar(50),
                                     phone varchar(11),
                                     email varchar(50)
        );

    WITH ins_cte AS (
        INSERT INTO humanresource.employees AS e (employee_id,
                                                  shop_id,
                                                  first_name,
                                                  surname,
                                                  patronymic,
                                                  salary,
                                                  post,
                                                  phone,
                                                  email)
            SELECT _employee_id,
                   _shop_id,
                   _first_name,
                   _surname,
                   _patronymic,
                   _salary,
                   _post,
                   _phone,
                   _email
            ON CONFLICT (employee_id) DO UPDATE
                SET shop_id = excluded.shop_id,
                    first_name = excluded.first_name,
                    surname = excluded.surname,
                    patronymic = excluded.patronymic,
                    salary = excluded.salary,
                    post = excluded.post,
                    phone = excluded.phone,
                    email = excluded.email
            RETURNING e.*)

    INSERT
    INTO history.employeeschanges AS ec (employee_id,
                                         shop_id,
                                         first_name,
                                         surname,
                                         patronymic,
                                         salary,
                                         post,
                                         phone,
                                         email,
                                         staff_id,
                                         ch_dt)
    SELECT ic.employee_id,
           ic.shop_id,
           ic.first_name,
           ic.surname,
           ic.patronymic,
           ic.salary,
           ic.post,
           ic.phone,
           ic.email,
           _staff_id,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;