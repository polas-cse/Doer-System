/*

oid                            : Surrogate primary key
login_id                       : Login Id
student_id                     : student unique id
application_tracking_id        : student unique admission id or application tracking id
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_class_oid            : Institute class oid
institute_class_section_oid    : Institute class section oid
roll_number                    : 
institute_class_group_oid      : Institute Group oid
institute_shift_oid            : Institute shift oid
institute_version_oid          : Institute version oid
education_curriculum_oid       : Education Curriculum oid
name_en                        : login Id
name_bn                        : 
date_of_birth                  : 
email                          : 
mobile_no                      : 
gender                         : 
religion                       : 
nationality                    : 
blood_group                    : 
national_id_no                 : Student national id no
birth_registration_no          : Student birth registration no.
father_name_en                 : 
father_name_bn                 : 
father_occupation              : 
father_contact_number          : 
father_email                   : 
mother_name_en                 : 
mother_name_bn                 : 
mother_occupation              : 
mother_contact_number          : 
mother_email                   : 
emergency_contact_person       : 
emergency_contact_no           : 
present_address_json           : permanentAddressJson : {"careOf":"Nur Ahamed","houseNo":"54","roadNo":"06","postOffice":"Adabor","postCode":"1207","thana":"Adabor", "thanaOid":"Adabor", "district":"Dhaka", "districtOid":"Dhaka"}
permanent_address_json         : permanentAddressJson : {"careOf":"Nur Ahamed","houseNo":"54","roadNo":"06","postOffice":"Adabor","postCode":"1207","thana":"Adabor", "thanaOid":"Adabor", "district":"Dhaka", "districtOid":"Dhaka"}
photo_path                     : 
photo_url                      : 
status                         : [Active,Inactive]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".student
(
oid                            varchar(128)                                                not null,
login_id                       varchar(128),
student_id                     varchar(128)                                                not null,
application_tracking_id        varchar(128),
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_class_oid            varchar(128),
institute_class_section_oid    varchar(128),
roll_number                    varchar(128),
institute_class_group_oid      varchar(128),
institute_shift_oid            varchar(128),
institute_version_oid          varchar(128),
education_curriculum_oid       varchar(128),
name_en                        varchar(128)                                                not null,
name_bn                        varchar(256),
date_of_birth                  date,
email                          varchar(128),
mobile_no                      varchar(128),
gender                         varchar(128),
religion                       varchar(128),
nationality                    varchar(128),
blood_group                    varchar(128),
national_id_no                 varchar(128),
birth_registration_no          varchar(128),
father_name_en                 varchar(128),
father_name_bn                 varchar(128),
father_occupation              varchar(128),
father_contact_number          varchar(128),
father_email                   varchar(128),
mother_name_en                 varchar(128),
mother_name_bn                 varchar(128),
mother_occupation              varchar(128),
mother_contact_number          varchar(128),
mother_email                   varchar(128),
emergency_contact_person       varchar(128),
emergency_contact_no           varchar(128),
present_address_json           varchar,
permanent_address_json         varchar,
photo_path                     varchar(256),
photo_url                      varchar(256),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_student                                                  primary key    (oid),
constraint                     uk_student_id_student                                       unique         (student_id),
constraint                     uk_application_tracking_id_student                          unique         (application_tracking_id),
constraint                     fk_institute_oid_student                                    foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_student                            foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_oid_student                              foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_section_oid_student                      foreign key    (institute_class_section_oid)
                                                                                           references     "schoolerp".institute_class_section(oid),
constraint                     fk_institute_class_group_oid_student                        foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_shift_oid_student                              foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_version_oid_student                            foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid)
);

/*

oid                            : Surrogate primary key
student_id                     : Surrogate primary key
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_class_oid            : Institute class oid
institute_class_section_oid    : Institute class section oid
roll_number                    : 
institute_class_group_oid      : Institute Group oid
institute_shift_oid            : Institute shift oid
institute_version_oid          : Institute version oid
education_curriculum_oid       : Education Curriculum oid
status                         : [Running, Pass, Fail]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".student_class_detail
(
oid                            varchar(128)                                                not null,
student_id                     varchar(128)                                                not null,
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_class_oid            varchar(128),
institute_class_section_oid    varchar(128),
roll_number                    varchar(128),
institute_class_group_oid      varchar(128),
institute_shift_oid            varchar(128),
institute_version_oid          varchar(128),
education_curriculum_oid       varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_student_class_detail                                     primary key    (oid),
constraint                     fk_institute_oid_student_class_detail                       foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_student_class_detail               foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_oid_student_class_detail                 foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_section_oid_student_class_detail         foreign key    (institute_class_section_oid)
                                                                                           references     "schoolerp".institute_class_section(oid),
constraint                     fk_institute_class_group_oid_student_class_detail           foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_shift_oid_student_class_detail                 foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_version_oid_student_class_detail               foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid)
);

/*
Institute Class Text Book Information
oid                            : Surrogate primary key
student_id                     : Surrogate primary key
institute_oid                  : Institute oid
institute_class_oid            : Institute class oid
subject_type                   : [Compulsory,Fourth,Optional]
education_subject_oid          : Education subject oid
institute_session_oid          : Institute session oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".student_subject
(
oid                            varchar(128)                                                not null,
student_id                     varchar(128)                                                not null,
institute_oid                  varchar(128),
institute_class_oid            varchar(128),
subject_type                   varchar(128),
education_subject_oid          varchar(128),
institute_session_oid          varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_student_subject                                          primary key    (oid),
constraint                     fk_institute_oid_student_subject                            foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_subject_oid_student_subject                    foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_institute_session_oid_student_subject                    foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid)
);

/*
Institute Class Text Book Information
oid                            : Surrogate primary key
student_id                     : Surrogate primary key
institute_oid                  : Institute oid
institute_class_oid            : Institute class oid
textbook_type                  : [Compulsory,Fourth]
institute_class_textbook_oid   : Institute class textbook oid
institute_session_oid          : Institute session oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".student_textbook
(
oid                            varchar(128)                                                not null,
student_id                     varchar(128)                                                not null,
institute_oid                  varchar(128),
institute_class_oid            varchar(128),
textbook_type                  varchar(128),
institute_class_textbook_oid   varchar(128),
institute_session_oid          varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_student_textbook                                         primary key    (oid),
constraint                     fk_institute_oid_student_textbook                           foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_student_textbook                   foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid)
);


