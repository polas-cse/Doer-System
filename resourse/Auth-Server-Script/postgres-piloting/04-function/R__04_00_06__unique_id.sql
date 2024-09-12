
--DROP FUNCTION IF EXISTS admission_id();
CREATE OR REPLACE FUNCTION admission_id(p_class_oid varchar(128), p_gender varchar(128))
RETURNS varchar(64) AS $admission_id$
    BEGIN
		RETURN (select  concat(i.eiin_number, to_char(now(), 'YY'), upper(LEFT(p_gender, 1)), class_id, 
		lpad((select count(a.oid)+1 from institute_admission a where a.institute_class_oid = p_class_oid)::text, 4,'0')) 
		from institute_class ic left join institute i on i.oid = ic.institute_oid where ic.oid = p_class_oid);
    END;
$admission_id$ language plpgsql;
--select admission_id();

--DROP FUNCTION IF EXISTS student_id();
CREATE OR REPLACE FUNCTION student_id(p_class_oid varchar(128), p_gender varchar(128))
RETURNS varchar(64) AS $student_id$
    BEGIN
		RETURN (select  concat(i.eiin_number, to_char(now(), 'YY'), upper(LEFT(p_gender, 1)), class_id, 
		lpad((select count(s.oid)+1 from student s where s.institute_class_oid = p_class_oid)::text, 4,'0')) 
		from institute_class ic left join institute i on i.oid = ic.institute_oid where ic.oid = p_class_oid);
    END;
$student_id$ language plpgsql;
--select admission_id();
