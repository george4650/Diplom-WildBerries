CREATE OR REPLACE FUNCTION humanresource.employee_ins(_src jsonb) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN

    INSERT INTO humanresource.employees(employee_id, shop_id, first_name, surname, patronymic, salary, post, phone,
                                        email, dt)
    SELECT nextval('humanresource.employee_sq') as employee_id,
           s.shop_id,
           s.first_name,
           s.surname,
           s.patronymic,
           s.salary,
           s.post,
           s.phone,
           s.email,
           _dt                          as dt
    FROM jsonb_to_record(_src) as s (
                                     shop_id integer,
                                     first_name varchar(32),
                                     surname varchar(32),
                                     patronymic varchar(32),
                                     salary integer,
                                     post varchar(50),
                                     phone varchar(11),
                                     email varchar(50)
        );

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;