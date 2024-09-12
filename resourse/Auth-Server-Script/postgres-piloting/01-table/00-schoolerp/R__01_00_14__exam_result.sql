/*

oid                            : Surrogate primary key
exam_oid                       : Exam oid 
institute_session_oid          : Institute session oid
institute_oid                  : Institute oid
approved_by                    : Who approved request
approved_on                    : When reqeust approved
published_by                   : Who published request
published_on                   : When reqeust published
status                         : [Pending,Submitted,Approved,Published]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".exam_result
(
oid                            varchar(128)                                                not null,
exam_oid                       varchar(128),
institute_session_oid          varchar(128),
institute_oid                  varchar(128),
approved_by                    varchar(128),
approved_on                    timestamp,
published_by                   varchar(128),
published_on                   timestamp,
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_exam_result                                              primary key    (oid),
constraint                     fk_exam_oid_exam_result                                     foreign key    (exam_oid)
                                                                                           references     "schoolerp".exam(oid),
constraint                     fk_institute_session_oid_exam_result                        foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_oid_exam_result                                foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
exam_oid                       : Exam oid 
exam_result_oid                : Exam result oid 
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_class_oid            : Institute class oid
institute_class_group_oid      : Institute Group oid
institute_class_section_oid    : Institute class section oid
institute_shift_oid            : Institute shift oid
institute_version_oid          : Institute version oid
grading_system_oid             : Institute grading system oid 
approved_by                    : Who approved request
approved_on                    : When reqeust approved
published_by                   : Who published request
published_on                   : When reqeust published
status                         : [Pending,Submitted,Approved,Published]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".exam_result_detail
(
oid                            varchar(128)                                                not null,
exam_oid                       varchar(128),
exam_result_oid                varchar(128),
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_class_oid            varchar(128),
institute_class_group_oid      varchar(128),
institute_class_section_oid    varchar(128),
institute_shift_oid            varchar(128),
institute_version_oid          varchar(128),
grading_system_oid             varchar(128),
approved_by                    varchar(128),
approved_on                    timestamp,
published_by                   varchar(128),
published_on                   timestamp,
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_exam_result_detail                                       primary key    (oid),
constraint                     fk_exam_oid_exam_result_detail                              foreign key    (exam_oid)
                                                                                           references     "schoolerp".exam(oid),
constraint                     fk_exam_result_oid_exam_result_detail                       foreign key    (exam_result_oid)
                                                                                           references     "schoolerp".exam_result(oid),
constraint                     fk_institute_oid_exam_result_detail                         foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_exam_result_detail                 foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_oid_exam_result_detail                   foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_group_oid_exam_result_detail             foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_class_section_oid_exam_result_detail           foreign key    (institute_class_section_oid)
                                                                                           references     "schoolerp".institute_class_section(oid),
constraint                     fk_institute_shift_oid_exam_result_detail                   foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_version_oid_exam_result_detail                 foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid),
constraint                     fk_grading_system_oid_exam_result_detail                    foreign key    (grading_system_oid)
                                                                                           references     "schoolerp".institute_grading_system(oid)
);

/*

oid                            : Surrogate primary key
exam_oid                       : Exam oid 
exam_result_detail_oid         : Exam oid 
institute_oid                  : Institute oid
institute_class_oid            : Institute class oid
institute_class_section_oid    : Institute class section oid
student_id                     : Student Id
education_subject_oid          : Education subject oid
class_textbook_oid             : Institute class textbook oid
total_marks                    : 
obtained_marks                 : 
letter_grade                   : Letter grade like A+, A, A-, B, C, D, F
grade_point                    : Grade point lke 5, 4, 3.5, 3, 2, 1, 0
assessment                     : Assessment like Excellent, Very Good, Good, Above Average, Average, Below Average, Poor, Pass, Fail
status                         : [Present,Absent]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".exam_result_marks
(
oid                            varchar(128)                                                not null,
exam_oid                       varchar(128),
exam_result_detail_oid         varchar(128),
institute_oid                  varchar(128),
institute_class_oid            varchar(128),
institute_class_section_oid    varchar(128),
student_id                     varchar(128),
education_subject_oid          varchar(128),
class_textbook_oid             varchar(128),
total_marks                    numeric(32,0)                                                              default 0,
obtained_marks                 numeric(32,0)                                                              default 0,
letter_grade                   varchar(128),
grade_point                    numeric(5)                                                                 default 0,
assessment                     varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_exam_result_marks                                        primary key    (oid),
constraint                     fk_exam_oid_exam_result_marks                               foreign key    (exam_oid)
                                                                                           references     "schoolerp".exam(oid),
constraint                     fk_exam_result_detail_oid_exam_result_marks                 foreign key    (exam_result_detail_oid)
                                                                                           references     "schoolerp".exam_result_detail(oid),
constraint                     fk_institute_oid_exam_result_marks                          foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_class_oid_exam_result_marks                    foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_section_oid_exam_result_marks            foreign key    (institute_class_section_oid)
                                                                                           references     "schoolerp".institute_class_section(oid),
constraint                     fk_education_subject_oid_exam_result_marks                  foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid)
);


