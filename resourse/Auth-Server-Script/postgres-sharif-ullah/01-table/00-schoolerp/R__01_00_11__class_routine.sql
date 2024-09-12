/*

oid                            : Surrogate primary key
institute_oid                  : Institute oid
institute_shift_oid            : Institute shift oid
institute_session_oid          : Institute session oid
institute_class_oid            : Institute class oid
institute_class_section_oid    : Institute class section oid
institute_class_group_oid      : Institute Group oid
institute_version_oid          : Institute version oid
status                         : [Active, Inactive]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".class_routine
(
oid                            varchar(128)                                                not null,
institute_oid                  varchar(128),
institute_shift_oid            varchar(128),
institute_session_oid          varchar(128),
institute_class_oid            varchar(128),
institute_class_section_oid    varchar(128),
institute_class_group_oid      varchar(128),
institute_version_oid          varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_class_routine                                            primary key    (oid),
constraint                     fk_institute_oid_class_routine                              foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_shift_oid_class_routine                        foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_session_oid_class_routine                      foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_oid_class_routine                        foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_section_oid_class_routine                foreign key    (institute_class_section_oid)
                                                                                           references     "schoolerp".institute_class_section(oid),
constraint                     fk_institute_class_group_oid_class_routine                  foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_version_oid_class_routine                      foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid)
);

/*

oid                            : Surrogate primary key
week_day_oid                   : Week day oid
class_period_oid               : Class period oid
education_subject_oid          : Education subject oid
class_textbook_oid             : Class period oid
teacher_oid                    : Teacher oid
class_routine_oid              : Class routine oid
created_by                     : Who created request
created_on                     : When reqeust created
*/
create table                   "schoolerp".class_routine_detail
(
oid                            varchar(128)                                                not null,
week_day_oid                   varchar(128),
class_period_oid               varchar(128),
education_subject_oid          varchar(128),
class_textbook_oid             varchar(128),
teacher_oid                    varchar(128),
class_routine_oid              varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
constraint                     pk_class_routine_detail                                     primary key    (oid),
constraint                     fk_week_day_oid_class_routine_detail                        foreign key    (week_day_oid)
                                                                                           references     "schoolerp".week_day(oid),
constraint                     fk_class_period_oid_class_routine_detail                    foreign key    (class_period_oid)
                                                                                           references     "schoolerp".class_period(oid),
constraint                     fk_education_subject_oid_class_routine_detail               foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_class_textbook_oid_class_routine_detail                  foreign key    (class_textbook_oid)
                                                                                           references     "schoolerp".institute_class_textbook(oid),
constraint                     fk_teacher_oid_class_routine_detail                         foreign key    (teacher_oid)
                                                                                           references     "schoolerp".teacher(oid),
constraint                     fk_class_routine_oid_class_routine_detail                   foreign key    (class_routine_oid)
                                                                                           references     "schoolerp".class_routine(oid)
);


