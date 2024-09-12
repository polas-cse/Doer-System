/*
Sms Features information to be stored here
oid                            : Surrogate primary key
name_en                        : SMS features name in english.
name_bn                        : SMS features name in bangla.
sms_template_name              : 
sms_template_text_en           : Template SMS Text format in English.
sms_template_text_bn           : Template SMS Text format in Bangla.
sms_language                   : [English,Bangla]
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
applicable_for                 : [Admin,Institute,Both]
remarks                        : Remarks
sms_push                       : [On,Off]
status                         : 
sms_feature_oid                : 
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
applicable_for                 varchar(128),
remarks                        text,
sms_push                       text,
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
constraint                     pk_sms_service_log                                          primary key    (oid)
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
sms_count                      : No fo sent SMS
remarks                        : 
sms_status                     : Status of sms
created_by                     : Who Create
created_on                     : When Create
updated_on                     : When Updated
updated_by                     : Who Updated
*/
create table                   "schoolerp".sms_log
(
oid                            varchar(128)                                                not null,
request_id                     varchar(128)                                                not null,
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
sms_count                      numeric(20,0),
remarks                        text,
sms_status                     varchar(32)                                                 not null,
created_by                     varchar(128)                                                not null       default current_user,
created_on                     timestamp                                                   not null       default current_timestamp,
updated_on                     timestamp,
updated_by                     varchar(128),
constraint                     pk_sms_log                                                  primary key    (oid)
);


