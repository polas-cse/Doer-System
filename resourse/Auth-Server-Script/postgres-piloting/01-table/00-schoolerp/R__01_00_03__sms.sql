/*
Sms Features information to be stored here
oid                            : Surrogate primary key
name_en                        : SMS features name in english.
name_bn                        : SMS features name in bangla.
sms_template_name              : 
sms_template_text_en           : Template SMS Text format in English.
sms_template_text_bn           : Template SMS Text format in Bangla.
sms_language                   : [English,Bangla]
email_subject                  : Email Subject
email_template_text_en         : Template Email Text format in English.
email_template_text_bn         : Template Email Text format in Bangla.
email_language                 : [English,Bangla]
message_parameter_json         : Education type  information
applicable_for                 : [Admin,Institute,Both]
remarks                        : Remarks
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".sms_feature
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
sms_template_name              varchar(128),
sms_template_text_en           text,
sms_template_text_bn           text,
sms_language                   varchar(128),
email_subject                  text,
email_template_text_en         text,
email_template_text_bn         text,
email_language                 varchar(128),
message_parameter_json         text,
applicable_for                 varchar(128),
remarks                        text,
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_sms_feature                                              primary key    (oid),
constraint                     uk_sms_template_name_sms_feature                            unique         (sms_template_name)
);

/*
Sms Features information to be stored here
oid                            : Surrogate primary key
name_en                        : SMS features name in english.
name_bn                        : SMS features name in bangla.
sms_template_name              : 
sms_template_text_en           : Template SMS Text format in English.
sms_template_text_bn           : Template SMS Text format in Bangla.
sms_language                   : [English,Bangla]
sms_push                       : [On,Off]
email_subject                  : Email Subject
email_template_text_en         : Template Email Text format in English.
email_template_text_bn         : Template Email Text format in Bangla.
email_language                 : [English,Bangla]
email_push                     : [On,Off]
contact_group_sms_push         : [On,Off]
contact_group_email_push       : [On,Off]
applicable_for                 : [Admin,Institute,Both]
remarks                        : Remarks
status                         : 
sms_feature_oid                : SMS Feature Oid
institute_oid                  : Institute Oid 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".sms_service
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
sms_template_name              varchar(128),
sms_template_text_en           text,
sms_template_text_bn           text,
sms_language                   varchar(128),
sms_push                       varchar(32)                                                                default 'Off',
email_subject                  text,
email_template_text_en         text,
email_template_text_bn         text,
email_language                 varchar(128),
email_push                     varchar(32)                                                                default 'Off',
contact_group_sms_push         varchar(32)                                                                default 'Off',
contact_group_email_push       varchar(32)                                                                default 'Off',
applicable_for                 varchar(128),
remarks                        text,
status                         varchar(128),
sms_feature_oid                varchar(128)                                                not null,
institute_oid                  varchar(128)                                                not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_sms_service                                              primary key    (oid),
constraint                     fk_sms_feature_oid_sms_service                              foreign key    (sms_feature_oid)
                                                                                           references     "schoolerp".sms_feature(oid)
);

/*

oid                            : 
contact_group_oid              : Contact group oid
sms_service_oid                : SMS service oid
institute_oid                  : Institute oid
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".sms_service_contact_group
(
oid                            varchar(128)                                                not null,
contact_group_oid              varchar(128),
sms_service_oid                varchar(128),
institute_oid                  varchar(128),
status                         varchar(128)                                                not null       default 'Active',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_sms_service_contact_group                                primary key    (oid),
constraint                     fk_sms_service_oid_sms_service_contact_group                foreign key    (sms_service_oid)
                                                                                           references     "schoolerp".sms_service(oid)
);

/*
Sms service request information to be stored here
oid                            : Surrogate primary key
sms_service_oid                : SMS Service Oid 
present_sms_service_status     : Present sms service  status On/Off.
request_sms_service_status     : Request sms service  status On/Off.
requested_by                   : Who (which login) requested the record
requested_on                   : When requested
approved_by                    : Who (which login) approved the record
approved_on                    : When approved
remarks                        : Remarks
status                         : [Pending,Approved,Rejected]
institute_oid                  : Institute Oid 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".sms_service_log
(
oid                            varchar(128)                                                not null,
sms_service_oid                varchar(128)                                                not null,
present_sms_service_status     varchar(128),
request_sms_service_status     varchar(128),
requested_by                   varchar(128),
requested_on                   timestamp,
approved_by                    varchar(128),
approved_on                    timestamp,
remarks                        text,
status                         varchar(128),
institute_oid                  varchar(128)                                                not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_sms_service_log                                          primary key    (oid),
constraint                     fk_sms_service_oid_sms_service_log                          foreign key    (sms_service_oid)
                                                                                           references     "schoolerp".sms_service(oid)
);

/*
SmsLog information to be stored here
oid                            : Surrogate primary key
request_id                     : Csb request id
sms_service_oid                : SMS Service Oid 
reference_source               : Reference type like Student, Teacher, Guardian
reference_oid                  : Reference Oid
reference_no                   : Reference no of service
trans_type                     : Type of transaction
mobile_no                      : Mobile number
sms                            : Sms text
send_date                      : Time when sms was send from provider
trace_id                       : trace id
request_receive_time           : when the request was received
provider_request_time          : when request was sent to bl from drws
provider_response_time         : when bl sent response to drws
service_provider               : [Grammen Phone, Banglalink, Airtel etc]
sms_count                      : No fo sent SMS
remarks                        : 
sms_status                     : Status of sms[sent,failed]
institute_oid                  : Institute Oid 
created_by                     : Who Create
created_on                     : When Create
updated_on                     : When Updated
updated_by                     : Who Updated
*/
create table                   "schoolerp".sms_log
(
oid                            varchar(128)                                                not null,
request_id                     varchar(128),
sms_service_oid                varchar(128),
reference_source               varchar(128),
reference_oid                  varchar(128),
reference_no                   varchar(64),
trans_type                     varchar(32),
mobile_no                      varchar(32)                                                 not null,
sms                            text,
send_date                      timestamp,
trace_id                       varchar(128),
request_receive_time           timestamp,
provider_request_time          timestamp,
provider_response_time         timestamp,
service_provider               varchar(32),
sms_count                      numeric(20,0),
remarks                        text,
sms_status                     varchar(32)                                                 not null,
institute_oid                  varchar(128),
created_by                     varchar(128)                                                not null       default current_user,
created_on                     timestamp                                                   not null       default current_timestamp,
updated_on                     timestamp,
updated_by                     varchar(128),
constraint                     pk_sms_log                                                  primary key    (oid)
);

