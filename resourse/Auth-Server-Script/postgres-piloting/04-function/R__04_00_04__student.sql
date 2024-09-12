
-- DROP FUNCTION IF EXISTS no_of_student_by_class(varchar(128));
CREATE OR REPLACE FUNCTION no_of_student_by_class(p_oid varchar(128))
RETURNS numeric(18, 2) AS $no_of_student_by_class$
    DECLARE
		no_of_student			NUMERIC(18,2) := (select coalesce(count(oid), 0) from schoolerp.student where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN no_of_student;
    END;
$no_of_student_by_class$ LANGUAGE plpgsql;
-- SELECT no_of_student_by_class('10');


-- DROP FUNCTION IF EXISTS no_of_student_by_textbook(varchar(128));
CREATE OR REPLACE FUNCTION no_of_student_by_textbook(p_class_oid varchar(128), p_textbook_oid varchar(128))
RETURNS numeric(18, 2) AS $no_of_student_by_textbook$
    DECLARE
		no_of_student			NUMERIC(18,2) := (select coalesce(count(oid), 0) from schoolerp.student_textbook where 1 = 1 and institute_class_oid = p_class_oid and  institute_class_textbook_oid = p_textbook_oid);
    BEGIN
      RETURN no_of_student;
    END;
$no_of_student_by_textbook$ LANGUAGE plpgsql;
-- SELECT no_of_student_by_textbook('10','10');


--DROP FUNCTION IF EXISTS no_of_student_by_subject(varchar(128));
CREATE OR REPLACE FUNCTION no_of_student_by_subject(p_institute_class_subject_oid varchar(128))
RETURNS numeric(18, 2) AS $no_of_student_by_subject$
    DECLARE
		no_of_student			NUMERIC(18,2) := (select count(i.oid) from schoolerp.institute_class_subject i, schoolerp.student_subject st 
			where 1 = 1 and i.education_subject_oid = st.education_subject_oid and i.institute_oid = st.institute_oid 
			and i.institute_session_oid = st.institute_session_oid and i.institute_class_oid = st.institute_class_oid 
			and i.oid = p_institute_class_subject_oid);
    BEGIN
      RETURN no_of_student;
    END;
$no_of_student_by_subject$ LANGUAGE plpgsql;
-- SELECT no_of_student_by_subject('10','10');
