
-- DROP FUNCTION IF EXISTS no_of_contact_by_contact_group(varchar(128));
CREATE OR REPLACE FUNCTION no_of_contact_by_contact_group(p_contact_group_oid varchar(128))
RETURNS numeric(18, 2) AS $no_of_contact_by_contact_group$
    DECLARE
		no_of_contact			NUMERIC(18,2) := (select coalesce(count(oid), 0) from schoolerp.contact_group_detail where 1 = 1 and contact_group_oid = p_contact_group_oid);
    BEGIN
      RETURN no_of_contact;
    END;
$no_of_contact_by_contact_group$ LANGUAGE plpgsql;
-- SELECT no_of_contact_by_contact_group('10');

-- DROP FUNCTION IF EXISTS no_of_contact_group_by_sms_service(varchar(128));
CREATE OR REPLACE FUNCTION no_of_contact_group_by_sms_service(p_sms_service_oid varchar(128))
RETURNS numeric(18, 2) AS $no_of_contact_group_by_sms_service$
    DECLARE
		no_of_contact_group			NUMERIC(18,2) := (select coalesce(count(oid), 0) from schoolerp.sms_service_contact_group where 1 = 1 and sms_service_oid = p_sms_service_oid);
    BEGIN
      RETURN no_of_contact_group;
    END;
$no_of_contact_group_by_sms_service$ LANGUAGE plpgsql;
-- SELECT no_of_contact_group_by_sms_service('10');
