-- DROP FUNCTION IF EXISTS create_institute(varchar(128));
CREATE OR REPLACE FUNCTION create_institute(p_institute_oid varchar(128))
RETURNS void AS $create_institute$
    DECLARE
    	v_institute				record;	
    	v_class_level				record;	
    	v_class					record;	
    	v_gading_system				record;	
    	v_gading_system_detail			record;	
    	v_education_group			record;	
    	v_textbook				record;	
    	v_shift					record;	
    BEGIN
    
        SELECT * INTO v_institute FROM institute WHERE oid = p_institute_oid;
    
        for v_class_level in (select ecl.oid, ecl.name_en, ecl.name_bn, ecl.no_of_class, ecl.sort_order, ecl.status, ecl.education_type_oid, ecl.education_system_oid 
        from institute_type it, education_type et, education_class_level ecl where 1 =1 and it.education_type_oid = et.oid and ecl.education_type_oid = et.oid 
        and it.institute_oid = p_institute_oid) loop 
        
        	INSERT INTO schoolerp.institute_class_level(oid, name_en, name_bn, no_of_class, sort_order, status, institute_oid, education_class_level_oid, 
        	education_type_oid, education_system_oid, created_by) VALUES(uuid(), v_class_level.name_en, v_class_level.name_bn, v_class_level.no_of_class, 
        	v_class_level.sort_order, v_class_level.status, p_institute_oid, v_class_level.oid, v_class_level.education_type_oid, 
        	v_class_level.education_system_oid, v_institute.created_by);
	end loop;
	
        for v_class in (select icl.oid as institute_class_level_oid, ec.oid, ec.name_en, ec.name_bn, ec.admission_age, ec.grade, ec.class_id, ec.sort_order, ec.status, ec.education_class_level_oid, 
        ec.education_type_oid, ec.education_system_oid from institute_class_level icl, education_class ec where 1 =1 
        and icl.education_class_level_oid = ec.education_class_level_oid and icl.institute_oid = p_institute_oid) loop 
        
        	INSERT INTO schoolerp.institute_class(oid, name_en, name_bn, institute_oid, institute_class_level_oid, education_class_oid, class_id, sort_order, status, created_by) 
        	VALUES(uuid(), v_class.name_en, v_class.name_bn, p_institute_oid, v_class.institute_class_level_oid, v_class.oid, v_class.class_id, v_class.sort_order, 
        	v_class.status, v_institute.created_by);
	end loop;
	
        for v_gading_system in (select it.oid as institute_type_oid, egs.oid, egs.name_en, egs.name_bn, egs.grade_point_scale, egs.sort_order, egs.status, egs.education_type_oid, 
        egs.education_system_oid from institute_type it, education_grading_system egs where it.education_type_oid = egs.education_type_oid and it.institute_oid = p_institute_oid) loop 
        
        	INSERT INTO schoolerp.institute_grading_system (oid, name_en, name_bn, grade_point_scale, sort_order, status, institute_oid, institute_type_oid, education_system_oid, created_by) 
        	VALUES(uuid(), v_gading_system.name_en, v_gading_system.name_bn, v_gading_system.grade_point_scale, v_gading_system.sort_order, v_gading_system.status, p_institute_oid,
        	v_gading_system.institute_type_oid, v_gading_system.education_system_oid,v_institute.created_by);
	end loop;
	
        for v_gading_system_detail in (select igs.oid as institute_grading_system_oid, egsd.oid, egsd.start_marks, egsd.end_marks, egsd.letter_grade, egsd.grade_point, 
        egsd.assessment, egsd.remarks, egsd.sort_order, egsd.status, egsd.education_grading_system_oid from institute_type it, education_grading_system egs, 
        education_grading_system_detail egsd, schoolerp.institute_grading_system igs where 1 = 1 and it.education_type_oid = egs.education_type_oid 
        and egsd.education_grading_system_oid = egs.oid and igs.institute_type_oid = it.oid and it.institute_oid = p_institute_oid) loop 
        
        	INSERT INTO schoolerp.institute_grading_system_detail (oid, start_marks, end_marks, letter_grade, grade_point, assessment, remarks, sort_order, status, 
        	institute_grading_system_oid, created_by) 
        	VALUES(uuid(), v_gading_system_detail.start_marks, v_gading_system_detail.end_marks, v_gading_system_detail.letter_grade, 
        	v_gading_system_detail.grade_point, v_gading_system_detail.assessment, v_gading_system_detail.remarks, v_gading_system_detail.sort_order,
        	v_gading_system_detail.status, v_gading_system_detail.institute_grading_system_oid, v_institute.created_by);
	end loop;
	
        for v_education_group in (select * from education_group where education_system_oid = v_institute.education_system_oid) loop 
        
		INSERT INTO institute_class_group(oid, name_en, name_bn, status, institute_oid, education_group_oid, education_system_oid, education_curriculum_oid, created_by)
		VALUES(uuid(), v_education_group.name_en, v_education_group.name_bn, v_education_group.status, p_institute_oid, v_education_group.oid,
		v_institute.education_system_oid, v_institute.education_curriculum_oid, v_institute.created_by);
		
	end loop;
	
	-- Insert Institute Text Book Information.
        for v_textbook in (select s.oid as institute_session_oid, iv.oid as institute_version_oid, et.* from institute_session s, education_session es, education_textbook et, 
        education_version ev, institute_version iv, institute_class ic  where 1 = 1 and s.education_session_oid = es.oid and et.education_session_oid = es.oid 
        and et.education_version_oid = ev.oid and iv.education_version_oid = ev.oid and iv.institute_oid = s.institute_oid and ic.institute_oid = s.institute_oid 
        and et.education_class_oid = ic.education_class_oid and s.institute_oid = p_institute_oid order by et.education_version_oid) loop 
        
		
		INSERT INTO institute_class_textbook(oid, name_en, name_bn, subject_code, e_book_link, status, institute_oid, institute_session_oid, institute_version_oid, 
		institute_class_group_oid, institute_class_oid, education_textbook_oid, created_by) VALUES(uuid(), v_textbook.name_en, v_textbook.name_bn, 
		v_textbook.subject_code, v_textbook.e_book_link, v_textbook.status, p_institute_oid, v_textbook.institute_session_oid, v_textbook.institute_version_oid, 
		(select oid from institute_class_group where education_group_oid = v_textbook.education_group_oid and institute_oid = p_institute_oid), 
		(select oid from institute_class where education_class_oid = v_textbook.education_class_oid and institute_oid = p_institute_oid), 
		v_textbook.oid, v_institute.created_by);
		
	end loop;
	
	-- Insert Institute Class Period Information.
        for v_shift in (select * from institute_shift where institute_oid = p_institute_oid) loop 
        
		INSERT INTO class_period(oid, name_en, name_bn, institute_oid, institute_shift_oid, sort_order, status, created_by)
		VALUES(uuid(), 'Period 1', 'পিরিয়ড ১', p_institute_oid, v_shift.oid, 1, 'Active', v_institute.created_by);
		INSERT INTO class_period(oid, name_en, name_bn, institute_oid, institute_shift_oid, sort_order, status, created_by)
		VALUES(uuid(), 'Period 2', 'পিরিয়ড ২', p_institute_oid, v_shift.oid, 2, 'Active', v_institute.created_by);
		INSERT INTO class_period(oid, name_en, name_bn, institute_oid, institute_shift_oid, sort_order, status, created_by)
		VALUES(uuid(), 'Period 3', 'পিরিয়ড ৩', p_institute_oid, v_shift.oid, 3, 'Active', v_institute.created_by);
		INSERT INTO class_period(oid, name_en, name_bn, institute_oid, institute_shift_oid, sort_order, status, created_by)
		VALUES(uuid(), 'Period 4', 'পিরিয়ড ৪', p_institute_oid, v_shift.oid, 4, 'Active', v_institute.created_by);
		INSERT INTO class_period(oid, name_en, name_bn, institute_oid, institute_shift_oid, sort_order, status, created_by)
		VALUES(uuid(), 'Period 5', 'পিরিয়ড ৫', p_institute_oid, v_shift.oid, 5, 'Active', v_institute.created_by);
		INSERT INTO class_period(oid, name_en, name_bn, institute_oid, institute_shift_oid, sort_order, status, created_by)
		VALUES(uuid(), 'Period 6', 'পিরিয়ড ৬', p_institute_oid, v_shift.oid, 6, 'Active', v_institute.created_by);
		
	end loop;
	
	-- Insert Institute Week Day Information
	INSERT INTO week_day(oid, institute_oid, name_en, name_bn, sort_order, status, created_by) VALUES(uuid(), p_institute_oid, 'Saturday', 'শনিবার', 1, 'Active', v_institute.created_by);
	INSERT INTO week_day(oid, institute_oid, name_en, name_bn, sort_order, status, created_by) VALUES(uuid(), p_institute_oid, 'Sunday', 'রবিবার', 2, 'Active', v_institute.created_by);
	INSERT INTO week_day(oid, institute_oid, name_en, name_bn, sort_order, status, created_by) VALUES(uuid(), p_institute_oid, 'Monday', 'সোমবার', 3, 'Active', v_institute.created_by);
	INSERT INTO week_day(oid, institute_oid, name_en, name_bn, sort_order, status, created_by) VALUES(uuid(), p_institute_oid, 'Tuesday', 'মঙ্গলবার', 4, 'Active', v_institute.created_by);
	INSERT INTO week_day(oid, institute_oid, name_en, name_bn, sort_order, status, created_by) VALUES(uuid(), p_institute_oid, 'Wednesday', 'বুধবার', 5, 'Active', v_institute.created_by);
	INSERT INTO week_day(oid, institute_oid, name_en, name_bn, sort_order, status, created_by) VALUES(uuid(), p_institute_oid, 'Thursday', 'বৃহস্পতিবার', 6, 'Active', v_institute.created_by);
	INSERT INTO week_day(oid, institute_oid, name_en, name_bn, sort_order, status, created_by) VALUES(uuid(), p_institute_oid, 'Friday', 'শুক্রবার', 7, 'Inactive', v_institute.created_by);
		
	-- Insert Institute Fees Head Information
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'ADMISSION_FEE', 'Admission Fee', 'ভর্তি ফী', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'TUITION_FEE', 'Tuition Fee', 'টিউশন ফী', 'Monthly', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'EXAM_FEE', 'Exam Fee', 'পরীক্ষার ফী', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'CAUTION_MONEY', 'Caution money', 'সতর্কতা টাকা', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'ANNUAL_CHARGE', 'Annual Charge', 'বাৎসরিক চার্জ', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'DEVELOPMENT_CHARGE', 'Development Charge', 'উন্নয়ন চার্জ', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'PROCESSING_FEE', 'Processing Fee', 'প্রক্রিয়াকরণ ফি', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'LATE_FEE', 'Late Fee', 'লেট ফি', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'ELECTRICITY_BILL', 'Electricity Bill', 'বিদ্যুৎ বিল', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'UTILITY_CHARGE', 'Utility Charge', 'ইউটিলিটি চার্জ', 'One-Time', NULL, 'Active', v_institute.created_by);
	INSERT INTO fee_head(oid, institute_oid, head_code, name_en, name_bn, head_type, remarks, status, created_by) 
	VALUES(uuid(), p_institute_oid, 'OTHERS', 'Others', 'অন্যান্য', 'One-Time', NULL, 'Active', v_institute.created_by);
    END;
