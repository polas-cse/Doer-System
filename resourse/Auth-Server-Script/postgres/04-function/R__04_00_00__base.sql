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


--DROP FUNCTION IF EXISTS random_number();
CREATE OR REPLACE FUNCTION random_number()
RETURNS INT AS $random_number$
    BEGIN
		RETURN floor(random() * (999999) + 1);
    END;
$random_number$ language plpgsql;
--select random_number();


--DROP FUNCTION IF EXISTS random_number();
CREATE OR REPLACE FUNCTION random_between(low INT, high INT)
RETURNS INT AS $random_between$
    BEGIN
		RETURN floor(random() * (high-low + 1) + low);
    END;
$random_between$ language plpgsql;
--select random_between(1, 100000);

