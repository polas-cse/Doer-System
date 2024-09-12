/*

oid                            : Surrogate primary key
payment_code                   : Payment Selection mode code
name_en                        : Payment Selection mode name in english
name_bn                        : Payment Selection mode  name in bangla
payment_type                   : Payment Selection mode  type in bangla
remarks                        : amount of fee
status                         : [Active,Inactive]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".payment_mode
(
oid                            varchar(128)                                                not null,
payment_code                   varchar(128),
name_en                        varchar(128),
name_bn                        varchar(128),
payment_type                   varchar(128),
remarks                        varchar(256),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_payment_mode                                             primary key    (oid)
);

/*

oid                            : Surrogate primary key
group_code                     : fee code
name_en                        : fee head name in english
name_bn                        : fee head name in bangla
group_type                     : head type
remarks                        : notes
status                         : [Active,Inactive]
institute_oid                  : institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".fee_head_group
(
oid                            varchar(128)                                                not null,
group_code                     varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128)                                                not null,
group_type                     varchar(128),
remarks                        varchar(256),
status                         varchar(128),
institute_oid                  varchar(128)                                                not null,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_fee_head_group                                           primary key    (oid),
constraint                     fk_institute_oid_fee_head_group                             foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
head_code                      : fee code.
name_en                        : fee head name in english
name_bn                        : fee head name in bangla
head_type                      : [Monthly,One-Time, Multiple]
remarks                        : amount of fee
status                         : [Active,Inactive]
institute_oid                  : institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".fee_head
(
oid                            varchar(128)                                                not null,
head_code                      varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128)                                                not null,
head_type                      varchar(128)                                                not null,
remarks                        varchar(256),
status                         varchar(128),
institute_oid                  varchar(128)                                                not null,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_fee_head                                                 primary key    (oid),
constraint                     fk_institute_oid_fee_head                                   foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : fee head name in english
name_bn                        : fee head name in bangla
remarks                        : amount of fee
status                         : [Active,Inactive]
fee_head_oid                   : fee code
head_code                      : head type
institute_oid                  : institute table mapping
institute_class_oid            : institute class table mapping
session_oid                    : institute session
group_oid                      : institute oid
group_code                     : fee code
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".fee_head_group_mapping
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128)                                                not null,
remarks                        varchar(256),
status                         varchar(128),
fee_head_oid                   varchar(128)                                                not null,
head_code                      varchar(128)                                                not null,
institute_oid                  varchar(128)                                                not null,
institute_class_oid            varchar(128)                                                not null,
session_oid                    varchar(128)                                                not null,
group_oid                      varchar(128)                                                not null,
group_code                     varchar(128)                                                not null,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_fee_head_group_mapping                                   primary key    (oid),
constraint                     fk_fee_head_oid_fee_head_group_mapping                      foreign key    (fee_head_oid)
                                                                                           references     "schoolerp".fee_head(oid),
constraint                     fk_institute_oid_fee_head_group_mapping                     foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_class_oid_fee_head_group_mapping               foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_session_oid_fee_head_group_mapping                       foreign key    (session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_group_oid_fee_head_group_mapping                         foreign key    (group_oid)
                                                                                           references     "schoolerp".fee_head_group(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : fee name in english
name_bn                        : fee name in bangla
amount                         : amount of fee
remarks                        : remarks about specific fees or note if have
payment_last_date              : specific fees payment last date
status                         : [Active,Inactive]
fee_head_oid                   : fee code
head_code                      : fee code
institute_oid                  : institute table mapping
institute_class_oid            : institute class table mapping
session_oid                    : institute session
group_oid                      : institute oid
group_code                     : fee code
group_mapping_oid              : institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".fees_setting
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256)                                                not null,
amount                         numeric(20,2)                                                              default 0,
remarks                        varchar(256),
payment_last_date              timestamp,
status                         varchar(128),
fee_head_oid                   varchar(128)                                                not null,
head_code                      varchar(128)                                                not null,
institute_oid                  varchar(128)                                                not null,
institute_class_oid            varchar(128)                                                not null,
session_oid                    varchar(128)                                                not null,
group_oid                      varchar(128),
group_code                     varchar(128),
group_mapping_oid              varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_fees_setting                                             primary key    (oid),
constraint                     fk_fee_head_oid_fees_setting                                foreign key    (fee_head_oid)
                                                                                           references     "schoolerp".fee_head(oid),
constraint                     fk_institute_oid_fees_setting                               foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_class_oid_fees_setting                         foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_session_oid_fees_setting                                 foreign key    (session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_group_oid_fees_setting                                   foreign key    (group_oid)
                                                                                           references     "schoolerp".fee_head_group(oid),
constraint                     fk_group_mapping_oid_fees_setting                           foreign key    (group_mapping_oid)
                                                                                           references     "schoolerp".fee_head_group_mapping(oid)
);

/*

oid                            : Surrogate primary key
student_id                     : fee code
student_oid                    : fee code
head_code                      : fee code
fee_head_oid                   : fee code
session_oid                    : institute session
institute_oid                  : fee code
institute_class_oid            : fee code
application_tracking_id        : fee code
reference_no                   : fee code
due_amount                     : amount of fee
paid_amount                    : amount of fee
remarks                        : remarks about specific fees or note if have
status                         : [Active,Inactive]
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".due_fees
(
oid                            varchar(128)                                                not null,
student_id                     varchar(128),
student_oid                    varchar(128),
head_code                      varchar(128)                                                not null,
fee_head_oid                   varchar(128)                                                not null,
session_oid                    varchar(128)                                                not null,
institute_oid                  varchar(128)                                                not null,
institute_class_oid            varchar(128)                                                not null,
application_tracking_id        varchar(128),
reference_no                   varchar(128),
due_amount                     numeric(20,2)                                                              default 0,
paid_amount                    numeric(20,2)                                                              default 0,
remarks                        varchar(256),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_due_fees                                                 primary key    (oid),
constraint                     fk_student_oid_due_fees                                     foreign key    (student_oid)
                                                                                           references     "schoolerp".student(oid),
constraint                     fk_fee_head_oid_due_fees                                    foreign key    (fee_head_oid)
                                                                                           references     "schoolerp".fee_head(oid),
constraint                     fk_session_oid_due_fees                                     foreign key    (session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_oid_due_fees                                   foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_class_oid_due_fees                             foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid)
);

/*

oid                            : Surrogate primary key
due_amount                     : amount of fee
remarks                        : remarks about specific fees or note if have
status                         : [Active,Inactive]
due_fees_oid                   : fee code
head_code                      : fee code
fee_head_oid                   : fee code
session_oid                    : institute session
institute_oid                  : fee code
institute_class_oid            : fee code
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".due_fees_history
(
oid                            varchar(128)                                                not null,
due_amount                     numeric(20,2)                                                              default 0,
remarks                        varchar(256),
status                         varchar(128),
due_fees_oid                   varchar(128)                                                not null,
head_code                      varchar(128)                                                not null,
fee_head_oid                   varchar(128)                                                not null,
session_oid                    varchar(128)                                                not null,
institute_oid                  varchar(128)                                                not null,
institute_class_oid            varchar(128)                                                not null,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_due_fees_history                                         primary key    (oid),
constraint                     fk_due_fees_oid_due_fees_history                            foreign key    (due_fees_oid)
                                                                                           references     "schoolerp".due_fees(oid),
constraint                     fk_fee_head_oid_due_fees_history                            foreign key    (fee_head_oid)
                                                                                           references     "schoolerp".fee_head(oid),
constraint                     fk_session_oid_due_fees_history                             foreign key    (session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_oid_due_fees_history                           foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_class_oid_due_fees_history                     foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid)
);

/*

oid                            : Surrogate primary key
collection_date                : fees collection  time.
payment_code                   : fees code
total_waiver_amount            : waiver  amount
total_discount_amount          : discount amount of fees collection
due_amount                     : due amount of fees collection
paid_amount                    : paid amount of fees collection
total_amount                   : total amount amount of fees collection
remarks                        : amount of fee
status                         : [Pending, Due, Paid]
student_id                     : student table oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".fees_collection
(
oid                            varchar(128)                                                not null,
collection_date                timestamp,
payment_code                   varchar(128),
total_waiver_amount            numeric(20,2)                                                              default 0,
total_discount_amount          numeric(20,2)                                                              default 0,
due_amount                     numeric(20,2)                                                              default 0,
paid_amount                    numeric(20,2)                                                              default 0,
total_amount                   numeric(20,2)                                                              default 0,
remarks                        varchar(256),
status                         varchar(128),
student_id                     varchar(128)                                                not null,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_fees_collection                                          primary key    (oid)
);

/*

oid                            : Surrogate primary key
payment_type                   : fee code
reference_no                   : fee code
waiver_percentage              : waiver percentage on fees
waiver_amount                  : waiver  amount
discount_amount                : discount amount of fees collection
due_amount                     : due amount of fees collection
paid_amount                    : due amount of fees collection
status                         : [Active, Inactive]
head_code                      : fees_collection table oid
due_fees_oid                   : Payment mode code
fees_collection_oid            : Payment mode code
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".fees_collection_detail
(
oid                            varchar(128)                                                not null,
payment_type                   varchar(128),
reference_no                   varchar(128),
waiver_percentage              numeric(20,2)                                                              default 0,
waiver_amount                  numeric(20,2)                                                              default 0,
discount_amount                numeric(20,2)                                                              default 0,
due_amount                     numeric(20,2)                                                              default 0,
paid_amount                    numeric(20,2)                                                              default 0,
status                         varchar(128),
head_code                      varchar(128),
due_fees_oid                   varchar(128)                                                not null,
fees_collection_oid            varchar(128)                                                not null,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_fees_collection_detail                                   primary key    (oid),
constraint                     fk_due_fees_oid_fees_collection_detail                      foreign key    (due_fees_oid)
                                                                                           references     "schoolerp".due_fees(oid),
constraint                     fk_fees_collection_oid_fees_collection_detail               foreign key    (fees_collection_oid)
                                                                                           references     "schoolerp".fees_collection(oid)
);


