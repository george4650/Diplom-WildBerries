CREATE OR REPLACE FUNCTION petshop.markup_ins(_src jsonb, _staff_id integer) returns json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt     TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _nm_id  integer;
    _markup numeric(6, 2);

BEGIN

    SELECT nm_id, markup
    INTO _nm_id, _markup
    FROM jsonb_to_record(_src) as s (nm_id integer,
                                     markup numeric(6, 2)
        );

    INSERT INTO petshop.markup (nm_id, markup)
    SELECT _nm_id,
           _markup;

    INSERT INTO history.markupchanges (nm_id,
                                       markup,
                                       staff_id,
                                       ch_dt)
    SELECT _nm_id,
           _markup,
           _staff_id,
           _dt;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;