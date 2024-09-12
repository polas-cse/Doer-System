--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Ubuntu 13.5-0ubuntu0.21.04.1)
-- Dumped by pg_dump version 13.5 (Ubuntu 13.5-0ubuntu0.21.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: schoolerp; Type: SCHEMA; Schema: -; Owner: dbadmin
--

CREATE SCHEMA schoolerp;


ALTER SCHEMA schoolerp OWNER TO dbadmin;

--
-- Name: class_section_name_bn(character varying); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION public.class_section_name_bn(p_oid character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
    DECLARE
		section_name_bn			text := (select string_agg(distinct name_bn , ', ') from schoolerp.institute_class_section where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN section_name_bn;
    END;
$$;


ALTER FUNCTION public.class_section_name_bn(p_oid character varying) OWNER TO dbadmin;

--
-- Name: class_section_name_en(character varying); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION public.class_section_name_en(p_oid character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
    DECLARE
		section_name_en			text := (select string_agg(distinct name_en , ', ') from schoolerp.institute_class_section where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN section_name_en;
    END;
$$;


ALTER FUNCTION public.class_section_name_en(p_oid character varying) OWNER TO dbadmin;

--
-- Name: student_due_fees_settings(text); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION public.student_due_fees_settings(p_data text) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
    	fees_oid	varchar(128);
    	v_json          json;
--/#    SELECT * FROM schoolerp.fees_setting where institute_oid = v_json->>'instituteOid' and institute_class_oid =  v_json->>'instituteClassOid' and session_oid =  v_json->>'sessionOid' and head_code in (v_json->>'headCodes');
  		feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = 'SCHOOL-ERP-Demo-School-001' and institute_class_oid =  'SCHOOL-ERP-Institute-Class-6' and session_oid ='SCHOOL-ERP-Institute-Session-2022' and head_code in ('ADMISSION_FEE', 'ANNUAL_CHARGE', 'DEVELOPMENT_CHARGE','OTHERS','UTILITY_CHARGE');
    begin
	SELECT p_data::json INTO v_json;
	for feesSetting in feesSettingCoursor loop
	fees_oid = uuid();
	
	INSERT INTO schoolerp.due_fees
	(oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(fees_oid, v_json->>'studentId', v_json->>'studentOid', feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP, v_json->>'applicationTrackingId');
	
	INSERT INTO schoolerp.due_fees_history
	(oid, due_fees_oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(uuid(), fees_oid, v_json->>'studentId', v_json->>'studentOid', feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP, v_json->>'applicationTrackingId');
	
	end loop;
    END;
$$;


ALTER FUNCTION public.student_due_fees_settings(p_data text) OWNER TO dbadmin;

--
-- Name: student_due_fees_settings(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION public.student_due_fees_settings(instituteoid character varying, instituteclassoid character varying, sessionoid character varying, headcode character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
    	fees_oid	varchar(128);
	feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = instituteOid and institute_class_oid = instituteClassOid and session_oid = sessionOid and head_code in ('ADMISSION_FEE','ANNUAL_CHARGE');
	i integer;
    BEGIN
	i := 0;
	for feesSetting in feesSettingCoursor loop
	i := i+1;
	fees_oid = uuid();
	
	INSERT INTO schoolerp.due_fees
	(oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(fees_oid, 'STUDENT-000000', 'SCHOOL-ERP-Institute-Student-0000', feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, 'Student Fees Details', 'Due', CURRENT_USER, CURRENT_TIMESTAMP, '123');
	
	
	INSERT INTO schoolerp.due_fees_history
	(oid, due_fees_oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(uuid(), fees_oid, 'STUDENT-000000', 'SCHOOL-ERP-Institute-Student-0000', feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, 'Student Fees Details', 'Due', CURRENT_USER, CURRENT_TIMESTAMP, '123');
	
	end loop;
    END;
$$;


ALTER FUNCTION public.student_due_fees_settings(instituteoid character varying, instituteclassoid character varying, sessionoid character varying, headcode character varying) OWNER TO dbadmin;

--
-- Name: student_due_fees_settings_01(character varying, character varying, character varying, text[]); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION public.student_due_fees_settings_01(instituteoid character varying, instituteclassoid character varying, sessionoid character varying, headcodes text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
    	fees_oid	varchar(128);
	feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = instituteOid and institute_class_oid = instituteClassOid and session_oid = sessionOid and head_code in (headCodes);
	i integer;
    BEGIN
	i := 0;
	for feesSetting in feesSettingCoursor loop
	i := i+1;
	fees_oid = uuid();
	
	INSERT INTO schoolerp.due_fees
	(oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(fees_oid, studentId, studentOid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, remarks, status, CURRENT_USER, CURRENT_TIMESTAMP, applicationTrackingId);
	
	INSERT INTO schoolerp.due_fees_history
	(oid, due_fees_oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(uuid(), fees_oid, studentId, studentOid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, remarks, status, CURRENT_USER, CURRENT_TIMESTAMP, applicationTrackingId);
	
	end loop;
    END;
$$;


ALTER FUNCTION public.student_due_fees_settings_01(instituteoid character varying, instituteclassoid character varying, sessionoid character varying, headcodes text[]) OWNER TO dbadmin;

--
-- Name: student_due_fees_settings_01(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION public.student_due_fees_settings_01(instituteoid character varying, instituteclassoid character varying, sessionoid character varying, headcode character varying, studentid character varying, studentoid character varying, remarks character varying, status character varying, applicationtrackingid character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
    	fees_oid	varchar(128);
	feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = instituteOid and institute_class_oid = instituteClassOid and session_oid = sessionOid and head_code = headCode;
	i integer;
    BEGIN
	i := 0;
	for feesSetting in feesSettingCoursor loop
	i := i+1;
	fees_oid = uuid();
	
	INSERT INTO schoolerp.due_fees
	(oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(fees_oid, studentId, studentOid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, remarks, status, CURRENT_USER, CURRENT_TIMESTAMP, applicationTrackingId);
	
	INSERT INTO schoolerp.due_fees_history
	(oid, due_fees_oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(uuid(), fees_oid, studentId, studentOid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, remarks, status, CURRENT_USER, CURRENT_TIMESTAMP, applicationTrackingId);
	
	end loop;
    END;
$$;


ALTER FUNCTION public.student_due_fees_settings_01(instituteoid character varying, instituteclassoid character varying, sessionoid character varying, headcode character varying, studentid character varying, studentoid character varying, remarks character varying, status character varying, applicationtrackingid character varying) OWNER TO dbadmin;

--
-- Name: uuid(); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION public.uuid() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    BEGIN
		RETURN (SELECT to_char(clock_timestamp(), 'YYYYMMDDHH24MISSMS') || '-' || uuid_in(overlay(overlay(md5(random()::text || ':' || clock_timestamp()::text) placing '4' FROM 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text FROM 17)::cstring));
    END;
$$;


ALTER FUNCTION public.uuid() OWNER TO dbadmin;

--
-- Name: addmission_fees_calculate(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.addmission_fees_calculate(p_data character varying, instituteoid character varying, instituteclassoid character varying, sessionoid character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
    	fees_oid	varchar(128);
    	v_json          json;
	feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = instituteOid and institute_class_oid = instituteClassOid and session_oid = sessionOid and head_code in ('ADMISSION_FEE', 'ANNUAL_CHARGE','DEVELOPMENT_CHARGE','OTHERS','UTILITY_CHARGE');
--/#  		feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = 'SCHOOL-ERP-Demo-School-001' and institute_class_oid =  'SCHOOL-ERP-Institute-Class-6' and session_oid ='SCHOOL-ERP-Institute-Session-2022' and head_code in ('ADMISSION_FEE', 'ANNUAL_CHARGE','DEVELOPMENT_CHARGE','OTHERS','UTILITY_CHARGE');
       begin
	SELECT p_data::json INTO v_json;
	for feesSetting in feesSettingCoursor loop
	fees_oid = uuid();
	
	INSERT INTO schoolerp.due_fees
	(oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(fees_oid, v_json->>'studentId', v_json->>'studentOid', feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, 
	feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP, v_json->>'applicationTrackingId');
	
	INSERT INTO schoolerp.due_fees_history
	(oid, due_fees_oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)
	
	VALUES(uuid(), fees_oid, v_json->>'studentId', v_json->>'studentOid', feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.institute_oid, feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP, v_json->>'applicationTrackingId');
	
	end loop;
    END;
$$;


ALTER FUNCTION schoolerp.addmission_fees_calculate(p_data character varying, instituteoid character varying, instituteclassoid character varying, sessionoid character varying) OWNER TO dbadmin;

--
-- Name: class_section_name_bn(character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.class_section_name_bn(p_oid character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
    DECLARE
		section_name_bn			text := (select string_agg(distinct name_bn , ', ') from schoolerp.institute_class_section where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN section_name_bn;
    END;
$$;


ALTER FUNCTION schoolerp.class_section_name_bn(p_oid character varying) OWNER TO dbadmin;

--
-- Name: class_section_name_en(character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.class_section_name_en(p_oid character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
    DECLARE
		section_name_en			text := (select string_agg(distinct name_en , ', ') from schoolerp.institute_class_section where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN section_name_en;
    END;
$$;


ALTER FUNCTION schoolerp.class_section_name_en(p_oid character varying) OWNER TO dbadmin;

--
-- Name: institute_shift_name_bn(character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.institute_shift_name_bn(p_oid character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
    DECLARE
		shift_name_bn			text := (select string_agg(name_bn , ', ') from schoolerp.institute_shift where 1 = 1 and institute_oid = p_oid);
    BEGIN
      RETURN shift_name_bn;
    END;
$$;


ALTER FUNCTION schoolerp.institute_shift_name_bn(p_oid character varying) OWNER TO dbadmin;

--
-- Name: institute_shift_name_en(character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.institute_shift_name_en(p_oid character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
    DECLARE
		shift_name_en			text := (select string_agg(name_en , ', ') from schoolerp.institute_shift where 1 = 1 and institute_oid = p_oid);
    BEGIN
      RETURN shift_name_en;
    END;
$$;


ALTER FUNCTION schoolerp.institute_shift_name_en(p_oid character varying) OWNER TO dbadmin;

--
-- Name: no_of_student_by_class(character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.no_of_student_by_class(p_oid character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
    DECLARE
		no_of_student			NUMERIC(18,2) := (select coalesce(count(oid), 0) from schoolerp.student where 1 = 1 and institute_class_oid = p_oid);
    BEGIN
      RETURN no_of_student;
    END;
$$;


ALTER FUNCTION schoolerp.no_of_student_by_class(p_oid character varying) OWNER TO dbadmin;

--
-- Name: no_of_student_by_textbook(character varying, character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.no_of_student_by_textbook(p_class_oid character varying, p_textbook_oid character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
    DECLARE
		no_of_student			NUMERIC(18,2) := (select coalesce(count(oid), 0) from schoolerp.student_textbook where 1 = 1 and institute_class_oid = p_class_oid and  institute_class_textbook_oid = p_textbook_oid);
    BEGIN
      RETURN no_of_student;
    END;
$$;


ALTER FUNCTION schoolerp.no_of_student_by_textbook(p_class_oid character varying, p_textbook_oid character varying) OWNER TO dbadmin;

--
-- Name: prepare_result_by_class_text_book(character varying, character varying, character varying); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.prepare_result_by_class_text_book(p_exam_oid character varying, p_exam_class_oid character varying, p_text_book_oid character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_start_marks             		int4;
        v_end_marks             		int4;
        v_obtained_marks             		int4;
    	v_student				record;	
    	v_grade_detail_list			record;	
    	v_grade_detail				record;	
        v_grading_system_oid                    varchar(128);			
    BEGIN
    
        select grading_system_oid into v_grading_system_oid from schoolerp.exam_class where 1 = 1 and institute_class_oid = p_exam_class_oid and exam_oid = p_exam_oid limit 1;
        
	for v_student in (SELECT oid, obtained_marks  FROM schoolerp.exam_result_marks where exam_oid = p_exam_oid and class_textbook_oid = p_text_book_oid) loop
				
		select v_student.obtained_marks::int4 into v_obtained_marks;			
		for v_grade_detail in (select start_marks, end_marks, letter_grade, grade_point, assessment from schoolerp.institute_grading_system_detail where institute_grading_system_oid = v_grading_system_oid) loop
			select v_grade_detail.start_marks::int4 into v_start_marks;
			select v_grade_detail.end_marks::int4 into v_end_marks;
			if (v_obtained_marks > (v_start_marks-1) and v_obtained_marks < (v_end_marks+1))  
		    then
			update schoolerp.exam_result_marks set letter_grade = v_grade_detail.letter_grade, grade_point = v_grade_detail.grade_point, assessment = v_grade_detail.assessment where oid = v_student.oid;
		
			end if; 
		end loop;
	end loop;
    END;
$$;


ALTER FUNCTION schoolerp.prepare_result_by_class_text_book(p_exam_oid character varying, p_exam_class_oid character varying, p_text_book_oid character varying) OWNER TO dbadmin;

--
-- Name: uuid(); Type: FUNCTION; Schema: schoolerp; Owner: dbadmin
--

CREATE FUNCTION schoolerp.uuid() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    BEGIN
		RETURN (SELECT to_char(clock_timestamp(), 'YYYYMMDDHH24MISSMS') || '-' || uuid_in(overlay(overlay(md5(random()::text || ':' || clock_timestamp()::text) placing '4' FROM 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text FROM 17)::cstring));
    END;
$$;


ALTER FUNCTION schoolerp.uuid() OWNER TO dbadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: class_period; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.class_period (
    oid character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(128),
    institute_oid character varying(128),
    institute_shift_oid character varying(128),
    start_time character varying(32),
    end_time character varying(32),
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.class_period OWNER TO dbadmin;

--
-- Name: class_routine; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.class_routine (
    oid character varying(128) NOT NULL,
    institute_oid character varying(128),
    institute_shift_oid character varying(128),
    institute_session_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_section_oid character varying(128),
    institute_class_group_oid character varying(128),
    institute_version_oid character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.class_routine OWNER TO dbadmin;

--
-- Name: class_routine_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.class_routine_detail (
    oid character varying(128) NOT NULL,
    week_day_oid character varying(128),
    class_period_oid character varying(128),
    class_textbook_oid character varying(128),
    teacher_oid character varying(128),
    class_routine_oid character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE schoolerp.class_routine_detail OWNER TO dbadmin;

--
-- Name: country; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.country (
    oid character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(128),
    capital character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.country OWNER TO dbadmin;

--
-- Name: district; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.district (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    establish_year character varying(128),
    status character varying(128),
    division_oid character varying(128) NOT NULL,
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.district OWNER TO dbadmin;

--
-- Name: division; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.division (
    oid character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(128),
    capital character varying(128),
    establish_year character varying(32),
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.division OWNER TO dbadmin;

--
-- Name: due_fees; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.due_fees (
    oid character varying(128) NOT NULL,
    student_id character varying(128) NOT NULL,
    student_oid character varying(128) NOT NULL,
    head_code character varying(128) NOT NULL,
    fee_head_oid character varying(128) NOT NULL,
    institute_oid character varying(128) NOT NULL,
    institute_class_oid character varying(128) NOT NULL,
    application_tracking_id character varying(128) NOT NULL,
    reference_no character varying(128),
    due_amount numeric(20,2) DEFAULT 0,
    paid_amount numeric(20,2) DEFAULT 0,
    remarks character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.due_fees OWNER TO dbadmin;

--
-- Name: due_fees_history; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.due_fees_history (
    oid character varying(128) NOT NULL,
    due_fees_oid character varying(128) NOT NULL,
    student_id character varying(128) NOT NULL,
    student_oid character varying(128) NOT NULL,
    head_code character varying(128) NOT NULL,
    fee_head_oid character varying(128) NOT NULL,
    institute_oid character varying(128) NOT NULL,
    institute_class_oid character varying(128) NOT NULL,
    due_amount numeric(20,2) DEFAULT 0,
    remarks character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.due_fees_history OWNER TO dbadmin;

--
-- Name: education_board; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_board (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    short_name character varying(128),
    website character varying(128),
    status character varying(128),
    education_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_board OWNER TO dbadmin;

--
-- Name: education_class; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_class (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    admission_age numeric(5,0) DEFAULT 0,
    grade character varying(128),
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    education_class_level_oid character varying(128),
    education_type_oid character varying(128),
    education_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_class OWNER TO dbadmin;

--
-- Name: education_class_level; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_class_level (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    no_of_class numeric(5,0) DEFAULT 0 NOT NULL,
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    education_type_oid character varying(128),
    education_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_class_level OWNER TO dbadmin;

--
-- Name: education_curriculum; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_curriculum (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    short_name character varying(128),
    website character varying(128),
    status character varying(128),
    education_medium_oid character varying(128),
    country_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_curriculum OWNER TO dbadmin;

--
-- Name: education_grading_system; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_grading_system (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    grade_point_scale numeric(5,0) DEFAULT 0 NOT NULL,
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    education_type_oid character varying(128),
    education_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_grading_system OWNER TO dbadmin;

--
-- Name: education_grading_system_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_grading_system_detail (
    oid character varying(128) NOT NULL,
    start_marks numeric(5,0) DEFAULT 0 NOT NULL,
    end_marks numeric(5,0) DEFAULT 0 NOT NULL,
    letter_grade character varying(128),
    grade_point character varying(128),
    assessment character varying(128),
    remarks character varying(128),
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    education_grading_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_grading_system_detail OWNER TO dbadmin;

--
-- Name: education_group; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_group (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    status character varying(128),
    education_system_oid character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_group OWNER TO dbadmin;

--
-- Name: education_medium; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_medium (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    short_name character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_medium OWNER TO dbadmin;

--
-- Name: education_session; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_session (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    education_type_json text,
    status character varying(128),
    education_system_oid character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.education_session OWNER TO dbadmin;

--
-- Name: education_shift; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_shift (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    status character varying(128),
    education_system_oid character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_shift OWNER TO dbadmin;

--
-- Name: education_system; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_system (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    short_name character varying(128),
    status character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_system OWNER TO dbadmin;

--
-- Name: education_textbook; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_textbook (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    subject_code character varying(128),
    e_book_link character varying(256),
    status character varying(128),
    education_session_oid character varying(128),
    education_version_oid character varying(128),
    education_group_oid character varying(128),
    education_class_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.education_textbook OWNER TO dbadmin;

--
-- Name: education_type; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_type (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    short_name character varying(128),
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    education_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_type OWNER TO dbadmin;

--
-- Name: education_version; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.education_version (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    status character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.education_version OWNER TO dbadmin;

--
-- Name: exam; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.exam (
    oid character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(128),
    start_date character varying(128),
    end_date character varying(128),
    exam_type character varying(128),
    status character varying(128),
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.exam OWNER TO dbadmin;

--
-- Name: exam_class; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.exam_class (
    oid character varying(128) NOT NULL,
    exam_oid character varying(128),
    institute_class_oid character varying(128),
    grading_system_oid character varying(128),
    no_of_student numeric(5,0) DEFAULT 0,
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.exam_class OWNER TO dbadmin;

--
-- Name: exam_result; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.exam_result (
    oid character varying(128) NOT NULL,
    exam_oid character varying(128),
    institute_session_oid character varying(128),
    institute_oid character varying(128),
    approved_by character varying(128),
    approved_on timestamp without time zone,
    published_by character varying(128),
    published_on timestamp without time zone,
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.exam_result OWNER TO dbadmin;

--
-- Name: exam_result_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.exam_result_detail (
    oid character varying(128) NOT NULL,
    exam_oid character varying(128),
    exam_result_oid character varying(128),
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_group_oid character varying(128),
    institute_class_section_oid character varying(128),
    institute_shift_oid character varying(128),
    institute_version_oid character varying(128),
    grading_system_oid character varying(128),
    approved_by character varying(128),
    approved_on timestamp without time zone,
    published_by character varying(128),
    published_on timestamp without time zone,
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.exam_result_detail OWNER TO dbadmin;

--
-- Name: exam_result_marks; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.exam_result_marks (
    oid character varying(128) NOT NULL,
    exam_oid character varying(128),
    exam_result_detail_oid character varying(128),
    institute_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_section_oid character varying(128),
    student_id character varying(128),
    class_textbook_oid character varying(128),
    total_marks numeric(32,0) DEFAULT 0,
    obtained_marks numeric(32,0) DEFAULT 0,
    letter_grade character varying(128),
    grade_point character varying(128),
    assessment character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.exam_result_marks OWNER TO dbadmin;

--
-- Name: exam_routine; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.exam_routine (
    oid character varying(128) NOT NULL,
    exam_date character varying(128),
    exam_oid character varying(128),
    exam_class_oid character varying(128),
    exam_time_oid character varying(128),
    class_textbook_oid character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.exam_routine OWNER TO dbadmin;

--
-- Name: exam_time; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.exam_time (
    oid character varying(128) NOT NULL,
    start_time character varying(128),
    end_time character varying(128),
    exam_duration character varying(128),
    exam_oid character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.exam_time OWNER TO dbadmin;

--
-- Name: fee_head; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.fee_head (
    oid character varying(128) NOT NULL,
    institute_oid character varying(128) NOT NULL,
    head_code character varying(128),
    name_en character varying(128) NOT NULL,
    name_bn character varying(128) NOT NULL,
    head_type character varying(128) NOT NULL,
    remarks character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.fee_head OWNER TO dbadmin;

--
-- Name: fees_collection; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.fees_collection (
    oid character varying(128) NOT NULL,
    collection_date timestamp without time zone,
    student_id character varying(128) NOT NULL,
    payment_code character varying(128),
    total_waiver_amount numeric(20,2) DEFAULT 0,
    total_discount_amount numeric(20,2) DEFAULT 0,
    due_amount numeric(20,2) DEFAULT 0,
    paid_amount numeric(20,2) DEFAULT 0,
    total_amount numeric(20,2) DEFAULT 0,
    remarks character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.fees_collection OWNER TO dbadmin;

--
-- Name: fees_collection_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.fees_collection_detail (
    oid character varying(128) NOT NULL,
    fees_collection_oid character varying(128) NOT NULL,
    due_fees_oid character varying(128) NOT NULL,
    head_code character varying(128),
    waiver_percentage numeric(20,2) DEFAULT 0,
    waiver_amount numeric(20,2) DEFAULT 0,
    discount_amount numeric(20,2) DEFAULT 0,
    due_amount numeric(20,2) DEFAULT 0,
    paid_amount numeric(20,2) DEFAULT 0,
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.fees_collection_detail OWNER TO dbadmin;

--
-- Name: fees_setting; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.fees_setting (
    oid character varying(128) NOT NULL,
    head_code character varying(128) NOT NULL,
    fee_head_oid character varying(128) NOT NULL,
    institute_oid character varying(128) NOT NULL,
    institute_class_oid character varying(128) NOT NULL,
    session_oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256) NOT NULL,
    amount numeric(20,2) DEFAULT 0,
    remarks character varying(256),
    payment_last_date timestamp without time zone,
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.fees_setting OWNER TO dbadmin;

--
-- Name: file_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.file_detail (
    oid character varying(128) NOT NULL,
    application_tracking_id character varying(128),
    registration_id character varying(128),
    offer_id character varying(128),
    payment_id character varying(128),
    policy_no character varying(256),
    insurer_id character varying(128),
    file_name character varying(256) NOT NULL,
    file_type character varying(256) NOT NULL,
    document_title character varying(256),
    file_url character varying(256) NOT NULL,
    file_path character varying(256) NOT NULL,
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.file_detail OWNER TO dbadmin;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE schoolerp.flyway_schema_history OWNER TO dbadmin;

--
-- Name: guardian; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.guardian (
    oid character varying(128) NOT NULL,
    login_id character varying(128),
    guardian_id character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(256),
    date_of_birth date,
    email character varying(128),
    mobile_no character varying(128),
    gender character varying(128),
    religion character varying(128),
    nationality character varying(128),
    blood_group character varying(128),
    educational_qualification character varying(128),
    father_name_en character varying(128) NOT NULL,
    father_name_bn character varying(256),
    father_occupation character varying(128),
    father_contact_number character varying(128),
    father_email character varying(128),
    mother_name_en character varying(128) NOT NULL,
    mother_name_bn character varying(256),
    mother_occupation character varying(128),
    mother_contact_number character varying(128),
    mother_email character varying(128),
    emergency_contact_person character varying(128),
    emergency_contact_no character varying(128),
    present_address_json character varying,
    permanent_address_json character varying,
    photo_path character varying(256),
    photo_url character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.guardian OWNER TO dbadmin;

--
-- Name: guardian_student; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.guardian_student (
    oid character varying(128) NOT NULL,
    guardian_id character varying(128),
    student_id character varying(128),
    guardian_oid character varying(128),
    student_oid character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE schoolerp.guardian_student OWNER TO dbadmin;

--
-- Name: institute; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    email character varying(128),
    address character varying(256),
    contact character varying(128),
    type character varying(128),
    code character varying(128),
    status character varying(128),
    district_oid character varying(128),
    education_board_oid character varying(128),
    education_system_oid character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.institute OWNER TO dbadmin;

--
-- Name: institute_admission; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_admission (
    oid character varying(128) NOT NULL,
    admission_id character varying(128) NOT NULL,
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_group_oid character varying(128),
    institute_shift_oid character varying(128),
    institute_version_oid character varying(128),
    education_curriculum_oid character varying(128),
    applicant_name_en character varying(128) NOT NULL,
    applicant_name_bn character varying(256),
    date_of_birth date,
    email character varying(128),
    mobile_no character varying(128),
    gender character varying(128),
    religion character varying(128),
    nationality character varying(128),
    blood_group character varying(128),
    father_name_en character varying(128) NOT NULL,
    father_name_bn character varying(256),
    father_occupation character varying(128),
    father_contact_number character varying(128),
    father_email character varying(128),
    mother_name_en character varying(128) NOT NULL,
    mother_name_bn character varying(256),
    mother_occupation character varying(128),
    mother_contact_number character varying(128),
    mother_email character varying(128),
    emergency_contact_person character varying(128),
    emergency_contact_no character varying(128),
    present_address_json character varying,
    permanent_address_json character varying,
    photo_path character varying(256),
    photo_url character varying(256),
    status character varying(128),
    approved_by character varying(128),
    approved_on timestamp without time zone,
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.institute_admission OWNER TO dbadmin;

--
-- Name: institute_class; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_class (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    institute_oid character varying(128),
    institute_class_level_oid character varying(128),
    education_class_oid character varying(128),
    no_of_section numeric(5,0) DEFAULT 0 NOT NULL,
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.institute_class OWNER TO dbadmin;

--
-- Name: institute_class_group; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_class_group (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    status character varying(128),
    institute_oid character varying(128),
    education_system_oid character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.institute_class_group OWNER TO dbadmin;

--
-- Name: institute_class_level; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_class_level (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    no_of_class numeric(5,0) DEFAULT 0 NOT NULL,
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    institute_oid character varying(128),
    education_class_level_oid character varying(128),
    education_type_oid character varying(128),
    education_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.institute_class_level OWNER TO dbadmin;

--
-- Name: institute_class_section; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_class_section (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_group_oid character varying(128),
    institute_shift_oid character varying(128),
    institute_version_oid character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.institute_class_section OWNER TO dbadmin;

--
-- Name: institute_class_textbook; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_class_textbook (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    subject_code character varying(128),
    e_book_link character varying(256),
    status character varying(128),
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    institute_version_oid character varying(128),
    institute_class_group_oid character varying(128),
    institute_class_oid character varying(128),
    education_textbook_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.institute_class_textbook OWNER TO dbadmin;

--
-- Name: institute_grading_system; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_grading_system (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    grade_point_scale numeric(5,0) DEFAULT 0,
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    institute_oid character varying(128),
    institute_type_oid character varying(128),
    education_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.institute_grading_system OWNER TO dbadmin;

--
-- Name: institute_grading_system_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_grading_system_detail (
    oid character varying(128) NOT NULL,
    start_marks numeric(5,0) DEFAULT 0 NOT NULL,
    end_marks numeric(5,0) DEFAULT 0 NOT NULL,
    letter_grade character varying(128),
    grade_point character varying(128),
    assessment character varying(128),
    remarks character varying(128),
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    institute_grading_system_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.institute_grading_system_detail OWNER TO dbadmin;

--
-- Name: institute_session; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_session (
    oid character varying(128) NOT NULL,
    name_en character varying(256) NOT NULL,
    name_bn character varying(256),
    education_type_json text,
    status character varying(128),
    institute_oid character varying(128),
    education_system_oid character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.institute_session OWNER TO dbadmin;

--
-- Name: institute_shift; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_shift (
    oid character varying(128) NOT NULL,
    name_en character varying(32) NOT NULL,
    name_bn character varying(32),
    institute_oid character varying(128),
    education_shift_oid character varying(128),
    start_time character varying(128),
    end_time character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.institute_shift OWNER TO dbadmin;

--
-- Name: institute_type; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_type (
    oid character varying(128) NOT NULL,
    institute_oid character varying(128),
    status character varying(128),
    education_type_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.institute_type OWNER TO dbadmin;

--
-- Name: institute_version; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.institute_version (
    oid character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(128),
    status character varying(128),
    institute_oid character varying(128),
    education_version_oid character varying(128),
    education_curriculum_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE schoolerp.institute_version OWNER TO dbadmin;

--
-- Name: login; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.login (
    oid character varying(128) NOT NULL,
    login_id character varying(128) NOT NULL,
    password character varying(256),
    user_name character varying(256) NOT NULL,
    name_en character varying(256),
    name_bn character varying(256),
    email character varying(256),
    mobile_no character varying(64),
    menu_json text,
    user_photo_path character varying(512),
    user_photo_url character varying(512),
    status character varying(128),
    reset_required character varying(32),
    role_oid character varying(128),
    institute_oid character varying(128),
    trace_id character varying(128),
    login_period_start_time character varying(32),
    login_period_end_time character varying(32),
    login_disable_start_date timestamp without time zone,
    logindisableenddate timestamp without time zone,
    temp_login_disable_start_date timestamp without time zone,
    temp_login_disable_end_date timestamp without time zone,
    last_login_time timestamp without time zone,
    last_logout_time timestamp without time zone,
    password_expire_time timestamp without time zone,
    current_version character varying(32) DEFAULT '1'::character varying,
    edited_by character varying(128),
    edited_on timestamp without time zone,
    approved_by character varying(128),
    approved_on timestamp without time zone,
    remarked_by character varying(128),
    remarked_on timestamp without time zone,
    is_approver_remarks character varying(32),
    approver_remarks text,
    is_new_record character varying(32),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activated_by character varying(128),
    activated_on timestamp without time zone,
    closed_by character varying(128),
    closed_on timestamp without time zone,
    closing_remark text,
    deleted_by character varying(128),
    deleted_on timestamp without time zone,
    deletion_remark text,
    CONSTRAINT ck_is_approver_remarks_login CHECK ((((is_approver_remarks)::text = 'Yes'::text) OR ((is_approver_remarks)::text = 'No'::text))),
    CONSTRAINT ck_is_new_record_login CHECK ((((is_new_record)::text = 'Yes'::text) OR ((is_new_record)::text = 'No'::text))),
    CONSTRAINT ck_status_login CHECK ((((status)::text = 'Active'::text) OR ((status)::text = 'Inactive'::text)))
);


ALTER TABLE schoolerp.login OWNER TO dbadmin;

--
-- Name: login_history; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.login_history (
    oid character varying(128) NOT NULL,
    login_id character varying(128) NOT NULL,
    password character varying(256) NOT NULL,
    user_name character varying(128) NOT NULL,
    email character varying(256),
    mobile_no character varying(64),
    menu_json text,
    role_oid character varying(128) NOT NULL,
    user_photo_path character varying(512),
    status character varying(128),
    reset_required character varying(32),
    history_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    login_oid character varying(128) NOT NULL,
    trace_id character varying(128),
    login_period_start_time character varying(32),
    login_period_end_time character varying(32),
    login_disable_start_date timestamp without time zone,
    logindisableenddate timestamp without time zone,
    temp_login_disable_start_date timestamp without time zone,
    temp_login_disable_end_date timestamp without time zone,
    last_login_time timestamp without time zone,
    last_logout_time timestamp without time zone,
    password_expire_time timestamp without time zone,
    version character varying(32) NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone,
    approved_by character varying(128),
    approved_on timestamp without time zone,
    remarked_by character varying(128),
    remarked_on timestamp without time zone,
    is_approver_remarks character varying(32),
    approver_remarks text,
    is_new_record character varying(32),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    activated_by character varying(128),
    activated_on timestamp without time zone,
    closed_by character varying(128),
    closed_on timestamp without time zone,
    closing_remark text,
    deleted_by character varying(128),
    deleted_on timestamp without time zone,
    deletion_remark text,
    CONSTRAINT ck_is_approver_remarks_login_history CHECK ((((is_approver_remarks)::text = 'Yes'::text) OR ((is_approver_remarks)::text = 'No'::text))),
    CONSTRAINT ck_is_new_record_login_history CHECK ((((is_new_record)::text = 'Yes'::text) OR ((is_new_record)::text = 'No'::text))),
    CONSTRAINT ck_status_login_history CHECK ((((status)::text = 'Active'::text) OR ((status)::text = 'Inactive'::text)))
);


ALTER TABLE schoolerp.login_history OWNER TO dbadmin;

--
-- Name: login_log; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.login_log (
    oid character varying(128) NOT NULL,
    login_oid character varying(128) NOT NULL,
    login_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    logout_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    log_type character varying(32) DEFAULT 'login'::character varying NOT NULL,
    ip_address character varying(32),
    location text,
    CONSTRAINT ck_log_type_login_log CHECK ((((log_type)::text = 'login'::text) OR ((log_type)::text = 'Logout'::text)))
);


ALTER TABLE schoolerp.login_log OWNER TO dbadmin;

--
-- Name: notice; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.notice (
    oid character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(128) NOT NULL,
    description_en text NOT NULL,
    description_bn text NOT NULL,
    notice_en_path character varying(512),
    notice_en_url character varying(512),
    notice_bn_path character varying(512),
    notice_bn_url character varying(512),
    published_date character varying(128),
    expiry_date character varying(128),
    institute_oid character varying(128) NOT NULL,
    session_oid character varying(128) NOT NULL,
    status character varying(128),
    published_by character varying(128),
    published_on character varying(128),
    approved_by character varying(128),
    approved_on character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.notice OWNER TO dbadmin;

--
-- Name: otp; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.otp (
    oid character varying(128) NOT NULL,
    login_id character varying(128) NOT NULL,
    mobile_no character varying(128) NOT NULL,
    otp character varying(128) NOT NULL,
    otp_status character varying(32) DEFAULT 'Submitted'::character varying,
    otp_verified character varying(32) DEFAULT 'No'::character varying,
    otp_generated_on timestamp without time zone NOT NULL,
    otp_expiration_time timestamp without time zone NOT NULL,
    otp_request_by character varying(128),
    otp_request_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone,
    CONSTRAINT ck_otp_status_otp CHECK ((((otp_status)::text = 'Submitted'::text) OR ((otp_status)::text = 'OtpSent'::text) OR ((otp_status)::text = 'OtpVerified'::text) OR ((otp_status)::text = 'OtpExpired'::text) OR ((otp_status)::text = 'OtpCancelled'::text))),
    CONSTRAINT ck_otp_verified_otp CHECK ((((otp_verified)::text = 'Yes'::text) OR ((otp_verified)::text = 'No'::text)))
);


ALTER TABLE schoolerp.otp OWNER TO dbadmin;

--
-- Name: password_reset_log; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.password_reset_log (
    oid character varying(128) NOT NULL,
    login_id character varying(128) NOT NULL,
    old_password character varying(128) NOT NULL,
    new_password character varying(128) NOT NULL,
    maker_id character varying(128),
    checker_id character varying(128),
    approver_id character varying(128),
    approved_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    resetstatus character varying(32),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE schoolerp.password_reset_log OWNER TO dbadmin;

--
-- Name: payment_mode; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.payment_mode (
    oid character varying(128) NOT NULL,
    payment_code character varying(128),
    name_en character varying(128),
    name_bn character varying(128),
    payment_type character varying(128),
    remarks character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.payment_mode OWNER TO dbadmin;

--
-- Name: request_log; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.request_log (
    oid character varying(128) NOT NULL,
    container_name character varying(256) NOT NULL,
    status character varying(32) NOT NULL,
    request_received_on timestamp without time zone NOT NULL,
    response_sent_on timestamp without time zone,
    response_time_in_ms numeric(10,0) DEFAULT 0 NOT NULL,
    request_source character varying(64) NOT NULL,
    request_source_service character varying(256) NOT NULL,
    request_json text NOT NULL,
    response_json text,
    start_sequence numeric(20,0) DEFAULT 0 NOT NULL,
    end_sequence numeric(20,0) DEFAULT 0 NOT NULL,
    trace_id character varying(32) NOT NULL,
    CONSTRAINT ck_status_request_log CHECK ((((status)::text = 'RequestReceived'::text) OR ((status)::text = 'SentForProcessing'::text) OR ((status)::text = 'ReceivedAfterProcessing'::text) OR ((status)::text = 'ResponseSent'::text)))
);


ALTER TABLE schoolerp.request_log OWNER TO dbadmin;

--
-- Name: role; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.role (
    oid character varying(128) NOT NULL,
    role_id character varying(128) NOT NULL,
    role_description text NOT NULL,
    menu_json text,
    role_type character varying(32),
    status character varying(32) NOT NULL,
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone,
    CONSTRAINT ck_role_type_role CHECK ((((role_type)::text = 'Admin'::text) OR ((role_type)::text = 'Institute'::text) OR ((role_type)::text = 'Student'::text) OR ((role_type)::text = 'Teacher'::text) OR ((role_type)::text = 'Guardian'::text))),
    CONSTRAINT ck_status_role CHECK ((((status)::text = 'Active'::text) OR ((status)::text = 'Inactive'::text)))
);


ALTER TABLE schoolerp.role OWNER TO dbadmin;

--
-- Name: sign_up; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.sign_up (
    oid character varying(128) NOT NULL,
    registration_id character varying(128) NOT NULL,
    login_id character varying(128) NOT NULL,
    name_en character varying(128) NOT NULL,
    name_bn character varying(256),
    email character varying(256) NOT NULL,
    mobile_no character varying(256) NOT NULL,
    nid character varying(64),
    photo_path text,
    photo_url character varying(512),
    is_verified character varying(512) DEFAULT 'no'::character varying,
    status character varying(32),
    CONSTRAINT ck_status_sign_up CHECK ((((status)::text = 'Active'::text) OR ((status)::text = 'Inactive'::text)))
);


ALTER TABLE schoolerp.sign_up OWNER TO dbadmin;

--
-- Name: sms_log; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.sms_log (
    oid character varying(128) NOT NULL,
    request_id character varying(128) NOT NULL,
    application_tracking_id character varying(128),
    policy_no character varying(128),
    reference_no character varying(64),
    trans_type character varying(32),
    mobile_no character varying(32) NOT NULL,
    sms text,
    send_date timestamp without time zone,
    trace_id character varying(128),
    request_receive_time timestamp without time zone,
    provider_request_time timestamp without time zone,
    provider_response_time timestamp without time zone,
    sms_count numeric(20,0),
    remarks text,
    sms_status character varying(32) NOT NULL,
    created_by character varying(128) DEFAULT CURRENT_USER NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_on timestamp without time zone,
    updated_by character varying(128)
);


ALTER TABLE schoolerp.sms_log OWNER TO dbadmin;

--
-- Name: student; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.student (
    oid character varying(128) NOT NULL,
    login_id character varying(128),
    student_id character varying(128) NOT NULL,
    application_tracking_id character varying(128),
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_section_oid character varying(128),
    roll_number character varying(128),
    institute_class_group_oid character varying(128),
    institute_shift_oid character varying(128),
    institute_version_oid character varying(128),
    education_curriculum_oid character varying(128),
    name_en character varying(128) NOT NULL,
    name_bn character varying(256),
    date_of_birth date,
    email character varying(128),
    mobile_no character varying(128),
    gender character varying(128),
    religion character varying(128),
    nationality character varying(128),
    blood_group character varying(128),
    father_name_en character varying(128) NOT NULL,
    father_name_bn character varying(256),
    father_occupation character varying(128),
    father_contact_number character varying(128),
    father_email character varying(128),
    mother_name_en character varying(128) NOT NULL,
    mother_name_bn character varying(256),
    mother_occupation character varying(128),
    mother_contact_number character varying(128),
    mother_email character varying(128),
    emergency_contact_person character varying(128),
    emergency_contact_no character varying(128),
    present_address_json character varying,
    permanent_address_json character varying,
    photo_path character varying(256),
    photo_url character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.student OWNER TO dbadmin;

--
-- Name: student_attendance; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.student_attendance (
    oid character varying(128) NOT NULL,
    attendance_date date,
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_section_oid character varying(128),
    institute_class_group_oid character varying(128),
    institute_shift_oid character varying(128),
    institute_version_oid character varying(128),
    teacher_oid character varying(128),
    class_textbook_oid character varying(128),
    class_period_oid character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.student_attendance OWNER TO dbadmin;

--
-- Name: student_attendance_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.student_attendance_detail (
    oid character varying(128) NOT NULL,
    student_id character varying(128),
    student_oid character varying(128),
    student_attendance_oid character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE schoolerp.student_attendance_detail OWNER TO dbadmin;

--
-- Name: student_class_detail; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.student_class_detail (
    oid character varying(128) NOT NULL,
    student_id character varying(128) NOT NULL,
    institute_oid character varying(128),
    institute_session_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_section_oid character varying(128),
    roll_number character varying(128),
    institute_class_group_oid character varying(128),
    institute_shift_oid character varying(128),
    institute_version_oid character varying(128),
    education_curriculum_oid character varying(128),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.student_class_detail OWNER TO dbadmin;

--
-- Name: student_textbook; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.student_textbook (
    oid character varying(128) NOT NULL,
    student_id character varying(128) NOT NULL,
    institute_oid character varying(128),
    institute_class_oid character varying(128),
    institute_class_textbook_oid character varying(128),
    institute_session_oid character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.student_textbook OWNER TO dbadmin;

--
-- Name: teacher; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.teacher (
    oid character varying(128) NOT NULL,
    login_id character varying(128),
    teacher_id character varying(128) NOT NULL,
    institute_oid character varying(128),
    name_en character varying(128) NOT NULL,
    name_bn character varying(256),
    date_of_birth date,
    email character varying(128),
    mobile_no character varying(128),
    gender character varying(128),
    religion character varying(128),
    nationality character varying(128),
    blood_group character varying(128),
    educational_qualification character varying(128),
    father_name_en character varying(128) NOT NULL,
    father_name_bn character varying(256),
    father_occupation character varying(128),
    father_contact_number character varying(128),
    father_email character varying(128),
    mother_name_en character varying(128) NOT NULL,
    mother_name_bn character varying(256),
    mother_occupation character varying(128),
    mother_contact_number character varying(128),
    mother_email character varying(128),
    emergency_contact_person character varying(128),
    emergency_contact_no character varying(128),
    present_address_json character varying,
    permanent_address_json character varying,
    photo_path character varying(256),
    photo_url character varying(256),
    status character varying(128),
    created_by character varying(128) DEFAULT CURRENT_USER,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.teacher OWNER TO dbadmin;

--
-- Name: week_day; Type: TABLE; Schema: schoolerp; Owner: dbadmin
--

CREATE TABLE schoolerp.week_day (
    oid character varying(128) NOT NULL,
    institute_oid character varying(128),
    name_en character varying(128) NOT NULL,
    name_bn character varying(128),
    sort_order numeric(5,0) DEFAULT 0 NOT NULL,
    status character varying(128),
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by character varying(128),
    updated_on timestamp without time zone
);


ALTER TABLE schoolerp.week_day OWNER TO dbadmin;

--
-- Data for Name: class_period; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.class_period (oid, name_en, name_bn, institute_oid, institute_shift_oid, start_time, end_time, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-shift-morning-class-perion-01	Period 1	পিরিয়ড ১	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	8:30 am	9:15 am	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-morning-class-perion-02	Period 2	পিরিয়ড ২	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	9:15 am	10:00 am	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-morning-class-perion-03	Period 3	পিরিয়ড ৩	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	10:00 am	10:45 am	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-morning-class-perion-04	Period 4	পিরিয়ড ৪	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	10:45 am	11:30 am	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-morning-class-perion-05	Period 5	পিরিয়ড ৫	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	11:30 am	12:15 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-morning-class-perion-06	Period 6	পিরিয়ড ৬	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	12:15 pm	1:00 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-evening-class-perion-01	Period 1	পিরিয়ড ১	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Evening	2:30 pm	3:15 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-evening-class-perion-02	Period 2	পিরিয়ড ২	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Evening	3:15 pm	4:00 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-evening-class-perion-03	Period 3	পিরিয়ড ৩	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Evening	4:00 pm	4:45 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-evening-class-perion-04	Period 4	পিরিয়ড ৪	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Evening	4:45 pm	5:30 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-evening-class-perion-05	Period 5	পিরিয়ড ৫	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Evening	5:30 pm	6:15 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
schoolerp-shift-evening-class-perion-06	Period 6	পিরিয়ড ৬	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Evening	6:15 pm	7:00 pm	Active	System	2022-06-23 13:13:16.462446	\N	\N
\.


--
-- Data for Name: class_routine; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.class_routine (oid, institute_oid, institute_shift_oid, institute_session_oid, institute_class_oid, institute_class_section_oid, institute_class_group_oid, institute_version_oid, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-Bangla-Version	Active	dbadmin	2022-06-23 13:13:17.084762	\N	\N
schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Kamini	\N	SCHOOL-ERP-Institute-Bangla-Version	Active	dbadmin	2022-06-23 13:13:17.084762	\N	\N
schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Shapla	\N	SCHOOL-ERP-Institute-Bangla-Version	Active	dbadmin	2022-06-23 13:13:17.084762	\N	\N
schoolerp-class-6-morning-shift-english-version-Section-Jaba	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-English-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-English-Version	Active	dbadmin	2022-06-23 13:13:17.084762	\N	\N
schoolerp-class-6-morning-shift-english-version-Section-Kamini	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-English-Version-Section-Kamini	\N	SCHOOL-ERP-Institute-English-Version	Active	dbadmin	2022-06-23 13:13:17.084762	\N	\N
schoolerp-class-6-morning-shift-english-version-Section-Shapla	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-English-Version-Section-Shapla	\N	SCHOOL-ERP-Institute-English-Version	Active	dbadmin	2022-06-23 13:13:17.084762	\N	\N
\.


--
-- Data for Name: class_routine_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.class_routine_detail (oid, week_day_oid, class_period_oid, class_textbook_oid, teacher_oid, class_routine_oid, created_by, created_on) FROM stdin;
schoolerp-class-routine-details-oid-0001	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0002	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0003	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0004	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0005	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0006	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0007	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0008	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0009	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0010	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0011	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0012	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0013	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0014	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0015	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0016	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0017	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0018	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0019	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0020	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0021	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0022	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0023	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0024	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0025	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0026	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0027	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0028	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0029	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0030	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0031	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0032	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0033	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0034	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0035	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0036	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0037	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0038	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0039	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0040	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0041	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0042	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0043	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0044	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0045	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0046	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0047	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0048	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0049	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0050	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0051	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0052	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0053	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0054	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0055	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0056	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0057	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0058	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0059	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0060	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0061	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0062	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0063	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0064	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0065	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0066	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0067	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0068	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0069	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0070	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0071	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0072	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0073	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0074	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0075	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0076	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0077	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0078	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0079	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0080	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0081	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0082	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0083	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0084	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0085	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0086	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0087	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0088	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0089	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0090	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0091	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0092	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0093	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0094	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0095	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0096	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0097	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0098	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0099	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0100	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0101	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0102	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0103	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0104	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0105	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0106	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0107	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0108	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-bangla-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0109	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0110	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0111	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0112	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0113	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0114	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0115	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0116	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0117	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0118	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0119	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0120	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0121	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0122	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0123	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0124	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0125	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0126	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0127	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0128	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0129	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0130	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0131	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0132	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0133	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0134	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0135	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0136	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0137	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0138	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0139	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0140	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0141	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0142	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0143	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0144	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Jaba	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0145	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0146	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0147	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0148	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0149	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0150	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0151	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0152	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0153	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0154	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0155	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0156	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0157	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0158	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0159	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0160	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0161	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0162	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0163	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0164	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0165	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0166	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0167	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0168	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0169	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0170	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0171	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0172	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0173	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0174	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0175	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0176	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0177	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0178	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0179	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0180	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Kamini	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0181	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0182	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0183	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0184	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0185	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0186	SCHOOL-ERP--week-day-name-Saturday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0187	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0188	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0189	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0190	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0191	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0192	SCHOOL-ERP--week-day-name-Sunday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0193	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0194	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0195	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0196	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0197	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0198	SCHOOL-ERP--week-day-name-Monday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0199	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0200	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0201	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0202	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0203	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0204	SCHOOL-ERP--week-day-name-Tuesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0205	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0206	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0207	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0208	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0209	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0210	SCHOOL-ERP--week-day-name-Wednesday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0211	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-01	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-teacher-oid-0001	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0212	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-02	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-teacher-oid-0002	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0213	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-03	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-teacher-oid-0003	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0214	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-04	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-teacher-oid-0004	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0215	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-05	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-teacher-oid-0005	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
schoolerp-class-routine-details-oid-0216	SCHOOL-ERP--week-day-name-Thursday	schoolerp-shift-morning-class-perion-06	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-teacher-oid-0006	schoolerp-class-6-morning-shift-english-version-Section-Shapla	dbadmin	2022-06-23 13:13:17.099795
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.country (oid, name_en, name_bn, capital, status, created_by, created_on) FROM stdin;
SCHOOL-ERP-Country-Bangladesh	Bangladesh	বাংলাদেশ	Dhaka	Active	System	2022-06-23 13:13:15.100144
SCHOOL-ERP-Country-United-Kingdom	United Kingdom	যুক্তরাজ্য	London	Active	System	2022-06-23 13:13:15.100144
\.


--
-- Data for Name: district; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.district (oid, name_en, name_bn, establish_year, status, division_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Barguna	Barguna	বরগুনা	1984	Active	SCHOOL-ERP-Barisal-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Barisal	Barisal	বরিশাল	1797	Active	SCHOOL-ERP-Barisal-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Bhola	Bhola	ভোলা	1984	Active	SCHOOL-ERP-Barisal-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Jhalokati	Jhalokati	ঝালকাঠি	1984	Active	SCHOOL-ERP-Barisal-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Patuakhali	Patuakhali	পটুয়াখালী	1969	Active	SCHOOL-ERP-Barisal-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Pirojpur	Pirojpur	পিরোজপুর	1984	Active	SCHOOL-ERP-Barisal-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Bandarban	Bandarban	বান্দরবান	1981	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Brahmanbaria	Brahmanbaria	ব্রাহ্মণবাড়িয়া	1984	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Chandpur	Chandpur	চাঁদপুর	1984	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Chittagong	Chittagong	চট্টগ্রাম	1666	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Comilla	Comilla	কুমিল্লা	1790	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Coxs-Bazar	Cox's Bazar	কক্সবাজার	1984	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Feni	Feni	ফেনী	1984	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Khagrachhari	Khagrachhari	খাগড়াছড়ি	1983	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Lakshmipur	Lakshmipur	লক্ষ্মীপুর	1984	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Noakhali	Noakhali	নোয়াখালী	1821	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Rangamati	Rangamati	রাঙ্গামাটি	1983	Active	SCHOOL-ERP-Chittagong-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Dhaka	Dhaka	ঢাকা	1772	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Faridpur	Faridpur	ফরিদপুর	1815	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Gazipur	Gazipur	গাজীপুর	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Gopalganj	Gopalganj	গোপালগঞ্জ	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Kishoreganj	Kishoreganj	কিশোরগঞ্জ	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Madaripur	Madaripur	মাদারীপুর	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Manikganj	Manikganj	মানিকগঞ্জ	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Munshiganj	Munshiganj	মুন্সীগঞ্জ	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Narayanganj	Narayanganj	নারায়ণগঞ্জ	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Narsingdi	Narsingdi	নরসিংদী	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Rajbari	Rajbari	রাজবাড়ী	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Shariatpur	Shariatpur	শরীয়তপুর	1984	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Tangail	Tangail	টাঙ্গাইল	1969	Active	SCHOOL-ERP-Dhaka-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Bagerhat	Bagerhat	বাগেরহাট	1984	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Chuadanga	Chuadanga	চুয়াডাঙ্গা	1984	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Jessore	Jessore	যশোর	1781	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Jhenaidah	Jhenaidah	ঝিনাইদহ	1984	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Khulna	Khulna	খুলনা	1882	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Kushtia	Kushtia	কুষ্টিয়া	1947	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Magura	Magura	মাগুরা	1984	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Meherpur	Meherpur	মেহেরপুর	1984	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Narail	Narail	নড়াইল	1984	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Satkhira	Satkhira	সাতক্ষীরা	1984	Active	SCHOOL-ERP-Khulna-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Jamalpur	Jamalpur	জামালপুর	1978	Active	SCHOOL-ERP-Mymensingh-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Mymensingh	Mymensingh	ময়মনসিংহ	1787	Active	SCHOOL-ERP-Mymensingh-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Netrokona	Netrokona	নেত্রকোণা	1984	Active	SCHOOL-ERP-Mymensingh-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Sherpur	Sherpur	শেরপুর	1984	Active	SCHOOL-ERP-Mymensingh-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Bogra	Bogra	বগুড়া	1821	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Joypurhat	Joypurhat	জয়পুরহাট	1983	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Naogaon	Naogaon	নওগাঁ	1984	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Natore	Natore	নাটোর	1984	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Chapai-Nawabganj	Chapai Nawabganj	চাঁপাইনবাবগঞ্জ	1984	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Pabna	Pabna	পাবনা	1832	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Rajshahi	Rajshahi	রাজশাহী	1772	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Sirajganj	Sirajganj	সিরাজগঞ্জ	1984	Active	SCHOOL-ERP-Rajshahi-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Dinajpur	Dinajpur	দিনাজপুর	1786	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Gaibandha	Gaibandha	গাইবান্ধা	1984	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Kurigram	Kurigram	কুড়িগ্রাম	1984	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Lalmonirhat	Lalmonirhat	লালমনিরহাট	1984	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Nilphamari	Nilphamari	নীলফামারী	1984	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Panchagarh	Panchagarh	পঞ্চগড়	1984	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Rangpur	Rangpur	রংপুর	1772	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Thakurgaon	Thakurgaon	ঠাকুরগাঁও	1984	Active	SCHOOL-ERP-Rangpur-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Habiganj	Habiganj	হবিগঞ্জ	1984	Active	SCHOOL-ERP-Sylhet-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Moulvibazar	Moulvibazar	মৌলভীবাজার	1984	Active	SCHOOL-ERP-Sylhet-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Sunamganj	Sunamganj	সুনামগঞ্জ	1984	Active	SCHOOL-ERP-Sylhet-Division	System	2022-06-23 13:13:15.121875
SCHOOL-ERP-Sylhet	Sylhet	সিলেট	1782	Active	SCHOOL-ERP-Sylhet-Division	System	2022-06-23 13:13:15.121875
\.


--
-- Data for Name: division; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.division (oid, name_en, name_bn, capital, establish_year, status, created_by, created_on) FROM stdin;
SCHOOL-ERP-Barisal-Division	Barisal Division	বরিশাল বিভাগ	Barisal	1993	Active	System	2022-06-23 13:13:15.107778
SCHOOL-ERP-Chittagong-Division	Chittagong Division	চট্টগ্রাম বিভাগ	Chittagong	1829	Active	System	2022-06-23 13:13:15.107778
SCHOOL-ERP-Dhaka-Division	Dhaka Division	ঢাকা বিভাগ	Dhaka	1829	Active	System	2022-06-23 13:13:15.107778
SCHOOL-ERP-Khulna-Division	Khulna Division	খুলনা বিভাগ	Khulna	1960	Active	System	2022-06-23 13:13:15.107778
SCHOOL-ERP-Mymensingh-Division	Mymensingh Division	ময়মনসিংহ বিভাগ	Mymensingh	2015	Active	System	2022-06-23 13:13:15.107778
SCHOOL-ERP-Rajshahi-Division	Rajshahi Division	রাজশাহী বিভাগ	Rajshahi	1829	Active	System	2022-06-23 13:13:15.107778
SCHOOL-ERP-Rangpur-Division	Rangpur Division	রংপুর বিভাগ	Rangpur	2010	Active	System	2022-06-23 13:13:15.107778
SCHOOL-ERP-Sylhet-Division	Sylhet Division	সিলেট বিভাগ	Sylhet	1995	Active	System	2022-06-23 13:13:15.107778
\.


--
-- Data for Name: due_fees; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.due_fees (oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, application_tracking_id, reference_no, due_amount, paid_amount, remarks, status, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: due_fees_history; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.due_fees_history (oid, due_fees_oid, student_id, student_oid, head_code, fee_head_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: education_board; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_board (oid, name_en, name_bn, short_name, website, status, education_system_oid, created_by, created_on) FROM stdin;
Education-Board-0001	Board of Intermediate and Secondary Education, Dhaka	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, ঢাকা	Dhaka	https://www.dhakaeducationboard.gov.bd/	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0002	Board of Intermediate and Secondary Education, Chittagong	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, চট্টগ্রাম	Chittagong	https://web.bise-ctg.gov.bd/bisectg	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0003	Board of Intermediate and Secondary Education, Comilla	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, কুমিল্লা	Comilla	https://web.comillaboard.gov.bd/bisecb	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0004	Board of Intermediate and Secondary Education, Rajshahi	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, রাজশাহী	Rajshahi	http://www.rajshahieducationboard.gov.bd/	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0005	Board of Intermediate and Secondary Education, Jessore	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, যশোর	Jessore	http://www.rajshahieducationboard.gov.bd/	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0006	Board of Intermediate and Secondary Education, Barisal	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, বরিশাল	Barisal	http://www.barisalboard.gov.bd/	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0007	Board of Intermediate and Secondary Education, Sylhet	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, সিলেট	Sylhet	https://sylhetboard.gov.bd/	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0008	Board of Intermediate and Secondary Education, Dinajpur	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, দিনাজপুর	Dinajpur	https://dinajpurboard.gov.bd/	Active	Education-System-0001	System	2022-06-23 13:13:15.690761
Education-Board-0009	Technical Education Board	কারিগরি শিক্ষা বোর্ড	Technical	http://www.bteb.gov.bd/	Active	Education-System-0002	System	2022-06-23 13:13:15.690761
Education-Board-0010	Madrasha Education Board	মাদ্রাসা শিক্ষা বোর্ড	Madrasha	http://www.bmeb.gov.bd/	Active	Education-System-0003	System	2022-06-23 13:13:15.690761
Education-Board-0011	National Qawmi Madrasah Board, Bangladesh	জাতীয় কওমী মাদরাসা শিক্ষাবোর্ড , বাংলাদেশ	Qawmi Madrasah	http://www.qawmiboard.com	Active	Education-System-0004	System	2022-06-23 13:13:15.690761
\.


--
-- Data for Name: education_class; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_class (oid, name_en, name_bn, admission_age, grade, sort_order, status, education_class_level_oid, education_type_oid, education_system_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Education-Program-Nursery	Nursery	নার্সারি	3	Nursery	1	Active	SCHOOL-ERP-Education-Level-Nursery	Education-Type-0001	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-KG	KG	কেজি	5	KG	2	Active	SCHOOL-ERP-Education-Level-KG	Education-Type-0001	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-1	Class 1	প্রথম শ্রেণি	6	I	3	Active	SCHOOL-ERP-Education-Level-Class-1	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-2	Class 2	দ্বিতীয় শ্রেণি	7	II	4	Active	SCHOOL-ERP-Education-Level-Class-2	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-3	Class 3	তৃতীয় শ্রেণি	8	III	5	Active	SCHOOL-ERP-Education-Level-Class-3	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-4	Class 4	চতুর্থ শ্রেণি	9	IV	6	Active	SCHOOL-ERP-Education-Level-Class-4	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-5	Class 5	পঞ্চম শ্রেণি	10	V	7	Active	SCHOOL-ERP-Education-Level-Class-5	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-6	Class 6	ষষ্ঠ শ্রেণি	11	VI	8	Active	SCHOOL-ERP-Education-Level-Class-6	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-7	Class 7	সপ্তম শ্রেণি	12	VII	9	Active	SCHOOL-ERP-Education-Level-Class-7	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-8	Class 8	অষ্টম শ্রেণি	13	VIII	10	Active	SCHOOL-ERP-Education-Level-Class-8	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-9-10	Class 9-10	নবম-দশম শ্রেণি	13	IX	10	Active	\N	Education-Type-0004	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-9	Class 9	নবম শ্রেণি	14	IX	11	Active	SCHOOL-ERP-Education-Level-Class-9-10	Education-Type-0004	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-10	Class 10	দশম শ্রেণি	15	X	12	Active	SCHOOL-ERP-Education-Level-Class-9-10	Education-Type-0004	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-11	Class 11	একাদশ শ্রেণি	16	XI	13	Active	SCHOOL-ERP-Education-Level-Class-11-12	Education-Type-0005	Education-System-0001	System	2022-06-23 13:13:15.736235
SCHOOL-ERP-Education-Program-Class-12	Class 12	দ্বাদশ শ্রেণি	17	XII	14	Active	SCHOOL-ERP-Education-Level-Class-11-12	Education-Type-0005	Education-System-0001	System	2022-06-23 13:13:15.736235
\.


--
-- Data for Name: education_class_level; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_class_level (oid, name_en, name_bn, no_of_class, sort_order, status, education_type_oid, education_system_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Education-Level-Nursery	Nursery	নার্সারি	1	1	Active	Education-Type-0001	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-KG	KG	কেজি	1	2	Active	Education-Type-0001	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-1	Class 1	প্রথম শ্রেণি	1	3	Active	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-2	Class 2	দ্বিতীয় শ্রেণি	1	4	Active	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-3	Class 3	তৃতীয় শ্রেণি	1	5	Active	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-4	Class 4	চতুর্থ শ্রেণি	1	6	Active	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-5	Class 5	পঞ্চম শ্রেণি	1	7	Active	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-6	Class 6	ষষ্ঠ শ্রেণি	1	8	Active	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-7	Class 7	সপ্তম শ্রেণি	1	9	Active	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-8	Class 8	অষ্টম শ্রেণি	1	10	Active	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-9-10	Class 9-10	নবম-দশম শ্রেণি	2	11	Active	Education-Type-0004	Education-System-0001	System	2022-06-23 13:13:15.72171
SCHOOL-ERP-Education-Level-Class-11-12	Class 11-12	একাদশ- দ্বাদশ শ্রেণি	2	12	Active	Education-Type-0005	Education-System-0001	System	2022-06-23 13:13:15.72171
\.


--
-- Data for Name: education_curriculum; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_curriculum (oid, name_en, name_bn, short_name, website, status, education_medium_oid, country_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Education-Curriculum-0001	National Curriculum and Textbook Board	জাতীয় শিক্ষাক্রম ও পাঠ্যপুস্তক বোর্ড	NCTB	https://nctb.portal.gov.bd	Active	SCHOOL-ERP-Education-Bangla-Medium	SCHOOL-ERP-Country-Bangladesh	System	2022-06-23 13:13:15.68013
SCHOOL-ERP-Education-Curriculum-0002	Cambridge Assessment International Education	কেমব্রিজ অ্যাসেসমেন্ট ইন্টারন্যাশনাল এডুকেশন	CAIE	https://www.cambridgeinternational.org/	Active	SCHOOL-ERP-Education-English-Medium	SCHOOL-ERP-Country-United-Kingdom	System	2022-06-23 13:13:15.68013
\.


--
-- Data for Name: education_grading_system; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_grading_system (oid, name_en, name_bn, grade_point_scale, sort_order, status, education_type_oid, education_system_oid, created_by, created_on) FROM stdin;
Education-Grading-System-0001	Pre-Primary Education Grading System	প্রাক-প্রাথমিক শিক্ষা গ্রেডিং সিস্টেম	5	1	Inactive	Education-Type-0001	Education-System-0001	System	2022-06-23 13:13:15.756763
Education-Grading-System-0002	Primary Education Grading System	প্রাথমিক শিক্ষা গ্রেডিং সিস্টেম	5	2	Inactive	Education-Type-0002	Education-System-0001	System	2022-06-23 13:13:15.756763
Education-Grading-System-0003	Junior Secondary Education Grading System	জুনিয়র মাধ্যমিক শিক্ষা গ্রেডিং সিস্টেম	5	3	Active	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:15.756763
Education-Grading-System-0004	Secondary Education Grading System	মাধ্যমিক শিক্ষা গ্রেডিং সিস্টেম	5	4	Active	Education-Type-0004	Education-System-0001	System	2022-06-23 13:13:15.756763
Education-Grading-System-0005	Higher Secondary Education Grading System	উচ্চ মাধ্যমিক শিক্ষা গ্রেডিং সিস্টেম	5	5	Inactive	Education-Type-0005	Education-System-0001	System	2022-06-23 13:13:15.756763
\.


--
-- Data for Name: education_grading_system_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_grading_system_detail (oid, start_marks, end_marks, letter_grade, grade_point, assessment, remarks, sort_order, status, education_grading_system_oid, created_by, created_on) FROM stdin;
20220301162218193-mRCeTWDSpxyGPcUR	80	100	A+	5	Excellent	First Class	1	Active	Education-Grading-System-0003	System	2022-06-23 13:13:15.763676
20220301162218399-bVCaywkwwAXYqFzB	70	79	A	4	Very Good	First Class	2	Active	Education-Grading-System-0003	System	2022-06-23 13:13:15.763676
20220301162218616-cSErEFWFpzGaxaWR	60	69	A-	3.5	Good	First Class	3	Active	Education-Grading-System-0003	System	2022-06-23 13:13:15.763676
20220301162218823-aLMLfEVRTUPDcdCC	50	59	B	3	Above Average	Second Class	4	Active	Education-Grading-System-0003	System	2022-06-23 13:13:15.763676
20220301162219004-aPBNWVbJrkyXnffs	40	49	C	2	Below Average	Second Class	5	Active	Education-Grading-System-0003	System	2022-06-23 13:13:15.763676
20220301162219191-zGwsxNthDRUQDqaz	33	39	D	1	Poor	Third Class	6	Active	Education-Grading-System-0003	System	2022-06-23 13:13:15.763676
20220301162219373-RzDZwNvdBrnqeAXq	0	32	F	0	Fail	Fail	7	Active	Education-Grading-System-0003	System	2022-06-23 13:13:15.763676
20220301162219606-zWHQsXXfGKcQaCzJ	80	100	A+	5	Excellent	First Class	1	Active	Education-Grading-System-0004	System	2022-06-23 13:13:15.763676
20220301162220147-yBQKWnsXNaHBatXy	70	79	A	4	Very Good	First Class	2	Active	Education-Grading-System-0004	System	2022-06-23 13:13:15.763676
20220301162220329-naCrqrsMwyyEsFCP	60	69	A-	3.5	Good	First Class	3	Active	Education-Grading-System-0004	System	2022-06-23 13:13:15.763676
20220301162220612-NuQwGFNpbvFzpvmG	50	59	B	3	Above Average	Second Class	4	Active	Education-Grading-System-0004	System	2022-06-23 13:13:15.763676
20220301162220822-mVCQqYvYgpJJSKcq	40	49	C	2	Below Average	Second Class	5	Active	Education-Grading-System-0004	System	2022-06-23 13:13:15.763676
20220301162221180-zHQpkwgyTBctwPZw	33	39	D	1	Poor	Third Class	6	Active	Education-Grading-System-0004	System	2022-06-23 13:13:15.763676
20220301162221361-HEmdhqGVVRPaJdnL	0	32	F	0	Fail	Fail	7	Active	Education-Grading-System-0004	System	2022-06-23 13:13:15.763676
\.


--
-- Data for Name: education_group; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_group (oid, name_en, name_bn, status, education_system_oid, education_curriculum_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Education-Group-Science	Science	বিজ্ঞান	Active	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.777703
SCHOOL-ERP-Education-Group-Humanities	Humanities	মানবিক	Active	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.777703
SCHOOL-ERP-Education-Group-Bussiness-Studies	Bussiness Studies	ব্যবসায় শিক্ষা	Active	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.777703
\.


--
-- Data for Name: education_medium; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_medium (oid, name_en, name_bn, short_name, status, created_by, created_on) FROM stdin;
SCHOOL-ERP-Education-Bangla-Medium	Bangla Medium	বাংলা মিডিয়াম	Bangla	Active	System	2022-06-23 13:13:15.667695
SCHOOL-ERP-Education-English-Medium	English Medium	ইংলিশ মিডিয়াম	English	Active	System	2022-06-23 13:13:15.667695
\.


--
-- Data for Name: education_session; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_session (oid, name_en, name_bn, education_type_json, status, education_system_oid, education_curriculum_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Education-Session-2022	2022	২০২২	[{"oid":"Education-Type-0001","name_en":"Pre-Primary Education","name_bn":"প্রাক-প্রাথমিক শিক্ষা","short_name":null,"sort_order":1,"status":"Active","education_system_oid":"Education-System-0001","created_by":"System","created_on":"2022-06-21T10:24:58.156Z"},{"oid":"Education-Type-0002","name_en":"Primary Education","name_bn":"প্রাথমিক শিক্ষা","short_name":"PSC","sort_order":2,"status":"Active","education_system_oid":"Education-System-0001","created_by":"System","created_on":"2022-06-21T10:24:58.156Z"},{"oid":"Education-Type-0003","name_en":"Junior Secondary Education","name_bn":"জুনিয়র মাধ্যমিক শিক্ষা","short_name":"JSC","sort_order":3,"status":"Active","education_system_oid":"Education-System-0001","created_by":"System","created_on":"2022-06-21T10:24:58.156Z"},{"oid":"Education-Type-0004","name_en":"Secondary Education","name_bn":"মাধ্যমিক শিক্ষা","short_name":"SSC","sort_order":4,"status":"Active","education_system_oid":"Education-System-0001","created_by":"System","created_on":"2022-06-21T10:24:58.156Z"}]	Running	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.753801	\N	\N
SCHOOL-ERP-Education-Session-2022-2023	2022-2023	২০২২-২০২৩	[{"oid":"Education-Type-0005","name_en":"Higher Secondary Education","name_bn":"উচ্চ মাধ্যমিক শিক্ষা","short_name":"HSC","sort_order":5,"status":"Active","education_system_oid":"Education-System-0001","created_by":"System","created_on":"2022-06-21T10:24:58.156Z"}]	Running	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.753801	\N	\N
\.


--
-- Data for Name: education_shift; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_shift (oid, name_en, name_bn, status, education_system_oid, education_curriculum_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Education-Shift-Morning	Morning	সকাল	Active	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.02394
SCHOOL-ERP-Education-Shift-Evening	Evening	বৈকালীন	Active	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.02394
\.


--
-- Data for Name: education_system; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_system (oid, name_en, name_bn, short_name, status, education_curriculum_oid, created_by, created_on) FROM stdin;
Education-System-0001	Intermediate and Secondary Education	মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা	General	Active	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.686074
Education-System-0002	Technical and vocational education	কারিগরি ও বৃত্তিমূলক শিক্ষা	Technical	Active	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.686074
Education-System-0003	Madrasha Education	মাদ্রাসা শিক্ষা	Madrasha	Active	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.686074
Education-System-0004	Qawmi Education	কওমি শিক্ষা	Qawmi	Active	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.686074
\.


--
-- Data for Name: education_textbook; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_textbook (oid, name_en, name_bn, subject_code, e_book_link, status, education_session_oid, education_version_oid, education_group_oid, education_class_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Education-Text-Book-0001	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1YAC42sxSW9_29z7EmfvBGQu9RKjA5o6_/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-1	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0002	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/10QoWhNxnKZOQXre4LHQcVs2qWqGNtwZ1/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-1	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0003	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1siUN1QwjG0ShXafp2vc4UD2PTSMk6_KE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-1	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0004	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1DmsuTQ9v5BCmiUoqKnpKL3ou-mp2pl-r/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-1	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0005	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/10QoWhNxnKZOQXre4LHQcVs2qWqGNtwZ1/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-1	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0006	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1XVpkkZmLAq6ea4uK2J0PXWhyPb4VWk48/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-1	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0007	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/100PjG_WbhZx0wB6briUgv09-3Xw34Siw/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-2	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0008	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/10bylQbD1SbcBpPFlMKzNrKD8ye3dTbRG/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-2	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0009	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1p-3JeK9U7oBxG5nSPdPRKhBVpLGkoT18/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-2	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0010	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/100PjG_WbhZx0wB6briUgv09-3Xw34Siw/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-2	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0011	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1iLYADpSJ0SUBHgbEe30Y38uTKgbm3yCv/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-2	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0012	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1p-3JeK9U7oBxG5nSPdPRKhBVpLGkoT18/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-2	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0013	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1fOE7-P9tJQ4bL4JvuiNx0eiCeZQzlpKj/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0014	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1akqoiew6ISxV4aEZgofx_p9UfS5QSWD-/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0015	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1CvhFZqPWpKPQpN0fXMZPmjN-EwoqohCV/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0016	Elementary science	প্রাথমিক বিজ্ঞান	\N	https://drive.google.com/file/d/1idJG8ECciW6olc15dQKS4caXrCOfBUQ7/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0017	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1krByf7tepXgTUpc-p1Z64Ee8_5HhuY6e/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0018	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/19q0QyhYZtZamZ7NZq4g2_KRIdkqfaKjv/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0019	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1GmrpUGlLOB_MkxZlSshPWdXMAOmC6B9p/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0020	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1wtl8jfjf1bcm5BoCe43We_QEX0l_Tka9/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0021	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1mTciqSvjdl7Y_s5riKbex_7HqcgBRue_/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0022	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1fOE7-P9tJQ4bL4JvuiNx0eiCeZQzlpKj/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0023	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1akqoiew6ISxV4aEZgofx_p9UfS5QSWD-/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0024	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1F2GUSJtCxHag8sjYVK6hPMOIvMP8aoqI/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0025	Elementary science	প্রাথমিক বিজ্ঞান	\N	https://drive.google.com/file/d/1bpWyIpQgQP_JsFbwq13Ia1DA1du-5rt_/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0026	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1R_2WQMU6E4pLSD3y81BCtb1Ewdte8yfW/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0027	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1hLifyobJLR2xfyhaC3Z0i11m8BJme_Wq/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0028	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1q_osf9Nl6EOqsYW5pmgdFomN-Pv1qzAM/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0029	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/10t0_pm2xoz98uBQqb_wjmcjTxBGqW18P/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0030	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1nRO6UEO248mMQbrWkUBFhH8tmQvFpdW1/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-3	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0031	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1opTQDbSHrOHVpYYped8E00enc5oIrbmu/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0032	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1fGJsLPeKXPlO3B9RNsW-4CQgg1qI_Gn9/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0033	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1G5gMP02a66gU6tqnkHNfkCsxwA5ACds9/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0034	Elementary science	প্রাথমিক বিজ্ঞান	\N	https://drive.google.com/file/d/1FibtewZSPTQ0At9H-VZy8FyyO7avmt6p/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0035	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1JwOZ-sDjBXYaO1y_AuDfLs2_kH2OqlvE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0036	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1vQVoRZPt2TXEi2n6wm7bVpSdv1c6X7qu/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0037	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1vo5dSUgQxoe9AIrsBUsKwteuY_YcsVpv/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0038	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1OoNzTYKyMRhBRw-RMMYzt-dWPnZBe9aE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0039	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1BQ3ZyDBpZ4Uec7YiFPvQHKmIqj8IVwXm/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0040	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1opTQDbSHrOHVpYYped8E00enc5oIrbmu/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0041	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1qC2vF5ZYTnj-8SSz48ZKnErkmN_QuzDd/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0042	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1G5gMP02a66gU6tqnkHNfkCsxwA5ACds9/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0043	Elementary science	প্রাথমিক বিজ্ঞান	\N	https://drive.google.com/file/d/1wf0KAcfb3ai7AmA0aTmmU3jXi5-0HRhS/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0044	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1tW89irArrvU6Y-EOAjCWs0_NxsEMLSyQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0045	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1yTmrRG3OCddRz6eEBgr0cD7NgSwuArq-/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0046	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1Q1ixjm5M17nLFqL1baurkDayDxD_dljf/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0047	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/11JkgNKP6S9SByLfmZqmrnSxLYWxHddcQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0048	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1x2sboOpnpMyXPzuwg8EmzP65jUb_Pmi5/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-4	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0049	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1ztjvNvIQuFHMkqGFry3HsPGMKarV29iQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0050	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1zFQ5sdrHt3CW2OGoBwVuI582b9DS8RAs/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0051	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1Jh-pn8GmrJGYblmieMwUf9sfKQRUZJ4F/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0052	Elementary science	প্রাথমিক বিজ্ঞান	\N	https://drive.google.com/file/d/1Cdj5eCUdVQkDcroXRTNbISEDZgbm5r-I/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0053	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1hE0R1tqjtKvRsNO-sg0bej3GMFqhBYTW/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0054	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1ALCHF_zNKg-u2Jk219F8J-Mk3hMGCeY0/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0055	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1UxtHsjgmDiCCRJZXJidXqSzwwXlLtlkH/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0056	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1iQ5QPs-_bKvgwlt83dYsAs8qDYLQ_NUt/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0057	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1UQ-3NnitOiDGHyxrgYRFmKuQVoBssSkg/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0058	Amar Bangla Boi	আমার বাংলা বই	\N	https://drive.google.com/file/d/1ztjvNvIQuFHMkqGFry3HsPGMKarV29iQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0059	Elementary Mathmetics	প্রাথমিক গণিত	\N	https://drive.google.com/file/d/1579ERF45_vZC5qG1Q3skJV-XrgXQWHOr/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0060	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1Jh-pn8GmrJGYblmieMwUf9sfKQRUZJ4F/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0061	Elementary science	প্রাথমিক বিজ্ঞান	\N	https://drive.google.com/file/d/1QJ8icgHAogR2pVbyhQG7GReSv8vXoKGM/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0062	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1ybskB3JxMUL1zOogqvruAbqmW5zHTO44/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0063	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1tdDwT9sfU1BhpFytoUcaUX6j7-UyP-UV/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0064	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1uG1KdrzAzNej-flBJAKpY9qqItNyL_6k/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0065	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1ij7LFy3fl7JTo6MFC_Eqxu-4tEKEyjSg/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0066	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/14UeVHbZ2ixVwF24wboMhxgPKwxPYB4EH/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-5	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0067	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lJe77StiP9XU05l5N1TpFHYYZfdrPHYG/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0068	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1Bx1qA7ejBbtqLmn8GNYuamB5kZLikje0/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0069	Mathematics	গণিত	\N	https://drive.google.com/file/d/1opJ_ElO9K6FsbwA4O9lyg41qh0KY2Vj9/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0070	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1MkbHLio_XGDcPek4QTIvARmqG4n1Y33g/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0071	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1QTF5MmGTybEYZC2L2VDEQ0I8pLCe8Im2/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0072	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1kT-pGVUaW31-TwTXIfld7oec1U-YE4Qm/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0073	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1fmjmXwOrJlGRhQfwjLpz4hUlGZz0i-HI/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0074	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1mWebTbdMa0jfRLIWlNfwRIi7_JLlF5kM/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0075	CharuPath	চারুপাঠ	\N	https://drive.google.com/file/d/1qWlasEraPwZkRcYca0uDO6QU9En6s7zQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0076	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1IMqW99KPRx6kYjqnV4o9KmrmeQYNCftA/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0077	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1j8tEFdyV4r0eZA4oo1JU9IjIA_Qbap23/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0078	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1U50oQ6Mzs-Xdp8PFkjExv3UOkk-UfQ47/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0079	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1MZFv8rpvhL1S_lYIDBS9qIU33rv05YiH/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0080	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1PFR-pXSZcSLnTOVgkfE5xQP3T8uais4Q/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0081	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1fU15Yty8LSNkLu5nbL6nQEnzCay4qCPM/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0082	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1XSk-62gL2qy0I6_ZaK4tGxVjLMY9MjRB/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0083	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1sJzvdjZe1YDNaeelLZIlLpSsOzPMjmk6/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0084	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1nboaiH1G3rDj79MM5s74r4-k0VyROPjS/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0085	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/121N58bqtgZd7_yehf3IEo9DYhC1vP2k0/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0086	Arabic	আরবি	\N	https://drive.google.com/file/d/19zxX9QpMofltiKddJnM-rp16YQYyYMRP/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0087	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1zkGFH3MyfNTr0PQbGKX1mczKH2nrA3v-/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0088	Pali	পালি	\N	https://drive.google.com/file/d/1WUlYjlGm7xlAJmNl8h8Y0CbhpzOg_0Ef/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0089	Music	সংগীত	\N	https://drive.google.com/file/d/13VZXJ8BcZaUR8zEVcdROJqQzG0n0DmsB/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0090	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lJe77StiP9XU05l5N1TpFHYYZfdrPHYG/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0091	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1Bx1qA7ejBbtqLmn8GNYuamB5kZLikje0/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0092	Mathematics	গণিত	\N	https://drive.google.com/file/d/10Xd4qgYdDiorcJzGzzzeocTDtlNwP_dC/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0093	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1MkbHLio_XGDcPek4QTIvARmqG4n1Y33g/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0094	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1QTF5MmGTybEYZC2L2VDEQ0I8pLCe8Im2/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0095	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1PQ2c30eaZokDfvtWdwoEbBEms0ElZsyh/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0096	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1q3P1CfxV1k2tpj4f0e2Kyq62Y60um7dO/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0097	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1nTdzh6SEc4uXimXU4OG-kCZElLuem8ET/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0098	CharuPath	চারুপাঠ	\N	https://drive.google.com/file/d/1qWlasEraPwZkRcYca0uDO6QU9En6s7zQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0099	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1MLdE_GBYysaYKCLwRn_TiCIbQDmp7f00/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0100	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/16a1_cZ-w9fseR-CeYqPJrtXwsYZaCPYp/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0101	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1zVUFa4txwZqA22Q09Zw1P3L4pzYADD38/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0102	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1zC8vi_ZjTCPrlRmfo-SW7-IYncaZaFOb/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0103	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1JXA7S77F0JdK1zLvrmnmZ4avLfuhxBN0/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0104	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1rGjQLauawJKTrJqQJZtaSsc_gNnH1SUS/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0105	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1NUhbAekbbdOMTJPKkGn9aEDGOL3QiUbB/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0106	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1O7B3wKP7FQls5UzKGH5Te182cmFAQ2zX/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0107	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1u1CL7DTlDuoqImoAGYjAqRF9mla_BkFb/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0108	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/1YF8yAaBKai3hmG9LKEYQ8ApxFQ5BOme6/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0109	Arabic	আরবি	\N	https://drive.google.com/file/d/19zxX9QpMofltiKddJnM-rp16YQYyYMRP/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0110	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1zkGFH3MyfNTr0PQbGKX1mczKH2nrA3v-/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0111	Pali	পালি	\N	https://drive.google.com/file/d/1WUlYjlGm7xlAJmNl8h8Y0CbhpzOg_0Ef/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0112	Music	সংগীত	\N	https://drive.google.com/file/d/13VZXJ8BcZaUR8zEVcdROJqQzG0n0DmsB/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-6	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0113	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1--_FJruc6h3RP2z4J3D6MEgzkyYFd7rS/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0114	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/18ZmkoiAjM-WDUDHWRYGK9BsDbNt5tNt-/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0115	Soptobarrna	সপ্তবর্ণা	\N	https://drive.google.com/file/d/12xtR4HeQYFObRahh31FLAezKTKoaAu5l/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0116	Mathematics	গণিত	\N	https://drive.google.com/file/d/1ReXrHNs8ZN0sNBCC9jdOIWiSaELxhOWk/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0117	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1XEcPhlUxIqgeuwyDNdRogwEN9eQaA6GU/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0118	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1OgqTsBtE0IPnfUVYFUcu8Bobt_qHDUg6/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0119	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/19GUv5q2wR8UwzDRb89vM5W-oC9hrClUt/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0120	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1djrnwN0jkPGmGDeUdvHIGH0Me3RFgBEr/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0121	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1hZjhIVNcHgmzsxJiE1N0UTlXkl1pPygU/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0122	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1emcopi48FZ9fuYloJ8G-p3plaW1AaZTo/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0123	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1hsAtIoveZWzDEwZppTbxmkDyogrnhyXu/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0124	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1VwNPaIQ2NtzClBE_ca2YQk6W46ae8Vrs/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0125	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/13OIL62GB77oavK0Vlh8iRNFZyjADrl_B/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0126	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1tKRIzRNrypjynhMwU1vkY9s-bEjy3GSW/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0127	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1bsF77_QWPwUcXSDVyTmkxFmGaQXvrbDP/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0128	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1bK85z_g5bZDocrbDjyyX7fgXlhslgAop/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0129	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1GGG1AWYXNUy0yMl-Tx1aqKjr82GXfvPZ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0130	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1G0rtrbXJnk7mbmr-jz4sLBHor81I049v/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0131	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/12vX-Dq3fvlzW4rjU8Za2Q0eL1OoOHKRV/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0132	Arabic	আরবি	\N	https://drive.google.com/file/d/1uLTiHoO9Iy_N8tJWOQXzrTYD9tNoxpUE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0133	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1QOBdjKb9k1y7xeqba1bBg841yq7Czu0d/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0134	Pali	পালি	\N	https://drive.google.com/file/d/1WfFkvwyuJc2u0ckAN4t6m9JyiLwiWarf/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0135	Music	সংগীত	\N	https://drive.google.com/file/d/1TTLTJhIiDFpOJC3rFtjHnoe10emXM8j5/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0136	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1--_FJruc6h3RP2z4J3D6MEgzkyYFd7rS/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0137	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/18ZmkoiAjM-WDUDHWRYGK9BsDbNt5tNt-/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0138	Soptobarrna	সপ্তবর্ণা	\N	https://drive.google.com/file/d/12xtR4HeQYFObRahh31FLAezKTKoaAu5l/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0139	Mathematics	গণিত	\N	https://drive.google.com/file/d/1c9mojRsOKd_0wSLdWaMpH6PIl9oiGMVt/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0140	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1XEcPhlUxIqgeuwyDNdRogwEN9eQaA6GU/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0141	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1OgqTsBtE0IPnfUVYFUcu8Bobt_qHDUg6/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0142	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1iLKXYHIQC6lRByZWnPFlk-DkBbPgD3nN/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0143	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/11v24ZKmhBxCYlOV-3fpg-DCRT-3IK6uU/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0144	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/129KPHSzVjrEKk9y4dnSA1dSNmcyP23Fp/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0145	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/13uyED4ZAS_gjcdqz5alHJIIzfSKiGNqc/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0146	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1PKmxcCMq_cPKBNAjWBnFeWJa79dCdAAY/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0147	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1qRUoTP9sXM-YNOFiE5sgf2tX2Dczm9QZ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0148	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1mmk7p51NDsXYy6D-drvWqpKezuzqOBc3/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0149	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1_cgizUaRApE207n2OKmvExxyfHtRDhZx/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0150	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1_vk00_0ibMNhFrVNyZDakG7ZLTza-9qs/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0151	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1l5yloBb0lQ32VsV51Wul1ksFtjpPA75o/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0152	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1HHThrlHcLtWF-jrgnsAJfTGKgmaIxMZx/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0153	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1SN3UDd74sOn7DPUgcuymJoVeVIuofg59/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0154	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/173ar--gefElH1npeOoOoDO3sBRqT1BeA/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0155	Arabic	আরবি	\N	https://drive.google.com/file/d/1uLTiHoO9Iy_N8tJWOQXzrTYD9tNoxpUE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0156	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1QOBdjKb9k1y7xeqba1bBg841yq7Czu0d/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0157	Pali	পালি	\N	https://drive.google.com/file/d/1WfFkvwyuJc2u0ckAN4t6m9JyiLwiWarf/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0158	Music	সংগীত	\N	https://drive.google.com/file/d/1TTLTJhIiDFpOJC3rFtjHnoe10emXM8j5/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-7	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0159	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lYhBM45Ez3tpTYiRLqspnFaWUgsKatHG/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0160	Bangla Byakaron o Nirmiti 	বাংলা ব্যকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1IDoZoUvO6Fm3TFDJ_6v9cj1eFuvEJ-wc/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0161	Agricultural education	কৃষি শিক্ষা 	\N	https://drive.google.com/file/d/1Nt4fUWIkMfEPYyeXlxHSpCHLj6ELes7F/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0162	Domestic science	গার্হস্থ্য বিজ্ঞান 	\N	https://drive.google.com/file/d/1S9hn8v4tQJewcXm6p6nU227ZzcxpRhSF/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0163	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য 	\N	https://drive.google.com/file/d/1yHUQE_t8iu37d1giLefix_Ns71RaeuHd/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0164	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি 	\N	https://drive.google.com/file/d/1wCBCcXBzcqfMj4jr6eAWcVs7RpeVuwzm/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0165	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা 	\N	https://drive.google.com/file/d/1svslGt9HeVMRyladAaZQwWIUdXFPMrJY/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0166	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1e3dKzRQh_XHlkAWafvBXQepErSE5hoxE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0167	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1z0wqeogZB1oLokdXfwuoPxnnwwOkoIsi/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0168	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1cTrGw-wIz4DEXguic3OqR549TEKG7XvR/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0169	Sahitya Konika	সাহিত্য কনিকা	\N	https://drive.google.com/file/d/1FBZFZObFSu6l6ssBfGLK1baPkqVjAIc1/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0170	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1GXGg4FzXjDpMyJmh7YfVbguBOpRmAJ-k/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0171	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1BTHK9_DX3LLxU2UkrRTShCzr05bSi8vK/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0172	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/19D-ouc0eEKgUo6RFkfonZEfOcnlwyXIh/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0173	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1gjgpXBmGymeqm3rKcHSSGmGOBHXzrm9J/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0174	Christianity and Moral Education	খ্রিষ্টান ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1zjoXducRg9CbOFmvK1Lew7QTg3RrgklQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0175	Buddhism and Moral Education	বৌদ্ধ ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1ZpaaDncPDeXkN0-rR3fixS8zD77SkCI4/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0176	Mathematics	গণিত	\N	https://drive.google.com/file/d/1w9mWTPL8uUGuMdevKCs83G9nBa4NqVAs/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0177	Arabic	আরবি	\N	https://drive.google.com/file/d/1mpZkyrDXCsNIOGbb84pQEpSSuITlVx--/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0178	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1mqeEQ2qtgbkhN62PNwCTRsV4tNK64Iki/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0179	Pali	পালি	\N	https://drive.google.com/file/d/1lNgI9exhbRZyJMCfR1Y5GBs4rhTIqDyP/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0180	Music	সংগীত	\N	https://drive.google.com/file/d/1e1GvvZ9n6XhfBG9pGHN41qusVnEyHo9H/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0181	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lYhBM45Ez3tpTYiRLqspnFaWUgsKatHG/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0182	Bangla Byakaron o Nirmiti 	বাংলা ব্যকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1IDoZoUvO6Fm3TFDJ_6v9cj1eFuvEJ-wc/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0183	Agricultural education	কৃষি শিক্ষা 	\N	https://drive.google.com/file/d/1LOHof04M5I52NXf4L1F1pAwiNKrQVzX8/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0184	Domestic science	গার্হস্থ্য বিজ্ঞান 	\N	https://drive.google.com/file/d/1N-wz2IZtCf9RVV5-YTBjXaqQb8cnPMy4/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0185	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য 	\N	https://drive.google.com/file/d/1HHvZPU98I4J0AOE3N83XLnav5xd3thBv/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0186	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি 	\N	https://drive.google.com/file/d/1y2ZNN9Lauom00L0lttWHHaBEA8GpI_fh/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0187	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা 	\N	https://drive.google.com/file/d/1CX_c9XMHA5J3z5km1s0RNjDnviwainLl/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0188	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1ETV5MJynXKCLeHfctN2ddAeGempV4e0Z/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0189	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1z0wqeogZB1oLokdXfwuoPxnnwwOkoIsi/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0190	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1cTrGw-wIz4DEXguic3OqR549TEKG7XvR/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0191	Sahitya Konika	সাহিত্য কনিকা	\N	https://drive.google.com/file/d/1FBZFZObFSu6l6ssBfGLK1baPkqVjAIc1/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0192	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1J0JIpLmkl6uuWENmRLRkTPc4995gptRn/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0193	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1cKCSROCOnnucSKbq3Ud5NXsi-5CrC8EE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0194	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1wF5X2wytmIAB-lD2vZlJpJj0c9ETEJSp/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0195	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1IdMs2ftD8AedQA_c8j_VgKBIaDHyyV4y/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0196	Christianity and Moral Education	খ্রিষ্টান ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1nTVTiG-GrzO5QOlReMqAUx15bS7Ks50j/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0197	Buddhism and Moral Education	বৌদ্ধ ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1hQmHlqJydt6LU0JNz8kHvr2Ryw7D5rgw/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0198	Mathematics	গণিত	\N	https://drive.google.com/file/d/1rsqIYofr9YJJ9TThj8nFB-9q98ZKVcYq/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0199	Arabic	আরবি	\N	https://drive.google.com/file/d/1mpZkyrDXCsNIOGbb84pQEpSSuITlVx--/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0200	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1mqeEQ2qtgbkhN62PNwCTRsV4tNK64Iki/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0201	Pali	পালি	\N	https://drive.google.com/file/d/1lNgI9exhbRZyJMCfR1Y5GBs4rhTIqDyP/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0202	Music	সংগীত	\N	https://drive.google.com/file/d/1e1GvvZ9n6XhfBG9pGHN41qusVnEyHo9H/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-8	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0203	Bangla Sahitta	 বাংলা সাহিত্য	\N	https://drive.google.com/file/d/1EGkrQmjtjSZY6d7XzqI9d68tBzh-xz2N/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0204	Bangla Sahapath	বাংলা সহপাঠ	\N	https://drive.google.com/file/d/1opKsdJb4CC47li9wZctzhWvV8l_vb7OC/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0205	Bangla Bhashar Byakaran	বাংলা ভাষার ব্যাকরণ	\N	https://drive.google.com/file/d/1r7jl2Kya-HjGhgqe4MdKbHd6r6aFpCl5/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0206	English for Toady	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1tsq23Q7BNljxPMcW9LtZvaaw4rgoMAyA/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0207	Mathematics	গণিত	\N	https://drive.google.com/file/d/1e4F5mXS0csR-SvOkEWPcuJF2CvimRGSh/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0208	Enlish Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1VjWKIcw8UFkJyTzGpwPpEdK1dLvzcDr8/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0256	Finance and banking	ফিন্যান্স ও ব্যাংকিং	\N	https://drive.google.com/file/d/1gS1vo_iXO7raWDjbebQTTc9cVVYjP2sn/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0209	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1Pe9SViRX6eoFRK_D9yoghjkib0aXKqDb/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0210	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1JlmZ6Rgh0kGZhw07nai9GQM7wlXfPEI3/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0211	Rachanasomvar	রচনাসম্ভার	\N	\N	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0212	Physics	পদার্থবিজ্ঞান	\N	https://drive.google.com/file/d/1R9UtZnrU36EwbjEh1ewEstDvTPVCwMUy/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0213	Chemistry	রসায়ন	\N	https://drive.google.com/file/d/1fD4Nh4AQjS7GGGGRHsTmGN8Jfq8tXqPM/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0214	Biology	জীববিজ্ঞান	\N	https://drive.google.com/file/d/10Dpx7644QAL9bEzaK4Vapjvbmr2I7DIx/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0215	Higher Mathematics	উচ্চতর গণিত	\N	https://drive.google.com/file/d/1i2lw0hGAy6Lkh_A6KExJDGOjiG2MsEZE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0216	Geography and environment	ভূগোল ও পরিবেশ	\N	https://drive.google.com/file/d/1ZLGtRHVRFjPzN7FAvmVrSVmJ8kc5_vdq/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0217	Economy	অর্থনীতি	\N	https://drive.google.com/file/d/1cuurvGHxFCmjN6LHTy8kfv6JfpiZhV6P/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0218	Agricultural education	কৃষিশিক্ষা	\N	https://drive.google.com/file/d/1pRMMK9QSVCVznl2zE0g2sL6rp8ijYciD/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0219	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/1uuFBAm8ua5d-sobYgfeZwPNCm_Uqfwpu/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0220	Politics and citizenship	পৌরনীতি ও নাগরিকতা	\N	https://drive.google.com/file/d/1h_rRkIsU8A3WKNSjs201u870QjkgUkFE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0221	Accounting	হিসাববিজ্ঞান	\N	https://drive.google.com/file/d/16dCCr9Bb7h4lhyuuYlmHtcCv9FFob5zU/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0222	Finance and banking	ফিন্যান্স ও ব্যাংকিং	\N	https://drive.google.com/file/d/1Yw6gEH2zMaPLGnK6VbdgPVzqt-p0gvvE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0223	Business ventures	ব্যবসায় উদ্যোগ	\N	https://drive.google.com/file/d/1QxwzRVO5h8FC-BAshw9oFFOmWSj44jHq/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0224	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1rv9S0p_S8JMv4iZkyjEYLpxqzykpYPnN/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0225	Hinduism and Moral Education	হিন্দু ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/14MKK9v3e6Baf0DxuAjY38dToQPiVrMqG/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0226	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1yvASZUQCdkY4l5RvS4LAr7aX1cLD-7O5/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0227	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1ww7aRcOnGDukayednoYCrRrV7glXugzq/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0228	Career education	ক্যারিয়ার এডুকেশন	\N	https://drive.google.com/file/d/1anfFWos1PDAKjkgyBe9XfOaowSP-Xy5N/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0229	Bangladesh and world identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1AIlAdAl7-mwfJXnKO6ZAqzhldclg-kUT/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0230	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1w83kQnLyBTCC8ABYnn376W1nbX2iDvmQ/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0231	History and world civilization of Bangladesh	বাংলাদেশের ইতিহাস ও বিশ্বসভ্যতা	\N	https://drive.google.com/file/d/1qWV0SaMwpZH1xiso04KAPt2v9EDyyiqX/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0232	Physical education, health sciences and sports	শারীরিক শিক্ষা, স্বাস্থ্য বিজ্ঞান ও খেলাধুলা	\N	https://drive.google.com/file/d/18e2JlIXvtosz24FachEtJnYge1XvsF1P/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0233	Illustrated Arabic text	সচিত্র আরবি পাঠ	\N	https://drive.google.com/file/d/1o2s8W6VA_28AW8kM9pQCKJt1K2Wg6hFB/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0234	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/17s6qoXnWfTw5PRDFUN5F9_iepvBA_GD1/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0235	Pali	পালি	\N	https://drive.google.com/file/d/1m8_pf-QcizTTtMBmCIGgoKmLv2jaYunb/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0236	Music	সংগীত	\N	https://drive.google.com/file/d/1K0hBjwVOZwYdcqi7bsNz6xKBZ48_0eqn/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0237	Bangla Sahitta	 বাংলা সাহিত্য	\N	https://drive.google.com/file/d/1EGkrQmjtjSZY6d7XzqI9d68tBzh-xz2N/view	\N	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0238	Bangla Sahapath	বাংলা সহপাঠ	\N	https://drive.google.com/file/d/1opKsdJb4CC47li9wZctzhWvV8l_vb7OC/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0239	Bangla Bhashar Byakaran	বাংলা ভাষার ব্যাকরণ	\N	https://drive.google.com/file/d/1r7jl2Kya-HjGhgqe4MdKbHd6r6aFpCl5/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0240	English for Toady	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1tsq23Q7BNljxPMcW9LtZvaaw4rgoMAyA/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0241	Mathematics	গণিত	\N	https://drive.google.com/file/d/108V-kz2oHnjMviMGanN4OJI0xq9Cjpl_/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0242	Enlish Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1VjWKIcw8UFkJyTzGpwPpEdK1dLvzcDr8/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0243	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1DS5BqwEVIc-CiVMS-304wzmAIF5jHP2H/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0244	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1zr2SmC_ZJepOcg3FqnPnBQosV9XwU352/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0245	Rachanasomvar	রচনাসম্ভার	\N	\N	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0246	Physics	পদার্থবিজ্ঞান	\N	https://drive.google.com/file/d/1kjcETM6dRLZ_2jgB2YcwEr-t4M8lprhC/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0247	Chemistry	রসায়ন	\N	https://drive.google.com/file/d/1hPj-FZxjW6UpBMhJqBxJeptGXY7Bw8os/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0248	Biology	জীববিজ্ঞান	\N	https://drive.google.com/file/d/1X-0_S7cdf-R7nIqssFRq7yCTZuN5ga6b/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0249	Higher Mathematics	উচ্চতর গণিত	\N	https://drive.google.com/file/d/1_MbX32CCdwygW4A-KoLhLI3plGWacaRC/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0250	Geography and environment	ভূগোল ও পরিবেশ	\N	https://drive.google.com/file/d/1QGjFzYordwsiCh6kRBU8g11byoh15Xdt/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0251	Economy	অর্থনীতি	\N	https://drive.google.com/file/d/13y91wGKWYYXdhDvOWiGONqsrcUq55AN3/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0252	Agricultural education	কৃষিশিক্ষা	\N	https://drive.google.com/file/d/1OcXut4lc1axULGRXe0Wqv7QAcR95vhwv/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0253	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	\N	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0254	Politics and citizenship	পৌরনীতি ও নাগরিকতা	\N	https://drive.google.com/file/d/1ZshZG-kzhNa-ZIr0hPtJgtVEwCBFVVOC/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0255	Accounting	হিসাববিজ্ঞান	\N	https://drive.google.com/file/d/1q0px2Q-ngvS_GXhK-cPtpNfjMT-76NgE/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0257	Business ventures	ব্যবসায় উদ্যোগ	\N	https://drive.google.com/file/d/1cx0Ynn0CrCP4okH53RvuEX7xrUTNIjx_/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0258	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1KD8Yc8TcXKZhcexUjiQ7pRxSsQEqpIi6/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0259	Hinduism and Moral Education	হিন্দু ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1roi1h8I-XF-O46r48bcDL8xBFFkJy7UF/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0260	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1LjeuUW2vvw5g0aK7Jwnvsu8VS3IyPBNn/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0261	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/19o5oPGX5_HfFPoOJ3yzoZrrTsFjPwscW/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0262	Career education	ক্যারিয়ার এডুকেশন	\N	https://drive.google.com/file/d/14-HB-dNZjqwESmDxKXNC0k9wBaxpT85C/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0263	Bangladesh and world identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/10_Svz7vbvfL43g4DfTMtH9WKxRwFH40j/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0264	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1vCBBmZq3-qgm1Mcm8tN0T1FwVqnMwjiw/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0265	History and world civilization of Bangladesh	বাংলাদেশের ইতিহাস ও বিশ্বসভ্যতা	\N	https://drive.google.com/file/d/1-xIZIUWtFdCtxJVdjJ9M2nluUZp7o7KY/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0266	Physical education, health sciences and sports	শারীরিক শিক্ষা, স্বাস্থ্য বিজ্ঞান ও খেলাধুলা	\N	https://drive.google.com/file/d/1toz3XIKHxwU3gOkMz-V9knjTH-32D2cD/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0267	Illustrated Arabic text	সচিত্র আরবি পাঠ	\N	https://drive.google.com/file/d/1o2s8W6VA_28AW8kM9pQCKJt1K2Wg6hFB/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0268	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/17s6qoXnWfTw5PRDFUN5F9_iepvBA_GD1/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0269	Pali	পালি	\N	https://drive.google.com/file/d/1m8_pf-QcizTTtMBmCIGgoKmLv2jaYunb/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0270	Music	সংগীত	\N	https://drive.google.com/file/d/1K0hBjwVOZwYdcqi7bsNz6xKBZ48_0eqn/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-English-Version	\N	SCHOOL-ERP-Education-Program-Class-9-10	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0271	Sahittopath	সাহিত্যপাঠ	\N	https://drive.google.com/file/d/1O_qmMAUIlVDIPcz1UPUoPlrg14wDOPik/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-11	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0272	Sahapath	সহপাঠ	\N	https://drive.google.com/file/d/1gK3fLmN2AEoC4TC-FqI9KOXvNXKVm4zR/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-11	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0273	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1iiR_BTEU5MpCUsKmVOpHCRYSAyVl-GT2/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-11	System	2022-06-23 13:13:15.78188	\N	\N
SCHOOL-ERP-Education-Text-Book-0274	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1kZaoZTb5GsR3dO53apyc_8vNo7vACObi/view	Active	SCHOOL-ERP-Education-Session-2022	SCHOOL-ERP-Education-Bangla-Version	\N	SCHOOL-ERP-Education-Program-Class-11	System	2022-06-23 13:13:15.78188	\N	\N
\.


--
-- Data for Name: education_type; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_type (oid, name_en, name_bn, short_name, sort_order, status, education_system_oid, created_by, created_on) FROM stdin;
Education-Type-0001	Pre-Primary Education	প্রাক-প্রাথমিক শিক্ষা	\N	1	Active	Education-System-0001	System	2022-06-23 13:13:15.703893
Education-Type-0002	Primary Education	প্রাথমিক শিক্ষা	PSC	2	Active	Education-System-0001	System	2022-06-23 13:13:15.703893
Education-Type-0003	Junior Secondary Education	জুনিয়র মাধ্যমিক শিক্ষা	JSC	3	Active	Education-System-0001	System	2022-06-23 13:13:15.703893
Education-Type-0004	Secondary Education	মাধ্যমিক শিক্ষা	SSC	4	Active	Education-System-0001	System	2022-06-23 13:13:15.703893
Education-Type-0005	Higher Secondary Education	উচ্চ মাধ্যমিক শিক্ষা	HSC	5	Active	Education-System-0001	System	2022-06-23 13:13:15.703893
Education-Type-0006	Ebtedayee	ইবতেদায়ী	\N	1	Active	Education-System-0003	System	2022-06-23 13:13:15.703893
Education-Type-0007	Dakhil	দাখিল	\N	2	Active	Education-System-0003	System	2022-06-23 13:13:15.703893
Education-Type-0008	Alim	আলিম	\N	3	Active	Education-System-0003	System	2022-06-23 13:13:15.703893
Education-Type-0009	Fazil	ফাজিল	\N	4	Active	Education-System-0003	System	2022-06-23 13:13:15.703893
Education-Type-0010	Kamil	কামিল	\N	5	Active	Education-System-0003	System	2022-06-23 13:13:15.703893
Education-Type-0011	Tahfeez ul Quran	তাহফিজুল কুরআন	\N	1	Active	Education-System-0004	System	2022-06-23 13:13:15.703893
Education-Type-0012	Mutawassitah	মুতাওয়াসিতাহ	\N	2	Active	Education-System-0004	System	2022-06-23 13:13:15.703893
Education-Type-0013	Sanaria ammah	সানারিয়া আম্মা	\N	3	Active	Education-System-0004	System	2022-06-23 13:13:15.703893
Education-Type-0014	Fazilat	ফজিলত	\N	4	Active	Education-System-0004	System	2022-06-23 13:13:15.703893
Education-Type-0015	Takmil	তাকমিল	\N	5	Active	Education-System-0004	System	2022-06-23 13:13:15.703893
\.


--
-- Data for Name: education_version; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.education_version (oid, name_en, name_bn, status, education_curriculum_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Education-Bangla-Version	Bangla Version	বাংলা সংস্করণ	Active	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.683506
SCHOOL-ERP-Education-English-Version	English Version	ইংরেজি সংস্করণ	Active	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:15.683506
\.


--
-- Data for Name: exam; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.exam (oid, name_en, name_bn, start_date, end_date, exam_type, status, institute_oid, institute_session_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
20220623-151835-v2944gh2bH6T0By	Test	Test	2022-10-10	2023-12-10	Term-Exam	Draft	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	school	2022-06-23 15:18:35.477958	\N	\N
doererp-exam-oid-0001	Midterm exam	অর্ধবার্ষিকী পরীক্ষা	2022-05-01	2022-05-18	Term-Exam	Publish	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	dbadmin	2022-06-23 13:13:17.338972	\N	\N
doererp-exam-oid-0002	Test Exam	টেস্ট পরীক্ষা	2022-10-01	2022-10-15	Term-Exam	Approved	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	dbadmin	2022-06-23 13:13:17.338972	\N	\N
doererp-exam-oid-0003	Final Exam	বার্ষিক পরিক্ষা	2022-12-01	2022-12-20	Term-Exam	Draft	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	dbadmin	2022-06-23 13:13:17.338972	\N	\N
\.


--
-- Data for Name: exam_class; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.exam_class (oid, exam_oid, institute_class_oid, grading_system_oid, no_of_student, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-exam-class-oid-0001	doererp-exam-oid-0001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Grading-System-0001	0	Active	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0002	doererp-exam-oid-0001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Grading-System-0001	0	Active	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0003	doererp-exam-oid-0001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Grading-System-0001	0	Active	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0004	doererp-exam-oid-0001	SCHOOL-ERP-Institute-Class-09	SCHOOL-ERP-Institute-Grading-System-0002	0	Active	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0005	doererp-exam-oid-0001	SCHOOL-ERP-Institute-Class-10	SCHOOL-ERP-Institute-Grading-System-0002	0	Active	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0006	doererp-exam-oid-0002	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Grading-System-0001	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0007	doererp-exam-oid-0002	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Grading-System-0001	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0008	doererp-exam-oid-0002	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Grading-System-0001	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0009	doererp-exam-oid-0002	SCHOOL-ERP-Institute-Class-09	SCHOOL-ERP-Institute-Grading-System-0002	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0010	doererp-exam-oid-0002	SCHOOL-ERP-Institute-Class-10	SCHOOL-ERP-Institute-Grading-System-0002	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0011	doererp-exam-oid-0003	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Grading-System-0001	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0012	doererp-exam-oid-0003	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Grading-System-0001	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0013	doererp-exam-oid-0003	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Grading-System-0001	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0014	doererp-exam-oid-0003	SCHOOL-ERP-Institute-Class-09	SCHOOL-ERP-Institute-Grading-System-0002	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
schoolerp-exam-class-oid-0015	doererp-exam-oid-0003	SCHOOL-ERP-Institute-Class-10	SCHOOL-ERP-Institute-Grading-System-0002	0	Inactive	dbadmin	2022-06-23 13:13:17.34977	\N	\N
20220623-151835-Qtvqw8UCtTc61SF	20220623-151835-v2944gh2bH6T0By	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Grading-System-0001	9	\N	dbadmin	2022-06-23 15:18:35.511736	\N	\N
20220623-151835-qdpR9ekstn6WrE9	20220623-151835-v2944gh2bH6T0By	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Grading-System-0001	8	\N	dbadmin	2022-06-23 15:18:35.511736	\N	\N
\.


--
-- Data for Name: exam_result; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.exam_result (oid, exam_oid, institute_session_oid, institute_oid, approved_by, approved_on, published_by, published_on, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-exam-result-oid-0001	doererp-exam-oid-0001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Demo-School-001	System	2022-06-23 13:13:17.413794	System	2022-06-23 13:13:17.413794	Publish	dbadmin	2022-06-23 13:13:17.413794	\N	\N
\.


--
-- Data for Name: exam_result_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.exam_result_detail (oid, exam_oid, exam_result_oid, institute_oid, institute_session_oid, institute_class_oid, institute_class_group_oid, institute_class_section_oid, institute_shift_oid, institute_version_oid, grading_system_oid, approved_by, approved_on, published_by, published_on, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-exam-result-detail-oid-0001	doererp-exam-oid-0001	schoolerp-exam-result-oid-0001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:17.41951	System	2022-06-23 13:13:17.41951	Publish	dbadmin	2022-06-23 13:13:17.41951	\N	\N
schoolerp-exam-result-detail-oid-0002	doererp-exam-oid-0001	schoolerp-exam-result-oid-0001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	Institute-Class-6-Shift-Evening-Bangla-Version-Section-Jaba	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:17.41951	System	2022-06-23 13:13:17.41951	Publish	dbadmin	2022-06-23 13:13:17.41951	\N	\N
schoolerp-exam-result-detail-oid-0003	doererp-exam-oid-0001	schoolerp-exam-result-oid-0001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	Institute-Class-6-Shift-Morning-English-Version-Section-Jaba	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:17.41951	System	2022-06-23 13:13:17.41951	Publish	dbadmin	2022-06-23 13:13:17.41951	\N	\N
schoolerp-exam-result-detail-oid-0004	doererp-exam-oid-0001	schoolerp-exam-result-oid-0001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	Institute-Class-6-Shift-Evening-English-Version-Section-Jaba	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:17.41951	System	2022-06-23 13:13:17.41951	Publish	dbadmin	2022-06-23 13:13:17.41951	\N	\N
\.


--
-- Data for Name: exam_result_marks; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.exam_result_marks (oid, exam_oid, exam_result_detail_oid, institute_oid, institute_class_oid, institute_class_section_oid, student_id, class_textbook_oid, total_marks, obtained_marks, letter_grade, grade_point, assessment, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-exam-result-marks-oid-0001	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0067	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0002	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0068	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0003	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0069	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0004	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0070	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0005	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0072	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0006	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0074	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0007	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0076	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0008	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000000	SCHOOL-ERP-Institute-Text-Book-0077	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0009	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0067	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0010	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0068	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0011	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0069	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0012	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0070	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0013	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0072	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0014	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0074	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0015	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0076	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0016	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000001	SCHOOL-ERP-Institute-Text-Book-0077	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0017	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0067	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0018	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0068	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0019	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0069	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0020	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0070	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0021	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0072	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0022	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0074	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0023	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0076	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0024	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0001	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000013	SCHOOL-ERP-Institute-Text-Book-0077	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0025	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0067	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0026	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0068	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0027	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0069	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0028	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0070	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0029	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0072	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0030	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0074	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0031	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0076	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0032	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000003	SCHOOL-ERP-Institute-Text-Book-0077	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0033	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0067	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0034	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0068	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0035	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0069	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0036	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0070	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0037	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0072	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0038	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0074	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0039	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0076	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0040	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0002	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000015	SCHOOL-ERP-Institute-Text-Book-0077	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0041	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0090	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0042	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0091	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0043	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0092	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0044	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0093	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0045	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0095	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0046	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0097	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0047	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0099	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0048	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000002	SCHOOL-ERP-Institute-Text-Book-0100	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0049	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0090	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0050	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0091	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0051	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0092	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0052	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0093	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0053	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0095	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0054	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0097	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0055	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0099	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0056	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0003	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000014	SCHOOL-ERP-Institute-Text-Book-0100	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0057	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0090	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0058	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0091	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0059	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0092	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0060	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0093	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0061	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0095	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0062	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0097	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0063	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0099	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0064	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000004	SCHOOL-ERP-Institute-Text-Book-0100	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0065	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0090	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0066	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0091	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0067	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0092	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0068	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0093	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0069	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0095	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0070	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0097	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0071	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0099	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
schoolerp-exam-result-marks-oid-0072	doererp-exam-oid-0001	schoolerp-exam-result-detail-oid-0004	SCHOOL-ERP-Demo-School-001	\N	\N	STUDENT-000016	SCHOOL-ERP-Institute-Text-Book-0100	100	85	A+	5	Excellent	Present	dbadmin	2022-06-23 13:13:17.434739	\N	\N
\.


--
-- Data for Name: exam_routine; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.exam_routine (oid, exam_date, exam_oid, exam_class_oid, exam_time_oid, class_textbook_oid, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-exam-routine-oid-0001	2022-01-06	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0077	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0002	2022-01-07	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0095	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0003	2022-01-08	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0091	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0004	2022-01-09	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0076	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0005	2022-01-10	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0074	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0006	2022-01-11	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0069	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0007	2022-01-12	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0093	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0008	2022-01-13	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0099	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0009	2022-01-14	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0072	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0010	2022-01-15	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0097	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0011	2022-01-16	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0092	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0012	2022-01-17	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0100	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0013	2022-01-18	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0068	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0014	2022-01-19	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0090	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0015	2022-01-20	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0070	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0016	2022-01-21	doererp-exam-oid-0001	schoolerp-exam-class-oid-0001	schoolerp-exam-time-oid-0001	SCHOOL-ERP-Institute-Text-Book-0067	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0017	2022-02-10	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0077	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0018	2022-02-11	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0095	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0019	2022-02-12	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0091	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0020	2022-02-13	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0076	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0021	2022-02-14	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0074	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0022	2022-02-15	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0069	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0023	2022-02-16	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0093	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0024	2022-02-17	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0099	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0025	2022-02-18	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0072	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0026	2022-02-19	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0097	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0027	2022-02-20	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0092	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0028	2022-02-21	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0100	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0029	2022-02-22	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0068	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0030	2022-02-23	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0090	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0031	2022-02-24	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0070	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
schoolerp-exam-routine-oid-0032	2022-02-25	doererp-exam-oid-0002	schoolerp-exam-class-oid-0006	schoolerp-exam-time-oid-0002	SCHOOL-ERP-Institute-Text-Book-0067	Active	dbadmin	2022-06-23 13:13:17.367068	\N	\N
\.


--
-- Data for Name: exam_time; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.exam_time (oid, start_time, end_time, exam_duration, exam_oid, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-exam-time-oid-0001	10:00 AM	1:00 PM	3	doererp-exam-oid-0001	Active	dbadmin	2022-06-23 13:13:17.345079	\N	\N
schoolerp-exam-time-oid-0002	10:00 AM	12:00 PM	2	doererp-exam-oid-0002	Inactive	dbadmin	2022-06-23 13:13:17.345079	\N	\N
schoolerp-exam-time-oid-0003	10:00 AM	1:00 PM	3	doererp-exam-oid-0003	Inactive	dbadmin	2022-06-23 13:13:17.345079	\N	\N
20220623-151835-KFsANor9vEtUYT4	11:11	11:11	00:00	20220623-151835-v2944gh2bH6T0By	Active	dbadmin	2022-06-23 15:18:35.505101	\N	\N
\.


--
-- Data for Name: fee_head; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.fee_head (oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-fee-head-oid-admission-fee	SCHOOL-ERP-Demo-School-001	ADMISSION_FEE	Admission Fee	ভর্তি ফী	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-tuition-fee	SCHOOL-ERP-Demo-School-001	TUITION_FEE	Tuition Fee	টিউশন ফী	Monthly	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-exam-fee	SCHOOL-ERP-Demo-School-001	EXAM_FEE	Exam Fee	পরীক্ষার ফী	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-caution-money	SCHOOL-ERP-Demo-School-001	CAUTION_MONEY	Caution money	সতর্কতা টাকা	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-annual-charge	SCHOOL-ERP-Demo-School-001	ANNUAL_CHARGE	Annual Charge	বাৎসরিক চার্জ	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-development-charge	SCHOOL-ERP-Demo-School-001	DEVELOPMENT_CHARGE	Development Charge	উন্নয়ন চার্জ	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-processing-fee	SCHOOL-ERP-Demo-School-001	PROCESSING_FEE	Processing Fee	প্রক্রিয়াকরণ ফি	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-late-fee	SCHOOL-ERP-Demo-School-001	LATE_FEE	Late Fee	লেট ফি	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-electricity-bill	SCHOOL-ERP-Demo-School-001	ELECTRICITY_BILL	Electricity Bill	বিদ্যুৎ বিল	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-utility-charge	SCHOOL-ERP-Demo-School-001	UTILITY_CHARGE	Utility Charge	ইউটিলিটি চার্জ	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
schoolerp-fee-head-oid-other	SCHOOL-ERP-Demo-School-001	OTHERS	Others	অন্যান্য	One-Time	\N	Active	dbadmin	2022-06-23 13:13:17.506163	\N	\N
\.


--
-- Data for Name: fees_collection; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.fees_collection (oid, collection_date, student_id, payment_code, total_waiver_amount, total_discount_amount, due_amount, paid_amount, total_amount, remarks, status, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: fees_collection_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.fees_collection_detail (oid, fees_collection_oid, due_fees_oid, head_code, waiver_percentage, waiver_amount, discount_amount, due_amount, paid_amount, status, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: fees_setting; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.fees_setting (oid, head_code, fee_head_oid, institute_oid, institute_class_oid, session_oid, name_en, name_bn, amount, remarks, payment_last_date, status, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: file_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.file_detail (oid, application_tracking_id, registration_id, offer_id, payment_id, policy_no, insurer_id, file_name, file_type, document_title, file_url, file_path, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
0	\N	<< Flyway Schema Creation >>	SCHEMA	"schoolerp"	\N	dbadmin	2022-06-23 13:13:13.223214	0	t
1	\N	01 00 00  base	SQL	00-schoolerp/R__01_00_00__base.sql	2064923622	dbadmin	2022-06-23 13:13:13.307253	47	t
2	\N	01 00 01  authorization	SQL	00-schoolerp/R__01_00_01__authorization.sql	-1166210459	dbadmin	2022-06-23 13:13:13.396918	29	t
3	\N	01 00 02  authentication	SQL	00-schoolerp/R__01_00_02__authentication.sql	-94170555	dbadmin	2022-06-23 13:13:13.49142	95	t
4	\N	01 00 03  sms	SQL	00-schoolerp/R__01_00_03__sms.sql	-293879965	dbadmin	2022-06-23 13:13:13.621808	27	t
5	\N	01 00 04  document	SQL	00-schoolerp/R__01_00_04__document.sql	-1361148251	dbadmin	2022-06-23 13:13:13.689748	23	t
6	\N	01 00 05  education	SQL	00-schoolerp/R__01_00_05__education.sql	-1096560996	dbadmin	2022-06-23 13:13:13.78086	175	t
7	\N	01 00 06  institute	SQL	00-schoolerp/R__01_00_06__institute.sql	1129440331	dbadmin	2022-06-23 13:13:14.025592	218	t
8	\N	01 00 07  admission	SQL	00-schoolerp/R__01_00_07__admission.sql	-1573378612	dbadmin	2022-06-23 13:13:14.25828	23	t
9	\N	01 00 08  student	SQL	00-schoolerp/R__01_00_08__student.sql	640723972	dbadmin	2022-06-23 13:13:14.307739	55	t
10	\N	01 00 09  teacher	SQL	00-schoolerp/R__01_00_09__teacher.sql	2035444621	dbadmin	2022-06-23 13:13:14.381752	21	t
11	\N	01 00 10  guardian	SQL	00-schoolerp/R__01_00_10__guardian.sql	1791436413	dbadmin	2022-06-23 13:13:14.4184	33	t
12	\N	01 00 11  class routine	SQL	00-schoolerp/R__01_00_11__class_routine.sql	-2142333979	dbadmin	2022-06-23 13:13:14.46577	36	t
13	\N	01 00 12  attendance	SQL	00-schoolerp/R__01_00_12__attendance.sql	685083478	dbadmin	2022-06-23 13:13:14.518029	35	t
14	\N	01 00 13  exam	SQL	00-schoolerp/R__01_00_13__exam.sql	-2040791335	dbadmin	2022-06-23 13:13:14.574448	50	t
15	\N	01 00 14  exam result	SQL	00-schoolerp/R__01_00_14__exam_result.sql	60941122	dbadmin	2022-06-23 13:13:14.640666	60	t
16	\N	01 00 15  fees	SQL	00-schoolerp/R__01_00_15__fees.sql	977056863	dbadmin	2022-06-23 13:13:14.73933	101	t
17	\N	01 00 16  notice	SQL	00-schoolerp/R__01_00_16__notice.sql	1348991325	dbadmin	2022-06-23 13:13:14.862785	18	t
18	\N	04 00 00  base	SQL	R__04_00_00__base.sql	414365795	dbadmin	2022-06-23 13:13:14.892869	12	t
19	\N	04 00 01  education	SQL	R__04_00_01__education.sql	0	dbadmin	2022-06-23 13:13:14.922366	3	t
20	\N	04 00 02  institute	SQL	R__04_00_02__institute.sql	-429379627	dbadmin	2022-06-23 13:13:14.939569	6	t
21	\N	04 00 03  institute class	SQL	R__04_00_03__institute_class.sql	-420441938	dbadmin	2022-06-23 13:13:14.969041	21	t
22	\N	04 00 04  student	SQL	R__04_00_04__student.sql	-1587858820	dbadmin	2022-06-23 13:13:15.012215	5	t
23	\N	04 00 05  exam result	SQL	R__04_00_05__exam_result.sql	1261196766	dbadmin	2022-06-23 13:13:15.037112	4	t
24	\N	04 00 05  fess	SQL	R__04_00_05__fess.sql	-1973273238	dbadmin	2022-06-23 13:13:15.057572	11	t
25	\N	07 00 00  base	SQL	00-schoolerp/R__07_00_00__base.sql	1092339481	dbadmin	2022-06-23 13:13:15.182659	82	t
26	\N	07 00 01  authorization	SQL	00-schoolerp/R__07_00_01__authorization.sql	1898835670	dbadmin	2022-06-23 13:13:15.210981	14	t
27	\N	07 00 02  authentication	SQL	00-schoolerp/R__07_00_02__authentication.sql	263238424	dbadmin	2022-06-23 13:13:15.556579	220	t
28	\N	07 00 05  education	SQL	00-schoolerp/R__07_00_05__education.sql	16768380	dbadmin	2022-06-23 13:13:16.026813	359	t
29	\N	07 00 06  institute	SQL	00-schoolerp/R__07_00_06__institute.sql	-1295564279	dbadmin	2022-06-23 13:13:16.478525	352	t
30	\N	07 00 07  admission	SQL	00-schoolerp/R__07_00_07__admission.sql	1506531962	dbadmin	2022-06-23 13:13:16.561362	45	t
31	\N	07 00 08  student	SQL	00-schoolerp/R__07_00_08__student.sql	-1433891803	dbadmin	2022-06-23 13:13:16.870809	253	t
32	\N	07 00 09  teacher	SQL	00-schoolerp/R__07_00_09__teacher.sql	-654442294	dbadmin	2022-06-23 13:13:16.927976	36	t
33	\N	07 00 10  guardian	SQL	00-schoolerp/R__07_00_10__guardian.sql	1076158582	dbadmin	2022-06-23 13:13:17.046108	81	t
34	\N	07 00 11  class routine	SQL	00-schoolerp/R__07_00_11__class_routine.sql	1283061502	dbadmin	2022-06-23 13:13:17.270364	185	t
35	\N	07 00 12  attendance	SQL	00-schoolerp/R__07_00_12__attendance.sql	691433805	dbadmin	2022-06-23 13:13:17.321922	37	t
36	\N	07 00 13  exam	SQL	00-schoolerp/R__07_00_13__exam.sql	1007818814	dbadmin	2022-06-23 13:13:17.391124	51	t
37	\N	07 00 14  exam result	SQL	00-schoolerp/R__07_00_14__exam_result.sql	1160587810	dbadmin	2022-06-23 13:13:17.492899	79	t
38	\N	07 00 15  fees	SQL	00-schoolerp/R__07_00_15__fees.sql	521924320	dbadmin	2022-06-23 13:13:17.526017	20	t
\.


--
-- Data for Name: guardian; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.guardian (oid, login_id, guardian_id, name_en, name_bn, date_of_birth, email, mobile_no, gender, religion, nationality, blood_group, educational_qualification, father_name_en, father_name_bn, father_occupation, father_contact_number, father_email, mother_name_en, mother_name_bn, mother_occupation, mother_contact_number, mother_email, emergency_contact_person, emergency_contact_no, present_address_json, permanent_address_json, photo_path, photo_url, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-guardian-oid-0000	guardian	G-20220201000	Guardian	অভিভাবক	1980-05-05	sadek_hasan@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Master's	Shourav	সৌরভ	Farmar	1800000001	shourav@gmail.com	Sumi	সুমি	House Wife	1900000001	sumi@gmail.com	01300000001	01400000001	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0001	sadek_hasan	G-20220201001	Sadek Hasan	সাদেক হাসান	1980-05-05	sadek_hasan@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Master's	Shourav	সৌরভ	Farmar	1800000001	shourav@gmail.com	Sumi	সুমি	House Wife	1900000001	sumi@gmail.com	01300000001	01400000001	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0002	nahid_uzz_jaman	G-20220201002	Nahid Uzz Jaman	নাহিদ উজ জামান	1980-05-06	nahid_uzz_jaman@gmail.com	01915111222	Male	Islam	Bangladeshi	A+	Higher Secondary	Faysal	ফায়সাল	Doctor	1800000002	faysal@@gmail.com	Nodi	নদী	Nurse	1900000002	nodi@gmail.com	01300000002	01400000002	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0003	shazzad_hossain	G-20220201003	Shazzad Hossain	শাহজাদ হোসেন	1980-05-07	shazzad_hossain@gmail.com	01915111222	Male	Islam	Bangladeshi	A+	Master's	Taharul	তাহারুল	Daily labor	1800000003	taharul@gmail.com	Meghla	মেঘলা	House Wife	1900000003	meghla@gmail.com	01300000003	01400000003	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0004	abdul_khalek	G-20220201004	Abdul Khalek	আব্দুল খালেক	1980-05-08	abdul_khalek@gmail.com	01915111222	Male	Islam	Bangladeshi	O+	Diploma in Engineering	Nayem	নাঈম	Engineer	1800000004	nayem@gmail.com	Jhorna	ঝর্না	Daily Labor	1900000004	jhorna@gmail.com	01300000004	01400000004	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0005	alam_saddam	G-20220201005	Alam Saddam	আলম সাদ্দাম	1980-05-09	alam_saddam@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Kamil	Nafis	নাফিস	Engineer	1800000005	nafis@gmail.com	Aysha	আয়েশা	House Wife	1900000005	ayesha@gmail.com	01300000005	01400000005	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0006	mizan_riyadh	G-20220201006	Mizan Riyadh	মিজান রিয়াদ	1980-05-10	mizan_riyadh@gmail.com	01915111222	Male	Islam	Bangladeshi	A+	Higher Secondary	Rifat	রিফাত	Daily labor	1800000006	rifat@gmail.com	sadia	সাদিয়া	House Wife	1900000006	sadia@gmail.com	01300000006	01400000006	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0007	haq_mizanur	G-20220201007	Haq Mizanur	হক মিজানুর	1980-05-11	haq_mizanur@gmail.com	01915111222	Male	Islam	Bangladeshi	O+	Master's	Fahim	ফাহিম	Business	1800000007	fahim@gmail.com	Eshita	ঈশিতা	Nurse	1900000007	eshita@gmail.com	01300000007	01400000007	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0008	mizan_tariqul	G-20220201008	Mizan Tariqul	মিজান তারিকুল	1980-05-12	mizan_tariqul@gmail.com	01915111222	Male	Islam	Bangladeshi	O+	Higher Secondary	Rafi	রাফি	Engineer	1800000008	rafi@gmail.com	Surovi	সুরভি	House Wife	1900000008	surovi@gmail.com	01300000008	01400000008	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0009	raihan_parvez	G-20220201009	Raihan Parvez	রায়হান পারভেজ	1980-05-13	raihan_parvez@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Diploma in Engineering	Siam	সিয়াম	Business	1800000009	siam@gmail.com	Barsha	বর্ষা	House Wife	1900000009	barsha@gmail.com	01300000009	01400000009	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0010	abdul_masood	G-20220201010	Abdul Masood	আব্দুল মাসুদ	1980-05-14	abdul_masood@gmail.com	01915111222	Male	Islam	Bangladeshi	B-	Kamil	Anik	অনীক	Farmar	1800000010	anik@gmail.com	Laboni	লাবণী	Daily Labor	1900000010	laboni@gmail.com	01300000010	01400000010	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0011	karim_russell	G-20220201011	Karim Russell	করিম রাসেল	1980-05-15	karim_russell@gmail.com	01915111222	Male	Islam	Bangladeshi	A+	Higher Secondary	Farhan	ফারহান	Doctor	1800000011	farhan@gmail.com	Jemi	জেমি	House Wife	1900000011	jemo@gmail.com	01300000011	01400000011	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0012	sadeq_sirajul	G-20220201012	Sadeq Sirajul	সাদেক সিরাজুল	1980-05-16	sadeq_sirajul@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Diploma in Engineering	Tasfin	তাসফিন	Business	1800000012	tasfin@gmail.com	Jui	জুঁই	Nurse	1900000012	jui@gmail.com	01300000012	01400000012	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0013	kazi_atiqur	G-20220201013	Kazi Atiqur	কাজী আতিকুর	1980-05-17	kazi_atiqur@gmail.com	01915111222	Male	Islam	Bangladeshi	O-	Master's	Sabbir	সাব্বির	Daily labor	1800000013	sabbir@gmail.com	Rasheda	রাশেদা	House Wife	1900000013	rasheda@gmail.com	01300000013	01400000013	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0014	anvir_mostafa	G-20220201014	Anvir Mostafa	আনভীর মোস্তফা	1980-05-18	anvir_mostafa@gmail.com	01915111222	Male	Islam	Bangladeshi	B-	Master's	Abir	আবির	Engineer	1800000014	abir@gmail.com	Farhana	ফারহানা	House Wife	1900000014	farhana@gmail.com	01300000014	01400000014	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0015	rana_rezaul	G-20220201015	Rana Rezaul	রানা রেজাউল	1980-05-19	rana_rezaul@gmail.com	01915111222	Male	Islam	Bangladeshi	AB+	Kamil	Fahim	ফাহিম	Daily labor	1800000015	fahim@gmail.com	Bizly	বিজলী	House Wife	1900000015	bizly@gmail.com	01300000015	01400000015	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0016	hassan_saddam	G-20220201016	Hassan Saddam	হাসান সাদ্দাম	1980-05-20	hassan_saddam@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Diploma in Engineering	Rafi	রাফি	Daily labor	1800000016	rafi@gmail.com	Tithi	তিথি	Nurse	1900000016	tithi@gmail.com	01300000016	01400000016	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0017	musharraf_amin	G-20220201017	Musharraf Amin	মোশাররফ আমিন	1980-05-21	musharraf_amin@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Higher Secondary	Siam	সিয়াম	Daily labor	1800000017	siam@gmail.com	Shakila	শাকিলা	House Wife	1900000017	shakila@gmail.com	01300000017	01400000017	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0018	tahsin_atiqur	G-20220201018	Tahsin Atiqur	তাহসিন আতিকুর	1980-05-22	tahsin_atiqur@gmail.com	01915111222	Male	Islam	Bangladeshi	A+	Master's	Anik	অনীক	Engineer	1800000018	anik@gmail.com	Sompa	সোম্পা	House Wife	1900000018	sompa@gmail.com	01300000018	01400000018	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0019	mizan_malek	G-20220201019	Mizan Malek	মিজান মালেক	1980-05-23	mizan_malek@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Master's	Farhan	ফারহান	Doctor	1800000019	farhan@gmail.com	Moriyom	মরিয়ম	Daily Labor	1900000019	moriyom@gmail.com	01300000019	01400000019	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0020	rabbi_anvir	G-20220201020	Rabbi Anvir	আনভীর রাব্বি	1980-05-24	rabbi_anvir@gmail.com	01915111222	Male	Islam	Bangladeshi	O+	Higher Secondary	Tasfin	তাসফিন	Farmar	1800000020	tasfin@gmail.com	Mousumi	মৌসুমী	House Wife	1900000020	mousumi@gmail.com	01300000020	01400000020	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0021	kamal_tanvir	G-20220201021	Kamal Tanvir	কামাল তানভীর	1980-05-25	kamal_tanvir@gmail.com	01915111222	Male	Islam	Bangladeshi	B+	Master's	Shourav	সৌরভ	Farmar	1800000021	shourav@gmail.com	Sumi	সুমি	House Wife	1900000021	sumi@gmail.com	01300000001	01400000001	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0022	rana_russell	G-20220201022	Rana Russell	রানা রাসেল	1980-05-26	rana_russell@gmail.com	01915111222	Male	Islam	Bangladeshi	A+	Higher Secondary	Faysal	ফায়সাল	Doctor	1800000022	faysal@@gmail.com	Nodi	নদী	Nurse	1900000022	nodi@gmail.com	01300000002	01400000002	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0023	jahangir_alam	G-20220201023	Jahangir Alam	জাহাঙ্গীর আলম 	1980-05-27	jahangir_alam@gmail.com	01915111222	Male	Islam	Bangladeshi	A+	Master's	Taharul	তাহারুল	Daily labor	1800000023	taharul@gmail.com	Meghla	মেঘলা	House Wife	1900000023	meghla@gmail.com	01300000003	01400000003	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0024	babu_tariqul	G-20220201024	Babu Tariqul	বাবু তারিকুল	1980-05-05	babu_tariqul@gmail.com	01915111222	Male	Islam	Bangladeshi	O+	Diploma in Engineering	Nayem	নাঈম	Engineer	1800000024	nayem@gmail.com	Jhorna	ঝর্না	Daily Labor	1900000024	jhorna@gmail.com	01300000004	01400000004	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0025	jasmin_begum	G-20220201025	Jasmin Begum	জেসমিন বেগম	1980-05-06	jasmin_begum@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Kamil	Nafis	নাফিস	Engineer	1800000025	nafis@gmail.com	Aysha	আয়েশা	House Wife	1900000025	ayesha@gmail.com	01300000005	01400000005	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0026	fatema_khatun	G-20220201026	Fatema khatun	ফাতেমা খাতুন	1980-05-07	fatema_khatun@gmail.com	01915222333	Female	Islam	Bangladeshi	A+	Higher Secondary	Rifat	রিফাত	Daily labor	1800000026	rifat@gmail.com	sadia	সাদিয়া	House Wife	1900000026	sadia@gmail.com	01300000006	01400000006	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0027	sahana_hossain	G-20220201027	Sahana Hossain	সাহানা হোসেন	1980-05-08	sahana_hossain@gmail.com	01915222333	Female	Islam	Bangladeshi	O+	Master's	Fahim	ফাহিম	Business	1800000027	fahim@gmail.com	Eshita	ঈশিতা	Nurse	1900000027	eshita@gmail.com	01300000007	01400000007	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0028	khadiza_khanam	G-20220201028	Khadiza Khanam	খাদিজা খানম	1980-05-09	khadiza_khanam@gmail.com	01915222333	Female	Islam	Bangladeshi	O+	Higher Secondary	Rafi	রাফি	Engineer	1800000028	rafi@gmail.com	Surovi	সুরভি	House Wife	1900000028	surovi@gmail.com	01300000008	01400000008	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0029	ishita_marjia	G-20220201029	Ishita Marjia	ঈশিতা মারজিয়া	1980-05-10	ishita_marjia@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Diploma in Engineering	Siam	সিয়াম	Business	1800000029	siam@gmail.com	Barsha	বর্ষা	House Wife	1900000029	barsha@gmail.com	01300000009	01400000009	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0030	afsana_sharmin	G-20220201030	Afsana Sharmin	আফসানা শারমিন	1980-05-11	afsana_sharmin@gmail.com	01915222333	Female	Islam	Bangladeshi	B-	Kamil	Anik	অনীক	Farmar	1800000030	anik@gmail.com	Laboni	লাবণী	Daily Labor	1900000030	laboni@gmail.com	01300000010	01400000010	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0031	sheikh_akhi	G-20220201031	Sheikh Akhi	শেখ আখি	1980-05-12	sheikh_akhi@gmail.com	01915222333	Female	Islam	Bangladeshi	A+	Higher Secondary	Farhan	ফারহান	Doctor	1800000031	farhan@gmail.com	Jemi	জেমি	House Wife	1900000031	jemo@gmail.com	01300000011	01400000011	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0032	basri_farzana	G-20220201032	Basri Farzana	বসরী ফারজানা	1980-05-13	basri_farzana@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Diploma in Engineering	Tasfin	তাসফিন	Business	1800000032	tasfin@gmail.com	Jui	জুঁই	Nurse	1900000032	jui@gmail.com	01300000012	01400000012	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0033	ishita_subarna	G-20220201033	Ishita Subarna	ঈশিতা সূবর্ণা	1980-05-14	ishita_subarna@gmail.com	01915222333	Female	Islam	Bangladeshi	O-	Master's	Sabbir	সাব্বির	Daily labor	1800000033	sabbir@gmail.com	Rasheda	রাশেদা	House Wife	1900000033	rasheda@gmail.com	01300000013	01400000013	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0034	samchun_nahar	G-20220201034	Samchun Nahar	সামছুন নাহার 	1980-05-15	samchun_nahar@gmail.com	01915222333	Female	Islam	Bangladeshi	B-	Master's	Abir	আবির	Engineer	1800000034	abir@gmail.com	Farhana	ফারহানা	House Wife	1900000034	farhana@gmail.com	01300000014	01400000014	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0035	parveen_rumana	G-20220201035	Parveen Rumana	পারভীন রুমানা	1980-05-16	parveen_rumana@gmail.com	01915222333	Female	Islam	Bangladeshi	AB+	Kamil	Fahim	ফাহিম	Daily labor	1800000035	fahim@gmail.com	Bizly	বিজলী	House Wife	1900000035	bizly@gmail.com	01300000015	01400000015	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0036	sultana_tanzina	G-20220201036	Sultana Tanzina	সুলতানা তানজিনা	1980-05-17	sultana_tanzina@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Diploma in Engineering	Rafi	রাফি	Daily labor	1800000036	rafi@gmail.com	Tithi	তিথি	Nurse	1900000036	tithi@gmail.com	01300000016	01400000016	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0037	afsana_rahman	G-20220201037	Afsana Rahman	আফসানা রহমান 	1980-05-18	afsana_rahman@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Higher Secondary	Siam	সিয়াম	Daily labor	1800000037	siam@gmail.com	Shakila	শাকিলা	House Wife	1900000037	shakila@gmail.com	01300000017	01400000017	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0038	rima_happy	G-20220201038	Rima Happy	রিমা হ্যাপি	1980-05-19	rima_happy@gmail.com	01915222333	Female	Islam	Bangladeshi	A+	Master's	Anik	অনীক	Engineer	1800000038	anik@gmail.com	Sompa	সোম্পা	House Wife	1900000038	sompa@gmail.com	01300000018	01400000018	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0039	afri_mahmuda	G-20220201039	Afri Mahmuda	আফ্রি মাহমুদা	1980-05-05	afri_mahmuda@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Master's	Farhan	ফারহান	Doctor	1800000039	farhan@gmail.com	Moriyom	মরিয়ম	Daily Labor	1900000039	moriyom@gmail.com	01300000019	01400000019	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0040	hamid_afroza	G-20220201040	Hamid Afroza	হামিদ আফরোজা	1980-05-06	hamid_afroza@gmail.com	01915222333	Female	Islam	Bangladeshi	B-	Higher Secondary	Tasfin	তাসফিন	Farmar	1800000040	tasfin@gmail.com	Mousumi	মৌসুমী	House Wife	1900000040	mousumi@gmail.com	01300000020	01400000020	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0041	siddika_irene	G-20220201041	Siddika Irene	সিদ্দিকা আইরিন	1980-05-07	siddika_irene@gmail.com	01915222333	Female	Islam	Bangladeshi	AB+	Master's	Shourav	সৌরভ	Farmar	1800000041	shourav@gmail.com	Sumi	সুমি	House Wife	1900000041	sumi@gmail.com	01300000001	01400000001	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0042	begum_monira	G-20220201042	Begum Monira	বেগম মনিরা	1980-05-08	begum_monira@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Higher Secondary	Faysal	ফায়সাল	Doctor	1800000042	faysal@@gmail.com	Nodi	নদী	Nurse	1900000042	nodi@gmail.com	01300000002	01400000002	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0043	maria_sanjida	G-20220201043	Maria Sanjida	মারিয়া সানজিদা	1980-05-09	maria_sanjida@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Master's	Taharul	তাহারুল	Daily labor	1800000043	taharul@gmail.com	Meghla	মেঘলা	House Wife	1900000043	meghla@gmail.com	01300000003	01400000003	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0044	mim_anwara	G-20220201044	Mim Anwara	মিম আনোয়ারা	1980-05-10	mim_anwara@gmail.com	01915222333	Female	Islam	Bangladeshi	A+	Diploma in Engineering	Nayem	নাঈম	Engineer	1800000044	nayem@gmail.com	Jhorna	ঝর্না	Daily Labor	1900000044	jhorna@gmail.com	01300000004	01400000004	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0045	sirajum_marjia	G-20220201045	Sirajum Marjia	সিরাজুম মারজিয়া	1980-05-11	sirajum_marjia@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Kamil	Nafis	নাফিস	Engineer	1800000045	nafis@gmail.com	Aysha	আয়েশা	House Wife	1900000045	ayesha@gmail.com	01300000005	01400000005	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0046	hani_shahnaz	G-20220201046	Hani Shahnaz	হানি শাহানাজ	1980-05-12	hani_shahnaz@gmail.com	01915222333	Female	Islam	Bangladeshi	B-	Higher Secondary	Rifat	রিফাত	Daily labor	1800000046	rifat@gmail.com	sadia	সাদিয়া	House Wife	1900000046	sadia@gmail.com	01300000006	01400000006	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0047	parveen_rumana_01	G-20220201047	Parveen Rumana	পারভীন রুমানা	1980-05-13	parveen_rumana@gmail.com	01915222333	Female	Islam	Bangladeshi	AB+	Master's	Fahim	ফাহিম	Business	1800000047	fahim@gmail.com	Eshita	ঈশিতা	Nurse	1900000047	eshita@gmail.com	01300000007	01400000007	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
schoolerp-guardian-oid-0048	parveen_tanzina	G-20220201048	Parveen Tanzina	পারভীন তানজিনা 	1980-05-14	parveen_tanzina@gmail.com	01915222333	Female	Islam	Bangladeshi	B+	Higher Secondary	Rafi	রাফি	Engineer	1800000048	rafi@gmail.com	Surovi	সুরভি	House Wife	1900000048	surovi@gmail.com	01300000008	01400000008	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.964631	\N	\N
\.


--
-- Data for Name: guardian_student; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.guardian_student (oid, guardian_id, student_id, guardian_oid, student_oid, created_by, created_on) FROM stdin;
doererp-gs-oid-0001	schoolerp-guardian-id-0001	STUDENT-000001	schoolerp-guardian-oid-0001	SCHOOL-ERP-Institute-Student-0001	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0002	schoolerp-guardian-id-0002	STUDENT-000002	schoolerp-guardian-oid-0002	SCHOOL-ERP-Institute-Student-0002	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0003	schoolerp-guardian-id-0003	STUDENT-000003	schoolerp-guardian-oid-0003	SCHOOL-ERP-Institute-Student-0003	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0004	schoolerp-guardian-id-0004	STUDENT-000004	schoolerp-guardian-oid-0004	SCHOOL-ERP-Institute-Student-0004	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0005	schoolerp-guardian-id-0005	STUDENT-000005	schoolerp-guardian-oid-0005	SCHOOL-ERP-Institute-Student-0005	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0006	schoolerp-guardian-id-0006	STUDENT-000006	schoolerp-guardian-oid-0006	SCHOOL-ERP-Institute-Student-0006	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0007	schoolerp-guardian-id-0007	STUDENT-000007	schoolerp-guardian-oid-0007	SCHOOL-ERP-Institute-Student-0007	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0008	schoolerp-guardian-id-0008	STUDENT-000008	schoolerp-guardian-oid-0008	SCHOOL-ERP-Institute-Student-0008	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0009	schoolerp-guardian-id-0009	STUDENT-000009	schoolerp-guardian-oid-0009	SCHOOL-ERP-Institute-Student-0009	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0010	schoolerp-guardian-id-0010	STUDENT-000010	schoolerp-guardian-oid-0010	SCHOOL-ERP-Institute-Student-0010	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0011	schoolerp-guardian-id-0011	STUDENT-000011	schoolerp-guardian-oid-0011	SCHOOL-ERP-Institute-Student-0011	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0012	schoolerp-guardian-id-0012	STUDENT-000012	schoolerp-guardian-oid-0012	SCHOOL-ERP-Institute-Student-0012	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0013	schoolerp-guardian-id-0013	STUDENT-000013	schoolerp-guardian-oid-0013	SCHOOL-ERP-Institute-Student-0013	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0014	schoolerp-guardian-id-0014	STUDENT-000014	schoolerp-guardian-oid-0014	SCHOOL-ERP-Institute-Student-0014	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0015	schoolerp-guardian-id-0015	STUDENT-000015	schoolerp-guardian-oid-0015	SCHOOL-ERP-Institute-Student-0015	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0016	schoolerp-guardian-id-0016	STUDENT-000016	schoolerp-guardian-oid-0016	SCHOOL-ERP-Institute-Student-0016	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0017	schoolerp-guardian-id-0017	STUDENT-000017	schoolerp-guardian-oid-0017	SCHOOL-ERP-Institute-Student-0017	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0018	schoolerp-guardian-id-0018	STUDENT-000018	schoolerp-guardian-oid-0018	SCHOOL-ERP-Institute-Student-0018	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0019	schoolerp-guardian-id-0019	STUDENT-000019	schoolerp-guardian-oid-0019	SCHOOL-ERP-Institute-Student-0019	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0020	schoolerp-guardian-id-0020	STUDENT-000020	schoolerp-guardian-oid-0020	SCHOOL-ERP-Institute-Student-0020	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0021	schoolerp-guardian-id-0021	STUDENT-000021	schoolerp-guardian-oid-0021	SCHOOL-ERP-Institute-Student-0021	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0022	schoolerp-guardian-id-0022	STUDENT-000022	schoolerp-guardian-oid-0022	SCHOOL-ERP-Institute-Student-0022	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0023	schoolerp-guardian-id-0023	STUDENT-000023	schoolerp-guardian-oid-0023	SCHOOL-ERP-Institute-Student-0023	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0024	schoolerp-guardian-id-0024	STUDENT-000024	schoolerp-guardian-oid-0024	SCHOOL-ERP-Institute-Student-0024	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0025	schoolerp-guardian-id-0025	STUDENT-000001	schoolerp-guardian-oid-0025	SCHOOL-ERP-Institute-Student-0001	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0026	schoolerp-guardian-id-0026	STUDENT-000002	schoolerp-guardian-oid-0026	SCHOOL-ERP-Institute-Student-0002	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0027	schoolerp-guardian-id-0027	STUDENT-000003	schoolerp-guardian-oid-0027	SCHOOL-ERP-Institute-Student-0003	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0028	schoolerp-guardian-id-0028	STUDENT-000004	schoolerp-guardian-oid-0028	SCHOOL-ERP-Institute-Student-0004	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0029	schoolerp-guardian-id-0029	STUDENT-000005	schoolerp-guardian-oid-0029	SCHOOL-ERP-Institute-Student-0005	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0030	schoolerp-guardian-id-0030	STUDENT-000006	schoolerp-guardian-oid-0030	SCHOOL-ERP-Institute-Student-0006	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0031	schoolerp-guardian-id-0031	STUDENT-000007	schoolerp-guardian-oid-0031	SCHOOL-ERP-Institute-Student-0007	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0032	schoolerp-guardian-id-0032	STUDENT-000008	schoolerp-guardian-oid-0032	SCHOOL-ERP-Institute-Student-0008	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0033	schoolerp-guardian-id-0033	STUDENT-000009	schoolerp-guardian-oid-0033	SCHOOL-ERP-Institute-Student-0009	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0034	schoolerp-guardian-id-0034	STUDENT-000010	schoolerp-guardian-oid-0034	SCHOOL-ERP-Institute-Student-0010	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0035	schoolerp-guardian-id-0035	STUDENT-000011	schoolerp-guardian-oid-0035	SCHOOL-ERP-Institute-Student-0011	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0036	schoolerp-guardian-id-0036	STUDENT-000012	schoolerp-guardian-oid-0036	SCHOOL-ERP-Institute-Student-0012	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0037	schoolerp-guardian-id-0037	STUDENT-000013	schoolerp-guardian-oid-0037	SCHOOL-ERP-Institute-Student-0013	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0038	schoolerp-guardian-id-0038	STUDENT-000014	schoolerp-guardian-oid-0038	SCHOOL-ERP-Institute-Student-0014	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0039	schoolerp-guardian-id-0039	STUDENT-000015	schoolerp-guardian-oid-0039	SCHOOL-ERP-Institute-Student-0015	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0040	schoolerp-guardian-id-0040	STUDENT-000016	schoolerp-guardian-oid-0040	SCHOOL-ERP-Institute-Student-0016	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0041	schoolerp-guardian-id-0041	STUDENT-000017	schoolerp-guardian-oid-0041	SCHOOL-ERP-Institute-Student-0017	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0042	schoolerp-guardian-id-0042	STUDENT-000018	schoolerp-guardian-oid-0042	SCHOOL-ERP-Institute-Student-0018	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0043	schoolerp-guardian-id-0043	STUDENT-000019	schoolerp-guardian-oid-0043	SCHOOL-ERP-Institute-Student-0019	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0044	schoolerp-guardian-id-0044	STUDENT-000020	schoolerp-guardian-oid-0044	SCHOOL-ERP-Institute-Student-0020	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0045	schoolerp-guardian-id-0045	STUDENT-000021	schoolerp-guardian-oid-0045	SCHOOL-ERP-Institute-Student-0021	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0046	schoolerp-guardian-id-0046	STUDENT-000022	schoolerp-guardian-oid-0046	SCHOOL-ERP-Institute-Student-0022	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0047	schoolerp-guardian-id-0047	STUDENT-000023	schoolerp-guardian-oid-0047	SCHOOL-ERP-Institute-Student-0023	dbadmin	2022-06-23 13:13:17.013568
doererp-gs-oid-0048	schoolerp-guardian-id-0048	STUDENT-000024	schoolerp-guardian-oid-0048	SCHOOL-ERP-Institute-Student-0024	dbadmin	2022-06-23 13:13:17.013568
\.


--
-- Data for Name: institute; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute (oid, name_en, name_bn, email, address, contact, type, code, status, district_oid, education_board_oid, education_system_oid, education_curriculum_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Demo-School-001	Motijheel Model School and College	মতিঝিল মডেল স্কুল অ্যান্ড কলেজ	\N	\N	\N	\N	\N	Active	SCHOOL-ERP-Dhaka	Education-Board-0001	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	dbadmin	2022-06-23 13:13:16.12638	\N	\N
\.


--
-- Data for Name: institute_admission; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_admission (oid, admission_id, institute_oid, institute_session_oid, institute_class_oid, institute_class_group_oid, institute_shift_oid, institute_version_oid, education_curriculum_oid, applicant_name_en, applicant_name_bn, date_of_birth, email, mobile_no, gender, religion, nationality, blood_group, father_name_en, father_name_bn, father_occupation, father_contact_number, father_email, mother_name_en, mother_name_bn, mother_occupation, mother_contact_number, mother_email, emergency_contact_person, emergency_contact_no, present_address_json, permanent_address_json, photo_path, photo_url, status, approved_by, approved_on, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Institute-Admission-0001	ADMISSION-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Kazi Riyad	কাজী রিয়াদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Sadek Hasan	সাদেক হাসান	Service Holder	01915111222	sadek_hasan@gmail.com	Jasmin Begum	জেসমিন বেগম	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0002	ADMISSION-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Ahnaf Ahmed	আহনাফ আহমেদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Nahid Uzz Jaman	নাহিদ উজ জামান	Service Holder	01915111222	sadek_hasan@gmail.com	Fatema khatun	ফাতেমা খাতুন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0003	ADMISSION-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Md. Kamal Parvez	মোঃ কামাল পারভেজ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Shazzad Hossain	শাহজাদ হোসেন	Service Holder	01915111222	sadek_hasan@gmail.com	Sahana Hossain	সাহানা হোসেন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0004	ADMISSION-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Fahadul Islam	ফাহাদুল ইসলাম	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Abdul Khalek	আব্দুল খালেক	Service Holder	01915111222	sadek_hasan@gmail.com	Khadiza Khanam	খাদিজা খানম	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0005	ADMISSION-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Mohaiminul Ahmed	মোহাইমিনুল আহমেদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Alam Saddam	আলম সাদ্দাম	Service Holder	01915111222	sadek_hasan@gmail.com	Ishita Marjia	ঈশিতা মারজিয়া	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0006	ADMISSION-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Md. Shamiul Islam	মোঃ শামিউল ইসলাম	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Mizan Riyadh	মিজান রিয়াদ	Service Holder	01915111222	sadek_hasan@gmail.com	Afsana Sharmin	আফসানা শারমিন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0007	ADMISSION-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Mohammad Fardin	মোহাম্মদ ফারদিন	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Haq Mizanur	হক মিজানুর	Service Holder	01915111222	sadek_hasan@gmail.com	Sheikh Akhi	শেখ আখি	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0008	ADMISSION-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Imtiaz Riyadh	ইমতিয়াজ রিয়াদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Mizan Tariqul	মিজান তারিকুল	Service Holder	01915111222	sadek_hasan@gmail.com	Basri Farzana	বসরী ফারজানা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0009	ADMISSION-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Sahidur Rahman	সহিদুর রহমান	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Raihan Parvez	রায়হান পারভেজ	Service Holder	01915111222	sadek_hasan@gmail.com	Ishita Subarna	ঈশিতা সূবর্ণা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0010	ADMISSION-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Shahnawaz Karim	শাহনেওয়াজ করিম	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Abdul Masood	আব্দুল মাসুদ	Service Holder	01915111222	sadek_hasan@gmail.com	Samchun Nahar	সামছুন নাহার 	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0011	ADMISSION-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Kobir khan	কবির খান	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Karim Russell	করিম রাসেল	Service Holder	01915111222	sadek_hasan@gmail.com	Parveen Rumana	পারভীন রুমানা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0012	ADMISSION-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Sayed Akash	সাইদ আকাশ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Sadeq Sirajul	সাদেক সিরাজুল	Service Holder	01915111222	sadek_hasan@gmail.com	Sultana Tanzina	সুলতানা তানজিনা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0013	ADMISSION-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Tisha Mim	তিশা মিমি	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Kazi Atiqur	কাজী আতিকুর	Service Holder	01915111222	sadek_hasan@gmail.com	Afsana Rahman	আফসানা রহমান 	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0014	ADMISSION-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Siddika Jannatul	সিদ্দিকা জান্নাতুল	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Anvir Mostafa	আনভীর মোস্তফা	Service Holder	01915111222	sadek_hasan@gmail.com	Rima Happy	রিমা হ্যাপি	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0015	ADMISSION-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Maryam	হামিদ মরিয়ম	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Rana Rezaul	রানা রেজাউল	Service Holder	01915111222	sadek_hasan@gmail.com	Afri Mahmuda	আফ্রি মাহমুদা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0016	ADMISSION-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Anika Tanzina	আনিকা তানজিনা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Hassan Saddam	হাসান সাদ্দাম	Service Holder	01915111222	sadek_hasan@gmail.com	Hamid Afroza	হামিদ আফরোজা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0017	ADMISSION-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Islam is happy	ইসলাম হ্যাপি	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Musharraf Amin	মোশাররফ আমিন	Service Holder	01915111222	sadek_hasan@gmail.com	Siddika Irene	সিদ্দিকা আইরিন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0018	ADMISSION-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Afsana Subarna	আফসানা সূবর্ণা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Tahsin Atiqur	তাহসিন আতিকুর	Service Holder	01915111222	sadek_hasan@gmail.com	Begum Monira	বেগম মনিরা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0019	ADMISSION-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Rabia	হামিদ রাবেয়া	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Mizan Malek	মিজান মালেক	Service Holder	01915111222	sadek_hasan@gmail.com	Maria Sanjida	মারিয়া সানজিদা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0020	ADMISSION-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Bristy	হামিদ বৃষ্টি	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Rabbi Anvir	আনভীর রাব্বি	Service Holder	01915111222	sadek_hasan@gmail.com	Mim Anwara	মিম আনোয়ারা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0021	ADMISSION-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Mukta Sanjida	মুক্তা সানজিদা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Kamal Tanvir	কামাল তানভীর	Service Holder	01915111222	sadek_hasan@gmail.com	Sirajum Marjia	সিরাজুম মারজিয়া	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0022	ADMISSION-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Ishita Shiuli	ঈশিতা শিউলী	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Rana Russell	রানা রাসেল	Service Holder	01915111222	sadek_hasan@gmail.com	Hani Shahnaz	হানি শাহানাজ	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0023	ADMISSION-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Ferdous Taslima	ফেরদৌস তাসলিমা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Jahangir Alam	জাহাঙ্গীর আলম 	Service Holder	01915111222	sadek_hasan@gmail.com	Parveen Rumana	পারভীন রুমানা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
SCHOOL-ERP-Institute-Admission-0024	ADMISSION-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Kulchum	হামিদ কুলছুম	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Babu Tariqul	বাবু তারিকুল	Service Holder	01915111222	sadek_hasan@gmail.com	Parveen Tanzina	পারভীন তানজিনা 	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Submitted	\N	\N	dbadmin	2022-06-23 13:13:16.516063	\N	\N
\.


--
-- Data for Name: institute_class; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_class (oid, name_en, name_bn, institute_oid, institute_class_level_oid, education_class_oid, no_of_section, sort_order, status, created_by, created_on) FROM stdin;
SCHOOL-ERP-Institute-Class-6	Class 6	ষষ্ঠ শ্রেণি	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Level-Class-6	SCHOOL-ERP-Education-Program-Class-6	0	1	Active	System	2022-06-23 13:13:16.159274
SCHOOL-ERP-Institute-Class-7	Class 7	সপ্তম শ্রেণি	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Level-Class-7	SCHOOL-ERP-Education-Program-Class-7	0	2	Active	System	2022-06-23 13:13:16.159274
SCHOOL-ERP-Institute-Class-8	Class 8	অষ্টম শ্রেণি	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Level-Class-8	SCHOOL-ERP-Education-Program-Class-8	0	3	Active	System	2022-06-23 13:13:16.159274
SCHOOL-ERP-Institute-Class-9-10	Class 9-10	নবম-দশম শ্রেণি	SCHOOL-ERP-Demo-School-001	\N	SCHOOL-ERP-Education-Program-Class-9-10	0	4	Inactive	System	2022-06-23 13:13:16.159274
SCHOOL-ERP-Institute-Class-09	Class 9	নবম শ্রেণি	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Level-Class-9-10	SCHOOL-ERP-Education-Program-Class-9	0	5	Active	System	2022-06-23 13:13:16.159274
SCHOOL-ERP-Institute-Class-10	Class 10	দশম শ্রেণি	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Level-Class-9-10	SCHOOL-ERP-Education-Program-Class-10	0	6	Active	System	2022-06-23 13:13:16.159274
SCHOOL-ERP-Institute-Class-11	Class 11	একাদশ শ্রেণি	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Level-Class-11-12	SCHOOL-ERP-Education-Program-Class-11	0	7	Active	System	2022-06-23 13:13:16.159274
SCHOOL-ERP-Institute-Class-12	Class 12	দ্বাদশ শ্রেণি	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Level-Class-11-12	SCHOOL-ERP-Education-Program-Class-12	0	8	Active	System	2022-06-23 13:13:16.159274
\.


--
-- Data for Name: institute_class_group; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_class_group (oid, name_en, name_bn, status, institute_oid, education_system_oid, education_curriculum_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Institute-Group-Science	Science	বিজ্ঞান	Active	SCHOOL-ERP-Demo-School-001	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.188338	\N	\N
SCHOOL-ERP-Institute-Group-Humanities	Humanities	মানবিক	Active	SCHOOL-ERP-Demo-School-001	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.188338	\N	\N
SCHOOL-ERP-Institute-Group-Bussiness-Studies	Bussiness Studies	ব্যবসায় শিক্ষা	Active	SCHOOL-ERP-Demo-School-001	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.188338	\N	\N
\.


--
-- Data for Name: institute_class_level; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_class_level (oid, name_en, name_bn, no_of_class, sort_order, status, institute_oid, education_class_level_oid, education_type_oid, education_system_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Institute-Level-Class-6	Class 6	ষষ্ঠ শ্রেণি	1	8	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Level-Class-6	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:16.151533
SCHOOL-ERP-Institute-Level-Class-7	Class 7	সপ্তম শ্রেণি	1	9	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Level-Class-7	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:16.151533
SCHOOL-ERP-Institute-Level-Class-8	Class 8	অষ্টম শ্রেণি	1	10	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Level-Class-8	Education-Type-0003	Education-System-0001	System	2022-06-23 13:13:16.151533
SCHOOL-ERP-Institute-Level-Class-9-10	Class 9-10	নবম-দশম শ্রেণি	2	11	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Level-Class-9-10	Education-Type-0004	Education-System-0001	System	2022-06-23 13:13:16.151533
SCHOOL-ERP-Institute-Level-Class-11-12	Class 11-12	একাদশ- দ্বাদশ শ্রেণি	2	12	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Level-Class-11-12	Education-Type-0005	Education-System-0001	System	2022-06-23 13:13:16.151533
\.


--
-- Data for Name: institute_class_section; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_class_section (oid, name_en, name_bn, institute_oid, institute_session_oid, institute_class_oid, institute_class_group_oid, institute_shift_oid, institute_version_oid, status, created_by, created_on, updated_by, updated_on) FROM stdin;
Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Morning-Bangla-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Morning-Bangla-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Morning-English-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Morning-English-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Morning-English-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Evening-Bangla-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Evening-Bangla-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Evening-Bangla-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Evening-English-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Evening-English-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-6-Shift-Evening-English-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Morning-Bangla-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Morning-Bangla-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Morning-Bangla-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Morning-English-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Morning-English-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Morning-English-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Evening-Bangla-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Evening-Bangla-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Evening-Bangla-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Evening-English-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Evening-English-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-7-Shift-Evening-English-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Morning-Bangla-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Morning-Bangla-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Morning-Bangla-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Morning-English-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Morning-English-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Morning-English-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Evening-Bangla-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Evening-Bangla-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Evening-Bangla-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Evening-English-Version-Section-Jaba	Jaba	জবা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Evening-English-Version-Section-Kamini	Kamini	কামিনী	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
Institute-Class-8-Shift-Evening-English-Version-Section-Shapla	Shapla	শাপলা	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	Active	System	2022-06-23 13:13:16.197061	\N	\N
\.


--
-- Data for Name: institute_class_textbook; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_class_textbook (oid, name_en, name_bn, subject_code, e_book_link, status, institute_oid, institute_session_oid, institute_version_oid, institute_class_group_oid, institute_class_oid, education_textbook_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Institute-Text-Book-0067	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lJe77StiP9XU05l5N1TpFHYYZfdrPHYG/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0067	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0068	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1Bx1qA7ejBbtqLmn8GNYuamB5kZLikje0/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0068	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0069	Mathematics	গণিত	\N	https://drive.google.com/file/d/1opJ_ElO9K6FsbwA4O9lyg41qh0KY2Vj9/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0069	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0070	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1MkbHLio_XGDcPek4QTIvARmqG4n1Y33g/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0070	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0071	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1QTF5MmGTybEYZC2L2VDEQ0I8pLCe8Im2/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0071	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0072	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1kT-pGVUaW31-TwTXIfld7oec1U-YE4Qm/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0072	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0073	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1fmjmXwOrJlGRhQfwjLpz4hUlGZz0i-HI/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0073	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0074	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1mWebTbdMa0jfRLIWlNfwRIi7_JLlF5kM/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0074	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0075	CharuPath	চারুপাঠ	\N	https://drive.google.com/file/d/1qWlasEraPwZkRcYca0uDO6QU9En6s7zQ/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0075	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0076	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1IMqW99KPRx6kYjqnV4o9KmrmeQYNCftA/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0076	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0077	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1j8tEFdyV4r0eZA4oo1JU9IjIA_Qbap23/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0077	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0078	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1U50oQ6Mzs-Xdp8PFkjExv3UOkk-UfQ47/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0078	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0079	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1MZFv8rpvhL1S_lYIDBS9qIU33rv05YiH/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0079	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0080	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1PFR-pXSZcSLnTOVgkfE5xQP3T8uais4Q/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0080	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0081	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1fU15Yty8LSNkLu5nbL6nQEnzCay4qCPM/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0081	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0082	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1XSk-62gL2qy0I6_ZaK4tGxVjLMY9MjRB/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0082	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0083	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1sJzvdjZe1YDNaeelLZIlLpSsOzPMjmk6/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0083	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0084	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1nboaiH1G3rDj79MM5s74r4-k0VyROPjS/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0084	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0085	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/121N58bqtgZd7_yehf3IEo9DYhC1vP2k0/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0085	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0245	Rachanasomvar	রচনাসম্ভার	\N	\N	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0245	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0086	Arabic	আরবি	\N	https://drive.google.com/file/d/19zxX9QpMofltiKddJnM-rp16YQYyYMRP/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0086	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0087	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1zkGFH3MyfNTr0PQbGKX1mczKH2nrA3v-/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0087	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0088	Pali	পালি	\N	https://drive.google.com/file/d/1WUlYjlGm7xlAJmNl8h8Y0CbhpzOg_0Ef/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0088	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0089	Music	সংগীত	\N	https://drive.google.com/file/d/13VZXJ8BcZaUR8zEVcdROJqQzG0n0DmsB/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0089	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0090	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lJe77StiP9XU05l5N1TpFHYYZfdrPHYG/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0090	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0091	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1Bx1qA7ejBbtqLmn8GNYuamB5kZLikje0/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0091	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0092	Mathematics	গণিত	\N	https://drive.google.com/file/d/10Xd4qgYdDiorcJzGzzzeocTDtlNwP_dC/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0092	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0093	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1MkbHLio_XGDcPek4QTIvARmqG4n1Y33g/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0093	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0094	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1QTF5MmGTybEYZC2L2VDEQ0I8pLCe8Im2/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0094	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0095	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1PQ2c30eaZokDfvtWdwoEbBEms0ElZsyh/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0095	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0096	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1q3P1CfxV1k2tpj4f0e2Kyq62Y60um7dO/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0096	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0097	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1nTdzh6SEc4uXimXU4OG-kCZElLuem8ET/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0097	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0098	CharuPath	চারুপাঠ	\N	https://drive.google.com/file/d/1qWlasEraPwZkRcYca0uDO6QU9En6s7zQ/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0098	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0099	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1MLdE_GBYysaYKCLwRn_TiCIbQDmp7f00/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0099	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0100	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/16a1_cZ-w9fseR-CeYqPJrtXwsYZaCPYp/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0100	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0101	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1zVUFa4txwZqA22Q09Zw1P3L4pzYADD38/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0101	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0102	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1zC8vi_ZjTCPrlRmfo-SW7-IYncaZaFOb/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0102	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0103	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1JXA7S77F0JdK1zLvrmnmZ4avLfuhxBN0/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0103	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0104	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1rGjQLauawJKTrJqQJZtaSsc_gNnH1SUS/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0104	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0105	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1NUhbAekbbdOMTJPKkGn9aEDGOL3QiUbB/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0105	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0106	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1O7B3wKP7FQls5UzKGH5Te182cmFAQ2zX/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0106	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0107	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1u1CL7DTlDuoqImoAGYjAqRF9mla_BkFb/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0107	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0108	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/1YF8yAaBKai3hmG9LKEYQ8ApxFQ5BOme6/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0108	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0109	Arabic	আরবি	\N	https://drive.google.com/file/d/19zxX9QpMofltiKddJnM-rp16YQYyYMRP/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0109	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0110	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1zkGFH3MyfNTr0PQbGKX1mczKH2nrA3v-/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0110	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0111	Pali	পালি	\N	https://drive.google.com/file/d/1WUlYjlGm7xlAJmNl8h8Y0CbhpzOg_0Ef/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0111	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0112	Music	সংগীত	\N	https://drive.google.com/file/d/13VZXJ8BcZaUR8zEVcdROJqQzG0n0DmsB/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Education-Text-Book-0112	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0113	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1--_FJruc6h3RP2z4J3D6MEgzkyYFd7rS/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0113	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0114	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/18ZmkoiAjM-WDUDHWRYGK9BsDbNt5tNt-/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0114	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0115	Soptobarrna	সপ্তবর্ণা	\N	https://drive.google.com/file/d/12xtR4HeQYFObRahh31FLAezKTKoaAu5l/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0115	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0116	Mathematics	গণিত	\N	https://drive.google.com/file/d/1ReXrHNs8ZN0sNBCC9jdOIWiSaELxhOWk/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0116	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0117	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1XEcPhlUxIqgeuwyDNdRogwEN9eQaA6GU/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0117	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0118	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1OgqTsBtE0IPnfUVYFUcu8Bobt_qHDUg6/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0118	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0119	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/19GUv5q2wR8UwzDRb89vM5W-oC9hrClUt/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0119	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0120	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1djrnwN0jkPGmGDeUdvHIGH0Me3RFgBEr/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0120	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0121	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1hZjhIVNcHgmzsxJiE1N0UTlXkl1pPygU/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0121	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0122	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1emcopi48FZ9fuYloJ8G-p3plaW1AaZTo/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0122	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0123	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1hsAtIoveZWzDEwZppTbxmkDyogrnhyXu/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0123	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0124	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1VwNPaIQ2NtzClBE_ca2YQk6W46ae8Vrs/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0124	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0125	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/13OIL62GB77oavK0Vlh8iRNFZyjADrl_B/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0125	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0126	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1tKRIzRNrypjynhMwU1vkY9s-bEjy3GSW/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0126	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0127	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1bsF77_QWPwUcXSDVyTmkxFmGaQXvrbDP/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0127	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0128	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1bK85z_g5bZDocrbDjyyX7fgXlhslgAop/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0128	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0129	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1GGG1AWYXNUy0yMl-Tx1aqKjr82GXfvPZ/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0129	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0130	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1G0rtrbXJnk7mbmr-jz4sLBHor81I049v/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0130	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0131	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/12vX-Dq3fvlzW4rjU8Za2Q0eL1OoOHKRV/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0131	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0132	Arabic	আরবি	\N	https://drive.google.com/file/d/1uLTiHoO9Iy_N8tJWOQXzrTYD9tNoxpUE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0132	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0133	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1QOBdjKb9k1y7xeqba1bBg841yq7Czu0d/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0133	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0134	Pali	পালি	\N	https://drive.google.com/file/d/1WfFkvwyuJc2u0ckAN4t6m9JyiLwiWarf/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0134	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0135	Music	সংগীত	\N	https://drive.google.com/file/d/1TTLTJhIiDFpOJC3rFtjHnoe10emXM8j5/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0135	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0136	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1--_FJruc6h3RP2z4J3D6MEgzkyYFd7rS/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0136	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0137	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/18ZmkoiAjM-WDUDHWRYGK9BsDbNt5tNt-/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0137	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0138	Soptobarrna	সপ্তবর্ণা	\N	https://drive.google.com/file/d/12xtR4HeQYFObRahh31FLAezKTKoaAu5l/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0138	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0139	Mathematics	গণিত	\N	https://drive.google.com/file/d/1c9mojRsOKd_0wSLdWaMpH6PIl9oiGMVt/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0139	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0140	Bangla Byakaron o Nirmiti 	বাংলা ব্যাকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1XEcPhlUxIqgeuwyDNdRogwEN9eQaA6GU/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0140	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0141	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1OgqTsBtE0IPnfUVYFUcu8Bobt_qHDUg6/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0141	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0142	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1iLKXYHIQC6lRByZWnPFlk-DkBbPgD3nN/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0142	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0143	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/11v24ZKmhBxCYlOV-3fpg-DCRT-3IK6uU/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0143	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0144	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/129KPHSzVjrEKk9y4dnSA1dSNmcyP23Fp/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0144	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0145	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/13uyED4ZAS_gjcdqz5alHJIIzfSKiGNqc/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0145	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0146	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1PKmxcCMq_cPKBNAjWBnFeWJa79dCdAAY/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0146	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0147	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1qRUoTP9sXM-YNOFiE5sgf2tX2Dczm9QZ/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0147	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0148	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1mmk7p51NDsXYy6D-drvWqpKezuzqOBc3/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0148	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0149	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1_cgizUaRApE207n2OKmvExxyfHtRDhZx/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0149	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0150	Agricultural education	কৃষি শিক্ষা	\N	https://drive.google.com/file/d/1_vk00_0ibMNhFrVNyZDakG7ZLTza-9qs/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0150	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0151	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা	\N	https://drive.google.com/file/d/1l5yloBb0lQ32VsV51Wul1ksFtjpPA75o/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0151	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0152	Language and Culture of Minority and Ethnic Groups	ক্ষুদ্র ও নৃগোষ্ঠীর ভাষা ও সংস্কৃতি	\N	https://drive.google.com/file/d/1HHThrlHcLtWF-jrgnsAJfTGKgmaIxMZx/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0152	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0153	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য	\N	https://drive.google.com/file/d/1SN3UDd74sOn7DPUgcuymJoVeVIuofg59/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0153	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0154	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/173ar--gefElH1npeOoOoDO3sBRqT1BeA/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0154	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0155	Arabic	আরবি	\N	https://drive.google.com/file/d/1uLTiHoO9Iy_N8tJWOQXzrTYD9tNoxpUE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0155	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0156	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1QOBdjKb9k1y7xeqba1bBg841yq7Czu0d/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0156	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0157	Pali	পালি	\N	https://drive.google.com/file/d/1WfFkvwyuJc2u0ckAN4t6m9JyiLwiWarf/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0157	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0158	Music	সংগীত	\N	https://drive.google.com/file/d/1TTLTJhIiDFpOJC3rFtjHnoe10emXM8j5/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Education-Text-Book-0158	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0159	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lYhBM45Ez3tpTYiRLqspnFaWUgsKatHG/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0159	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0160	Bangla Byakaron o Nirmiti 	বাংলা ব্যকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1IDoZoUvO6Fm3TFDJ_6v9cj1eFuvEJ-wc/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0160	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0161	Agricultural education	কৃষি শিক্ষা 	\N	https://drive.google.com/file/d/1Nt4fUWIkMfEPYyeXlxHSpCHLj6ELes7F/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0161	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0162	Domestic science	গার্হস্থ্য বিজ্ঞান 	\N	https://drive.google.com/file/d/1S9hn8v4tQJewcXm6p6nU227ZzcxpRhSF/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0162	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0163	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য 	\N	https://drive.google.com/file/d/1yHUQE_t8iu37d1giLefix_Ns71RaeuHd/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0163	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0164	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি 	\N	https://drive.google.com/file/d/1wCBCcXBzcqfMj4jr6eAWcVs7RpeVuwzm/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0164	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0246	Physics	পদার্থবিজ্ঞান	\N	https://drive.google.com/file/d/1kjcETM6dRLZ_2jgB2YcwEr-t4M8lprhC/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0246	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0165	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা 	\N	https://drive.google.com/file/d/1svslGt9HeVMRyladAaZQwWIUdXFPMrJY/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0165	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0166	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1e3dKzRQh_XHlkAWafvBXQepErSE5hoxE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0166	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0167	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1z0wqeogZB1oLokdXfwuoPxnnwwOkoIsi/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0167	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0168	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1cTrGw-wIz4DEXguic3OqR549TEKG7XvR/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0168	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0169	Sahitya Konika	সাহিত্য কনিকা	\N	https://drive.google.com/file/d/1FBZFZObFSu6l6ssBfGLK1baPkqVjAIc1/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0169	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0170	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1GXGg4FzXjDpMyJmh7YfVbguBOpRmAJ-k/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0170	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0171	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1BTHK9_DX3LLxU2UkrRTShCzr05bSi8vK/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0171	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0172	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/19D-ouc0eEKgUo6RFkfonZEfOcnlwyXIh/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0172	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0173	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1gjgpXBmGymeqm3rKcHSSGmGOBHXzrm9J/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0173	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0174	Christianity and Moral Education	খ্রিষ্টান ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1zjoXducRg9CbOFmvK1Lew7QTg3RrgklQ/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0174	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0175	Buddhism and Moral Education	বৌদ্ধ ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1ZpaaDncPDeXkN0-rR3fixS8zD77SkCI4/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0175	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0176	Mathematics	গণিত	\N	https://drive.google.com/file/d/1w9mWTPL8uUGuMdevKCs83G9nBa4NqVAs/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0176	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0177	Arabic	আরবি	\N	https://drive.google.com/file/d/1mpZkyrDXCsNIOGbb84pQEpSSuITlVx--/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0177	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0178	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1mqeEQ2qtgbkhN62PNwCTRsV4tNK64Iki/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0178	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0179	Pali	পালি	\N	https://drive.google.com/file/d/1lNgI9exhbRZyJMCfR1Y5GBs4rhTIqDyP/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0179	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0180	Music	সংগীত	\N	https://drive.google.com/file/d/1e1GvvZ9n6XhfBG9pGHN41qusVnEyHo9H/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0180	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0181	Ananda Path (Bangla Quick Reading)	আনন্দ পাঠ(বাংলা দ্রুত পঠন)	\N	https://drive.google.com/file/d/1lYhBM45Ez3tpTYiRLqspnFaWUgsKatHG/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0181	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0182	Bangla Byakaron o Nirmiti 	বাংলা ব্যকরণ ও নির্মিতি	\N	https://drive.google.com/file/d/1IDoZoUvO6Fm3TFDJ_6v9cj1eFuvEJ-wc/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0182	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0183	Agricultural education	কৃষি শিক্ষা 	\N	https://drive.google.com/file/d/1LOHof04M5I52NXf4L1F1pAwiNKrQVzX8/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0183	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0184	Domestic science	গার্হস্থ্য বিজ্ঞান 	\N	https://drive.google.com/file/d/1N-wz2IZtCf9RVV5-YTBjXaqQb8cnPMy4/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0184	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0185	Physical education and health	শারীরিক শিক্ষা ও স্বাস্থ্য 	\N	https://drive.google.com/file/d/1HHvZPU98I4J0AOE3N83XLnav5xd3thBv/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0185	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0186	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি 	\N	https://drive.google.com/file/d/1y2ZNN9Lauom00L0lttWHHaBEA8GpI_fh/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0186	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0187	Work and Life Oriented Education	কর্ম ও জীবনমুখী শিক্ষা 	\N	https://drive.google.com/file/d/1CX_c9XMHA5J3z5km1s0RNjDnviwainLl/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0187	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0188	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1ETV5MJynXKCLeHfctN2ddAeGempV4e0Z/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0188	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0189	English for Today	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1z0wqeogZB1oLokdXfwuoPxnnwwOkoIsi/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0189	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0190	English Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1cTrGw-wIz4DEXguic3OqR549TEKG7XvR/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0190	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0191	Sahitya Konika	সাহিত্য কনিকা	\N	https://drive.google.com/file/d/1FBZFZObFSu6l6ssBfGLK1baPkqVjAIc1/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0191	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0192	Bangladesh and World Identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1J0JIpLmkl6uuWENmRLRkTPc4995gptRn/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0192	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0193	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1cKCSROCOnnucSKbq3Ud5NXsi-5CrC8EE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0193	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0194	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1wF5X2wytmIAB-lD2vZlJpJj0c9ETEJSp/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0194	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0195	Hinduism and Moral Education	হিন্দুধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1IdMs2ftD8AedQA_c8j_VgKBIaDHyyV4y/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0195	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0196	Christianity and Moral Education	খ্রিষ্টান ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1nTVTiG-GrzO5QOlReMqAUx15bS7Ks50j/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0196	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0197	Buddhism and Moral Education	বৌদ্ধ ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1hQmHlqJydt6LU0JNz8kHvr2Ryw7D5rgw/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0197	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0198	Mathematics	গণিত	\N	https://drive.google.com/file/d/1rsqIYofr9YJJ9TThj8nFB-9q98ZKVcYq/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0198	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0199	Arabic	আরবি	\N	https://drive.google.com/file/d/1mpZkyrDXCsNIOGbb84pQEpSSuITlVx--/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0199	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0200	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/1mqeEQ2qtgbkhN62PNwCTRsV4tNK64Iki/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0200	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0201	Pali	পালি	\N	https://drive.google.com/file/d/1lNgI9exhbRZyJMCfR1Y5GBs4rhTIqDyP/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0201	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0202	Music	সংগীত	\N	https://drive.google.com/file/d/1e1GvvZ9n6XhfBG9pGHN41qusVnEyHo9H/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Education-Text-Book-0202	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0203	Bangla Sahitta	 বাংলা সাহিত্য	\N	https://drive.google.com/file/d/1EGkrQmjtjSZY6d7XzqI9d68tBzh-xz2N/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0203	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0204	Bangla Sahapath	বাংলা সহপাঠ	\N	https://drive.google.com/file/d/1opKsdJb4CC47li9wZctzhWvV8l_vb7OC/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0204	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0205	Bangla Bhashar Byakaran	বাংলা ভাষার ব্যাকরণ	\N	https://drive.google.com/file/d/1r7jl2Kya-HjGhgqe4MdKbHd6r6aFpCl5/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0205	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0206	English for Toady	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1tsq23Q7BNljxPMcW9LtZvaaw4rgoMAyA/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0206	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0207	Mathematics	গণিত	\N	https://drive.google.com/file/d/1e4F5mXS0csR-SvOkEWPcuJF2CvimRGSh/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0207	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0208	Enlish Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1VjWKIcw8UFkJyTzGpwPpEdK1dLvzcDr8/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0208	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0209	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1Pe9SViRX6eoFRK_D9yoghjkib0aXKqDb/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0209	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0210	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1JlmZ6Rgh0kGZhw07nai9GQM7wlXfPEI3/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0210	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0211	Rachanasomvar	রচনাসম্ভার	\N	\N	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0211	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0212	Physics	পদার্থবিজ্ঞান	\N	https://drive.google.com/file/d/1R9UtZnrU36EwbjEh1ewEstDvTPVCwMUy/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0212	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0213	Chemistry	রসায়ন	\N	https://drive.google.com/file/d/1fD4Nh4AQjS7GGGGRHsTmGN8Jfq8tXqPM/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0213	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0214	Biology	জীববিজ্ঞান	\N	https://drive.google.com/file/d/10Dpx7644QAL9bEzaK4Vapjvbmr2I7DIx/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0214	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0215	Higher Mathematics	উচ্চতর গণিত	\N	https://drive.google.com/file/d/1i2lw0hGAy6Lkh_A6KExJDGOjiG2MsEZE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0215	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0216	Geography and environment	ভূগোল ও পরিবেশ	\N	https://drive.google.com/file/d/1ZLGtRHVRFjPzN7FAvmVrSVmJ8kc5_vdq/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0216	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0217	Economy	অর্থনীতি	\N	https://drive.google.com/file/d/1cuurvGHxFCmjN6LHTy8kfv6JfpiZhV6P/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0217	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0218	Agricultural education	কৃষিশিক্ষা	\N	https://drive.google.com/file/d/1pRMMK9QSVCVznl2zE0g2sL6rp8ijYciD/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0218	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0219	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	https://drive.google.com/file/d/1uuFBAm8ua5d-sobYgfeZwPNCm_Uqfwpu/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0219	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0220	Politics and citizenship	পৌরনীতি ও নাগরিকতা	\N	https://drive.google.com/file/d/1h_rRkIsU8A3WKNSjs201u870QjkgUkFE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0220	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0221	Accounting	হিসাববিজ্ঞান	\N	https://drive.google.com/file/d/16dCCr9Bb7h4lhyuuYlmHtcCv9FFob5zU/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0221	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0222	Finance and banking	ফিন্যান্স ও ব্যাংকিং	\N	https://drive.google.com/file/d/1Yw6gEH2zMaPLGnK6VbdgPVzqt-p0gvvE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0222	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0223	Business ventures	ব্যবসায় উদ্যোগ	\N	https://drive.google.com/file/d/1QxwzRVO5h8FC-BAshw9oFFOmWSj44jHq/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0223	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0224	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1rv9S0p_S8JMv4iZkyjEYLpxqzykpYPnN/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0224	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0247	Chemistry	রসায়ন	\N	https://drive.google.com/file/d/1hPj-FZxjW6UpBMhJqBxJeptGXY7Bw8os/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0247	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0225	Hinduism and Moral Education	হিন্দু ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/14MKK9v3e6Baf0DxuAjY38dToQPiVrMqG/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0225	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0226	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1yvASZUQCdkY4l5RvS4LAr7aX1cLD-7O5/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0226	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0227	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1ww7aRcOnGDukayednoYCrRrV7glXugzq/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0227	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0228	Career education	ক্যারিয়ার এডুকেশন	\N	https://drive.google.com/file/d/1anfFWos1PDAKjkgyBe9XfOaowSP-Xy5N/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0228	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0229	Bangladesh and world identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/1AIlAdAl7-mwfJXnKO6ZAqzhldclg-kUT/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0229	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0230	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1w83kQnLyBTCC8ABYnn376W1nbX2iDvmQ/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0230	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0231	History and world civilization of Bangladesh	বাংলাদেশের ইতিহাস ও বিশ্বসভ্যতা	\N	https://drive.google.com/file/d/1qWV0SaMwpZH1xiso04KAPt2v9EDyyiqX/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0231	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0232	Physical education, health sciences and sports	শারীরিক শিক্ষা, স্বাস্থ্য বিজ্ঞান ও খেলাধুলা	\N	https://drive.google.com/file/d/18e2JlIXvtosz24FachEtJnYge1XvsF1P/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0232	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0233	Illustrated Arabic text	সচিত্র আরবি পাঠ	\N	https://drive.google.com/file/d/1o2s8W6VA_28AW8kM9pQCKJt1K2Wg6hFB/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0233	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0234	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/17s6qoXnWfTw5PRDFUN5F9_iepvBA_GD1/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0234	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0235	Pali	পালি	\N	https://drive.google.com/file/d/1m8_pf-QcizTTtMBmCIGgoKmLv2jaYunb/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0235	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0236	Music	সংগীত	\N	https://drive.google.com/file/d/1K0hBjwVOZwYdcqi7bsNz6xKBZ48_0eqn/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Bangla-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0236	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0237	Bangla Sahitta	 বাংলা সাহিত্য	\N	https://drive.google.com/file/d/1EGkrQmjtjSZY6d7XzqI9d68tBzh-xz2N/view	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0237	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0238	Bangla Sahapath	বাংলা সহপাঠ	\N	https://drive.google.com/file/d/1opKsdJb4CC47li9wZctzhWvV8l_vb7OC/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0238	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0239	Bangla Bhashar Byakaran	বাংলা ভাষার ব্যাকরণ	\N	https://drive.google.com/file/d/1r7jl2Kya-HjGhgqe4MdKbHd6r6aFpCl5/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0239	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0240	English for Toady	ইংলিশ ফর টুডে	\N	https://drive.google.com/file/d/1tsq23Q7BNljxPMcW9LtZvaaw4rgoMAyA/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0240	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0241	Mathematics	গণিত	\N	https://drive.google.com/file/d/108V-kz2oHnjMviMGanN4OJI0xq9Cjpl_/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0241	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0242	Enlish Grammer and Composition	ইংরেজি ব্যাকরণ এবং রচনা	\N	https://drive.google.com/file/d/1VjWKIcw8UFkJyTzGpwPpEdK1dLvzcDr8/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0242	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0243	Information and communication technology	তথ্য ও যোগাযোগ প্রযুক্তি	\N	https://drive.google.com/file/d/1DS5BqwEVIc-CiVMS-304wzmAIF5jHP2H/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0243	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0244	Science	বিজ্ঞান	\N	https://drive.google.com/file/d/1zr2SmC_ZJepOcg3FqnPnBQosV9XwU352/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0244	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0248	Biology	জীববিজ্ঞান	\N	https://drive.google.com/file/d/1X-0_S7cdf-R7nIqssFRq7yCTZuN5ga6b/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0248	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0249	Higher Mathematics	উচ্চতর গণিত	\N	https://drive.google.com/file/d/1_MbX32CCdwygW4A-KoLhLI3plGWacaRC/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0249	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0250	Geography and environment	ভূগোল ও পরিবেশ	\N	https://drive.google.com/file/d/1QGjFzYordwsiCh6kRBU8g11byoh15Xdt/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0250	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0251	Economy	অর্থনীতি	\N	https://drive.google.com/file/d/13y91wGKWYYXdhDvOWiGONqsrcUq55AN3/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0251	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0252	Agricultural education	কৃষিশিক্ষা	\N	https://drive.google.com/file/d/1OcXut4lc1axULGRXe0Wqv7QAcR95vhwv/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0252	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0253	Domestic science	গার্হস্থ্য বিজ্ঞান	\N	\N	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0253	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0254	Politics and citizenship	পৌরনীতি ও নাগরিকতা	\N	https://drive.google.com/file/d/1ZshZG-kzhNa-ZIr0hPtJgtVEwCBFVVOC/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0254	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0255	Accounting	হিসাববিজ্ঞান	\N	https://drive.google.com/file/d/1q0px2Q-ngvS_GXhK-cPtpNfjMT-76NgE/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0255	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0256	Finance and banking	ফিন্যান্স ও ব্যাংকিং	\N	https://drive.google.com/file/d/1gS1vo_iXO7raWDjbebQTTc9cVVYjP2sn/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0256	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0257	Business ventures	ব্যবসায় উদ্যোগ	\N	https://drive.google.com/file/d/1cx0Ynn0CrCP4okH53RvuEX7xrUTNIjx_/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0257	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0258	Islam and Moral Education	ইসলাম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1KD8Yc8TcXKZhcexUjiQ7pRxSsQEqpIi6/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0258	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0259	Hinduism and Moral Education	হিন্দু ধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1roi1h8I-XF-O46r48bcDL8xBFFkJy7UF/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0259	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0260	Buddhism and Moral Education	বৌদ্ধধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/1LjeuUW2vvw5g0aK7Jwnvsu8VS3IyPBNn/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0260	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0261	Christianity and Moral Education	খ্রিষ্টধর্ম ও নৈতিক শিক্ষা	\N	https://drive.google.com/file/d/19o5oPGX5_HfFPoOJ3yzoZrrTsFjPwscW/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0261	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0262	Career education	ক্যারিয়ার এডুকেশন	\N	https://drive.google.com/file/d/14-HB-dNZjqwESmDxKXNC0k9wBaxpT85C/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0262	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0263	Bangladesh and world identity	বাংলাদেশ ও বিশ্বপরিচয়	\N	https://drive.google.com/file/d/10_Svz7vbvfL43g4DfTMtH9WKxRwFH40j/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0263	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0264	Arts and Crafts	চারু ও কারুকলা	\N	https://drive.google.com/file/d/1vCBBmZq3-qgm1Mcm8tN0T1FwVqnMwjiw/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0264	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0265	History and world civilization of Bangladesh	বাংলাদেশের ইতিহাস ও বিশ্বসভ্যতা	\N	https://drive.google.com/file/d/1-xIZIUWtFdCtxJVdjJ9M2nluUZp7o7KY/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0265	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0266	Physical education, health sciences and sports	শারীরিক শিক্ষা, স্বাস্থ্য বিজ্ঞান ও খেলাধুলা	\N	https://drive.google.com/file/d/1toz3XIKHxwU3gOkMz-V9knjTH-32D2cD/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0266	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0267	Illustrated Arabic text	সচিত্র আরবি পাঠ	\N	https://drive.google.com/file/d/1o2s8W6VA_28AW8kM9pQCKJt1K2Wg6hFB/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0267	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0268	Sanskrit	সংস্কৃত	\N	https://drive.google.com/file/d/17s6qoXnWfTw5PRDFUN5F9_iepvBA_GD1/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0268	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0269	Pali	পালি	\N	https://drive.google.com/file/d/1m8_pf-QcizTTtMBmCIGgoKmLv2jaYunb/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0269	System	2022-06-23 13:13:16.240937	\N	\N
SCHOOL-ERP-Institute-Text-Book-0270	Music	সংগীত	\N	https://drive.google.com/file/d/1K0hBjwVOZwYdcqi7bsNz6xKBZ48_0eqn/view	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-English-Version	\N	SCHOOL-ERP-Institute-Class-9-10	SCHOOL-ERP-Education-Text-Book-0270	System	2022-06-23 13:13:16.240937	\N	\N
\.


--
-- Data for Name: institute_grading_system; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_grading_system (oid, name_en, name_bn, grade_point_scale, sort_order, status, institute_oid, institute_type_oid, education_system_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Institute-Grading-System-0001	Junior Secondary Education Grading System	জুনিয়র মাধ্যমিক শিক্ষা গ্রেডিং সিস্টেম	5	3	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Type-001	Education-System-0001	System	2022-06-23 13:13:16.174633
SCHOOL-ERP-Institute-Grading-System-0002	Secondary Education Grading System	মাধ্যমিক শিক্ষা গ্রেডিং সিস্টেম	5	4	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Type-002	Education-System-0001	System	2022-06-23 13:13:16.174633
SCHOOL-ERP-Institute-Grading-System-0003	Higher Secondary Education Grading System	উচ্চ মাধ্যমিক শিক্ষা গ্রেডিং সিস্টেম	5	5	Inactive	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Type-003	Education-System-0001	System	2022-06-23 13:13:16.174633
\.


--
-- Data for Name: institute_grading_system_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_grading_system_detail (oid, start_marks, end_marks, letter_grade, grade_point, assessment, remarks, sort_order, status, institute_grading_system_oid, created_by, created_on) FROM stdin;
20220301162218193-mRCeTWDSpxyGPc01	80	100	A+	5	Excellent	First Class	1	Active	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:16.179741
20220301162218399-bVCaywkwwAerXYqFzB	70	79	A	4	Very Good	First Class	2	Active	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:16.179741
20220301162218616-cSErEFtyWFpzGaxaWR	60	69	A-	3.5	Good	First Class	3	Active	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:16.179741
20220301162218823-aLMLfEVRTUPgdDcdCC	50	59	B	3	Above Average	Second Class	4	Active	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:16.179741
20220301162219004-aPBNWVbJdghrkyXnffs	40	49	C	2	Below Average	Second Class	5	Active	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:16.179741
20220301162219191-zGwsxNthDdrtRUQDqaz	33	39	D	1	Poor	Third Class	6	Active	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:16.179741
20220301162219373-RzDZwNvdBrhrenqeAXq	0	32	F	0	Fail	Fail	7	Active	SCHOOL-ERP-Institute-Grading-System-0001	System	2022-06-23 13:13:16.179741
20220301162219606-zWHQsXXfGuyreKcQaCzJ	80	100	A+	5	Excellent	First Class	1	Active	SCHOOL-ERP-Institute-Grading-System-0002	System	2022-06-23 13:13:16.179741
20220301162220147-yBQKWnsXNarewHBatXy	70	79	A	4	Very Good	First Class	2	Active	SCHOOL-ERP-Institute-Grading-System-0002	System	2022-06-23 13:13:16.179741
20220301162220329-naCrqrsMwyredyEsFCP	60	69	A-	3.5	Good	First Class	3	Active	SCHOOL-ERP-Institute-Grading-System-0002	System	2022-06-23 13:13:16.179741
20220301162220612-NuQwGFNpkjbvFzpvmG	50	59	B	3	Above Average	Second Class	4	Active	SCHOOL-ERP-Institute-Grading-System-0002	System	2022-06-23 13:13:16.179741
20220301162220822-mVCQqYvYtfdgpJJSKcq	40	49	C	2	Below Average	Second Class	5	Active	SCHOOL-ERP-Institute-Grading-System-0002	System	2022-06-23 13:13:16.179741
20220301162221180-zHQpkwytgyTBctwPZw	33	39	D	1	Poor	Third Class	6	Active	SCHOOL-ERP-Institute-Grading-System-0002	System	2022-06-23 13:13:16.179741
20220301162221361-HEmuytdhqGVVRPaJdnL	0	32	F	0	Fail	Fail	7	Active	SCHOOL-ERP-Institute-Grading-System-0002	System	2022-06-23 13:13:16.179741
\.


--
-- Data for Name: institute_session; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_session (oid, name_en, name_bn, education_type_json, status, institute_oid, education_system_oid, education_curriculum_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Institute-Session-2022	2022	২০২২	[{"oid":"Education-Type-0003","name_en":"Junior Secondary Education","name_bn":"জুনিয়র মাধ্যমিক শিক্ষা","short_name":"JSC","sort_order":3,"status":"Active","education_system_oid":"Education-System-0001"},{"oid":"Education-Type-0004","name_en":"Secondary Education","name_bn":"মাধ্যমিক শিক্ষা","short_name":"SSC","sort_order":4,"status":"Active","education_system_oid":"Education-System-0001"}]	Running	SCHOOL-ERP-Demo-School-001	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.14784	\N	\N
SCHOOL-ERP-Institute-Session-2022-2023	2022-2023	২০২২-২০২৩	[{"oid":"Education-Type-0005","name_en":"Higher Secondary Education","name_bn":"উচ্চ মাধ্যমিক শিক্ষা","short_name":"HSC","sort_order":5,"status":"Active","education_system_oid":"Education-System-0001"}]	Running	SCHOOL-ERP-Demo-School-001	Education-System-0001	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.14784	\N	\N
\.


--
-- Data for Name: institute_shift; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_shift (oid, name_en, name_bn, institute_oid, education_shift_oid, start_time, end_time, status, created_by, created_on) FROM stdin;
SCHOOL-ERP-Institute-Shift-Morning	Morning	সকাল	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Shift-Morning	8	13	Active	System	2022-06-23 13:13:16.14455
SCHOOL-ERP-Institute-Shift-Evening	Evening	বৈকালীন	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Shift-Evening	14	19	Active	System	2022-06-23 13:13:16.14455
\.


--
-- Data for Name: institute_type; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_type (oid, institute_oid, status, education_type_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Institute-Type-001	SCHOOL-ERP-Demo-School-001	Active	Education-Type-0003	System	2022-06-23 13:13:16.13793
SCHOOL-ERP-Institute-Type-002	SCHOOL-ERP-Demo-School-001	Active	Education-Type-0004	System	2022-06-23 13:13:16.13793
SCHOOL-ERP-Institute-Type-003	SCHOOL-ERP-Demo-School-001	Active	Education-Type-0005	System	2022-06-23 13:13:16.13793
\.


--
-- Data for Name: institute_version; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.institute_version (oid, name_en, name_bn, status, institute_oid, education_version_oid, education_curriculum_oid, created_by, created_on) FROM stdin;
SCHOOL-ERP-Institute-Bangla-Version	Bangla Version	বাংলা সংস্করণ	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.141537
SCHOOL-ERP-Institute-English-Version	English Version	ইংরেজি সংস্করণ	Active	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Education-English-Version	SCHOOL-ERP-Education-Curriculum-0001	System	2022-06-23 13:13:16.141537
\.


--
-- Data for Name: login; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.login (oid, login_id, password, user_name, name_en, name_bn, email, mobile_no, menu_json, user_photo_path, user_photo_url, status, reset_required, role_oid, institute_oid, trace_id, login_period_start_time, login_period_end_time, login_disable_start_date, logindisableenddate, temp_login_disable_start_date, temp_login_disable_end_date, last_login_time, last_logout_time, password_expire_time, current_version, edited_by, edited_on, approved_by, approved_on, remarked_by, remarked_on, is_approver_remarks, approver_remarks, is_new_record, created_by, created_on, activated_by, activated_on, closed_by, closed_on, closing_remark, deleted_by, deleted_on, deletion_remark) FROM stdin;
LN00000045	jafrul	jafrul	jafrul	jafrul	জাফরুল	jafrul@doer.com.bd	01946508277	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/school-admin-dashboard"},{"title":"Profile","icon":"fa fa-user-cog","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"My Profile","link":"/school-admin-dashboard"},{"title":"Change Password","link":"/school-admin-dashboard/change-password"}]},{"title":"Admission","icon":"fas fa-envelope-open-text","active":false,"link":"/school-admin-dashboard","type":"dropdown","submenus":[{"title":"Admission List","link":"/school-admin-dashboard/admission-list"}]},{"title":"Students","icon":"fa fa-user-cog","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"All Students","link":"/school-admin-dashboard/student-list"},{"title":"Student Promotion","link":"/school-admin-dashboard"}]},{"title":"Teachers","icon":"fa fa-user-cog","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add New Teacher","link":"/school-admin-dashboard/add-new-teacher"},{"title":"All Teachers","link":"/school-admin-dashboard/teacher-list"}]},{"title":"Classes","icon":"fa fa-chalkboard","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add New Class","link":"create-class"},{"title":"All Classes","link":"class-list"},{"title":"Add Class Room","link":"add-class-room"},{"title":"All Classes & Subject","link":"class-room-list"}]},{"title":"Class Routines","icon":"fa fa-chalkboard","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add New Class Routine","link":"/school-admin-dashboard/add-new-routine"},{"title":"All Class Routines","link":"/school-admin-dashboard/routine-list"}]},{"title":"Attendance","icon":"fas fa-envelope-open-text","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Student Attendance","link":"/school-admin-dashboard/admin-attendance"},{"title":"All Attendance List","link":"/school-admin-dashboard/attendance-list"}]},{"title":"Exams","icon":"fa fa-user-graduate","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Exam","link":"/school-admin-dashboard/add-exam"},{"title":"Add Exam Routine","link":"/school-admin-dashboard"},{"title":"All Exam Routines","link":"/school-admin-dashboard"}]},{"title":"Results","icon":"fa fa-user-graduate","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Exam Marks","link":"/school-admin-dashboard"},{"title":"All Exam Marks","link":"/school-admin-dashboard"},{"title":"Create A Result","link":"/school-admin-dashboard"},{"title":"All Results","link":"/school-admin-dashboard"}]},{"title":"Users","icon":"fa fa-user-graduate","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add User Role","link":"/school-admin-dashboard"},{"title":"All User Roles","link":"/school-admin-dashboard"},{"title":"Create User Account","link":"/school-admin-dashboard/create-account"},{"title":"All User Accounts","link":"/school-admin-dashboard"}]},{"title":"Notices","icon":"fas fa-envelope-open-text","active":false,"link":"/school-admin-dashboard","type":"dropdown","badge":{"text":"Beta","class":"badge-primary","link":"/school-admin-dashboard"},"submenus":[{"title":"Add New Notice","link":"/school-admin-dashboard"},{"title":"All Notices","link":"/school-admin-dashboard"}]},{"title":"Fees","icon":"fas fa-envelope-open-text","active":false,"link":"/school-admin-dashboard","type":"dropdown","badge":{"text":"Beta","class":"badge-primary","link":"/school-admin-dashboard"},"submenus":[{"title":"Add New Fee","link":"/school-admin-dashboard"},{"title":"All Fees","link":"/school-admin-dashboard"}]}]	\N	\N	Active	No	SCHOOL-ADMIN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000040	hasan	hasan	hasan	hasan	হাসান	hasan@doer.com.bd	01782557464	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	STUDENT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000050	simak	simak	simak	simak	simak	simak@doer.com.bd	01782557464	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	TEACHER	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000060	komol	komol	komol	Komol Dash	কমল দাস	a@gmail.com	01782557465	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	STUDENT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000070	arun	arun	arun	Arun Ahmed	অরুণ আহমেদ	a@gmail.com	01782557466	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	STUDENT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000080	tohar	tohar	tohar	Tohar Rahman	তোহার রহমান	a@gmail.com	01782557467	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	STUDENT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000090	manik	manik	manik	Manik Chad 	মানিক চাদ	a@gmail.com	01782557468	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	STUDENT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000100	akash	akash	akash	Akash Ahmed	আকাশ আহমেদ	a@gmail.com	01782557469	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	STUDENT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000110	kamal	kamal	kamal	Kamal Hasan	কামাল হাসান	a@gmail.com	01782557470	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	STUDENT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000120	tamim	tamim	tamim	Tamim Ahmed	তামিম আহমেদ	teacher@gmail.com	01782557471	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	TEACHER	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000130	anik	anik	anik	Anik Datta	অনিক দত্ত	teacher@gmail.com	01782557472	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	TEACHER	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000140	shamim	shamim	shamim	Shamim Sarker	শামীম সরকার	teacher@gmail.com	01782557473	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	TEACHER	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000141	admin	admin	admin	Admin	অ্যাডমিন	admin@gmail.com	01782557474	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.SYS.ADMIN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000142	school	school	school	School	বিদ্যালয়	school@gmail.com	01782557475	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"student-dashboard/view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.SCHOOL.ADMIN	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000143	teacher	teacher	teacher	Teacher	শিক্ষক	teacher@gmail.com	01782557476	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000144	student	student	student	Student	ছাত্র	student@gmail.com	01782557477	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000145	guardian	guardian	guardian	Guardian	অভিভাবক	guardian@gmail.com	01782557478	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000146	sabbir	sabbir	sabbir	Sabbir	সাব্বির	sabbir@gmail.com	01782557479	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000147	abir	abir	abir	Abir	আবির	abir@gmail.com	01782557480	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000148	fahim	fahim	fahim	Fahim	ফাহিম	fahim@gmail.com	01782557481	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000149	rafi	rafi	rafi	Rafi	রাফি	rafi@gmail.com	01782557482	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000150	siam	siam	siam	Siam	সিয়াম	siam@gmail.com	01782557483	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000151	amit	amit	amit	Amit	অমিত	amit@gmail.com	01782557484	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000152	farhan	farhan	farhan	Farhan	ফারহান	farhan@gmail.com	01782557485	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000153	tasfin	tasfin	tasfin	Tasfin	তাসফিন	tasfin@gmail.com	01782557486	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000154	shourav	shourav	shourav	Shourav	সৌরভ	shourav@gmail.com	01782557487	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000155	faysal	faysal	faysal	Faysal	ফায়সাল	faysal@gmail.com	01782557488	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000156	taharul	taharul	taharul	Taharul	তাহারুল	taharul@gmail.com	01782557489	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000157	nayem	nayem	nayem	Nayem	নাঈম	nayme@gmail.com	01782557490	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000158	nafis	nafis	nafis	Nafis	নাফিস	nafis@gmail.com	01782557491	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000159	rifat	rifat	rifat	Rifat	রিফাত	rifat@gmail.com	01782557492	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000160	rakibul	rakibul	rakibul	Rakibul	রাকিবুল	rakibul@gmail.com	01782557493	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000161	aysha	aysha	aysha	Aysha	আয়েশা	ayesha@gmail.com	01782557494	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000162	sadia	sadia	sadia	sadia	সাদিয়া	sadia@gmail.com	01782557495	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000163	eshita	eshita	eshita	Eshita	ঈশিতা	eshita@gmail.com	01782557496	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000164	surovi	surovi	surovi	Surovi	সুরভি	surovi@gmail.com	01782557497	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000165	barsha	barsha	barsha	Barsha	বর্ষা	barsha@gmail.com	01782557498	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"teacher-profile"},{"title":"Change Password","link":"teacher-change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"teacher-notice","badge":{"text":"New Notice","class":"badge-alert","link":"teacher-notice"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"teacher-class-routine"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"teacher-exam-routine"},{"title":"Exam Result","link":"teacher-exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"teacher-attendance","type":"simple"},{"title":"List of Applicants","icon":"fa fa-users","active":false,"link":"teacher-applicants","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.TEACHER	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000166	sadek_hasan	sadek_hasan	sadek_hasan	Sadek Hasan	সাদেক হাসান	sadek_hasan@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000167	nahid_uzz_jaman	nahid_uzz_jaman	nahid_uzz_jaman	Nahid Uzz Jaman	নাহিদ উজ জামান	nahid_uzz_jaman@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000168	shazzad_hossain	shazzad_hossain	shazzad_hossain	Shazzad Hossain	শাহজাদ হোসেন	shazzad_hossain@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000169	abdul_khalek	abdul_khalek	abdul_khalek	Abdul Khalek	আব্দুল খালেক	abdul_khalek@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000170	alam_saddam	alam_saddam	alam_saddam	Alam Saddam	আলম সাদ্দাম	alam_saddam@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000171	mizan_riyadh	mizan_riyadh	mizan_riyadh	Mizan Riyadh	মিজান রিয়াদ	mizan_riyadh@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000172	haq_mizanur	haq_mizanur	haq_mizanur	Haq Mizanur	হক মিজানুর	haq_mizanur@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000173	mizan_tariqul	mizan_tariqul	mizan_tariqul	Mizan Tariqul	মিজান তারিকুল	mizan_tariqul@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000174	raihan_parvez	raihan_parvez	raihan_parvez	Raihan Parvez	রায়হান পারভেজ	raihan_parvez@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000175	abdul_masood	abdul_masood	abdul_masood	Abdul Masood	আব্দুল মাসুদ	abdul_masood@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000176	karim_russell	karim_russell	karim_russell	Karim Russell	করিম রাসেল	karim_russell@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000177	sadeq_sirajul	sadeq_sirajul	sadeq_sirajul	Sadeq Sirajul	সাদেক সিরাজুল	sadeq_sirajul@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000178	kazi_atiqur	kazi_atiqur	kazi_atiqur	Kazi Atiqur	কাজী আতিকুর	kazi_atiqur@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000179	anvir_mostafa	anvir_mostafa	anvir_mostafa	Anvir Mostafa	আনভীর মোস্তফা	anvir_mostafa@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000180	rana_rezaul	rana_rezaul	rana_rezaul	Rana Rezaul	রানা রেজাউল	rana_rezaul@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000181	hassan_saddam	hassan_saddam	hassan_saddam	Hassan Saddam	হাসান সাদ্দাম	hassan_saddam@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000182	musharraf_amin	musharraf_amin	musharraf_amin	Musharraf Amin	মোশাররফ আমিন	musharraf_amin@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000183	tahsin_atiqur	tahsin_atiqur	tahsin_atiqur	Tahsin Atiqur	তাহসিন আতিকুর	tahsin_atiqur@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000184	mizan_malek	mizan_malek	mizan_malek	Mizan Malek	মিজান মালেক	mizan_malek@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000185	rabbi_anvir	rabbi_anvir	rabbi_anvir	Rabbi Anvir	আনভীর রাব্বি	rabbi_anvir@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000186	kamal_tanvir	kamal_tanvir	kamal_tanvir	Kamal Tanvir	কামাল তানভীর	kamal_tanvir@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000187	rana_russell	rana_russell	rana_russell	Rana Russell	রানা রাসেল	rana_russell@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000188	jahangir_alam	jahangir_alam	jahangir_alam	Jahangir Alam	জাহাঙ্গীর আলম 	jahangir_alam@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000189	babu_tariqul	babu_tariqul	babu_tariqul	Babu Tariqul	বাবু তারিকুল	babu_tariqul@gmail.com	01915111222	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000190	jasmin_begum	jasmin_begum	jasmin_begum	Jasmin Begum	জেসমিন বেগম	jasmin_begum@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000191	fatema_khatun	fatema_khatun	fatema_khatun	Fatema khatun	ফাতেমা খাতুন	fatema_khatun@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000192	sahana_hossain	sahana_hossain	sahana_hossain	Sahana Hossain	সাহানা হোসেন	sahana_hossain@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000193	khadiza_khanam	khadiza_khanam	khadiza_khanam	Khadiza Khanam	খাদিজা খানম	khadiza_khanam@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000194	ishita_marjia	ishita_marjia	ishita_marjia	Ishita Marjia	ঈশিতা মারজিয়া	ishita_marjia@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000195	afsana_sharmin	afsana_sharmin	afsana_sharmin	Afsana Sharmin	আফসানা শারমিন	afsana_sharmin@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000196	sheikh_akhi	sheikh_akhi	sheikh_akhi	Sheikh Akhi	শেখ আখি	sheikh_akhi@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000197	basri_farzana	basri_farzana	basri_farzana	Basri Farzana	বসরী ফারজানা	basri_farzana@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000198	ishita_subarna	ishita_subarna	ishita_subarna	Ishita Subarna	ঈশিতা সূবর্ণা	ishita_subarna@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000199	samchun_nahar	samchun_nahar	samchun_nahar	Samchun Nahar	সামছুন নাহার 	samchun_nahar@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000200	parveen_rumana	parveen_rumana	parveen_rumana	Parveen Rumana	পারভীন রুমানা	parveen_rumana@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000201	sultana_tanzina	sultana_tanzina	sultana_tanzina	Sultana Tanzina	সুলতানা তানজিনা	sultana_tanzina@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000202	afsana_rahman	afsana_rahman	afsana_rahman	Afsana Rahman	আফসানা রহমান 	afsana_rahman@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000203	rima_happy	rima_happy	rima_happy	Rima Happy	রিমা হ্যাপি	rima_happy@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000204	afri_mahmuda	afri_mahmuda	afri_mahmuda	Afri Mahmuda	আফ্রি মাহমুদা	afri_mahmuda@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000205	hamid_afroza	hamid_afroza	hamid_afroza	Hamid Afroza	হামিদ আফরোজা	hamid_afroza@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000206	siddika_irene	siddika_irene	siddika_irene	Siddika Irene	সিদ্দিকা আইরিন	siddika_irene@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000207	begum_monira	begum_monira	begum_monira	Begum Monira	বেগম মনিরা	begum_monira@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000208	maria_sanjida	maria_sanjida	maria_sanjida	Maria Sanjida	মারিয়া সানজিদা	maria_sanjida@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000209	mim_anwara	mim_anwara	mim_anwara	Mim Anwara	মিম আনোয়ারা	mim_anwara@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000210	sirajum_marjia	sirajum_marjia	sirajum_marjia	Sirajum Marjia	সিরাজুম মারজিয়া	sirajum_marjia@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000211	hani_shahnaz	hani_shahnaz	hani_shahnaz	Hani Shahnaz	হানি শাহানাজ	hani_shahnaz@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000212	parveen_rumana_01	parveen_rumana_01	parveen_rumana_01	Parveen Rumana	পারভীন রুমানা	parveen_rumana@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000213	parveen_tanzina	parveen_tanzina	parveen_tanzina	Parveen Tanzina	পারভীন তানজিনা 	parveen_tanzina@gmail.com	01915222333	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"},{"title":"Exam Result","link":"/guardian/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	\N	\N	Active	No	SCHOOL.ERP.GUARDIAN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000214	kazi_riyad	kazi_riyad	kazi_riyad	Kazi Riyad	কাজী রিয়াদ	sadek_hasan@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000215	ahnaf_ahmed	ahnaf_ahmed	ahnaf_ahmed	Ahnaf Ahmed	আহনাফ আহমেদ	nahid_uzz_jaman@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000216	md._kamal_parvez	md._kamal_parvez	md._kamal_parvez	Md. Kamal Parvez	মোঃ কামাল পারভেজ	shazzad_hossain@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000217	fahadul_islam	fahadul_islam	fahadul_islam	Fahadul Islam	ফাহাদুল ইসলাম	abdul_khalek@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000218	mohaiminul_ahmed	mohaiminul_ahmed	mohaiminul_ahmed	Mohaiminul Ahmed	মোহাইমিনুল আহমেদ	alam_saddam@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000219	md._shamiul_islam	md._shamiul_islam	md._shamiul_islam	Md. Shamiul Islam	মোঃ শামিউল ইসলাম	mizan_riyadh@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000220	mohammad_fardin	mohammad_fardin	mohammad_fardin	Mohammad Fardin	মোহাম্মদ ফারদিন	haq_mizanur@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000221	imtiaz_riyadh	imtiaz_riyadh	imtiaz_riyadh	Imtiaz Riyadh	ইমতিয়াজ রিয়াদ	mizan_tariqul@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000222	sahidur_rahman	sahidur_rahman	sahidur_rahman	Sahidur Rahman	সহিদুর রহমান	raihan_parvez@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000223	shahnawaz_karim	shahnawaz_karim	shahnawaz_karim	Shahnawaz Karim	শাহনেওয়াজ করিম	abdul_masood@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000224	kobir_khan	kobir_khan	kobir_khan	Kobir khan	কবির খান	karim_russell@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000225	sayed_akash	sayed_akash	sayed_akash	Sayed Akash	সাইদ আকাশ	sadeq_sirajul@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000226	tisha_mim	tisha_mim	tisha_mim	Tisha Mim	তিশা মিমি	kazi_atiqur@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000227	siddika_jannatul	siddika_jannatul	siddika_jannatul	Siddika Jannatul	সিদ্দিকা জান্নাতুল	anvir_mostafa@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000228	hamid_maryam	hamid_maryam	hamid_maryam	Hamid Maryam	হামিদ মরিয়ম	rana_rezaul@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000229	anika_tanzina	anika_tanzina	anika_tanzina	Anika Tanzina	আনিকা তানজিনা	hassan_saddam@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000230	islam_is_happy	islam_is_happy	islam_is_happy	Islam is happy	ইসলাম হ্যাপি	musharraf_amin@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000231	afsana_subarna	afsana_subarna	afsana_subarna	Afsana Subarna	আফসানা সূবর্ণা	tahsin_atiqur@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000232	hamid_rabia	hamid_rabia	hamid_rabia	Hamid Rabia	হামিদ রাবেয়া	mizan_malek@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000233	hamid_bristy	hamid_bristy	hamid_bristy	Hamid Bristy	হামিদ বৃষ্টি	rabbi_anvir@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000234	mukta_sanjida	mukta_sanjida	mukta_sanjida	Mukta Sanjida	মুক্তা সানজিদা	kamal_tanvir@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000235	ishita_shiuli	ishita_shiuli	ishita_shiuli	Ishita Shiuli	ঈশিতা শিউলী	rana_russell@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000236	ferdous_taslima	ferdous_taslima	ferdous_taslima	Ferdous Taslima	ফেরদৌস তাসলিমা	jahangir_alam@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
LN00000237	hamid_kulchum	hamid_kulchum	hamid_kulchum	Hamid Kulchum	হামিদ কুলছুম	babu_tariqul@gmail.com	01915101010	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/list"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	\N	\N	Active	No	SCHOOL.ERP.STUDENT	SCHOOL-ERP-Demo-School-001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: login_history; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.login_history (oid, login_id, password, user_name, email, mobile_no, menu_json, role_oid, user_photo_path, status, reset_required, history_on, login_oid, trace_id, login_period_start_time, login_period_end_time, login_disable_start_date, logindisableenddate, temp_login_disable_start_date, temp_login_disable_end_date, last_login_time, last_logout_time, password_expire_time, version, edited_by, edited_on, approved_by, approved_on, remarked_by, remarked_on, is_approver_remarks, approver_remarks, is_new_record, created_by, created_on, activated_by, activated_on, closed_by, closed_on, closing_remark, deleted_by, deleted_on, deletion_remark) FROM stdin;
\.


--
-- Data for Name: login_log; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.login_log (oid, login_oid, login_time, logout_time, log_type, ip_address, location) FROM stdin;
\.


--
-- Data for Name: notice; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.notice (oid, name_en, name_bn, description_en, description_bn, notice_en_path, notice_en_url, notice_bn_path, notice_bn_url, published_date, expiry_date, institute_oid, session_oid, status, published_by, published_on, approved_by, approved_on, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: otp; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.otp (oid, login_id, mobile_no, otp, otp_status, otp_verified, otp_generated_on, otp_expiration_time, otp_request_by, otp_request_on, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: password_reset_log; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.password_reset_log (oid, login_id, old_password, new_password, maker_id, checker_id, approver_id, approved_on, resetstatus, created_by, created_on, updated_by, updated_on) FROM stdin;
\.


--
-- Data for Name: payment_mode; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.payment_mode (oid, payment_code, name_en, name_bn, payment_type, remarks, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-payment-mode-oid-cash	CASH	Cash	নগদ	cash	\N	Active	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-bank	BANK	Bank	ব্যাংক	bank	\N	Active	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-online	ONLINE	Online	অনলাইন	online	\N	Active	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-bkash	BKASH	bKash	বিকাশ	online	\N	Inactive	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-nagad	NAGAD	Nagad	নগদ	online	\N	Inactive	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-roket	ROKET	Rocket	রকেট	online	\N	Inactive	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-upay	UPAY	Upay	উপায়	online	\N	Inactive	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-debit-card	DEBIT_CARD	Debit Card	ডেবিট কার্ড	online	\N	Inactive	dbadmin	2022-06-23 13:13:17.518807	\N	\N
schoolerp-payment-mode-oid-credit-card	CREDIT_CARD	Credit Card	ক্রেডিট কার্ড	online	\N	Inactive	dbadmin	2022-06-23 13:13:17.518807	\N	\N
\.


--
-- Data for Name: request_log; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.request_log (oid, container_name, status, request_received_on, response_sent_on, response_time_in_ms, request_source, request_source_service, request_json, response_json, start_sequence, end_sequence, trace_id) FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.role (oid, role_id, role_description, menu_json, role_type, status, created_by, created_on, updated_by, updated_on) FROM stdin;
SYSTEM.SA	SYSTEM.SA	SYSTEM.SA	Admin, Institute, Student, Teacher, Guardian	Admin	Active	System	2022-06-23 13:13:15.196987	\N	\N
STUDENT	STUDENT	STUDENT	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student-dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"view-student-profile"},{"title":"Change Password","link":"change-password"}]},{"title":"Notices","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student-dashboard","badge":{"text":"New Notice","class":"badge-alert","link":"/student-dashboard"}},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student-dashboard"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student-dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/student-dashboard"},{"title":"Exam Result","link":"/student-dashboard"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student-dashboard/attendance","type":"simple"}]	Student	Active	System	2022-06-23 13:13:15.196987	\N	\N
SCHOOL-ADMIN	SCHOOL-ADMIN	SCHOOL-ADMIN	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/school-admin-dashboard"},{"title":"Profile","icon":"fa fa-user-cog","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Profile","link":"/school-admin-dashboard"},{"title":"Change Password","link":"/school-admin-dashboard/change-password"}]},{"title":"Admission","icon":"fas fa-envelope-open-text","active":false,"link":"/school-admin-dashboard","type":"dropdown","submenus":[{"title":"Admission List","link":"/school-admin-dashboard/admission-list"}]},{"title":"Student","icon":"fa fa-user-cog","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Student List","link":"/school-admin-dashboard/student-list"},{"title":"Student Promotion","link":"/school-admin-dashboard"}]},{"title":"Teacher","icon":"fa fa-user-cog","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Teacher","link":"/school-admin-dashboard/add-new-teacher"},{"title":"Teacher List","link":"/school-admin-dashboard/teacher-list"}]},{"title":"Class","icon":"fa fa-chalkboard","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Class","link":"create-class"},{"title":"Class List","link":"class-list"},{"title":"Add Class Room","link":"add-class-room"},{"title":"Class Room List","link":"class-room-list"}]},{"title":"Class Routine","icon":"fa fa-chalkboard","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Class Routine","link":"/school-admin-dashboard/add-new-routine"},{"title":"Class Routine List","link":"/school-admin-dashboard/routine-list"}]},{"title":"Attendance","icon":"fas fa-envelope-open-text","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Student Attendance List","link":"/school-admin-dashboard/admin-attendance"}]},{"title":"Exam","icon":"fa fa-user-graduate","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Exam","link":"/school-admin-dashboard/add-exam"},{"title":"Add Exam Routine","link":"/school-admin-dashboard"},{"title":"Exam Routine List","link":"/school-admin-dashboard"}]},{"title":"Exam Result","icon":"fa fa-user-graduate","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Exam Result","link":"/school-admin-dashboard"},{"title":"Exam Result List","link":"/school-admin-dashboard"}]},{"title":"Users","icon":"fa fa-user-graduate","link":"/school-admin-dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add User Role","link":"/school-admin-dashboard"},{"title":"All User Roles","link":"/school-admin-dashboard"},{"title":"Create User Account","link":"/school-admin-dashboard/create-account"},{"title":"All User Accounts","link":"/school-admin-dashboard"}]},{"title":"Notice","icon":"fas fa-envelope-open-text","active":false,"link":"/school-admin-dashboard","type":"dropdown","badge":{"text":"Beta","class":"badge-primary","link":"/school-admin-dashboard"},"submenus":[{"title":"Add Notice","link":"/school-admin-dashboard"},{"title":"Notice List","link":"/school-admin-dashboard"}]}]	Institute	Active	System	2022-06-23 13:13:15.196987	\N	\N
TEACHER	TEACHER	TEACHER	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/profile","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/routine/list"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice"},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/exam","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam/exam-routine"},{"title":"Exam Result","link":"/guardian/exam/exam-result"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	Teacher	Active	System	2022-06-23 13:13:15.196987	\N	\N
SCHOOL.ERP.SYS.ADMIN	SCHOOL.ERP.SYS.ADMIN	School ERP System Admin	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/admin/dashboard"},{"title":"Profile","icon":"fa fa-user-cog","link":"/admin/profile","type":"dropdown","active":false,"submenus":[{"title":"My Profile","link":"/admin/profile"},{"title":"Change Password","link":"/admin/change-password"}]},{"title":"Education","icon":"fas fa-envelope-open-text","active":false,"link":"/admin/education","type":"dropdown","submenus":[{"title":"Education System List","link":"/admin/education/system/list"},{"title":"Education Type List","link":"/admin/education/type/list"},{"title":"Education Program List","link":"/admin/education/program/list"},{"title":"Education Grading List","link":"/admin/education/grading-system/list"},{"title":"Education Board List","link":"/admin/education/board/list"}]},{"title":"Institute","icon":"fas fa-envelope-open-text","active":false,"link":"/admin/institute","type":"dropdown","submenus":[{"title":"Add Institute","link":"/admin/institute/add"},{"title":"Institute List","link":"/admin/institute/list"}]},{"title":"Admission","icon":"fas fa-envelope-open-text","active":false,"link":"/admin/admission","type":"dropdown","submenus":[{"title":"Admission List","link":"/admin/admission/list"}]},{"title":"Student","icon":"fa fa-user-cog","link":"/admin/student","type":"dropdown","active":false,"submenus":[{"title":"Student List","link":"/admin/student/list"},{"title":"Student Promotion","link":"/admin/student/promotion"}]},{"title":"Guardian","icon":"fa fa-user-cog","link":"/admin/guardian","type":"dropdown","active":false,"submenus":[{"title":"Add Guardian","link":"/admin/guardian/add"},{"title":"Guardian List","link":"/admin/guardian/list"}]},{"title":"Teacher","icon":"fa fa-user-cog","link":"/admin/teacher","type":"dropdown","active":false,"submenus":[{"title":"Add Teacher","link":"/admin/teacher/add"},{"title":"Teacher List","link":"/admin/teacher/list"}]},{"title":"Class","icon":"fa fa-chalkboard","link":"/admin/class","type":"dropdown","active":false,"submenus":[{"title":"Add Class","link":"/admin/class/add"},{"title":"Class List","link":"/admin/class/list"},{"title":"Add Class Room","link":"/admin/class-room/add"},{"title":"Class Room List","link":"/admin/class-room/list"}]},{"title":"Class Routine","icon":"fa fa-chalkboard","link":"/admin/class-routine","type":"dropdown","active":false,"submenus":[{"title":"Add Class Routine","link":"/admin/class-routine/add"},{"title":"Class Routine List","link":"/admin/class-routine/list"}]},{"title":"Attendance","icon":"fas fa-envelope-open-text","link":"/admin/attendance","type":"dropdown","active":false,"submenus":[{"title":"Student Attendance List","link":"/admin/attendance/list"}]},{"title":"Exam","icon":"fa fa-user-graduate","link":"/admin/exam","type":"dropdown","active":false,"submenus":[{"title":"Add Exam","link":"/admin/exam/add"},{"title":"Exam List","link":"/admin/exam/list"},{"title":"Add Exam Routine","link":"/admin/exam-routine/add"},{"title":"Exam Routine List","link":"/admin/exam-routine/list"}]},{"title":"Exam Result","icon":"fa fa-user-graduate","link":"/admin/dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Exam Result","link":"/admin/exam-result/add"},{"title":"Exam Result List","link":"/admin/exam-result/list"}]},{"title":"Users","icon":"fa fa-user-graduate","link":"/admin/dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add User Role","link":"/admin/user"},{"title":"All User Roles","link":"/admin/user"},{"title":"Create User Account","link":"/admin/user/create-account"},{"title":"All User Accounts","link":"/admin/user"}]},{"title":"Notice","icon":"fas fa-envelope-open-text","active":false,"link":"/admin/dashboard","type":"dropdown","badge":{"text":"Beta","class":"badge-primary","link":"/admin/notice"},"submenus":[{"title":"Add Notice","link":"/admin/notice/add"},{"title":"Notice List","link":"/admin/notice/list"}]}]	Admin	Active	System	2022-06-23 13:13:15.196987	\N	\N
SCHOOL.ERP.SCHOOL.ADMIN	SCHOOL.ERP.SCHOOL.ADMIN	School ERP School Admin	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/school/dashboard"},{"title":"Profile","icon":"fa fa-user-cog","link":"/school/profile","type":"dropdown","active":false,"submenus":[{"title":"Profile","link":"/school/profile"},{"title":"Change Password","link":"/school/change-password"}]},{"title":"Education","icon":"fas fa-envelope-open-text","active":false,"link":"/school/education","type":"dropdown","submenus":[{"title":"Education Type List","link":"/school/education/type/list"},{"title":"Education Grading List","link":"/school/education/grading-system/list"},{"title":"Education Session","link":"/school/education/session/list"},{"title":"Education Version","link":"/school/education/version/list"},{"title":"Education Shift","link":"/school/education/shift/list"}]},{"title":"Admission","icon":"fas fa-envelope-open-text","active":false,"link":"/school/admission","type":"dropdown","submenus":[{"title":"Application List","link":"/school/admission/application-list"},{"title":"Selected List","link":"/school/admission/pending-list"},{"title":"Admission List","link":"/school/admission/list"}]},{"title":"Fees","icon":"fas fa-envelope-open-text","active":false,"link":"/school/fees","type":"dropdown","submenus":[{"title":"Fees Setting","link":"/school/fees/fees-setting/list"},{"title":"Fee Head","link":"/school/fees/fee-head/list"},{"title":"Due Fees","link":"/school/fees/due-fees/view"}]},{"title":"Student","icon":"fa fa-user-cog","link":"/school/student","type":"dropdown","active":false,"submenus":[{"title":"Student List","link":"/school/student/list"},{"title":"Student Promotion","link":"/school/student/promotion"}]},{"title":"Guardian","icon":"fa fa-user-cog","link":"/school/teacher","type":"dropdown","active":false,"submenus":[{"title":"Add Guardian","link":"/school/guardian/add"},{"title":"Guardian List","link":"/school/guardian/list"}]},{"title":"Teacher","icon":"fa fa-user-cog","link":"/school/teacher","type":"dropdown","active":false,"submenus":[{"title":"Add Teacher","link":"/school/teacher/add"},{"title":"Teacher List","link":"/school/teacher/list"}]},{"title":"Class","icon":"fa fa-chalkboard","link":"/school/class","type":"dropdown","active":false,"submenus":[{"title":"Class List","link":"/school/class/list"},{"title":"Class Group List","link":"/school/class-group/list"},{"title":"Add Class Section","link":"/school/class-section/add"},{"title":"Class Section List","link":"/school/class-section/list"}]},{"title":"Class Routine","icon":"fa fa-chalkboard","link":"/school/class-routine","type":"dropdown","active":false,"submenus":[{"title":"Add Class Routine","link":"/school/class-routine/add"},{"title":"Class Routine List","link":"/school/class-routine/list"}]},{"title":"Attendance","icon":"fas fa-envelope-open-text","link":"/school/attendance","type":"dropdown","active":false,"submenus":[{"title":"Student Attendance List","link":"/school/attendance/student/list"}]},{"title":"Exam","icon":"fa fa-user-graduate","link":"/school/exam","type":"dropdown","active":false,"submenus":[{"title":"Add Exam","link":"/school/exam/add"},{"title":"Exam List","link":"/school/exam/list"},{"title":"Add Exam Routine","link":"/school/exam-routine/add"},{"title":"Exam Routine List","link":"/school/exam-routine/list"}]},{"title":"Exam Result","icon":"fa fa-user-graduate","link":"/school/dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add Exam Result","link":"/school/exam-result/add"},{"title":"Exam Result List","link":"/school/exam-result/list"}]},{"title":"Users","icon":"fa fa-user-graduate","link":"/school/dashboard","type":"dropdown","active":false,"submenus":[{"title":"Add User Role","link":"/school/user"},{"title":"All User Roles","link":"/school/user"},{"title":"Create User Account","link":"/school/user/create-account"},{"title":"All User Accounts","link":"/school/user"}]},{"title":"Notice","icon":"fas fa-envelope-open-text","active":false,"link":"/school/dashboard","type":"dropdown","badge":{"text":"Beta","class":"badge-primary","link":"/school/notice"},"submenus":[{"title":"Add Notice","link":"/school/notice/add"},{"title":"Notice List","link":"/school/notice/list"}]}]	Institute	Active	System	2022-06-23 13:13:15.196987	\N	\N
SCHOOL.ERP.TEACHER	SCHOOL.ERP.TEACHER	School ERP Teacher	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/teacher/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/teacher/profile","type":"dropdown","submenus":[{"title":"My Profile","link":"/teacher/profile"},{"title":"Change Password","link":"/teacher/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/teacher/class","type":"dropdown","submenus":[{"title":"Class Routine","link":"/teacher/class-routine/view"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/teacher/exam-routine","type":"dropdown","submenus":[{"title":"Exam List","link":"/teacher/exam/list"},{"title":"Exam Routine","link":"/teacher/exam-routine/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/teacher/attendance","type":"simple"}]	Teacher	Active	System	2022-06-23 13:13:15.196987	\N	\N
SCHOOL.ERP.STUDENT	SCHOOL.ERP.STUDENT	School ERP Student	[{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/student/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/student/dashboard","type":"dropdown","submenus":[{"title":"Profile","link":"/student/profile"},{"title":"Change Password","link":"/student/change-password"}]},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/student/class-routine","type":"dropdown","submenus":[{"title":"Class Routine","link":"/student/class-routine/view"}]},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/student/exam","type":"dropdown","submenus":[{"title":"Exam List","link":"/student/exam/list"},{"title":"Exam Routine List","link":"/student/exam-routine/list"},{"title":"Exam Result","link":"/student/exam-result/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/student/attendance","type":"simple"},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/student/dashboard","badge":{"text":"Add Notice","class":"badge-alert","link":"/student/notice"}}]	Student	Active	System	2022-06-23 13:13:15.196987	\N	\N
SCHOOL.ERP.GUARDIAN	SCHOOL.ERP.GUARDIAN	School ERP Guardian	[{"title":"General","type":"header"},{"title":"Dashboard","icon":"fa fa-tachometer-alt","active":true,"link":"/guardian/dashboard"},{"title":"Profile","icon":"fas fa-user-tie","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"My Profile","link":"/guardian/profile"},{"title":"Change Password","link":"/guardian/change-password"}]},{"title":"Teacher","icon":"fas fa-user-tie","active":true,"link":"/guardian/teacher/list"},{"title":"Student","icon":"fas fa-user-tie","active":true,"link":"/guardian/student/list"},{"title":"Class","icon":"fas fa-chalkboard","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Class Routine","link":"/guardian/class-routine/view"}]},{"title":"Notice","icon":"fa fa-clipboard-list","active":false,"type":"simple","link":"/guardian/notice/list","badge":{"text":"New Notice","class":"badge-alert","link":"/guardian/notice/list"}},{"title":"Exam","icon":"far fa-newspaper","active":false,"link":"/guardian/dashboard","type":"dropdown","submenus":[{"title":"Exam Routine","link":"/guardian/exam-routine/list"}]},{"title":"Attendance","icon":"far fa-users","active":false,"link":"/guardian/attendance","type":"simple"}]	Guardian	Active	System	2022-06-23 13:13:15.196987	\N	\N
\.


--
-- Data for Name: sign_up; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.sign_up (oid, registration_id, login_id, name_en, name_bn, email, mobile_no, nid, photo_path, photo_url, is_verified, status) FROM stdin;
20211123082311922-RGaGpAgHUenBxxDK	HOOTHUT-REG-00000001	jamal	Md Jamal Uddin	মোঃ জামাল উদ্দিন	jamal.uddin@cellosco.pe	01914012488	2612980852531	/opt/soft/hoothut/files/customer/photo/customer-photo-584615f2-3db3-4189-91c3-7b20829d8ec2.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-584615f2-3db3-4189-91c3-7b20829d8ec2.jpg	no	Active
20211123082312192-VdvsreHwaHpYyKku	HOOTHUT-REG-00000002	liton	Md Moniruzzaman Liton	মোঃ মনিরুজ্জামান লিটন	liton@cellosco.pe	01810176820	7773055434	/opt/soft/hoothut/files/customer/photo/customer-photo-5342e882-171f-4462-99f1-39e48509b91f.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-5342e882-171f-4462-99f1-39e48509b91f.jpg	no	Active
20211123082313433-uFqmZFtcewMyaRxu	HOOTHUT-REG-00000003	ferdous	B.M. Ferdous Mahmud	বি.এম. ফেরদৌস মাহমুদ	ferdous.psy@gmail.com	01810176821	5974295528	/opt/soft/hoothut/files/tem/photo/tem-photo-b70ac950-340c-4f68-acc0-f5c8096494db.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-b70ac950-340c-4f68-acc0-f5c8096494db.jpg	no	Active
20211123082313877-gECrswBpUSDzEmfV	HOOTHUT-REG-00000004	kamal	Md. Kamal Pervez	মোঃ কামাল পারভেজ	parvez.kamal@doer.com.bd	01911933313	4176467613	/opt/soft/hoothut/files/customer/photo/customer-photo-2f15d545-8c00-4c45-b7db-c55c73b96532.png	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-2f15d545-8c00-4c45-b7db-c55c73b96532.png	no	Active
20211123082313669-LfpwbMCQJSsMdTTR	HOOTHUT-REG-00000005	01963845470	Jashim Uddin	জসিম উদ্দিন	jashim.uddin@doer.com.bd	01963845470	1957728551	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082314343-WkxKVZVaBvbPawKD	HOOTHUT-REG-00000006	01810176821	B.M. Ferdous Mahmud	বি.এম. ফেরদৌস মাহমুদ	ferdous.mahmud@doer.com.bd	01810176821	5974295528	/opt/soft/hoothut/files/tem/photo/tem-photo-b70ac950-340c-4f68-acc0-f5c8096494db.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-b70ac950-340c-4f68-acc0-f5c8096494db.jpg	no	Active
20211123082314581-zQptvPvpfCerescr	HOOTHUT-REG-00000007	01521436019	Tanvir Ahammed Sobuj	তানভীর আহমেদ সবুজ	tanvirahammed.sobuj@doer.com.bd	01521436019	2402470195	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082314100-qNhzDJukDByacZLu	HOOTHUT-REG-00000008	01915564675	Md Moniruzzaman Liton	মোঃ মনিরুজ্জামান লিটন	litonbd100@gmail.com	01915564675	7773055434	/opt/soft/hoothut/files/customer/photo/customer-photo-5342e882-171f-4462-99f1-39e48509b91f.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-5342e882-171f-4462-99f1-39e48509b91f.jpg	no	Active
20211123082314100-qNhzDJukuDByacZL	HOOTHUT-REG-00000009	ishtiak	Ishtiak Ahmed	ইশতিয়াক আহমেদ	istiak.ahmed@doer.com.bd	01712621310	\N	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082314100-zDJukyacZLuqNhDB	HOOTHUT-REG-00000010	jamal.uddin@cellosco.pe	Md Jamal Uddin	মোঃ জামাল উদ্দিন	jamal.uddin@cellosco.pe	01914012488	2612980852531	/opt/soft/hoothut/files/customer/photo/customer-photo-584615f2-3db3-4189-91c3-7b20829d8ec2.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-584615f2-3db3-4189-91c3-7b20829d8ec2.jpg	no	Active
20211123082314100-qukuDByacNhzDJZL	HOOTHUT-REG-00000011	01632736769	Faisal Ahmed	ফয়সাল আহমেদ	faisal.anik@doer.com.bd	01632736769	\N	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082314100-qukyacNhzTYULuDB	HOOTHUT-REG-00000012	01982259585	Tanvir Mallik	তানভীর মল্লিক	tanvir.mallik@doer.com.bd	01982259585	\N	/opt/soft/hoothut/files/customer/photo/customer-photo-2ad449ca-0807-470d-b541-59de1dae75d1.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-2ad449ca-0807-470d-b541-59de1dae75d1.jpg	no	Active
20211123082314100-qukyacLuNhDBzTYU	HOOTHUT-REG-00000013	01914012488	Md Jamal Uddin	মোঃ জামাল উদ্দিন	jamal.uddin@cellosco.pe	01914012488	2612980852531	/opt/soft/hoothut/files/customer/photo/customer-photo-584615f2-3db3-4189-91c3-7b20829d8ec2.jpg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-584615f2-3db3-4189-91c3-7b20829d8ec2.jpg	no	Active
20211123082314100-qukhDByazTYUcLuN	HOOTHUT-REG-00000014	01703777773	Md. Kamal Pervez	মোঃ কামাল পারভেজ	parvez.kamal@doer.com.bd	01703777773	4176467613	/opt/soft/hoothut/files/customer/photo/customer-photo-2f15d545-8c00-4c45-b7db-c55c73b96532.png	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/customer/photo/customer-photo-2f15d545-8c00-4c45-b7db-c55c73b96532.png	no	Active
20211123082314100-qacLuNYukyUhDBzT	HOOTHUT-REG-00000015	01750965768	Md. Shamiul Islam	মোঃ শামিউল ইসলাম	samiul.islam@doer.com.bd	01750965768	\N	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082314100-qzTukyacLuNBYUhD	HOOTHUT-REG-00000016	01677700324	Mohammad Abul Hasnat	মোহাম্মদ আবুল হাসনাত	abul.hasnat@doer.com.bd	01677700324	\N	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082314100-quYUkyacBzTLuNhD	HOOTHUT-REG-00000017	01732678737	Md Nahid Uj Jaman	মোঃ নাহিদ উজ জামান	nahid.jaman@doer.com.bd	01732678737	\N	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082313669-LfpwsMdbMTTRCQJS	HOOTHUT-REG-00000018	jashim	Jashim Uddin	জসিম উদ্দিন	jashim.uddin@doer.com.bd	01963845470	1957728551	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
20211123082314100-qukuDJZcNLByahzD	HOOTHUT-REG-00000019	faisal	Faisal Ahmed	ফয়সাল আহমেদ	faisal.anik@doer.com.bd	01632736769	\N	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	no	Active
\.


--
-- Data for Name: sms_log; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.sms_log (oid, request_id, application_tracking_id, policy_no, reference_no, trans_type, mobile_no, sms, send_date, trace_id, request_receive_time, provider_request_time, provider_response_time, sms_count, remarks, sms_status, created_by, created_on, updated_on, updated_by) FROM stdin;
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.student (oid, login_id, student_id, application_tracking_id, institute_oid, institute_session_oid, institute_class_oid, institute_class_section_oid, roll_number, institute_class_group_oid, institute_shift_oid, institute_version_oid, education_curriculum_oid, name_en, name_bn, date_of_birth, email, mobile_no, gender, religion, nationality, blood_group, father_name_en, father_name_bn, father_occupation, father_contact_number, father_email, mother_name_en, mother_name_bn, mother_occupation, mother_contact_number, mother_email, emergency_contact_person, emergency_contact_no, present_address_json, permanent_address_json, photo_path, photo_url, status, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Institute-Student-0000	student	STUDENT-000000	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	0	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Student	ছাত্র	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Sadek Hasan	সাদেক হাসান	Service Holder	01915111222	sadek_hasan@gmail.com	Jasmin Begum	জেসমিন বেগম	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0001	kazi_riyad	STUDENT-000001	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Kazi Riyad	কাজী রিয়াদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Sadek Hasan	সাদেক হাসান	Service Holder	01915111222	sadek_hasan@gmail.com	Jasmin Begum	জেসমিন বেগম	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0002	ahnaf_ahmed	STUDENT-000002	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Ahnaf Ahmed	আহনাফ আহমেদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Nahid Uzz Jaman	নাহিদ উজ জামান	Service Holder	01915111222	nahid_uzz_jaman@gmail.com	Fatema khatun	ফাতেমা খাতুন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0003	md._kamal_parvez	STUDENT-000003	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Md. Kamal Parvez	মোঃ কামাল পারভেজ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Shazzad Hossain	শাহজাদ হোসেন	Service Holder	01915111222	shazzad_hossain@gmail.com	Sahana Hossain	সাহানা হোসেন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0004	fahadul_islam	STUDENT-000004	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Fahadul Islam	ফাহাদুল ইসলাম	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Abdul Khalek	আব্দুল খালেক	Service Holder	01915111222	abdul_khalek@gmail.com	Khadiza Khanam	খাদিজা খানম	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0005	mohaiminul_ahmed	STUDENT-000005	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Mohaiminul Ahmed	মোহাইমিনুল আহমেদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Alam Saddam	আলম সাদ্দাম	Service Holder	01915111222	alam_saddam@gmail.com	Ishita Marjia	ঈশিতা মারজিয়া	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0006	md._shamiul_islam	STUDENT-000006	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Md. Shamiul Islam	মোঃ শামিউল ইসলাম	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Mizan Riyadh	মিজান রিয়াদ	Service Holder	01915111222	mizan_riyadh@gmail.com	Afsana Sharmin	আফসানা শারমিন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0007	mohammad_fardin	STUDENT-000007	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Mohammad Fardin	মোহাম্মদ ফারদিন	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Haq Mizanur	হক মিজানুর	Service Holder	01915111222	haq_mizanur@gmail.com	Sheikh Akhi	শেখ আখি	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0008	imtiaz_riyadh	STUDENT-000008	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Imtiaz Riyadh	ইমতিয়াজ রিয়াদ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Mizan Tariqul	মিজান তারিকুল	Service Holder	01915111222	mizan_tariqul@gmail.com	Basri Farzana	বসরী ফারজানা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0009	sahidur_rahman	STUDENT-000009	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Sahidur Rahman	সহিদুর রহমান	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Raihan Parvez	রায়হান পারভেজ	Service Holder	01915111222	raihan_parvez@gmail.com	Ishita Subarna	ঈশিতা সূবর্ণা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0010	shahnawaz_karim	STUDENT-000010	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Shahnawaz Karim	শাহনেওয়াজ করিম	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Abdul Masood	আব্দুল মাসুদ	Service Holder	01915111222	abdul_masood@gmail.com	Samchun Nahar	সামছুন নাহার 	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0011	kobir_khan	STUDENT-000011	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Kobir khan	কবির খান	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Karim Russell	করিম রাসেল	Service Holder	01915111222	karim_russell@gmail.com	Parveen Rumana	পারভীন রুমানা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0012	sayed_akash	STUDENT-000012	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Sayed Akash	সাইদ আকাশ	2010-05-04	kaziriyad@gmail.com	01915101010	Male	Islam	Bangladeshi	B+	Sadeq Sirajul	সাদেক সিরাজুল	Service Holder	01915111222	sadeq_sirajul@gmail.com	Sultana Tanzina	সুলতানা তানজিনা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0013	tisha_mim	STUDENT-000013	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Tisha Mim	তিশা মিমি	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Kazi Atiqur	কাজী আতিকুর	Service Holder	01915111222	kazi_atiqur@gmail.com	Afsana Rahman	আফসানা রহমান 	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0014	siddika_jannatul	STUDENT-000014	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Siddika Jannatul	সিদ্দিকা জান্নাতুল	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Anvir Mostafa	আনভীর মোস্তফা	Service Holder	01915111222	anvir_mostafa@gmail.com	Rima Happy	রিমা হ্যাপি	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0015	hamid_maryam	STUDENT-000015	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Maryam	হামিদ মরিয়ম	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Rana Rezaul	রানা রেজাউল	Service Holder	01915111222	rana_rezaul@gmail.com	Afri Mahmuda	আফ্রি মাহমুদা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0016	anika_tanzina	STUDENT-000016	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Anika Tanzina	আনিকা তানজিনা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Hassan Saddam	হাসান সাদ্দাম	Service Holder	01915111222	hassan_saddam@gmail.com	Hamid Afroza	হামিদ আফরোজা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0017	islam_is_happy	STUDENT-000017	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Islam is happy	ইসলাম হ্যাপি	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Musharraf Amin	মোশাররফ আমিন	Service Holder	01915111222	musharraf_amin@gmail.com	Siddika Irene	সিদ্দিকা আইরিন	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0018	afsana_subarna	STUDENT-000018	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Afsana Subarna	আফসানা সূবর্ণা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Tahsin Atiqur	তাহসিন আতিকুর	Service Holder	01915111222	tahsin_atiqur@gmail.com	Begum Monira	বেগম মনিরা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0019	hamid_rabia	STUDENT-000019	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Rabia	হামিদ রাবেয়া	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Mizan Malek	মিজান মালেক	Service Holder	01915111222	mizan_malek@gmail.com	Maria Sanjida	মারিয়া সানজিদা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0020	hamid_bristy	STUDENT-000020	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Bristy	হামিদ বৃষ্টি	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Rabbi Anvir	আনভীর রাব্বি	Service Holder	01915111222	rabbi_anvir@gmail.com	Mim Anwara	মিম আনোয়ারা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0021	mukta_sanjida	STUDENT-000021	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Mukta Sanjida	মুক্তা সানজিদা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Kamal Tanvir	কামাল তানভীর	Service Holder	01915111222	kamal_tanvir@gmail.com	Sirajum Marjia	সিরাজুম মারজিয়া	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0022	ishita_shiuli	STUDENT-000022	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Ishita Shiuli	ঈশিতা শিউলী	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Rana Russell	রানা রাসেল	Service Holder	01915111222	rana_russell@gmail.com	Hani Shahnaz	হানি শাহানাজ	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0023	ferdous_taslima	STUDENT-000023	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Ferdous Taslima	ফেরদৌস তাসলিমা	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Jahangir Alam	জাহাঙ্গীর আলম 	Service Holder	01915111222	jahangir_alam@gmail.com	Parveen Rumana	পারভীন রুমানা	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
SCHOOL-ERP-Institute-Student-0024	hamid_kulchum	STUDENT-000024	\N	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Hamid Kulchum	হামিদ কুলছুম	2010-05-04	kaziriyad@gmail.com	01915101010	Female	Islam	Bangladeshi	B+	Babu Tariqul	বাবু তারিকুল	Service Holder	01915111222	babu_tariqul@gmail.com	Parveen Tanzina	পারভীন তানজিনা 	House Wife	01915222333	jasmin_begum@gmail.com	Md. Abdul Jabbar	01711223344	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	/opt/soft/hoothut/files/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	https://hoothut.celloscope.net/beemabox/common/base/v1/file-download/tem/photo/tem-photo-27c99ffd-ad95-463f-b242-8fbcb8904cdf.jpeg	Active	dbadmin	2022-06-23 13:13:16.617764	\N	\N
\.


--
-- Data for Name: student_attendance; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.student_attendance (oid, attendance_date, institute_oid, institute_session_oid, institute_class_oid, institute_class_section_oid, institute_class_group_oid, institute_shift_oid, institute_version_oid, teacher_oid, class_textbook_oid, class_period_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-student-attendance-oid-0001	2022-05-31	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	schoolerp-teacher-oid-0001	SCHOOL-ERP-Institute-Text-Book-0067	schoolerp-shift-morning-class-perion-01	dbadmin	2022-06-23 13:13:17.284268	\N	\N
schoolerp-student-attendance-oid-0002	2022-05-31	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	schoolerp-teacher-oid-0002	SCHOOL-ERP-Institute-Text-Book-0068	schoolerp-shift-morning-class-perion-02	dbadmin	2022-06-23 13:13:17.284268	\N	\N
schoolerp-student-attendance-oid-0003	2022-05-31	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	schoolerp-teacher-oid-0003	SCHOOL-ERP-Institute-Text-Book-0069	schoolerp-shift-morning-class-perion-03	dbadmin	2022-06-23 13:13:17.284268	\N	\N
schoolerp-student-attendance-oid-0004	2022-05-31	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	schoolerp-teacher-oid-0004	SCHOOL-ERP-Institute-Text-Book-0070	schoolerp-shift-morning-class-perion-04	dbadmin	2022-06-23 13:13:17.284268	\N	\N
schoolerp-student-attendance-oid-0005	2022-05-31	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	schoolerp-teacher-oid-0005	SCHOOL-ERP-Institute-Text-Book-0071	schoolerp-shift-morning-class-perion-05	dbadmin	2022-06-23 13:13:17.284268	\N	\N
schoolerp-student-attendance-oid-0006	2022-05-31	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	schoolerp-teacher-oid-0006	SCHOOL-ERP-Institute-Text-Book-0072	schoolerp-shift-morning-class-perion-06	dbadmin	2022-06-23 13:13:17.284268	\N	\N
\.


--
-- Data for Name: student_attendance_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.student_attendance_detail (oid, student_id, student_oid, student_attendance_oid, status, created_by, created_on) FROM stdin;
schoolerp-student-attendance-details-oid-0001	STUDENT-000001	SCHOOL-ERP-Institute-Student-0001	schoolerp-student-attendance-oid-0001	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0002	STUDENT-000002	SCHOOL-ERP-Institute-Student-0002	schoolerp-student-attendance-oid-0001	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0003	STUDENT-000003	SCHOOL-ERP-Institute-Student-0003	schoolerp-student-attendance-oid-0001	Absent	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0004	STUDENT-000004	SCHOOL-ERP-Institute-Student-0004	schoolerp-student-attendance-oid-0001	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0005	STUDENT-000005	SCHOOL-ERP-Institute-Student-0005	schoolerp-student-attendance-oid-0001	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0006	STUDENT-000001	SCHOOL-ERP-Institute-Student-0001	schoolerp-student-attendance-oid-0002	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0007	STUDENT-000002	SCHOOL-ERP-Institute-Student-0002	schoolerp-student-attendance-oid-0002	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0008	STUDENT-000003	SCHOOL-ERP-Institute-Student-0003	schoolerp-student-attendance-oid-0002	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0009	STUDENT-000004	SCHOOL-ERP-Institute-Student-0004	schoolerp-student-attendance-oid-0002	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0010	STUDENT-000005	SCHOOL-ERP-Institute-Student-0005	schoolerp-student-attendance-oid-0002	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0011	STUDENT-000001	SCHOOL-ERP-Institute-Student-0001	schoolerp-student-attendance-oid-0003	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0012	STUDENT-000002	SCHOOL-ERP-Institute-Student-0002	schoolerp-student-attendance-oid-0003	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0013	STUDENT-000003	SCHOOL-ERP-Institute-Student-0003	schoolerp-student-attendance-oid-0003	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0014	STUDENT-000004	SCHOOL-ERP-Institute-Student-0004	schoolerp-student-attendance-oid-0003	Absent	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0015	STUDENT-000005	SCHOOL-ERP-Institute-Student-0005	schoolerp-student-attendance-oid-0003	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0016	STUDENT-000001	SCHOOL-ERP-Institute-Student-0001	schoolerp-student-attendance-oid-0004	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0017	STUDENT-000002	SCHOOL-ERP-Institute-Student-0002	schoolerp-student-attendance-oid-0004	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0018	STUDENT-000003	SCHOOL-ERP-Institute-Student-0003	schoolerp-student-attendance-oid-0004	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0019	STUDENT-000004	SCHOOL-ERP-Institute-Student-0004	schoolerp-student-attendance-oid-0004	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0020	STUDENT-000005	SCHOOL-ERP-Institute-Student-0005	schoolerp-student-attendance-oid-0004	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0021	STUDENT-000001	SCHOOL-ERP-Institute-Student-0001	schoolerp-student-attendance-oid-0005	Absent	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0022	STUDENT-000002	SCHOOL-ERP-Institute-Student-0002	schoolerp-student-attendance-oid-0005	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0023	STUDENT-000003	SCHOOL-ERP-Institute-Student-0003	schoolerp-student-attendance-oid-0005	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0024	STUDENT-000004	SCHOOL-ERP-Institute-Student-0004	schoolerp-student-attendance-oid-0005	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0025	STUDENT-000005	SCHOOL-ERP-Institute-Student-0005	schoolerp-student-attendance-oid-0005	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0026	STUDENT-000001	SCHOOL-ERP-Institute-Student-0001	schoolerp-student-attendance-oid-0006	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0027	STUDENT-000002	SCHOOL-ERP-Institute-Student-0002	schoolerp-student-attendance-oid-0006	Absent	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0028	STUDENT-000003	SCHOOL-ERP-Institute-Student-0003	schoolerp-student-attendance-oid-0006	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0029	STUDENT-000004	SCHOOL-ERP-Institute-Student-0004	schoolerp-student-attendance-oid-0006	Present	dbadmin	2022-06-23 13:13:17.299725
schoolerp-student-attendance-details-oid-0030	STUDENT-000005	SCHOOL-ERP-Institute-Student-0005	schoolerp-student-attendance-oid-0006	Present	dbadmin	2022-06-23 13:13:17.299725
\.


--
-- Data for Name: student_class_detail; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.student_class_detail (oid, student_id, institute_oid, institute_session_oid, institute_class_oid, institute_class_section_oid, roll_number, institute_class_group_oid, institute_shift_oid, institute_version_oid, education_curriculum_oid, status, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Institute-Student-Class-Detail-0001	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Active	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0002	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Active	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0003	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Active	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0004	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Active	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0005	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0006	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0007	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0008	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0009	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0010	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0011	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-Bangla-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0012	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-English-Version-Section-Jaba	1	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0013	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0014	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Morning-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0015	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0016	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-6	Institute-Class-6-Shift-Evening-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0017	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0018	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Morning-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0019	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0020	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-7	Institute-Class-7-Shift-Evening-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0021	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0022	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Morning-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Morning	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0023	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-Bangla-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-Bangla-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
SCHOOL-ERP-Institute-Student-Class-Detail-0024	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Session-2022	SCHOOL-ERP-Institute-Class-8	Institute-Class-8-Shift-Evening-English-Version-Section-Jaba	2	\N	SCHOOL-ERP-Institute-Shift-Evening	SCHOOL-ERP-Institute-English-Version	SCHOOL-ERP-Education-Curriculum-0001	Running	dbadmin	2022-06-23 13:13:16.659809	\N	\N
\.


--
-- Data for Name: student_textbook; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.student_textbook (oid, student_id, institute_oid, institute_class_oid, institute_class_textbook_oid, institute_session_oid, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP-Institute-Student-Textbook-0001	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0067	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0002	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0068	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0003	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0069	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0004	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0070	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0005	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0072	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0006	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0074	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0007	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0076	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0008	STUDENT-000000	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0077	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0009	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0067	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0010	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0068	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0011	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0069	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0012	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0070	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0013	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0072	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0014	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0074	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0015	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0076	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0016	STUDENT-000001	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0077	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0017	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0090	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0018	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0091	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0019	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0092	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0020	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0093	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0021	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0095	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0022	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0097	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0023	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0099	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0024	STUDENT-000002	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0100	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0025	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0067	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0026	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0068	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0027	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0069	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0028	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0070	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0029	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0072	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0030	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0074	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0031	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0076	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0032	STUDENT-000003	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0077	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0033	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0090	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0034	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0091	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0035	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0092	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0036	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0093	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0037	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0095	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0038	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0097	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0039	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0099	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0040	STUDENT-000004	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0100	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0041	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0113	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0042	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0114	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0043	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0115	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0044	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0116	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0045	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0117	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0046	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0118	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0047	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0119	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0048	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0121	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0049	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0122	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0050	STUDENT-000005	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0123	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0051	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0136	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0052	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0137	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0053	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0138	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0054	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0139	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0055	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0140	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0056	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0141	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0057	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0142	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0058	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0144	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0059	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0145	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0060	STUDENT-000006	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0146	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0061	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0113	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0062	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0114	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0063	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0115	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0064	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0116	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0065	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0117	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0066	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0118	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0067	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0119	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0068	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0121	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0069	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0122	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0070	STUDENT-000007	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0123	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0071	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0136	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0072	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0159	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0073	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0160	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0074	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0164	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0075	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0167	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0076	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0170	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0077	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0171	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0078	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0172	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0079	STUDENT-000009	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0176	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0080	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0181	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0081	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0182	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0082	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0186	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0083	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0189	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0084	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0192	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0085	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0193	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0086	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0194	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0087	STUDENT-000010	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0198	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0088	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0159	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0089	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0160	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0090	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0164	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0091	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0167	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0092	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0170	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0093	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0171	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0094	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0172	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0095	STUDENT-000011	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0176	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0096	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0181	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0097	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0067	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0098	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0068	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0099	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0069	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0100	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0070	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0101	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0072	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0102	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0074	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0103	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0076	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0104	STUDENT-000013	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0077	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0105	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0090	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0106	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0091	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0107	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0092	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0108	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0093	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0109	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0095	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0110	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0097	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0111	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0099	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0112	STUDENT-000014	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0100	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0113	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0067	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0114	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0068	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0115	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0069	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0116	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0070	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0117	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0072	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0118	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0074	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0119	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0076	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0120	STUDENT-000015	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0077	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0121	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0090	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0122	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0091	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0123	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0092	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0124	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0093	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0125	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0095	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0126	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0097	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0127	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0099	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0128	STUDENT-000016	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-6	SCHOOL-ERP-Institute-Text-Book-0100	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0129	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0137	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0130	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0138	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0131	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0139	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0132	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0140	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0133	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0141	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0134	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0142	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0135	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0144	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0136	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0145	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0137	STUDENT-000008	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0146	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0138	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0113	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0139	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0114	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0140	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0115	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0141	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0116	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0142	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0117	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0143	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0118	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0144	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0119	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0145	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0121	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0146	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0122	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0147	STUDENT-000017	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0123	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0148	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0136	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0149	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0137	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0150	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0138	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0151	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0139	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0152	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0140	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0153	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0141	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0154	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0142	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0155	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0144	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0156	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0145	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0157	STUDENT-000018	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0146	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0158	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0113	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0159	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0114	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0160	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0115	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0161	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0116	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0162	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0117	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0163	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0118	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0164	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0119	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0165	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0121	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0166	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0122	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0167	STUDENT-000019	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0123	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0168	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0136	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0169	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0137	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0170	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0138	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0171	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0139	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0172	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0140	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0173	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0141	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0174	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0142	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0175	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0144	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0176	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0145	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0177	STUDENT-000020	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-7	SCHOOL-ERP-Institute-Text-Book-0146	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0178	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0182	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0179	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0186	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0180	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0189	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0181	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0192	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0182	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0193	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0183	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0194	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0184	STUDENT-000012	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0198	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0185	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0159	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0186	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0160	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0187	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0164	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0188	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0167	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0189	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0170	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0190	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0171	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0191	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0172	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0192	STUDENT-000021	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0176	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0193	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0181	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0194	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0182	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0195	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0186	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0196	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0189	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0197	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0192	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0198	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0193	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0199	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0194	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0200	STUDENT-000022	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0198	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0201	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0159	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0202	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0160	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0203	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0164	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0204	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0167	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0205	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0170	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0206	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0171	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0207	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0172	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0208	STUDENT-000023	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0176	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0209	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0181	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0210	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0182	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0211	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0186	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0212	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0189	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0213	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0192	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0214	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0193	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0215	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0194	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
SCHOOL-ERP-Institute-Student-Textbook-0216	STUDENT-000024	SCHOOL-ERP-Demo-School-001	SCHOOL-ERP-Institute-Class-8	SCHOOL-ERP-Institute-Text-Book-0198	SCHOOL-ERP-Institute-Session-2022	System	2022-06-23 13:13:16.69943	\N	\N
\.


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.teacher (oid, login_id, teacher_id, institute_oid, name_en, name_bn, date_of_birth, email, mobile_no, gender, religion, nationality, blood_group, educational_qualification, father_name_en, father_name_bn, father_occupation, father_contact_number, father_email, mother_name_en, mother_name_bn, mother_occupation, mother_contact_number, mother_email, emergency_contact_person, emergency_contact_no, present_address_json, permanent_address_json, photo_path, photo_url, status, created_by, created_on, updated_by, updated_on) FROM stdin;
schoolerp-teacher-oid-0000	teacher	T-20220101000	SCHOOL-ERP-Demo-School-001	Teacher	শিক্ষক	1980-05-05	sabbir@gmail.com	01700000001	Male	Islam	Bangladeshi	B+	Master's	Shourav	সৌরভ	Farmar	01800000001	shourav@gmail.com	Sumi	সুমি	House Wife	01900000001	sumi@gmail.com	01300000001	01400000001	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0001	sabbir	T-20220101001	SCHOOL-ERP-Demo-School-001	Sabbir	সাব্বির	1980-05-05	sabbir@gmail.com	01700000001	Male	Islam	Bangladeshi	B+	Master's	Shourav	সৌরভ	Farmar	01800000001	shourav@gmail.com	Sumi	সুমি	House Wife	01900000001	sumi@gmail.com	01300000001	01400000001	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0002	abir	T-20220101002	SCHOOL-ERP-Demo-School-001	Abir	আবির	1980-05-06	abir@gmail.com	01700000002	Male	Islam	Bangladeshi	A+	Higher Secondary	Faysal	ফায়সাল	Doctor	01800000002	faysal@@gmail.com	Nodi	নদী	Nurse	01900000002	nodi@gmail.com	01300000002	01400000002	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0003	fahim	T-20220101003	SCHOOL-ERP-Demo-School-001	Fahim	ফাহিম	1980-05-07	fahim@gmail.com	01700000003	Male	Islam	Bangladeshi	A+	Master's	Taharul	তাহারুল	Daily labor	01800000003	taharul@gmail.com	Meghla	মেঘলা	House Wife	01900000003	meghla@gmail.com	01300000003	01400000003	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0004	rafi	T-20220101004	SCHOOL-ERP-Demo-School-001	Rafi	রাফি	1980-05-08	rafi@gmail.com	01700000004	Male	Islam	Bangladeshi	O+	Diploma in Engineering	Nayem	নাঈম	Engineer	01800000004	nayem@gmail.com	Jhorna	ঝর্না	Daily Labor	01900000004	jhorna@gmail.com	01300000004	01400000004	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0005	siam	T-20220101005	SCHOOL-ERP-Demo-School-001	Siam	সিয়াম	1980-05-09	siam@gmail.com	01700000005	Male	Islam	Bangladeshi	B+	Kamil	Nafis	নাফিস	Engineer	01800000005	nafis@gmail.com	Aysha	আয়েশা	House Wife	01900000005	ayesha@gmail.com	01300000005	01400000005	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0006	amit	T-20220101006	SCHOOL-ERP-Demo-School-001	Amit	অমিত	1980-05-10	amit@gmail.com	01700000006	Male	Islam	Bangladeshi	A+	Higher Secondary	Rifat	রিফাত	Daily labor	01800000006	rifat@gmail.com	sadia	সাদিয়া	House Wife	01900000006	sadia@gmail.com	01300000006	01400000006	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0007	farhan	T-20220101007	SCHOOL-ERP-Demo-School-001	Farhan	ফারহান	1980-05-11	farhan@gmail.com	01700000007	Male	Islam	Bangladeshi	O+	Master's	Fahim	ফাহিম	Business	01800000007	fahim@gmail.com	Eshita	ঈশিতা	Nurse	01900000007	eshita@gmail.com	01300000007	01400000007	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0008	tasfin	T-20220101008	SCHOOL-ERP-Demo-School-001	Tasfin	তাসফিন	1980-05-12	tasfin@gmail.com	01700000008	Male	Islam	Bangladeshi	O+	Higher Secondary	Rafi	রাফি	Engineer	01800000008	rafi@gmail.com	Surovi	সুরভি	House Wife	01900000008	surovi@gmail.com	01300000008	01400000008	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0009	shourav	T-20220101009	SCHOOL-ERP-Demo-School-001	Shourav	সৌরভ	1980-05-13	shourav@gmail.com	01700000009	Male	Islam	Bangladeshi	B+	Diploma in Engineering	Siam	সিয়াম	Business	01800000009	siam@gmail.com	Barsha	বর্ষা	House Wife	01900000009	barsha@gmail.com	01300000009	01400000009	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0010	faysal	T-20220101010	SCHOOL-ERP-Demo-School-001	Faysal	ফায়সাল	1980-05-14	faysal@gmail.com	01700000010	Male	Islam	Bangladeshi	B-	Kamil	Anik	অনীক	Farmar	01800000010	anik@gmail.com	Laboni	লাবণী	Daily Labor	01900000010	laboni@gmail.com	01300000010	01400000010	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0011	taharul	T-20220101011	SCHOOL-ERP-Demo-School-001	Taharul	তাহারুল	1980-05-15	taharul@gmail.com	01700000011	Male	Islam	Bangladeshi	A+	Higher Secondary	Farhan	ফারহান	Doctor	01800000011	farhan@gmail.com	Jemi	জেমি	House Wife	01900000011	jemo@gmail.com	01300000011	01400000011	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0012	nayem	T-20220101012	SCHOOL-ERP-Demo-School-001	Nayem	নাঈম	1980-05-16	nayme@gmail.com	01700000012	Male	Islam	Bangladeshi	B+	Diploma in Engineering	Tasfin	তাসফিন	Business	01800000012	tasfin@gmail.com	Jui	জুঁই	Nurse	01900000012	jui@gmail.com	01300000012	01400000012	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0013	nafis	T-20220101013	SCHOOL-ERP-Demo-School-001	Nafis	নাফিস	1980-05-17	nafis@gmail.com	01700000013	Male	Islam	Bangladeshi	O-	Master's	Sabbir	সাব্বির	Daily labor	01800000013	sabbir@gmail.com	Rasheda	রাশেদা	House Wife	01900000013	rasheda@gmail.com	01300000013	01400000013	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0014	rifat	T-20220101014	SCHOOL-ERP-Demo-School-001	Rifat	রিফাত	1980-05-18	rifat@gmail.com	01700000014	Male	Islam	Bangladeshi	B-	Master's	Abir	আবির	Engineer	01800000014	abir@gmail.com	Farhana	ফারহানা	House Wife	01900000014	farhana@gmail.com	01300000014	01400000014	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0015	rakibul	T-20220101015	SCHOOL-ERP-Demo-School-001	Rakibul	রাকিবুল	1980-05-19	rakibul@gmail.com	01700000015	Male	Islam	Bangladeshi	AB+	Kamil	Fahim	ফাহিম	Daily labor	01800000015	fahim@gmail.com	Bizly	বিজলী	House Wife	01900000015	bizly@gmail.com	01300000015	01400000015	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0016	aysha	T-20220101016	SCHOOL-ERP-Demo-School-001	Aysha	আয়েশা	1980-05-20	ayesha@gmail.com	01700000016	Female	Islam	Bangladeshi	B+	Diploma in Engineering	Rafi	রাফি	Daily labor	01800000016	rafi@gmail.com	Tithi	তিথি	Nurse	01900000016	tithi@gmail.com	01300000016	01400000016	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0017	sadia	T-20220101017	SCHOOL-ERP-Demo-School-001	sadia	সাদিয়া	1980-05-21	sadia@gmail.com	01700000017	Female	Islam	Bangladeshi	B+	Higher Secondary	Siam	সিয়াম	Daily labor	01800000017	siam@gmail.com	Shakila	শাকিলা	House Wife	01900000017	shakila@gmail.com	01300000017	01400000017	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0018	eshita	T-20220101018	SCHOOL-ERP-Demo-School-001	Eshita	ঈশিতা	1980-05-22	eshita@gmail.com	01700000018	Female	Islam	Bangladeshi	A+	Master's	Anik	অনীক	Engineer	01800000018	anik@gmail.com	Sompa	সোম্পা	House Wife	01900000018	sompa@gmail.com	01300000018	01400000018	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0019	surovi	T-20220101019	SCHOOL-ERP-Demo-School-001	Surovi	সুরভি	1980-05-23	surovi@gmail.com	01700000019	Female	Islam	Bangladeshi	B+	Master's	Farhan	ফারহান	Doctor	01800000019	farhan@gmail.com	Moriyom	মরিয়ম	Daily Labor	01900000019	moriyom@gmail.com	01300000019	01400000019	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
schoolerp-teacher-oid-0020	barsha	T-20220101020	SCHOOL-ERP-Demo-School-001	Barsha	বর্ষা	1980-05-24	barsha@gmail.com	01700000020	Female	Islam	Bangladeshi	O+	Higher Secondary	Tasfin	তাসফিন	Farmar	01800000020	tasfin@gmail.com	Mousumi	মৌসুমী	House Wife	01900000020	mousumi@gmail.com	01300000020	01400000020	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	{"careOf":"Md. Abdul Haque","houseNo":"87","roadNo":"32","villageOrWord":"","postOffice":"Jhigatola","postcode":"1209","thana":"Dhaka","thanaOid":"Dhaka","district":"Dhaka","districtOid":"SCHOOL-ERP-Dhaka"}	\N	\N	Active	dbadmin	2022-06-23 13:13:16.891779	\N	\N
\.


--
-- Data for Name: week_day; Type: TABLE DATA; Schema: schoolerp; Owner: dbadmin
--

COPY schoolerp.week_day (oid, institute_oid, name_en, name_bn, sort_order, status, created_by, created_on, updated_by, updated_on) FROM stdin;
SCHOOL-ERP--week-day-name-Saturday	SCHOOL-ERP-Demo-School-001	Saturday	শনিবার	1	Active	System	2022-06-23 13:13:16.452771	\N	\N
SCHOOL-ERP--week-day-name-Sunday	SCHOOL-ERP-Demo-School-001	Sunday	রবিবার	2	Active	System	2022-06-23 13:13:16.452771	\N	\N
SCHOOL-ERP--week-day-name-Monday	SCHOOL-ERP-Demo-School-001	Monday	সোমবার	3	Active	System	2022-06-23 13:13:16.452771	\N	\N
SCHOOL-ERP--week-day-name-Tuesday	SCHOOL-ERP-Demo-School-001	Tuesday	মঙ্গলবার	4	Active	System	2022-06-23 13:13:16.452771	\N	\N
SCHOOL-ERP--week-day-name-Wednesday	SCHOOL-ERP-Demo-School-001	Wednesday	বুধবার	5	Active	System	2022-06-23 13:13:16.452771	\N	\N
SCHOOL-ERP--week-day-name-Thursday	SCHOOL-ERP-Demo-School-001	Thursday	বৃহস্পতিবার	6	Active	System	2022-06-23 13:13:16.452771	\N	\N
SCHOOL-ERP--week-day-name-Friday	SCHOOL-ERP-Demo-School-001	Friday	শুক্রবার	7	Inactive	System	2022-06-23 13:13:16.452771	\N	\N
\.


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: class_period pk_class_period; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_period
    ADD CONSTRAINT pk_class_period PRIMARY KEY (oid);


--
-- Name: class_routine pk_class_routine; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT pk_class_routine PRIMARY KEY (oid);


--
-- Name: class_routine_detail pk_class_routine_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine_detail
    ADD CONSTRAINT pk_class_routine_detail PRIMARY KEY (oid);


--
-- Name: country pk_country; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.country
    ADD CONSTRAINT pk_country PRIMARY KEY (oid);


--
-- Name: district pk_district; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.district
    ADD CONSTRAINT pk_district PRIMARY KEY (oid);


--
-- Name: division pk_division; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.division
    ADD CONSTRAINT pk_division PRIMARY KEY (oid);


--
-- Name: due_fees pk_due_fees; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees
    ADD CONSTRAINT pk_due_fees PRIMARY KEY (oid);


--
-- Name: due_fees_history pk_due_fees_history; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees_history
    ADD CONSTRAINT pk_due_fees_history PRIMARY KEY (oid);


--
-- Name: education_board pk_education_board; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_board
    ADD CONSTRAINT pk_education_board PRIMARY KEY (oid);


--
-- Name: education_class pk_education_class; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_class
    ADD CONSTRAINT pk_education_class PRIMARY KEY (oid);


--
-- Name: education_class_level pk_education_class_level; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_class_level
    ADD CONSTRAINT pk_education_class_level PRIMARY KEY (oid);


--
-- Name: education_curriculum pk_education_curriculum; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_curriculum
    ADD CONSTRAINT pk_education_curriculum PRIMARY KEY (oid);


--
-- Name: education_grading_system pk_education_grading_system; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_grading_system
    ADD CONSTRAINT pk_education_grading_system PRIMARY KEY (oid);


--
-- Name: education_grading_system_detail pk_education_grading_system_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_grading_system_detail
    ADD CONSTRAINT pk_education_grading_system_detail PRIMARY KEY (oid);


--
-- Name: education_group pk_education_group; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_group
    ADD CONSTRAINT pk_education_group PRIMARY KEY (oid);


--
-- Name: education_medium pk_education_medium; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_medium
    ADD CONSTRAINT pk_education_medium PRIMARY KEY (oid);


--
-- Name: education_session pk_education_session; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_session
    ADD CONSTRAINT pk_education_session PRIMARY KEY (oid);


--
-- Name: education_shift pk_education_shift; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_shift
    ADD CONSTRAINT pk_education_shift PRIMARY KEY (oid);


--
-- Name: education_system pk_education_system; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_system
    ADD CONSTRAINT pk_education_system PRIMARY KEY (oid);


--
-- Name: education_textbook pk_education_textbook; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_textbook
    ADD CONSTRAINT pk_education_textbook PRIMARY KEY (oid);


--
-- Name: education_type pk_education_type; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_type
    ADD CONSTRAINT pk_education_type PRIMARY KEY (oid);


--
-- Name: education_version pk_education_version; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_version
    ADD CONSTRAINT pk_education_version PRIMARY KEY (oid);


--
-- Name: exam pk_exam; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam
    ADD CONSTRAINT pk_exam PRIMARY KEY (oid);


--
-- Name: exam_class pk_exam_class; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_class
    ADD CONSTRAINT pk_exam_class PRIMARY KEY (oid);


--
-- Name: exam_result pk_exam_result; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result
    ADD CONSTRAINT pk_exam_result PRIMARY KEY (oid);


--
-- Name: exam_result_detail pk_exam_result_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT pk_exam_result_detail PRIMARY KEY (oid);


--
-- Name: exam_result_marks pk_exam_result_marks; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_marks
    ADD CONSTRAINT pk_exam_result_marks PRIMARY KEY (oid);


--
-- Name: exam_routine pk_exam_routine; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_routine
    ADD CONSTRAINT pk_exam_routine PRIMARY KEY (oid);


--
-- Name: exam_time pk_exam_time; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_time
    ADD CONSTRAINT pk_exam_time PRIMARY KEY (oid);


--
-- Name: fee_head pk_fee_head; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fee_head
    ADD CONSTRAINT pk_fee_head PRIMARY KEY (oid);


--
-- Name: fees_collection pk_fees_collection; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_collection
    ADD CONSTRAINT pk_fees_collection PRIMARY KEY (oid);


--
-- Name: fees_collection_detail pk_fees_collection_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_collection_detail
    ADD CONSTRAINT pk_fees_collection_detail PRIMARY KEY (oid);


--
-- Name: fees_setting pk_fees_setting; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_setting
    ADD CONSTRAINT pk_fees_setting PRIMARY KEY (oid);


--
-- Name: file_detail pk_file_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.file_detail
    ADD CONSTRAINT pk_file_detail PRIMARY KEY (oid);


--
-- Name: guardian pk_guardian; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.guardian
    ADD CONSTRAINT pk_guardian PRIMARY KEY (oid);


--
-- Name: guardian_student pk_guardian_student; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.guardian_student
    ADD CONSTRAINT pk_guardian_student PRIMARY KEY (oid);


--
-- Name: institute pk_institute; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute
    ADD CONSTRAINT pk_institute PRIMARY KEY (oid);


--
-- Name: institute_admission pk_institute_admission; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT pk_institute_admission PRIMARY KEY (oid);


--
-- Name: institute_class pk_institute_class; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class
    ADD CONSTRAINT pk_institute_class PRIMARY KEY (oid);


--
-- Name: institute_class_group pk_institute_class_group; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_group
    ADD CONSTRAINT pk_institute_class_group PRIMARY KEY (oid);


--
-- Name: institute_class_level pk_institute_class_level; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_level
    ADD CONSTRAINT pk_institute_class_level PRIMARY KEY (oid);


--
-- Name: institute_class_section pk_institute_class_section; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_section
    ADD CONSTRAINT pk_institute_class_section PRIMARY KEY (oid);


--
-- Name: institute_class_textbook pk_institute_class_textbook; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_textbook
    ADD CONSTRAINT pk_institute_class_textbook PRIMARY KEY (oid);


--
-- Name: institute_grading_system pk_institute_grading_system; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_grading_system
    ADD CONSTRAINT pk_institute_grading_system PRIMARY KEY (oid);


--
-- Name: institute_grading_system_detail pk_institute_grading_system_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_grading_system_detail
    ADD CONSTRAINT pk_institute_grading_system_detail PRIMARY KEY (oid);


--
-- Name: institute_session pk_institute_session; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_session
    ADD CONSTRAINT pk_institute_session PRIMARY KEY (oid);


--
-- Name: institute_shift pk_institute_shift; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_shift
    ADD CONSTRAINT pk_institute_shift PRIMARY KEY (oid);


--
-- Name: institute_type pk_institute_type; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_type
    ADD CONSTRAINT pk_institute_type PRIMARY KEY (oid);


--
-- Name: institute_version pk_institute_version; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_version
    ADD CONSTRAINT pk_institute_version PRIMARY KEY (oid);


--
-- Name: login pk_login; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login
    ADD CONSTRAINT pk_login PRIMARY KEY (oid);


--
-- Name: login_history pk_login_history; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login_history
    ADD CONSTRAINT pk_login_history PRIMARY KEY (oid);


--
-- Name: login_log pk_login_log; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login_log
    ADD CONSTRAINT pk_login_log PRIMARY KEY (oid);


--
-- Name: notice pk_notice; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.notice
    ADD CONSTRAINT pk_notice PRIMARY KEY (oid);


--
-- Name: otp pk_otp; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.otp
    ADD CONSTRAINT pk_otp PRIMARY KEY (oid);


--
-- Name: password_reset_log pk_password_reset_log; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.password_reset_log
    ADD CONSTRAINT pk_password_reset_log PRIMARY KEY (oid);


--
-- Name: payment_mode pk_payment_mode; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.payment_mode
    ADD CONSTRAINT pk_payment_mode PRIMARY KEY (oid);


--
-- Name: role pk_role; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.role
    ADD CONSTRAINT pk_role PRIMARY KEY (oid);


--
-- Name: sign_up pk_sign_up; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.sign_up
    ADD CONSTRAINT pk_sign_up PRIMARY KEY (oid);


--
-- Name: student pk_student; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT pk_student PRIMARY KEY (oid);


--
-- Name: student_attendance pk_student_attendance; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT pk_student_attendance PRIMARY KEY (oid);


--
-- Name: student_attendance_detail pk_student_attendance_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance_detail
    ADD CONSTRAINT pk_student_attendance_detail PRIMARY KEY (oid);


--
-- Name: student_class_detail pk_student_class_detail; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT pk_student_class_detail PRIMARY KEY (oid);


--
-- Name: student_textbook pk_student_textbook; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_textbook
    ADD CONSTRAINT pk_student_textbook PRIMARY KEY (oid);


--
-- Name: teacher pk_teacher; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.teacher
    ADD CONSTRAINT pk_teacher PRIMARY KEY (oid);


--
-- Name: week_day pk_week_day; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.week_day
    ADD CONSTRAINT pk_week_day PRIMARY KEY (oid);


--
-- Name: institute_admission uk_admission_id_institute_admission; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT uk_admission_id_institute_admission UNIQUE (admission_id);


--
-- Name: student uk_application_tracking_id_student; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT uk_application_tracking_id_student UNIQUE (application_tracking_id);


--
-- Name: guardian uk_guardian_id_guardian; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.guardian
    ADD CONSTRAINT uk_guardian_id_guardian UNIQUE (guardian_id);


--
-- Name: sign_up uk_registration_id_sign_up; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.sign_up
    ADD CONSTRAINT uk_registration_id_sign_up UNIQUE (registration_id);


--
-- Name: role uk_role_id_role; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.role
    ADD CONSTRAINT uk_role_id_role UNIQUE (role_id);


--
-- Name: fees_collection uk_student_id_fees_collection; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_collection
    ADD CONSTRAINT uk_student_id_fees_collection UNIQUE (student_id);


--
-- Name: student uk_student_id_student; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT uk_student_id_student UNIQUE (student_id);


--
-- Name: teacher uk_teacher_id_teacher; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.teacher
    ADD CONSTRAINT uk_teacher_id_teacher UNIQUE (teacher_id);


--
-- Name: login uk_user_name_login; Type: CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login
    ADD CONSTRAINT uk_user_name_login UNIQUE (user_name);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: schoolerp; Owner: dbadmin
--

CREATE INDEX flyway_schema_history_s_idx ON schoolerp.flyway_schema_history USING btree (success);


--
-- Name: class_routine_detail fk_class_period_oid_class_routine_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine_detail
    ADD CONSTRAINT fk_class_period_oid_class_routine_detail FOREIGN KEY (class_period_oid) REFERENCES schoolerp.class_period(oid);


--
-- Name: student_attendance fk_class_period_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_class_period_oid_student_attendance FOREIGN KEY (class_period_oid) REFERENCES schoolerp.class_period(oid);


--
-- Name: class_routine_detail fk_class_routine_oid_class_routine_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine_detail
    ADD CONSTRAINT fk_class_routine_oid_class_routine_detail FOREIGN KEY (class_routine_oid) REFERENCES schoolerp.class_routine(oid);


--
-- Name: class_routine_detail fk_class_textbook_oid_class_routine_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine_detail
    ADD CONSTRAINT fk_class_textbook_oid_class_routine_detail FOREIGN KEY (class_textbook_oid) REFERENCES schoolerp.institute_class_textbook(oid);


--
-- Name: student_attendance fk_class_textbook_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_class_textbook_oid_student_attendance FOREIGN KEY (class_textbook_oid) REFERENCES schoolerp.institute_class_textbook(oid);


--
-- Name: education_curriculum fk_country_oid_education_curriculum; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_curriculum
    ADD CONSTRAINT fk_country_oid_education_curriculum FOREIGN KEY (country_oid) REFERENCES schoolerp.country(oid);


--
-- Name: institute fk_district_oid_institute; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute
    ADD CONSTRAINT fk_district_oid_institute FOREIGN KEY (district_oid) REFERENCES schoolerp.district(oid);


--
-- Name: district fk_division_oid_district; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.district
    ADD CONSTRAINT fk_division_oid_district FOREIGN KEY (division_oid) REFERENCES schoolerp.division(oid);


--
-- Name: due_fees_history fk_due_fees_oid_due_fees_history; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees_history
    ADD CONSTRAINT fk_due_fees_oid_due_fees_history FOREIGN KEY (due_fees_oid) REFERENCES schoolerp.due_fees(oid);


--
-- Name: fees_collection_detail fk_due_fees_oid_fees_collection_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_collection_detail
    ADD CONSTRAINT fk_due_fees_oid_fees_collection_detail FOREIGN KEY (due_fees_oid) REFERENCES schoolerp.due_fees(oid);


--
-- Name: institute fk_education_board_oid_institute; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute
    ADD CONSTRAINT fk_education_board_oid_institute FOREIGN KEY (education_board_oid) REFERENCES schoolerp.education_board(oid);


--
-- Name: education_textbook fk_education_class_oid_education_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_textbook
    ADD CONSTRAINT fk_education_class_oid_education_textbook FOREIGN KEY (education_class_oid) REFERENCES schoolerp.education_class(oid);


--
-- Name: institute_class fk_education_class_oid_institute_class; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class
    ADD CONSTRAINT fk_education_class_oid_institute_class FOREIGN KEY (education_class_oid) REFERENCES schoolerp.education_class(oid);


--
-- Name: education_system fk_education_curriculum_oid_education_system; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_system
    ADD CONSTRAINT fk_education_curriculum_oid_education_system FOREIGN KEY (education_curriculum_oid) REFERENCES schoolerp.education_curriculum(oid);


--
-- Name: education_textbook fk_education_group_oid_education_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_textbook
    ADD CONSTRAINT fk_education_group_oid_education_textbook FOREIGN KEY (education_group_oid) REFERENCES schoolerp.education_group(oid);


--
-- Name: education_curriculum fk_education_medium_oid_education_curriculum; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_curriculum
    ADD CONSTRAINT fk_education_medium_oid_education_curriculum FOREIGN KEY (education_medium_oid) REFERENCES schoolerp.education_medium(oid);


--
-- Name: education_textbook fk_education_session_oid_education_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_textbook
    ADD CONSTRAINT fk_education_session_oid_education_textbook FOREIGN KEY (education_session_oid) REFERENCES schoolerp.education_session(oid);


--
-- Name: institute_shift fk_education_shift_oid_institute_shift; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_shift
    ADD CONSTRAINT fk_education_shift_oid_institute_shift FOREIGN KEY (education_shift_oid) REFERENCES schoolerp.education_shift(oid);


--
-- Name: education_board fk_education_system_oid_education_board; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_board
    ADD CONSTRAINT fk_education_system_oid_education_board FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_class fk_education_system_oid_education_class; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_class
    ADD CONSTRAINT fk_education_system_oid_education_class FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_class_level fk_education_system_oid_education_class_level; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_class_level
    ADD CONSTRAINT fk_education_system_oid_education_class_level FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_grading_system fk_education_system_oid_education_grading_system; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_grading_system
    ADD CONSTRAINT fk_education_system_oid_education_grading_system FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_group fk_education_system_oid_education_group; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_group
    ADD CONSTRAINT fk_education_system_oid_education_group FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_session fk_education_system_oid_education_session; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_session
    ADD CONSTRAINT fk_education_system_oid_education_session FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_shift fk_education_system_oid_education_shift; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_shift
    ADD CONSTRAINT fk_education_system_oid_education_shift FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_type fk_education_system_oid_education_type; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_type
    ADD CONSTRAINT fk_education_system_oid_education_type FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: institute fk_education_system_oid_institute; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute
    ADD CONSTRAINT fk_education_system_oid_institute FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: institute_class_group fk_education_system_oid_institute_class_group; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_group
    ADD CONSTRAINT fk_education_system_oid_institute_class_group FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: institute_class_level fk_education_system_oid_institute_class_level; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_level
    ADD CONSTRAINT fk_education_system_oid_institute_class_level FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: institute_grading_system fk_education_system_oid_institute_grading_system; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_grading_system
    ADD CONSTRAINT fk_education_system_oid_institute_grading_system FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: institute_session fk_education_system_oid_institute_session; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_session
    ADD CONSTRAINT fk_education_system_oid_institute_session FOREIGN KEY (education_system_oid) REFERENCES schoolerp.education_system(oid);


--
-- Name: education_class fk_education_type_oid_education_class; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_class
    ADD CONSTRAINT fk_education_type_oid_education_class FOREIGN KEY (education_type_oid) REFERENCES schoolerp.education_type(oid);


--
-- Name: education_class_level fk_education_type_oid_education_class_level; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_class_level
    ADD CONSTRAINT fk_education_type_oid_education_class_level FOREIGN KEY (education_type_oid) REFERENCES schoolerp.education_type(oid);


--
-- Name: education_grading_system fk_education_type_oid_education_grading_system; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_grading_system
    ADD CONSTRAINT fk_education_type_oid_education_grading_system FOREIGN KEY (education_type_oid) REFERENCES schoolerp.education_type(oid);


--
-- Name: institute_class_level fk_education_type_oid_institute_class_level; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_level
    ADD CONSTRAINT fk_education_type_oid_institute_class_level FOREIGN KEY (education_type_oid) REFERENCES schoolerp.education_type(oid);


--
-- Name: institute_type fk_education_type_oid_institute_type; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_type
    ADD CONSTRAINT fk_education_type_oid_institute_type FOREIGN KEY (education_type_oid) REFERENCES schoolerp.education_type(oid);


--
-- Name: education_textbook fk_education_version_oid_education_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.education_textbook
    ADD CONSTRAINT fk_education_version_oid_education_textbook FOREIGN KEY (education_version_oid) REFERENCES schoolerp.education_version(oid);


--
-- Name: institute_version fk_education_version_oid_institute_version; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_version
    ADD CONSTRAINT fk_education_version_oid_institute_version FOREIGN KEY (education_version_oid) REFERENCES schoolerp.education_version(oid);


--
-- Name: exam_routine fk_exam_class_oid_exam_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_routine
    ADD CONSTRAINT fk_exam_class_oid_exam_routine FOREIGN KEY (exam_class_oid) REFERENCES schoolerp.exam_class(oid);


--
-- Name: exam_class fk_exam_oid_exam_class; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_class
    ADD CONSTRAINT fk_exam_oid_exam_class FOREIGN KEY (exam_oid) REFERENCES schoolerp.exam(oid);


--
-- Name: exam_result fk_exam_oid_exam_result; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result
    ADD CONSTRAINT fk_exam_oid_exam_result FOREIGN KEY (exam_oid) REFERENCES schoolerp.exam(oid);


--
-- Name: exam_result_detail fk_exam_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_exam_oid_exam_result_detail FOREIGN KEY (exam_oid) REFERENCES schoolerp.exam(oid);


--
-- Name: exam_result_marks fk_exam_oid_exam_result_marks; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_marks
    ADD CONSTRAINT fk_exam_oid_exam_result_marks FOREIGN KEY (exam_oid) REFERENCES schoolerp.exam(oid);


--
-- Name: exam_routine fk_exam_oid_exam_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_routine
    ADD CONSTRAINT fk_exam_oid_exam_routine FOREIGN KEY (exam_oid) REFERENCES schoolerp.exam(oid);


--
-- Name: exam_time fk_exam_oid_exam_time; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_time
    ADD CONSTRAINT fk_exam_oid_exam_time FOREIGN KEY (exam_oid) REFERENCES schoolerp.exam(oid);


--
-- Name: exam_result_marks fk_exam_result_detail_oid_exam_result_marks; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_marks
    ADD CONSTRAINT fk_exam_result_detail_oid_exam_result_marks FOREIGN KEY (exam_result_detail_oid) REFERENCES schoolerp.exam_result_detail(oid);


--
-- Name: exam_result_detail fk_exam_result_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_exam_result_oid_exam_result_detail FOREIGN KEY (exam_result_oid) REFERENCES schoolerp.exam_result(oid);


--
-- Name: exam_routine fk_exam_time_oid_exam_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_routine
    ADD CONSTRAINT fk_exam_time_oid_exam_routine FOREIGN KEY (exam_time_oid) REFERENCES schoolerp.exam_time(oid);


--
-- Name: due_fees fk_fee_head_oid_due_fees; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees
    ADD CONSTRAINT fk_fee_head_oid_due_fees FOREIGN KEY (fee_head_oid) REFERENCES schoolerp.fee_head(oid);


--
-- Name: due_fees_history fk_fee_head_oid_due_fees_history; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees_history
    ADD CONSTRAINT fk_fee_head_oid_due_fees_history FOREIGN KEY (fee_head_oid) REFERENCES schoolerp.fee_head(oid);


--
-- Name: fees_setting fk_fee_head_oid_fees_setting; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_setting
    ADD CONSTRAINT fk_fee_head_oid_fees_setting FOREIGN KEY (fee_head_oid) REFERENCES schoolerp.fee_head(oid);


--
-- Name: fees_collection_detail fk_fees_collection_oid_fees_collection_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_collection_detail
    ADD CONSTRAINT fk_fees_collection_oid_fees_collection_detail FOREIGN KEY (fees_collection_oid) REFERENCES schoolerp.fees_collection(oid);


--
-- Name: exam_class fk_grading_system_oid_exam_class; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_class
    ADD CONSTRAINT fk_grading_system_oid_exam_class FOREIGN KEY (grading_system_oid) REFERENCES schoolerp.institute_grading_system(oid);


--
-- Name: exam_result_detail fk_grading_system_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_grading_system_oid_exam_result_detail FOREIGN KEY (grading_system_oid) REFERENCES schoolerp.institute_grading_system(oid);


--
-- Name: guardian_student fk_guardian_oid_guardian_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.guardian_student
    ADD CONSTRAINT fk_guardian_oid_guardian_student FOREIGN KEY (guardian_oid) REFERENCES schoolerp.guardian(oid);


--
-- Name: class_routine fk_institute_class_group_oid_class_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT fk_institute_class_group_oid_class_routine FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: exam_result_detail fk_institute_class_group_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_institute_class_group_oid_exam_result_detail FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: institute_admission fk_institute_class_group_oid_institute_admission; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT fk_institute_class_group_oid_institute_admission FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: institute_class_section fk_institute_class_group_oid_institute_class_section; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_section
    ADD CONSTRAINT fk_institute_class_group_oid_institute_class_section FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: institute_class_textbook fk_institute_class_group_oid_institute_class_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_textbook
    ADD CONSTRAINT fk_institute_class_group_oid_institute_class_textbook FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: student fk_institute_class_group_oid_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT fk_institute_class_group_oid_student FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: student_attendance fk_institute_class_group_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_institute_class_group_oid_student_attendance FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: student_class_detail fk_institute_class_group_oid_student_class_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT fk_institute_class_group_oid_student_class_detail FOREIGN KEY (institute_class_group_oid) REFERENCES schoolerp.institute_class_group(oid);


--
-- Name: class_routine fk_institute_class_oid_class_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT fk_institute_class_oid_class_routine FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: due_fees fk_institute_class_oid_due_fees; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees
    ADD CONSTRAINT fk_institute_class_oid_due_fees FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: due_fees_history fk_institute_class_oid_due_fees_history; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees_history
    ADD CONSTRAINT fk_institute_class_oid_due_fees_history FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: exam_class fk_institute_class_oid_exam_class; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_class
    ADD CONSTRAINT fk_institute_class_oid_exam_class FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: exam_result_detail fk_institute_class_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_institute_class_oid_exam_result_detail FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: exam_result_marks fk_institute_class_oid_exam_result_marks; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_marks
    ADD CONSTRAINT fk_institute_class_oid_exam_result_marks FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: fees_setting fk_institute_class_oid_fees_setting; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_setting
    ADD CONSTRAINT fk_institute_class_oid_fees_setting FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: institute_admission fk_institute_class_oid_institute_admission; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT fk_institute_class_oid_institute_admission FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: institute_class_section fk_institute_class_oid_institute_class_section; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_section
    ADD CONSTRAINT fk_institute_class_oid_institute_class_section FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: student fk_institute_class_oid_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT fk_institute_class_oid_student FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: student_attendance fk_institute_class_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_institute_class_oid_student_attendance FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: student_class_detail fk_institute_class_oid_student_class_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT fk_institute_class_oid_student_class_detail FOREIGN KEY (institute_class_oid) REFERENCES schoolerp.institute_class(oid);


--
-- Name: class_routine fk_institute_class_section_oid_class_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT fk_institute_class_section_oid_class_routine FOREIGN KEY (institute_class_section_oid) REFERENCES schoolerp.institute_class_section(oid);


--
-- Name: exam_result_detail fk_institute_class_section_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_institute_class_section_oid_exam_result_detail FOREIGN KEY (institute_class_section_oid) REFERENCES schoolerp.institute_class_section(oid);


--
-- Name: exam_result_marks fk_institute_class_section_oid_exam_result_marks; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_marks
    ADD CONSTRAINT fk_institute_class_section_oid_exam_result_marks FOREIGN KEY (institute_class_section_oid) REFERENCES schoolerp.institute_class_section(oid);


--
-- Name: student fk_institute_class_section_oid_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT fk_institute_class_section_oid_student FOREIGN KEY (institute_class_section_oid) REFERENCES schoolerp.institute_class_section(oid);


--
-- Name: student_attendance fk_institute_class_section_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_institute_class_section_oid_student_attendance FOREIGN KEY (institute_class_section_oid) REFERENCES schoolerp.institute_class_section(oid);


--
-- Name: student_class_detail fk_institute_class_section_oid_student_class_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT fk_institute_class_section_oid_student_class_detail FOREIGN KEY (institute_class_section_oid) REFERENCES schoolerp.institute_class_section(oid);


--
-- Name: class_period fk_institute_oid_class_period; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_period
    ADD CONSTRAINT fk_institute_oid_class_period FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: class_routine fk_institute_oid_class_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT fk_institute_oid_class_routine FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: due_fees fk_institute_oid_due_fees; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees
    ADD CONSTRAINT fk_institute_oid_due_fees FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: due_fees_history fk_institute_oid_due_fees_history; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees_history
    ADD CONSTRAINT fk_institute_oid_due_fees_history FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: exam fk_institute_oid_exam; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam
    ADD CONSTRAINT fk_institute_oid_exam FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: exam_result fk_institute_oid_exam_result; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result
    ADD CONSTRAINT fk_institute_oid_exam_result FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: exam_result_detail fk_institute_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_institute_oid_exam_result_detail FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: exam_result_marks fk_institute_oid_exam_result_marks; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_marks
    ADD CONSTRAINT fk_institute_oid_exam_result_marks FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: fee_head fk_institute_oid_fee_head; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fee_head
    ADD CONSTRAINT fk_institute_oid_fee_head FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: fees_setting fk_institute_oid_fees_setting; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_setting
    ADD CONSTRAINT fk_institute_oid_fees_setting FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_admission fk_institute_oid_institute_admission; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT fk_institute_oid_institute_admission FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_class fk_institute_oid_institute_class; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class
    ADD CONSTRAINT fk_institute_oid_institute_class FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_class_group fk_institute_oid_institute_class_group; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_group
    ADD CONSTRAINT fk_institute_oid_institute_class_group FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_class_level fk_institute_oid_institute_class_level; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_level
    ADD CONSTRAINT fk_institute_oid_institute_class_level FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_class_section fk_institute_oid_institute_class_section; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_section
    ADD CONSTRAINT fk_institute_oid_institute_class_section FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_class_textbook fk_institute_oid_institute_class_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_textbook
    ADD CONSTRAINT fk_institute_oid_institute_class_textbook FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_grading_system fk_institute_oid_institute_grading_system; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_grading_system
    ADD CONSTRAINT fk_institute_oid_institute_grading_system FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_session fk_institute_oid_institute_session; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_session
    ADD CONSTRAINT fk_institute_oid_institute_session FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_shift fk_institute_oid_institute_shift; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_shift
    ADD CONSTRAINT fk_institute_oid_institute_shift FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_type fk_institute_oid_institute_type; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_type
    ADD CONSTRAINT fk_institute_oid_institute_type FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: institute_version fk_institute_oid_institute_version; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_version
    ADD CONSTRAINT fk_institute_oid_institute_version FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: notice fk_institute_oid_notice; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.notice
    ADD CONSTRAINT fk_institute_oid_notice FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: student fk_institute_oid_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT fk_institute_oid_student FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: student_attendance fk_institute_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_institute_oid_student_attendance FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: student_class_detail fk_institute_oid_student_class_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT fk_institute_oid_student_class_detail FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: student_textbook fk_institute_oid_student_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_textbook
    ADD CONSTRAINT fk_institute_oid_student_textbook FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: teacher fk_institute_oid_teacher; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.teacher
    ADD CONSTRAINT fk_institute_oid_teacher FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: week_day fk_institute_oid_week_day; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.week_day
    ADD CONSTRAINT fk_institute_oid_week_day FOREIGN KEY (institute_oid) REFERENCES schoolerp.institute(oid);


--
-- Name: class_routine fk_institute_session_oid_class_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT fk_institute_session_oid_class_routine FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: exam fk_institute_session_oid_exam; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam
    ADD CONSTRAINT fk_institute_session_oid_exam FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: exam_result fk_institute_session_oid_exam_result; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result
    ADD CONSTRAINT fk_institute_session_oid_exam_result FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: exam_result_detail fk_institute_session_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_institute_session_oid_exam_result_detail FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: institute_admission fk_institute_session_oid_institute_admission; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT fk_institute_session_oid_institute_admission FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: institute_class_section fk_institute_session_oid_institute_class_section; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_section
    ADD CONSTRAINT fk_institute_session_oid_institute_class_section FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: institute_class_textbook fk_institute_session_oid_institute_class_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_textbook
    ADD CONSTRAINT fk_institute_session_oid_institute_class_textbook FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: student fk_institute_session_oid_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT fk_institute_session_oid_student FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: student_attendance fk_institute_session_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_institute_session_oid_student_attendance FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: student_class_detail fk_institute_session_oid_student_class_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT fk_institute_session_oid_student_class_detail FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: student_textbook fk_institute_session_oid_student_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_textbook
    ADD CONSTRAINT fk_institute_session_oid_student_textbook FOREIGN KEY (institute_session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: class_period fk_institute_shift_oid_class_period; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_period
    ADD CONSTRAINT fk_institute_shift_oid_class_period FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: class_routine fk_institute_shift_oid_class_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT fk_institute_shift_oid_class_routine FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: exam_result_detail fk_institute_shift_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_institute_shift_oid_exam_result_detail FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: institute_admission fk_institute_shift_oid_institute_admission; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT fk_institute_shift_oid_institute_admission FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: institute_class_section fk_institute_shift_oid_institute_class_section; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_section
    ADD CONSTRAINT fk_institute_shift_oid_institute_class_section FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: student fk_institute_shift_oid_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT fk_institute_shift_oid_student FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: student_attendance fk_institute_shift_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_institute_shift_oid_student_attendance FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: student_class_detail fk_institute_shift_oid_student_class_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT fk_institute_shift_oid_student_class_detail FOREIGN KEY (institute_shift_oid) REFERENCES schoolerp.institute_shift(oid);


--
-- Name: institute_grading_system fk_institute_type_oid_institute_grading_system; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_grading_system
    ADD CONSTRAINT fk_institute_type_oid_institute_grading_system FOREIGN KEY (institute_type_oid) REFERENCES schoolerp.institute_type(oid);


--
-- Name: class_routine fk_institute_version_oid_class_routine; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine
    ADD CONSTRAINT fk_institute_version_oid_class_routine FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: exam_result_detail fk_institute_version_oid_exam_result_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.exam_result_detail
    ADD CONSTRAINT fk_institute_version_oid_exam_result_detail FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: institute_admission fk_institute_version_oid_institute_admission; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_admission
    ADD CONSTRAINT fk_institute_version_oid_institute_admission FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: institute_class_section fk_institute_version_oid_institute_class_section; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_section
    ADD CONSTRAINT fk_institute_version_oid_institute_class_section FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: institute_class_textbook fk_institute_version_oid_institute_class_textbook; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.institute_class_textbook
    ADD CONSTRAINT fk_institute_version_oid_institute_class_textbook FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: student fk_institute_version_oid_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student
    ADD CONSTRAINT fk_institute_version_oid_student FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: student_attendance fk_institute_version_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_institute_version_oid_student_attendance FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: student_class_detail fk_institute_version_oid_student_class_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_class_detail
    ADD CONSTRAINT fk_institute_version_oid_student_class_detail FOREIGN KEY (institute_version_oid) REFERENCES schoolerp.institute_version(oid);


--
-- Name: login_history fk_login_oid_login_history; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login_history
    ADD CONSTRAINT fk_login_oid_login_history FOREIGN KEY (login_oid) REFERENCES schoolerp.login(oid);


--
-- Name: login_log fk_login_oid_login_log; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login_log
    ADD CONSTRAINT fk_login_oid_login_log FOREIGN KEY (login_oid) REFERENCES schoolerp.login(oid);


--
-- Name: login fk_role_oid_login; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login
    ADD CONSTRAINT fk_role_oid_login FOREIGN KEY (role_oid) REFERENCES schoolerp.role(oid);


--
-- Name: login_history fk_role_oid_login_history; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.login_history
    ADD CONSTRAINT fk_role_oid_login_history FOREIGN KEY (role_oid) REFERENCES schoolerp.role(oid);


--
-- Name: fees_setting fk_session_oid_fees_setting; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.fees_setting
    ADD CONSTRAINT fk_session_oid_fees_setting FOREIGN KEY (session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: notice fk_session_oid_notice; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.notice
    ADD CONSTRAINT fk_session_oid_notice FOREIGN KEY (session_oid) REFERENCES schoolerp.institute_session(oid);


--
-- Name: student_attendance_detail fk_student_attendance_oid_student_attendance_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance_detail
    ADD CONSTRAINT fk_student_attendance_oid_student_attendance_detail FOREIGN KEY (student_attendance_oid) REFERENCES schoolerp.student_attendance(oid);


--
-- Name: due_fees fk_student_oid_due_fees; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees
    ADD CONSTRAINT fk_student_oid_due_fees FOREIGN KEY (student_oid) REFERENCES schoolerp.student(oid);


--
-- Name: due_fees_history fk_student_oid_due_fees_history; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.due_fees_history
    ADD CONSTRAINT fk_student_oid_due_fees_history FOREIGN KEY (student_oid) REFERENCES schoolerp.student(oid);


--
-- Name: guardian_student fk_student_oid_guardian_student; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.guardian_student
    ADD CONSTRAINT fk_student_oid_guardian_student FOREIGN KEY (student_oid) REFERENCES schoolerp.student(oid);


--
-- Name: student_attendance_detail fk_student_oid_student_attendance_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance_detail
    ADD CONSTRAINT fk_student_oid_student_attendance_detail FOREIGN KEY (student_oid) REFERENCES schoolerp.student(oid);


--
-- Name: class_routine_detail fk_teacher_oid_class_routine_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine_detail
    ADD CONSTRAINT fk_teacher_oid_class_routine_detail FOREIGN KEY (teacher_oid) REFERENCES schoolerp.teacher(oid);


--
-- Name: student_attendance fk_teacher_oid_student_attendance; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.student_attendance
    ADD CONSTRAINT fk_teacher_oid_student_attendance FOREIGN KEY (teacher_oid) REFERENCES schoolerp.teacher(oid);


--
-- Name: class_routine_detail fk_week_day_oid_class_routine_detail; Type: FK CONSTRAINT; Schema: schoolerp; Owner: dbadmin
--

ALTER TABLE ONLY schoolerp.class_routine_detail
    ADD CONSTRAINT fk_week_day_oid_class_routine_detail FOREIGN KEY (week_day_oid) REFERENCES schoolerp.week_day(oid);


--
-- PostgreSQL database dump complete
--