/*
Message template parameter information to be stored here
oid                            : 
parameter_id                   : 
name_en                        : 
name_bn                        : 
parameter_value                : 
is_general                     : [Yes,No]
is_schedule                    : [Yes,No]
remarks                        : Remarks
status                         : [Active,Inactive]
created_by                     : 
created_on                     : 
*/
create table                   "schoolerp".message_template_parameter
(
oid                            varchar(128)                                                not null,
parameter_id                   varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128)                                                not null,
parameter_value                varchar(128)                                                not null,
is_general                     varchar(32)                                                                default 'No',
is_schedule                    varchar(32)                                                                default 'No',
remarks                        text,
status                         varchar(128)                                                not null       default 'Active',
created_by                     varchar(128)                                                not null       default current_user,
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_message_template_parameter                               primary key    (oid),
constraint                     uk_parameter_id_message_template_parameter                  unique         (parameter_id),
constraint                     uk_parameter_value_message_template_parameter               unique         (parameter_value)
);

/*
Sms Features information to be stored here
oid                            : Surrogate primary key
message_template_id            : 
title_name_en                  : SMS features name in english.
title_name_bn                  : SMS features name in bangla.
message_template_text_en       : Template SMS Text format in English.
message_template_text_bn       : Template SMS Text format in Bangla.
message_language               : [English,Bangla]
message_template_type          : [Email,SMS]
email_subject                  : Email Subject
remarks                        : Remarks
status                         : [Active,Inactive]
institute_oid                  : Institute Oid 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".message_template
(
oid                            varchar(128)                                                not null,
message_template_id            varchar(128),
title_name_en                  varchar(128)                                                not null,
title_name_bn                  varchar(128),
message_template_text_en       text,
message_template_text_bn       text,
message_language               varchar(128),
message_template_type          varchar(128),
email_subject                  text,
remarks                        text,
status                         varchar(128),
institute_oid                  varchar(128)                                                not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_message_template                                         primary key    (oid)
);

/*

oid                            : 
name_en                        : 
name_bn                        : 
contact_no                     : 
email                          : 
address                        : 
reference_type                 : Reference Type like Student, Teacher, Guardian, People etc.
reference_oid                  : Reference Type like Student, Teacher, Guardian, People Table oid.
institute_oid                  : Institute oid
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".contact
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
contact_no                     varchar(128)                                                not null,
email                          varchar(128),
address                        varchar(128),
reference_type                 varchar(128),
reference_oid                  varchar(128),
institute_oid                  varchar(128),
status                         varchar(128)                                                not null       default 'Active',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_contact                                                  primary key    (oid)
);

/*

oid                            : 
name_en                        : 
name_bn                        : 
remarks                        : Remarks
institute_oid                  : Institute oid
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".contact_group
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
remarks                        text,
institute_oid                  varchar(128),
status                         varchar(128)                                                not null       default 'Active',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_contact_group                                            primary key    (oid)
);

/*

oid                            : 
contact_group_oid              : Contact Group oid
contact_oid                    : Contact oid
institute_oid                  : Institute oid
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".contact_group_detail
(
oid                            varchar(128)                                                not null,
contact_group_oid              varchar(128),
contact_oid                    varchar(128),
institute_oid                  varchar(128),
status                         varchar(128)                                                not null       default 'Active',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_contact_group_detail                                     primary key    (oid),
constraint                     fk_contact_group_oid_contact_group_detail                   foreign key    (contact_group_oid)
                                                                                           references     "schoolerp".contact_group(oid),
constraint                     fk_contact_oid_contact_group_detail                         foreign key    (contact_oid)
                                                                                           references     "schoolerp".contact(oid)
);

/*

oid                            : 
schedule_id                    : 
name_en                        : 
name_bn                        : 
remarks                        : Remarks
schedule_type                  : [Email, SMS]
schedule_mode                  : [Once, Daily, Weekly, Monthly, Yearly]
schedule_time                  : 
start_date                     : 
end_date                       : 
message_template_oid           : Institute oid
message_language               : [English,Bangla]
institute_oid                  : Institute oid
status                         : [Pending, Running, Completed]
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".schedule
(
oid                            varchar(128)                                                not null,
schedule_id                    varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
remarks                        text,
schedule_type                  varchar(128)                                                not null,
schedule_mode                  varchar(128)                                                not null,
schedule_time                  timestamp,
start_date                     date,
end_date                       date,
message_template_oid           varchar(128),
message_language               varchar(128),
institute_oid                  varchar(128),
status                         varchar(128)                                                not null       default 'Active',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_schedule                                                 primary key    (oid),
constraint                     fk_message_template_oid_schedule                            foreign key    (message_template_oid)
                                                                                           references     "schoolerp".message_template(oid)
);

/*

oid                            : 
contact_group_oid              : Contact group oid
schedule_oid                   : Schedule oid
institute_oid                  : Institute oid
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".schedule_detail
(
oid                            varchar(128)                                                not null,
contact_group_oid              varchar(128),
schedule_oid                   varchar(128),
institute_oid                  varchar(128),
status                         varchar(128)                                                not null       default 'Active',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_schedule_detail                                          primary key    (oid),
constraint                     fk_contact_group_oid_schedule_detail                        foreign key    (contact_group_oid)
                                                                                           references     "schoolerp".contact_group(oid),
constraint                     fk_schedule_oid_schedule_detail                             foreign key    (schedule_oid)
                                                                                           references     "schoolerp".schedule(oid)
);

/*

oid                            : 
sms_job_title                  : 
started_on                     : When started
message_text                   : 
total_sms                      : 
sent_sms                       : 
failed_sms                     : 
institute_oid                  : Institute oid
status                         : [Pending, Inprocess,Completed]
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".sms_job
(
oid                            varchar(128)                                                not null,
sms_job_title                  varchar(128)                                                not null,
started_on                     timestamp                                                   not null,
message_text                   text,
total_sms                      numeric(10,0)                                                              default 0,
sent_sms                       numeric(10,0)                                                              default 0,
failed_sms                     numeric(10,0)                                                              default 0,
institute_oid                  varchar(128),
status                         varchar(128)                                                not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_sms_job                                                  primary key    (oid)
);

/*

oid                            : 
name_en                        : 
name_bn                        : 
contact_no                     : 
email                          : 
contact_oid                    : Institute oid
sms_job_oid                    : Institute oid
institute_oid                  : Institute oid
status                         : [Pending,Sent,Failed]
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".sms_job_detail
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
contact_no                     varchar(128)                                                not null,
email                          varchar(128),
contact_oid                    varchar(128),
sms_job_oid                    varchar(128),
institute_oid                  varchar(128),
status                         varchar(128)                                                not null       default 'Pending',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_sms_job_detail                                           primary key    (oid),
constraint                     fk_contact_oid_sms_job_detail                               foreign key    (contact_oid)
                                                                                           references     "schoolerp".contact(oid),
constraint                     fk_sms_job_oid_sms_job_detail                               foreign key    (sms_job_oid)
                                                                                           references     "schoolerp".sms_job(oid)
);


