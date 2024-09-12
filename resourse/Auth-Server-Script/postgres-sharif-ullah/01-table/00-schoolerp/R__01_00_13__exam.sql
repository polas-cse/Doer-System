/*

oid                            : Surrogate primary key
name_en                        : Education system name in english.
name_bn                        : Education system name in bangla.
start_date                     : Shift start time.
end_date                       : Shift end time.
exam_type                      : [Term-Exam, Test-Exam, Class-Test-Exam]
status                         : [Draft,Submitted,Approved,Rejected,Published,Closed]
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".exam
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
start_date                     varchar(128),
end_date                       varchar(128),
exam_type                      varchar(128),
status                         varchar(128),
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_exam                                                     primary key    (oid),
constraint                     fk_institute_oid_exam                                       foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_exam                               foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid)
);

/*

oid                            : Surrogate primary key
start_time                     : Shift start time.
end_time                       : Shift end time.
exam_duration                  : Shift end time.
exam_oid                       : Exam oid 
status                         : [Active,Inactive]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".exam_time
(
oid                            varchar(128)                                                not null,
start_time                     varchar(128),
end_time                       varchar(128),
exam_duration                  varchar(128),
exam_oid                       varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_exam_time                                                primary key    (oid),
constraint                     fk_exam_oid_exam_time                                       foreign key    (exam_oid)
                                                                                           references     "schoolerp".exam(oid)
);

/*

oid                            : Surrogate primary key
exam_oid                       : Exam oid 
institute_class_oid            : Institute class oid
grading_system_oid             : Education grading system oid 
no_of_student                  : No of total section in class.
status                         : [Active,Inactive]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".exam_class
(
oid                            varchar(128)                                                not null,
exam_oid                       varchar(128),
institute_class_oid            varchar(128),
grading_system_oid             varchar(128),
no_of_student                  numeric(5,0)                                                               default 0,
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_exam_class                                               primary key    (oid),
constraint                     fk_exam_oid_exam_class                                      foreign key    (exam_oid)
                                                                                           references     "schoolerp".exam(oid),
constraint                     fk_institute_class_oid_exam_class                           foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_grading_system_oid_exam_class                            foreign key    (grading_system_oid)
                                                                                           references     "schoolerp".institute_grading_system(oid)
);

/*

oid                            : Surrogate primary key
exam_date                      : Shift start time.
exam_oid                       : Exam oid 
exam_class_oid                 : Exam class oid 
exam_time_oid                  : Exam class oid 
class_textbook_oid             : Institute class textbook oid
total_marks                    : 
status                         : [Active,Inactive]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".exam_routine
(
oid                            varchar(128)                                                not null,
exam_date                      varchar(128),
exam_oid                       varchar(128),
exam_class_oid                 varchar(128),
exam_time_oid                  varchar(128),
class_textbook_oid             varchar(128),
total_marks                    numeric(32,0)                                                              default 0,
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_exam_routine                                             primary key    (oid),
constraint                     fk_exam_oid_exam_routine                                    foreign key    (exam_oid)
                                                                                           references     "schoolerp".exam(oid),
constraint                     fk_exam_class_oid_exam_routine                              foreign key    (exam_class_oid)
                                                                                           references     "schoolerp".exam_class(oid),
constraint                     fk_exam_time_oid_exam_routine                               foreign key    (exam_time_oid)
                                                                                           references     "schoolerp".exam_time(oid)
);


