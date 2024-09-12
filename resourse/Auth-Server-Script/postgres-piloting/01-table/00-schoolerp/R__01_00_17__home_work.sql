/*

oid                            : Surrogate primary key
name_en                        : Example; Home Work - Date - Class 08 - Section A - TextBook Name
name_bn                        : Example; Home Work - Date - Class 08 - Section A - TextBook Name
description_en                 : Homework Describtion in English
description_bn                 : Homework Describtion in Bangla
assigned_date                  : 
submission_date                : 
teacher_oid                    : teacher Oid
education_subject_oid          : Education subject oid
class_textbook_oid             : Class Textbook Oid
institute_oid                  : Institute Oid 
institute_session_oid          : Institute session Oid 
institute_version_oid          : institute_version_oid
institute_shift_oid            : institute_shift_oid
institute_class_oid            : institute_class_oid
institute_class_section_oid    : institute_class_section_oid
status                         : [Running,Submitted]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".home_work
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256)                                                not null,
description_en                 text                                                        not null,
description_bn                 text                                                        not null,
assigned_date                  date,
submission_date                date,
teacher_oid                    varchar(128)                                                not null,
education_subject_oid          varchar(128),
class_textbook_oid             varchar(128),
institute_oid                  varchar(128)                                                not null,
institute_session_oid          varchar(128),
institute_version_oid          varchar(128),
institute_shift_oid            varchar(128),
institute_class_oid            varchar(128),
institute_class_section_oid    varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar,
updated_on                     timestamp,
constraint                     pk_home_work                                                primary key    (oid),
constraint                     fk_teacher_oid_home_work                                    foreign key    (teacher_oid)
                                                                                           references     "schoolerp".teacher(oid),
constraint                     fk_education_subject_oid_home_work                          foreign key    (education_subject_oid)
                                                                                           references     "schoolerp".education_subject(oid),
constraint                     fk_class_textbook_oid_home_work                             foreign key    (class_textbook_oid)
                                                                                           references     "schoolerp".institute_class_textbook(oid),
constraint                     fk_institute_oid_home_work                                  foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_home_work                          foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_version_oid_home_work                          foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid),
constraint                     fk_institute_shift_oid_home_work                            foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_class_oid_home_work                            foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_section_oid_home_work                    foreign key    (institute_class_section_oid)
                                                                                           references     "schoolerp".institute_class_section(oid)
);

/*

oid                            : Surrrogate primary key 
home_work_oid                  : Homework table oid
student_oid                    : studetnt table oid
student_id                     : studetnt table id
status                         : [Submitted,Unsubmitted]
assessment                     : [good,best,excellent]
remarks                        : Teacher will comments for each student
submission_date                : Home work submission date for each student
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".home_work_submission_history
(
oid                            varchar(128)                                                not null,
home_work_oid                  varchar(128),
student_oid                    varchar(128),
student_id                     varchar(128),
status                         varchar(128),
assessment                     varchar(128),
remarks                        text,
submission_date                date,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar,
updated_on                     timestamp,
constraint                     pk_home_work_submission_history                             primary key    (oid),
constraint                     fk_home_work_oid_home_work_submission_history               foreign key    (home_work_oid)
                                                                                           references     "schoolerp".home_work(oid),
constraint                     fk_student_oid_home_work_submission_history                 foreign key    (student_oid)
                                                                                           references     "schoolerp".student(oid),
constraint                     fk_student_id_home_work_submission_history                  foreign key    (student_id)
                                                                                           references     "schoolerp".student(student_id)
);


