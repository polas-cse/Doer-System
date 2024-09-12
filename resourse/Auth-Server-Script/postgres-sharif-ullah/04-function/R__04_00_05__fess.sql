-- DROP FUNCTION IF EXISTS schoolerp.addmission_fees_calculate();

CREATE OR REPLACE FUNCTION schoolerp.addmission_fees_calculate(p_data varchar(4096), instituteOid varchar(128), instituteClassOid varchar(128), sessionOid varchar(128), groupCode varchar(128))
RETURNS void AS $addmission_fees_calculate$
declare
    	fees_oid	varchar(128);
    	v_json          json;
    		    feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = instituteOid and institute_class_oid = instituteClassOid and session_oid = sessionOid and group_code = groupCode;
	    
begin
	SELECT p_data::json INTO v_json;
  	for feesSetting in feesSettingCoursor loop
    	fees_oid = uuid();

    	INSERT INTO schoolerp.due_fees
    	(oid, head_code, fee_head_oid, session_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)

    	VALUES(fees_oid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.session_oid, feesSetting.institute_oid,
    	feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP, v_json->>'applicationTrackingId');

    	INSERT INTO schoolerp.due_fees_history
    	(oid, due_fees_oid, head_code, fee_head_oid, session_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on)

    	VALUES(uuid(), fees_oid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.session_oid, feesSetting.institute_oid, feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP);

  	end loop;
  END;
$addmission_fees_calculate$ LANGUAGE plpgsql;

-- SELECT addmission_fees_calculate('{"instituteClassOid":"SCHOOL-ERP-Institute-Class-6","createdBy":"Kamal Parvez","studentOid":"SCHOOL-ERP-Institute-Student-0001","sessionOid":"SCHOOL-ERP-Institute-Student-0001","applicationTrackingId":"1234","instituteOid":"SCHOOL-ERP-Demo-School-001","remarks":"Test Purpose","status":"Active"}','SCHOOL-ERP-Demo-School-001', 'SCHOOL-ERP-Institute-Class-6', 'SCHOOL-ERP-Institute-Session-2022');


CREATE OR REPLACE FUNCTION schoolerp.addmission_fees_calculate(p_data varchar(4096), instituteOid varchar(128), instituteClassOid varchar(128), sessionOid varchar(128))
RETURNS void AS $addmission_fees_calculate$
declare
    	fees_oid	varchar(128);
    	v_json          json;
    		    
	    feesSettingCoursor CURSOR FOR SELECT * FROM schoolerp.fees_setting where institute_oid = instituteOid and institute_class_oid = instituteClassOid and session_oid = sessionOid and head_code in ('ADMISSION_FEE', 'ANNUAL_CHARGE','DEVELOPMENT_CHARGE','OTHERS','UTILITY_CHARGE');
begin
	SELECT p_data::json INTO v_json;
  	for feesSetting in feesSettingCoursor loop
    	fees_oid = uuid();

    	INSERT INTO schoolerp.due_fees
    	(oid, head_code, fee_head_oid, session_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on, application_tracking_id)

    	VALUES(fees_oid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.session_oid, feesSetting.institute_oid,
    	feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP, v_json->>'applicationTrackingId');

    	INSERT INTO schoolerp.due_fees_history
    	(oid, due_fees_oid, head_code, fee_head_oid, session_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on)

    	VALUES(uuid(), fees_oid, feesSetting.head_code, feesSetting.fee_head_oid, feesSetting.session_oid, feesSetting.institute_oid, feesSetting.institute_class_oid, feesSetting.amount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP);

  	end loop;
  END;
$addmission_fees_calculate$ LANGUAGE plpgsql;

-- SELECT addmission_fees_calculate('{"instituteClassOid":"SCHOOL-ERP-Institute-Class-6","createdBy":"Kamal Parvez","studentOid":"SCHOOL-ERP-Institute-Student-0001","sessionOid":"SCHOOL-ERP-Institute-Student-0001","applicationTrackingId":"1234","instituteOid":"SCHOOL-ERP-Demo-School-001","remarks":"Test Purpose","status":"Active"}','SCHOOL-ERP-Demo-School-001', 'SCHOOL-ERP-Institute-Class-6', 'SCHOOL-ERP-Institute-Session-2022');


-- DROP FUNCTION IF EXISTS schoolerp.insert_due_fees_with_history();

CREATE OR REPLACE FUNCTION schoolerp.insert_due_fees_with_history(p_data varchar(2048), instituteOid varchar(128), instituteClassOid varchar(128), sessionOid varchar(128), dueAmount numeric(20, 2))
RETURNS void AS $insert_due_fees_with_history$
declare
    	fees_oid	varchar(128);
    	v_json          json;
	    studentCoursor CURSOR FOR SELECT * FROM schoolerp.student where institute_oid = instituteOid and institute_class_oid = instituteClassOid and institute_session_oid = sessionOid;
begin
	SELECT p_data::json INTO v_json;
  	for studentCur in studentCoursor loop
    	fees_oid = uuid();

    	INSERT INTO schoolerp.due_fees
    	(oid, student_id , student_oid , head_code, fee_head_oid, session_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on)

    	VALUES(fees_oid, studentCur.student_id, studentCur.oid, v_json->>'headCode', v_json->>'feeHeadOid', studentCur.institute_session_oid, studentCur.institute_oid,
    	studentCur.institute_class_oid,  dueAmount, v_json->>'remarks', v_json->>'status', v_json->>'createdBy', CURRENT_TIMESTAMP);

    	INSERT INTO schoolerp.due_fees_history
    	(oid, due_fees_oid, head_code, fee_head_oid, session_oid, institute_oid, institute_class_oid, due_amount, remarks, status, created_by, created_on)

    	VALUES(uuid(), fees_oid, v_json->>'headCode', v_json->>'feeHeadOid', studentCur.institute_session_oid, studentCur.institute_oid, studentCur.institute_class_oid, dueAmount, v_json->>'remarks', 'Active', v_json->>'createdBy', CURRENT_TIMESTAMP);

  	end loop;
  END;
$insert_due_fees_with_history$ LANGUAGE plpgsql;

-- select * from schoolerp.insert_due_fees_with_history('{"instituteClassOid":"SCHOOL-ERP-Institute-Class-7","createdBy":"Kamal Parvez","sessionOid":"SCHOOL-ERP-Institute-Session-2022","headCode":"TUITION_FEE","instituteOid":"SCHOOL-ERP-Demo-School-001","feeHeadOid":"schoolerp-fee-head-oid-tuition-fee","remarks":"Test Purpose","status":"Due"}','SCHOOL-ERP-Demo-School-001','SCHOOL-ERP-Institute-Class-7','SCHOOL-ERP-Institute-Session-2022','10000.00'::numeric);
