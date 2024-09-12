/*

oid                            : Surrogate primary key
name_en                        : Education system name in english.
name_bn                        : Education system name in bangla.
short_name                     : Education system name in bangla.
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_medium
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
short_name                     varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_medium                                         primary key    (oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education system name in english.
name_bn                        : Education system name in bangla.
short_name                     : Education system name in bangla.
website                        : Education board official website
status                         : 
education_medium_oid           : Education Medium oid
country_oid                    : Country oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_curriculum
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
short_name                     varchar(128),
website                        varchar(128),
status                         varchar(128),
education_medium_oid           varchar(128),
country_oid                    varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_curriculum                                     primary key    (oid),
constraint                     fk_education_medium_oid_education_curriculum                foreign key    (education_medium_oid)
                                                                                           references     "schoolerp".education_medium(oid),
constraint                     fk_country_oid_education_curriculum                         foreign key    (country_oid)
                                                                                           references     "schoolerp".country(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education system name in english.
name_bn                        : Education system name in bangla.
status                         : 
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_version
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
status                         varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_version                                        primary key    (oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education system name in english.
name_bn                        : Education system name in bangla.
short_name                     : Education system name in bangla.
status                         : 
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_system
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
short_name                     varchar(128),
status                         varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_system                                         primary key    (oid),
constraint                     fk_education_curriculum_oid_education_system                foreign key    (education_curriculum_oid)
                                                                                           references     "schoolerp".education_curriculum(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education board name in english.
name_bn                        : Education board name in bangla.
short_name                     : Education board short name.
website                        : Education board official website
status                         : 
education_system_oid           : Education System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_board
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
short_name                     varchar(128),
website                        varchar(128),
status                         varchar(128),
education_system_oid           varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_board                                          primary key    (oid),
constraint                     fk_education_system_oid_education_board                     foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education type name in english.
name_bn                        : Education type name in bangla.
short_name                     : Education board short name.
sort_order                     : Sorting processor for asc/desc
status                         : 
education_system_oid           : Education System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_type
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
short_name                     varchar(128),
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
education_system_oid           varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_type                                           primary key    (oid),
constraint                     fk_education_system_oid_education_type                      foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education program name in english.
name_bn                        : Education program name in bangla.
no_of_class                    : Sorting processor for asc/desc
sort_order                     : Sorting processor for asc/desc
status                         : 
education_type_oid             : Education type oid
education_system_oid           : Education System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_class_level
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
no_of_class                    numeric(5,0)                                                not null       default 0,
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
education_type_oid             varchar(128),
education_system_oid           varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_class_level                                    primary key    (oid),
constraint                     fk_education_type_oid_education_class_level                 foreign key    (education_type_oid)
                                                                                           references     "schoolerp".education_type(oid),
constraint                     fk_education_system_oid_education_class_level               foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education program name in english.
name_bn                        : Education program name in bangla.
admission_age                  : Minimum or above 
grade                          : 
class_id                       : 
sort_order                     : Sorting processor for asc/desc
status                         : 
education_class_level_oid      : Education class level oid
education_type_oid             : Education type oid
education_system_oid           : Education System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_class
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
admission_age                  numeric(5,0)                                                               default 0,
grade                          varchar(128),
class_id                       varchar(128),
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
education_class_level_oid      varchar(128),
education_type_oid             varchar(128),
education_system_oid           varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_class                                          primary key    (oid),
constraint                     fk_education_type_oid_education_class                       foreign key    (education_type_oid)
                                                                                           references     "schoolerp".education_type(oid),
constraint                     fk_education_system_oid_education_class                     foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education session name in english.
name_bn                        : Education session name in bangla.
education_type_json            : Education type  information
status                         : [Draft,Running,Closed]
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".education_session
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
education_type_json            text,
status                         varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_education_session                                        primary key    (oid),
constraint                     fk_education_system_oid_education_session                   foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Education grading system name in english.
name_bn                        : Education grading system name in bangla.
grade_point_scale              : Sorting processor for asc/desc
sort_order                     : Sorting processor for asc/desc
status                         : 
education_type_oid             : Education type oid
education_system_oid           : Education System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_grading_system
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
grade_point_scale              numeric(5,2)                                                not null       default 0,
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
education_type_oid             varchar(128),
education_system_oid           varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_grading_system                                 primary key    (oid),
constraint                     fk_education_type_oid_education_grading_system              foreign key    (education_type_oid)
                                                                                           references     "schoolerp".education_type(oid),
constraint                     fk_education_system_oid_education_grading_system            foreign key    (education_system_oid)
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
education_grading_system_oid   : Education Grading System oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_grading_system_detail
(
oid                            varchar(128)                                                not null,
start_marks                    numeric(5,2)                                                not null       default 0,
end_marks                      numeric(5,2)                                                not null       default 0,
letter_grade                   varchar(128),
grade_point                    numeric(5,2),
assessment                     varchar(128),
remarks                        varchar(128),
sort_order                     numeric(5,0)                                                not null       default 0,
status                         varchar(128),
education_grading_system_oid   varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_grading_system_detail                          primary key    (oid)
);

/*
Education Group Information (Science, Humanities, Bussiness Studies)
oid                            : Surrogate primary key
name_en                        : Education group name in english.
name_bn                        : Education group name in bangla.
status                         : [Active,Inactive]
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_group
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
status                         varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_group                                          primary key    (oid),
constraint                     fk_education_system_oid_education_group                     foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*
Education Curriculum Text Book Information
oid                            : Surrogate primary key
name_en                        : Education text book name in english.
name_bn                        : Education text book name in bangla.
subject_code                   : Subject code.
subject_type                   : [Compulsory,Fourth,Optional]
status                         : [Active,Inactive]
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".education_subject
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
subject_code                   varchar(128),
subject_type                   varchar(128),
status                         varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_education_subject                                        primary key    (oid),
constraint                     fk_education_system_oid_education_subject                   foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*
Education Curriculum Text Book Information
oid                            : Surrogate primary key
education_subject_oid          : Education subject oid
education_type_oid             : Education type oid
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".education_type_subject
(
oid                            varchar(128)                                                not null,
education_subject_oid          varchar(128),
education_type_oid             varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_education_type_subject                                   primary key    (oid),
constraint                     fk_education_subject_oid_education_type_subject             foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_education_type_oid_education_type_subject                foreign key    (education_type_oid)
                                                                                           references     "schoolerp".education_type(oid),
constraint                     fk_education_system_oid_education_type_subject              foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*
Education Curriculum Text Book Information
oid                            : Surrogate primary key
education_subject_oid          : Education subject oid
education_session_oid          : Education session oid
education_group_oid            : Education Group oid
education_class_oid            : Education class oid
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
subject_code                   : Subject code.
subject_type                   : [Compulsory,Fourth,Optional]
status                         : [Active,Inactive]
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".education_class_subject
(
oid                            varchar(128)                                                not null,
education_subject_oid          varchar(128),
education_session_oid          varchar(128),
education_group_oid            varchar(128),
education_class_oid            varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
subject_code                   varchar(128),
subject_type                   varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_education_class_subject                                  primary key    (oid),
constraint                     fk_education_subject_oid_education_class_subject            foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_education_session_oid_education_class_subject            foreign key    (education_session_oid)
                                                                                           references     "schoolerp".education_session(oid),
constraint                     fk_education_group_oid_education_class_subject              foreign key    (education_group_oid)
                                                                                           references     "schoolerp".education_group(oid),
constraint                     fk_education_class_oid_education_class_subject              foreign key    (education_class_oid)
                                                                                           references     "schoolerp".education_class(oid),
constraint                     fk_education_system_oid_education_class_subject             foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);

/*
Education Curriculum Text Book Information
oid                            : Surrogate primary key
name_en                        : Education text book name in english.
name_bn                        : Education text book name in bangla.
subject_code                   : Text book subject code.
e_book_link                    : Text book PDF Link
textbook_type                  : [Compulsory,Fourth]
mnemonic                       : Textbook mnemonic like Bangla I, Bangla II
status                         : []
education_subject_oid          : Education subject oid
education_session_oid          : Education session oid
education_version_oid          : Education version oid
education_group_oid            : Education Group oid
education_class_oid            : Education class oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".education_textbook
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
subject_code                   varchar(128),
e_book_link                    varchar(256),
textbook_type                  varchar(128),
mnemonic                       varchar(128),
status                         varchar(128),
education_subject_oid          varchar(128),
education_session_oid          varchar(128),
education_version_oid          varchar(128),
education_group_oid            varchar(128),
education_class_oid            varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_education_textbook                                       primary key    (oid),
constraint                     fk_education_subject_oid_education_textbook                 foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_education_session_oid_education_textbook                 foreign key    (education_session_oid)
                                                                                           references     "schoolerp".education_session(oid),
constraint                     fk_education_version_oid_education_textbook                 foreign key    (education_version_oid)
                                                                                           references     "schoolerp".education_version(oid),
constraint                     fk_education_group_oid_education_textbook                   foreign key    (education_group_oid)
                                                                                           references     "schoolerp".education_group(oid),
constraint                     fk_education_class_oid_education_textbook                   foreign key    (education_class_oid)
                                                                                           references     "schoolerp".education_class(oid)
);

/*
Education Shift Information (Morning, Evening)
oid                            : Surrogate primary key
name_en                        : Education group name in english.
name_bn                        : Education group name in bangla.
status                         : 
education_system_oid           : Education System oid
education_curriculum_oid       : Education Curriculum oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".education_shift
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
status                         varchar(128),
education_system_oid           varchar(128),
education_curriculum_oid       varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_education_shift                                          primary key    (oid),
constraint                     fk_education_system_oid_education_shift                     foreign key    (education_system_oid)
                                                                                           references     "schoolerp".education_system(oid)
);


