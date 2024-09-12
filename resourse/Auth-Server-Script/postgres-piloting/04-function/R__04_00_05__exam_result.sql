
CREATE OR REPLACE FUNCTION prepare_result_by_text_book(p_data text)
RETURNS void AS $prepare_result_by_class_text_book$
    DECLARE
        v_start_marks             		int4;
        v_end_marks             		int4;
        v_obtained_marks             		int4;
        v_check_section             		int4;
    	v_student				record;	
    	v_grade_detail				record;	
    	v_class_section				record;	
        v_grading_system_oid                    varchar(128);	
        v_json                          	json;	
    BEGIN
        SELECT p_data::json INTO v_json;
    
        select grading_system_oid into v_grading_system_oid from schoolerp.exam_class where 1 = 1 and institute_class_oid = v_json->>'instituteClassOid' and exam_oid = v_json->>'examOid' limit 1;
      
        
        for v_class_section in (select distinct(institute_class_section_oid) from schoolerp.exam_result_marks where class_textbook_oid = v_json->>'textBookOid' 
        and institute_class_oid = v_json->>'instituteClassOid') loop 
        
		select count(oid) into v_check_section from exam_result_detail where exam_oid = v_json->>'examOid' and institute_class_oid = v_json->>'instituteClassOid' 
		and institute_class_section_oid = v_class_section.institute_class_section_oid;
		
		IF v_check_section < 1 THEN
		INSERT INTO schoolerp.exam_result_detail(oid, exam_oid, exam_result_oid, institute_oid, institute_session_oid, institute_class_oid, institute_class_group_oid, 
		institute_class_section_oid, institute_shift_oid, institute_version_oid, grading_system_oid, status, created_by) VALUES(uuid(), v_json->>'examOid', 
		(select oid from exam_result where exam_oid = v_json->>'examOid'), (select institute_oid from exam_result where exam_oid = v_json->>'examOid'), 
		(select institute_session_oid from exam_result where exam_oid = v_json->>'examOid'), v_json->>'instituteClassOid', 
		(select institute_class_group_oid from institute_class_section where oid = v_class_section.institute_class_section_oid), v_class_section.institute_class_section_oid,
		(select institute_shift_oid from institute_class_section where oid = v_class_section.institute_class_section_oid), v_json->>'instituteVersionOid', v_grading_system_oid,
		'Pending', v_json->>'createdBy');
		
		END IF;
	end loop;
        
	for v_student in (SELECT oid, obtained_marks, institute_class_section_oid  FROM schoolerp.exam_result_marks where exam_oid = v_json->>'examOid' and class_textbook_oid = v_json->>'textBookOid') loop
				
		select v_student.obtained_marks::int4 into v_obtained_marks;			
		for v_grade_detail in (select start_marks, end_marks, letter_grade, grade_point, assessment from schoolerp.institute_grading_system_detail 
			where institute_grading_system_oid = v_grading_system_oid) loop
			select v_grade_detail.start_marks::int4 into v_start_marks;
			select v_grade_detail.end_marks::int4 into v_end_marks;
			if (v_obtained_marks > (v_start_marks-1) and v_obtained_marks < (v_end_marks+1))  
		    then
			update schoolerp.exam_result_marks set exam_result_detail_oid = (select oid from exam_result_detail where exam_oid = v_json->>'examOid' 
			and institute_class_section_oid = v_student.institute_class_section_oid), letter_grade = v_grade_detail.letter_grade, 
			grade_point = v_grade_detail.grade_point, assessment = v_grade_detail.assessment where oid = v_student.oid;
		
		    end if; 
		end loop;
	end loop;
    END;
$prepare_result_by_class_text_book$ LANGUAGE plpgsql;
-- SELECT prepare_result_by_class_text_book('10');




CREATE OR REPLACE FUNCTION prepare_result_by_subject(p_data text)
RETURNS void AS $prepare_result_by_subject$
    DECLARE
        v_start_marks             		int4;
        v_end_marks             		int4;
        v_obtained_marks             		int4;
        v_check_section             		int4;
    	v_student				record;	
    	v_grade_detail				record;	
    	v_class_section				record;	
        v_grading_system_oid                    varchar(128);	
        v_json                          	json;	
    BEGIN
        SELECT p_data::json INTO v_json;
    
        select grading_system_oid into v_grading_system_oid from schoolerp.exam_class where 1 = 1 and institute_class_oid = v_json->>'instituteClassOid' and exam_oid = v_json->>'examOid' limit 1;
      
        
        for v_class_section in (select distinct(institute_class_section_oid) from schoolerp.exam_result_marks where education_subject_oid = v_json->>'educationSubjectOid' 
        and institute_class_oid = v_json->>'instituteClassOid') loop 
        
		select count(oid) into v_check_section from exam_result_detail where exam_oid = v_json->>'examOid' and institute_class_oid = v_json->>'instituteClassOid' 
		and institute_class_section_oid = v_class_section.institute_class_section_oid;
		
		IF v_check_section < 1 THEN
		INSERT INTO schoolerp.exam_result_detail(oid, exam_oid, exam_result_oid, institute_oid, institute_session_oid, institute_class_oid, institute_class_group_oid, 
		institute_class_section_oid, institute_shift_oid, institute_version_oid, grading_system_oid, status, created_by) VALUES(uuid(), v_json->>'examOid', 
		(select oid from exam_result where exam_oid = v_json->>'examOid'), (select institute_oid from exam_result where exam_oid = v_json->>'examOid'), 
		(select institute_session_oid from exam_result where exam_oid = v_json->>'examOid'), v_json->>'instituteClassOid', 
		(select institute_class_group_oid from institute_class_section where oid = v_class_section.institute_class_section_oid), v_class_section.institute_class_section_oid,
		(select institute_shift_oid from institute_class_section where oid = v_class_section.institute_class_section_oid), v_json->>'instituteVersionOid', v_grading_system_oid,
		'Pending', v_json->>'createdBy');
		
		END IF;
	end loop;
        
	for v_student in (SELECT oid, obtained_marks, institute_class_section_oid  FROM schoolerp.exam_result_marks where exam_oid = v_json->>'examOid' 
	and education_subject_oid = v_json->>'educationSubjectOid') loop
				
		select v_student.obtained_marks::int4 into v_obtained_marks;			
		for v_grade_detail in (select start_marks, end_marks, letter_grade, grade_point, assessment from schoolerp.institute_grading_system_detail 
			where institute_grading_system_oid = v_grading_system_oid) loop
			select v_grade_detail.start_marks::int4 into v_start_marks;
			select v_grade_detail.end_marks::int4 into v_end_marks;
			if (v_obtained_marks > (v_start_marks-1) and v_obtained_marks < (v_end_marks+1))  
		    then
			update schoolerp.exam_result_marks set exam_result_detail_oid = (select oid from exam_result_detail where exam_oid = v_json->>'examOid' 
			and institute_class_section_oid = v_student.institute_class_section_oid), letter_grade = v_grade_detail.letter_grade, 
			grade_point = v_grade_detail.grade_point, assessment = v_grade_detail.assessment where oid = v_student.oid;
		
		    end if; 
		end loop;
	end loop;
    END;
$prepare_result_by_subject$ LANGUAGE plpgsql;
-- SELECT prepare_result_by_subject('10');

