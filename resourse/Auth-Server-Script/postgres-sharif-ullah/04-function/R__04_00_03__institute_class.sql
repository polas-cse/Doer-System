
-- DROP FUNCTION IF EXISTS class_section_name_en(varchar(128));
CREATE OR REPLACE FUNCTION class_section_name_en(p_oid varchar(128))
RETURNS text AS $class_section_name_en$
    DECLARE
		section_name_en			text := (select string_agg(distinct name_en , ', ') from schoolerp.institute_class_section where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN section_name_en;
    END;
$class_section_name_en$ LANGUAGE plpgsql;
-- SELECT class_section_name_en('10');

-- DROP FUNCTION IF EXISTS class_section_name_bn(varchar(128));
CREATE OR REPLACE FUNCTION class_section_name_bn(p_oid varchar(128))
RETURNS text AS $class_section_name_bn$
    DECLARE
		section_name_bn			text := (select string_agg(distinct name_bn , ', ') from schoolerp.institute_class_section where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN section_name_bn;
    END;
$class_section_name_bn$ LANGUAGE plpgsql;
-- SELECT class_section_name_bn('10');
