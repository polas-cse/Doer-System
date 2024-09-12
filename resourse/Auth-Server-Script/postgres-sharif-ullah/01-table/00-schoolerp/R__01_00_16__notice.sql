/*

oid                            : Surrogate primary key
name_en                        : Topic of notice english Name 
name_bn                        : Topic of notice Bangla Name 
description_en                 : Notice Describtion in English
description_bn                 : Notice Describtion in Bangla
notice_en_path                 : Notice Path for english version file
notice_en_url                  : Notice Url for english version file
notice_bn_path                 : Notice Path for bangla version file
notice_bn_url                  : Notice Path for bangla version file
published_date                 : Notice Published Date
expiry_date                    : Notice Expiry Date
institute_oid                  : Institute Oid 
session_oid                    : Institute session Oid 
status                         : [Pending,Submitted,Approved,Published]
published_by                   : Who Publish This Notice
published_on                   : Who Publish This Notice
approved_by                    : Who Approved This Notice
approved_on                    : Who Approved This Notice
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".notice
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128)                                                not null,
description_en                 text                                                        not null,
description_bn                 text                                                        not null,
notice_en_path                 varchar(512),
notice_en_url                  varchar(512),
notice_bn_path                 varchar(512),
notice_bn_url                  varchar(512),
published_date                 varchar(128),
expiry_date                    varchar(128),
institute_oid                  varchar(128)                                                not null,
session_oid                    varchar(128)                                                not null,
status                         varchar(128),
published_by                   varchar(128),
published_on                   varchar(128),
approved_by                    varchar(128),
approved_on                    varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_notice                                                   primary key    (oid),
constraint                     fk_institute_oid_notice                                     foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_session_oid_notice                                       foreign key    (session_oid)
                                                                                           references     "schoolerp".institute_session(oid)
);


