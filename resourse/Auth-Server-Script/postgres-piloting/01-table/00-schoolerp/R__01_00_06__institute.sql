/*
All institute information (School, College, Technical, Madrasha, Qawmi)
oid                            : Surrogate primary key
name_en                        : Institute name in english.
name_bn                        : Institute name in bangla.
email                          : 
address                        : 
address_json_en                : institute address json for english language
address_json_bn                : institute address json for bangla language
contact                        : 
type                           : 
code                           : 
founded                        : 
mpo_level                      : 
mpo_number                     : 
eiin_number                    : 
logo_path                      : Logo Path
logo_url                       : Logo Url
schedule_message_push          : [On,Off]
status                         : 
district_oid                   : District oid
education_board_oid            : Education Board oid
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : 
created_on                     : 
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
email                          varchar(128),
address                        varchar(256),
address_json_en                text,
address_json_bn                text,
contact                        varchar(128),
type                           varchar(128),
code                           varchar(128),
founded                        varchar(128),
mpo_level                      varchar(32),
mpo_number                     varchar(64),
eiin_number                    varchar(128),
logo_path                      text,
logo_url                       text,
schedule_message_push          varchar(32)                                                                default 'Off',
status                         varchar(128),
district_oid                   varchar(128),
education_board_oid            varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute                                                primary key    (oid),
constraint                     fk_district_oid_institute                                   foreign key    (district_oid)
                                                                                           references     "schoolerp".district(oid),
constraint                     fk_education_board_oid_institute                            foreign key    (education_board_oid)
                                                                                           references     "schoolerp".education_board(oid),
constraint                     fk_education_system_oid_institute                           foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
institute_oid                  : Institute oid
status                         : [Active, Inactive]
education_type_oid             : Education type oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".institute_type
(
oid                            varchar(128)                                                not null,
institute_oid                  varchar(128),
status                         varchar(128),
education_type_oid             varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_institute_type                                           primary key    (oid),
constraint                     fk_institute_oid_institute_type                             foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_type_oid_institute_type                        foreign key    (education_type_oid)
                                                                                           references     "schoolerp".education_type(oid)
);

/*
Institute version information (Bangla, English).
oid                            : Surrogate primary key
name_en                        : Education system name in english.
name_bn                        : Education system name in bangla.
status                         : 
institute_oid                  : Institute oid
education_version_oid          : Education version oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".institute_version
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
status                         varchar(128),
institute_oid                  varchar(128),
education_version_oid          varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_institute_version                                        primary key    (oid),
constraint                     fk_institute_oid_institute_version                          foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_version_oid_institute_version                  foreign key    (education_version_oid)
                                                                                           references     "schoolerp".education_version(oid)
);

/*
Institute shift information (Morning, Evening)
oid                            : Surrogate primary key
name_en                        : Education system name in english.
name_bn                        : Education system name in bangla.
institute_oid                  : Institute oid
education_shift_oid            : Education shift oid
start_time                     : Shift start time.
end_time                       : Shift end time.
status                         : [Active, Inactive]
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".institute_shift
(
oid                            varchar(128)                                                not null,
name_en                        varchar(32)                                                 not null,
name_bn                        varchar(32),
institute_oid                  varchar(128),
education_shift_oid            varchar(128),
start_time                     varchar(128),
end_time                       varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_institute_shift                                          primary key    (oid),
constraint                     fk_institute_oid_institute_shift                            foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_shift_oid_institute_shift                      foreign key    (education_shift_oid)
                                                                                           references     "schoolerp".education_shift(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Institute scetion name in english.
name_bn                        : Institute scetion name in bangla.
education_type_json            : Education type  information
status                         : [Draft,Running,Closed]
institute_oid                  : Institute oid
education_session_oid          : Education Session oid
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute_session
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
education_type_json            text,
status                         varchar(128),
institute_oid                  varchar(128),
education_session_oid          varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_session                                        primary key    (oid),
constraint                     fk_institute_oid_institute_session                          foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_session_oid_institute_session                  foreign key    (education_session_oid)
                                                                                           references     "schoolerp".education_session(oid),
constraint                     fk_education_system_oid_institute_session                   foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education program name in english.
name_bn                        : Education program name in bangla.
no_of_class                    : Sorting processor for asc/desc
sort_order                     : Sorting processor for asc/desc
status                         : 
institute_oid                  : Institute oid
education_class_level_oid      : Education class level oid
education_type_oid             : Education type oid
education_system_oid           : Education System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".institute_class_level
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
no_of_class                    numeric(5,0)                                                not null       default 0,
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
institute_oid                  varchar(128),
education_class_level_oid      varchar(128),
education_type_oid             varchar(128),
education_system_oid           varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_institute_class_level                                    primary key    (oid),
constraint                     fk_institute_oid_institute_class_level                      foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_type_oid_institute_class_level                 foreign key    (education_type_oid)
                                                                                           references     "schoolerp".education_type(oid),
constraint                     fk_education_system_oid_institute_class_level               foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*
Institute class information (One, Two, ...., Tweleve)
oid                            : Surrogate primary key
name_en                        : Institute class name in english.
name_bn                        : Institute class name in bangla.
institute_oid                  : Institute oid
institute_class_level_oid      : Institute class level oid
education_class_oid            : Education class oid
no_of_section                  : No of total section in class.
class_id                       : Institute Class ID
sort_order                     : Sorting processor for asc/desc
status                         : [Active, Inactive]
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".institute_class
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
institute_oid                  varchar(128),
institute_class_level_oid      varchar(128),
education_class_oid            varchar(128),
no_of_section                  numeric(5,0)                                                not null       default 0,
class_id                       varchar(32),
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_institute_class                                          primary key    (oid),
constraint                     fk_institute_oid_institute_class                            foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_class_oid_institute_class                      foreign key    (education_class_oid)
                                                                                           references     "schoolerp".education_class(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education grading system name in english.
name_bn                        : Education grading system name in bangla.
grade_point_scale              : Sorting processor for asc/desc
sort_order                     : Sorting processor for asc/desc
status                         : 
institute_oid                  : Institute oid
institute_type_oid             : Education type oid
education_system_oid           : Education System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".institute_grading_system
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
grade_point_scale              numeric(5,0)                                                               default 0,
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
institute_oid                  varchar(128),
institute_type_oid             varchar(128),
education_system_oid           varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_institute_grading_system                                 primary key    (oid),
constraint                     fk_institute_oid_institute_grading_system                   foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_type_oid_institute_grading_system              foreign key    (institute_type_oid)
                                                                                           references     "schoolerp".institute_type(oid),
constraint                     fk_education_system_oid_institute_grading_system            foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
start_marks                    : Sorting processor for asc/desc
end_marks                      : Sorting processor for asc/desc
letter_grade                   : Letter grade like A+, A, A-, B, C, D, F
grade_point                    : Grade point lke 5, 4, 3.5, 3, 2, 1, 0
assessment                     : Assessment like Excellent, Very Good, Good, Above Average, Average, Below Average, Poor, Pass, Fail
remarks                        : Remarks like First Class, Second Class, Second Class, Second Class, Upper Third Class, Fail
sort_order                     : Sorting processor for asc/desc
status                         : 
institute_grading_system_oid   : Education Grading System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".institute_grading_system_detail
(
oid                            varchar(128)                                                not null,
start_marks                    numeric(5,0)                                                not null       default 0,
end_marks                      numeric(5,0)                                                not null       default 0,
letter_grade                   varchar(128),
grade_point                    numeric(5),
assessment                     varchar(128),
remarks                        varchar(128),
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
institute_grading_system_oid   varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_institute_grading_system_detail                          primary key    (oid)
);

/*
Education Group Information (Science, Humanities, Bussiness Studies)
oid                            : Surrogate primary key
name_en                        : Education group name in english.
name_bn                        : Education group name in bangla.
status                         : 
institute_oid                  : Institute oid
education_group_oid            : Education Group oid
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute_class_group
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
status                         varchar(128),
institute_oid                  varchar(128),
education_group_oid            varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_class_group                                    primary key    (oid),
constraint                     fk_institute_oid_institute_class_group                      foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_education_group_oid_institute_class_group                foreign key    (education_group_oid)
                                                                                           references     "schoolerp".education_group(oid),
constraint                     fk_education_system_oid_institute_class_group               foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*
Education Group Information (Science, Humanities, Bussiness Studies)
oid                            : Surrogate primary key
institute_class_group_oid      : Institute Group oid
institute_class_oid            : Institute class oid
institute_session_oid          : Institute session oid
institute_oid                  : Institute oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute_session_class_group
(
oid                            varchar(128)                                                not null,
institute_class_group_oid      varchar(128),
institute_class_oid            varchar(128),
institute_session_oid          varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_session_class_group                            primary key    (oid),
constraint                     fk_institute_class_group_oid_institute_session_class_group  foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_session_oid_institute_session_class_group      foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_oid_institute_session_class_group              foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*
Institute Class Section Information (Jaba, Kamini, Shapla)
oid                            : Surrogate primary key
name_en                        : Institute class section name in english.
name_bn                        : Institute class section name in bangla.
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_class_oid            : Institute class oid
institute_class_group_oid      : Institute Group oid
institute_shift_oid            : Institute shift oid
institute_version_oid          : Institute version oid
status                         : [Active,Inactive]
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute_class_section
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_class_oid            varchar(128),
institute_class_group_oid      varchar(128),
institute_shift_oid            varchar(128),
institute_version_oid          varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_class_section                                  primary key    (oid),
constraint                     fk_institute_oid_institute_class_section                    foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_institute_class_section            foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_oid_institute_class_section              foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_group_oid_institute_class_section        foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_shift_oid_institute_class_section              foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_version_oid_institute_class_section            foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid)
);

/*
Institute Subject Information
oid                            : Surrogate primary key
name_en                        : Education text book name in english.
name_bn                        : Education text book name in bangla.
subject_code                   : Text book subject code.
subject_type                   : [Compulsory,Fourth,Optional]
status                         : [Active,Inactive]
education_subject_oid          : Education subject oid
institute_oid                  : Institute oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute_subject
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
subject_code                   varchar(128),
subject_type                   varchar(128),
status                         varchar(128),
education_subject_oid          varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_subject                                        primary key    (oid),
constraint                     fk_education_subject_oid_institute_subject                  foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_institute_oid_institute_subject                          foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*
Institute Class Text Book Information
oid                            : Surrogate primary key
name_en                        : Text book name in english.
name_bn                        : Text book name in bangla.
subject_code                   : Text book subject code.
e_book_link                    : 
textbook_type                  : [Compulsory,Fourth]
mnemonic                       : Textbook mnemonic like Bangla I, Bangla II
status                         : 
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_version_oid          : Institute version oid
institute_class_group_oid      : Institute Group oid
institute_class_oid            : Institute class oid
education_textbook_oid         : Education textbook oid
education_subject_oid          : Education subject oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute_class_textbook
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
subject_code                   varchar(128),
e_book_link                    varchar(256),
textbook_type                  varchar(128),
mnemonic                       varchar(128),
status                         varchar(128),
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_version_oid          varchar(128),
institute_class_group_oid      varchar(128),
institute_class_oid            varchar(128),
education_textbook_oid         varchar(128),
education_subject_oid          varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_class_textbook                                 primary key    (oid),
constraint                     fk_institute_oid_institute_class_textbook                   foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_institute_class_textbook           foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_version_oid_institute_class_textbook           foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid),
constraint                     fk_institute_class_group_oid_institute_class_textbook       foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_education_subject_oid_institute_class_textbook           foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid)
);

/*
Institute Subject Information
oid                            : Surrogate primary key
education_subject_oid          : Education subject oid
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_class_group_oid      : Institute Group oid
institute_class_oid            : Institute class oid
subject_code                   : Subject code.
subject_type                   : [Compulsory,Fourth,Optional]
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".institute_class_subject
(
oid                            varchar(128)                                                not null,
education_subject_oid          varchar(128),
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_class_group_oid      varchar(128),
institute_class_oid            varchar(128),
subject_code                   varchar(128),
subject_type                   varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_class_subject                                  primary key    (oid),
constraint                     fk_education_subject_oid_institute_class_subject            foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_institute_oid_institute_class_subject                    foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_institute_class_subject            foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_group_oid_institute_class_subject        foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid)
);

/*
Institute Class Text Book Information
oid                            : Surrogate primary key
institute_oid                  : Institute oid
name_en                        : Text book name in english.
name_bn                        : Text book name in bangla.
sort_order                     : Sorting processor for asc/desc
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".week_day
(
oid                            varchar(128)                                                not null,
institute_oid                  varchar(128),
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_week_day                                                 primary key    (oid),
constraint                     fk_institute_oid_week_day                                   foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*
Institute Class Time Duration Information
oid                            : Surrogate primary key
name_en                        : Class duration name in english.
name_bn                        : Class duration name in bangla.
institute_oid                  : Institute oid
institute_shift_oid            : Institute shift oid
start_time                     : Class start time.
end_time                       : Class end time.
sort_order                     : Sorting processor for asc/desc
status                         : [Active,Inactive]
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".class_period
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
institute_oid                  varchar(128),
institute_shift_oid            varchar(128),
start_time                     varchar(32),
end_time                       varchar(32),
sort_order                     numeric(5,0)                                                               default 0,
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_class_period                                             primary key    (oid),
constraint                     fk_institute_oid_class_period                               foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_shift_oid_class_period                         foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid)
);


