--DROP FUNCTION IF EXISTS uuid();
CREATE OR REPLACE FUNCTION uuid()
RETURNS varchar(64) AS $uuid$
    BEGIN
		RETURN (SELECT to_char(clock_timestamp(), 'YYYYMMDDHH24MISSMS') || '-' || uuid_in(overlay(overlay(md5(random()::text || ':' || clock_timestamp()::text) placing '4' FROM 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text FROM 17)::cstring));
    END;
$uuid$ language plpgsql;
--select uuid();


--DROP FUNCTION IF EXISTS addDayToDay();
CREATE OR REPLACE FUNCTION addDayToDay()
RETURNS text AS $addDayToDay$
    BEGIN
		--RETURN (select now() + interval '"'+day+'" Day');
		RETURN (select to_char((now() + interval '10 Day'), 'YYYY-MM-DD'));
    END;
$addDayToDay$ language plpgsql;
--select addDayToDay();
