/*

oid                            : Surrogate primary key
attendance_date                : 
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_class_oid            : Institute class oid
institute_class_section_oid    : Institute class section oid
institute_class_group_oid      : Institute Group oid
institute_shift_oid            : Institute shift oid
institute_version_oid          : Institute version oid
teacher_oid                    : Teacher oid
class_textbook_oid             : Class period oid
class_period_oid               : Class period oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".student_attendance
(
oid                            varchar(128)                                                not null,
attendance_date                date,
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_class_oid            varchar(128),
institute_class_section_oid    varchar(128),
institute_class_group_oid      varchar(128),
institute_shift_oid            varchar(128),
institute_version_oid          varchar(128),
teacher_oid                    varchar(128),
class_textbook_oid             varchar(128),
class_period_oid               varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_student_attendance                                       primary key    (oid),
constraint                     fk_institute_oid_student_attendance                         foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_student_attendance                 foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_oid_student_attendance                   foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_section_oid_student_attendance           foreign key    (institute_class_section_oid)
                                                                                           references     "schoolerp".institute_class_section(oid),
constraint                     fk_institute_class_group_oid_student_attendance             foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_shift_oid_student_attendance                   foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_version_oid_student_attendance                 foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid),
constraint                     fk_teacher_oid_student_attendance                           foreign key    (teacher_oid)
                                                                                           references     "schoolerp".teacher(oid),
constraint                     fk_class_textbook_oid_student_attendance                    foreign key    (class_textbook_oid)
                                                                                           references     "schoolerp".institute_class_textbook(oid),
constraint                     fk_class_period_oid_student_attendance                      foreign key    (class_period_oid)
                                                                                           references     "schoolerp".class_period(oid)
);

/*

oid                            : Surrogate primary key
student_id                     : Student Id
student_oid                    : Student oid
student_attendance_oid         : Student attendance oid
status                         : [Present,Absent]
created_by                     : Who created request
created_on                     : When reqeust created
*/
create table                   "schoolerp".student_attendance_detail
(
oid                            varchar(128)                                                not null,
student_id                     varchar(128),
student_oid                    varchar(128),
student_attendance_oid         varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
constraint                     pk_student_attendance_detail                                primary key    (oid),
constraint                     fk_student_oid_student_attendance_detail                    foreign key    (student_oid)
                                                                                           references     "schoolerp".student(oid),
constraint                     fk_student_attendance_oid_student_attendance_detail         foreign key    (student_attendance_oid)
                                                                                           references     "schoolerp".student_attendance(oid)
);