$create_institute$ LANGUAGE plpgsql;
-- SELECT create_institute('10');

-- DROP FUNCTION IF EXISTS institute_shift_name_en(varchar(128));
CREATE OR REPLACE FUNCTION institute_shift_name_en(p_oid varchar(128))
RETURNS text AS $institute_shift_name_en$
    DECLARE
		shift_name_en			text := (select string_agg(name_en , ', ') from schoolerp.institute_shift where 1 = 1 and institute_oid = p_oid);
    BEGIN
      RETURN shift_name_en;
    END;
$institute_shift_name_en$ LANGUAGE plpgsql;
-- SELECT institute_shift_name_en('10');


-- DROP FUNCTION IF EXISTS institute_shift_name_bn(varchar(128));
CREATE OR REPLACE FUNCTION institute_shift_name_bn(p_oid varchar(128))
RETURNS text AS $institute_shift_name_bn$
    DECLARE
		shift_name_bn			text := (select string_agg(name_bn , ', ') from schoolerp.institute_shift where 1 = 1 and institute_oid = p_oid);
    BEGIN
      RETURN shift_name_bn;
    END;
$institute_shift_name_bn$ LANGUAGE plpgsql;
-- SELECT institute_shift_name_bn('10');


/*


CREATE OR REPLACE FUNCTION schoolerp.create_institute(instituteOid varchar(128), educationClassOid varchar(128), 
educationTypeOid varchar(128), educationGradingOid varchar(128))
RETURNS void AS $create_institute$
  declare
    	intitute_class_oid	varchar(128);
        eoid varchar(128);
        institute_grading_oid varchar(128);
	educationClassCursor CURSOR FOR SELECT * FROM schoolerp.education_class where oid = educationClassOid;
        educationTypeCursor CURSOR FOR SELECT * FROM schoolerp.education_type where oid = educationTypeOid; 
	educationGradingSystemCursor CURSOR FOR SELECT * FROM schoolerp.education_grading_system where oid = educationGradingOid; 
		
  BEGIN
   	  
      
   	for educationClass in educationClassCursor loop
    	intitute_class_oid = uuid();
     
        insert into "schoolerp".institute_class (oid, name_en, name_bn, institute_oid, institute_class_level_oid, education_class_oid, sort_order, status) 
        values (intitute_class_oid,educationClass.name_en,educationClass.name_bn,instituteOid,'SCHOOL-ERP-Institute-Level-Class-6',educationClass.oid ,1,'Active');
  	
        end loop;
   
   
        for educationType in educationTypeCursor loop
	eoid =  uuid();
	insert into schoolerp.institute_type (oid, institute_oid, status, education_type_oid) 
        values (eoid,'SCHOOL-ERP-Demo-School-001','Active', educationType.oid);
        
        end loop;
   
   	for educationGrading in educationGradingSystemCursor loop
	institute_grading_oid =  uuid();
	
	insert into schoolerp.institute_grading_system (oid, name_en, name_bn, grade_point_scale, 
	institute_oid, education_system_oid) 
        values (institute_grading_oid, educationGrading.name_en, educationGrading.name_bn, 
        educationGrading.grade_point_scale,instituteOid, educationGrading.education_system_oid);
   	
   	end loop;
   	
   END;
   
$create_institute$ LANGUAGE plpgsql;

--select  * FROM schoolerp.create_institute('SCHOOL-ERP-Demo-School-001', 'SCHOOL-ERP-Education-Program-Class-8', 
--'Education-Type-0004', 'Education-Grading-System-0003'); 

*/

