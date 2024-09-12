--By Liton @ 16-Oct-2022 13:40
alter	table	sms_log 			add institute_oid           varchar(128);




--By Tanvir @ 16-Oct-2022 13:00
ALTER TABLE asset_allocation
  ADD accounts_receivable numeric(20);

--By Liton @ 12-Jan-2023 14:30
alter	table	schoolerp.institute_session_class_group		add education_group_oid            varchar(128);


--By Liton @ 18-Jan-2023 14:00
alter	table	schoolerp.education_type_subject		add  subject_code                   varchar(128);
alter	table	schoolerp.education_type_subject		add  subject_type                   varchar(128);

--By Liton @ 06-Feb-2023 18:00

alter	table	schoolerp.fee_due				add  billing_period                 varchar(128);
alter	table	schoolerp.fee_due				add  fee_setting_oid                varchar(128);
alter	table	schoolerp.fee_due add constraint  fk_fee_setting_oid_fee_due       foreign key    (fee_setting_oid) 	references     "schoolerp".fee_setting(oid);
