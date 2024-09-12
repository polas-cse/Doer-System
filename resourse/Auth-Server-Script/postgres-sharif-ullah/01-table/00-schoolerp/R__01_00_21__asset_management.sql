/*

oid                            : Surrogate primary key
asset_id                       : Asset unique identification number.
name_en                        : Asset name in english.
name_bn                        : Asset name in bangla.
asset_type                     : []
quantity                       : 
founded                        : 
asset_nature                   : [Rent,Institute,Both]
status                         : [Active,Inactive]
remarks                        : 
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".asset
(
oid                            varchar(128)                                                not null,
asset_id                       varchar(128),
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
asset_type                     varchar(128),
quantity                       numeric(5,0)                                                not null       default 0,
founded                        varchar(128),
asset_nature                   varchar(128),
status                         varchar(128),
remarks                        text,
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_asset                                                    primary key    (oid),
constraint                     fk_institute_oid_asset                                      foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Asset detail name in english.
name_bn                        : Asset detail name in bangla.
asset_detail_id                : Asset unique identification number.
asset_nature                   : [Rent,Institute,Both]
status                         : [Active,Inactive]
description                    : 
remarks                        : 
asset_oid                      : Asset table oid.
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".asset_details
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
asset_detail_id                varchar(128),
asset_nature                   varchar(128),
status                         varchar(128),
description                    text,
remarks                        text,
asset_oid                      varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_asset_details                                            primary key    (oid),
constraint                     fk_asset_oid_asset_details                                  foreign key    (asset_oid)
                                                                                           references     "schoolerp".asset(oid),
constraint                     fk_institute_oid_asset_details                              foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
asset_details_oid              : 
asset_oid                      : Asset table oid.
asset_holder_oid               : 
rent_amount                    : 
advance_amount                 : 
current_advance_amount         : 
payment_mode                   : [Yearly, Half Yearly, Quaterly, Monthly, One Time]
adjustment_advance_with_rent   : 
contract_date                  : 
commencement_date              : 
end_date_of_contract           : 
closing_date                   : 
aggrement_doc_json             : [{"documentName":"","documentPath":"","documentUrl":""},{"documentName":"","documentPath":"","documentUrl":""},{"documentName":"","documentPath":"","documentUrl":""}]
status                         : [Active,Inactive]
remarks                        : 
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".asset_allocation
(
oid                            varchar(128)                                                not null,
asset_details_oid              varchar(128)                                                not null,
asset_oid                      varchar(128),
asset_holder_oid               varchar(128),
rent_amount                    numeric(20,2)                                                              default 0,
advance_amount                 numeric(20,2)                                                              default 0,
current_advance_amount         numeric(20,2)                                                              default 0,
payment_mode                   varchar(128),
adjustment_advance_with_rent   numeric(20,2)                                                              default 0,
contract_date                  date,
commencement_date              date,
end_date_of_contract           date,
closing_date                   date,
aggrement_doc_json             text,
status                         varchar(128),
remarks                        text,
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_asset_allocation                                         primary key    (oid),
constraint                     fk_asset_details_oid_asset_allocation                       foreign key    (asset_details_oid)
                                                                                           references     "schoolerp".asset_details(oid),
constraint                     fk_asset_oid_asset_allocation                               foreign key    (asset_oid)
                                                                                           references     "schoolerp".asset(oid),
constraint                     fk_asset_holder_oid_asset_allocation                        foreign key    (asset_holder_oid)
                                                                                           references     "schoolerp".people(oid),
constraint                     fk_institute_oid_asset_allocation                           foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
asset_details_oid              : 
asset_oid                      : Asset table oid.
asset_holder_oid               : 
rent_amount                    : 
advance_amount                 : 
current_advance_amount         : 
payment_mode                   : [Yearly, Half Yearly, Quaterly, Monthly]
adjustment_advance_with_rent   : 
contract_date                  : 
commencement_date              : 
end_date_of_contract           : 
closing_date                   : 
status                         : [Active,Inactive]
remarks                        : 
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".asset_allocation_history
(
oid                            varchar(128)                                                not null,
asset_details_oid              varchar(128)                                                not null,
asset_oid                      varchar(128),
asset_holder_oid               varchar(128),
rent_amount                    numeric(20,2)                                               not null       default 0,
advance_amount                 numeric(20,2)                                                              default 0,
current_advance_amount         numeric(20,2)                                                              default 0,
payment_mode                   varchar(128),
adjustment_advance_with_rent   numeric(20,2)                                                              default 0,
contract_date                  date,
commencement_date              date,
end_date_of_contract           date,
closing_date                   date,
status                         varchar(128),
remarks                        text,
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_asset_allocation_history                                 primary key    (oid),
constraint                     fk_asset_details_oid_asset_allocation_history               foreign key    (asset_details_oid)
                                                                                           references     "schoolerp".asset_details(oid),
constraint                     fk_asset_oid_asset_allocation_history                       foreign key    (asset_oid)
                                                                                           references     "schoolerp".asset(oid),
constraint                     fk_asset_holder_oid_asset_allocation_history                foreign key    (asset_holder_oid)
                                                                                           references     "schoolerp".people(oid),
constraint                     fk_institute_oid_asset_allocation_history                   foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
asset_income_id                : Asset income title in english.
title_en                       : Asset income title in english.
title_bn                       : Asset income title in bangla.
issue_date                     : 
due_date                       : 
rent_amount                    : 
paid_amount                    : 
due_amount                     : 
status                         : [Due,Paid,Partially Paid]
remarks                        : 
asset_holder_oid               : 
asset_details_oid              : Asset detail name in english.
asset_oid                      : Asset detail name in bangla.
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".asset_income
(
oid                            varchar(128)                                                not null,
asset_income_id                varchar(128)                                                not null,
title_en                       varchar(128)                                                not null,
title_bn                       varchar(128),
issue_date                     date,
due_date                       date,
rent_amount                    numeric(20,2)                                               not null       default 0,
paid_amount                    numeric(20,2)                                                              default 0,
due_amount                     numeric(20,2)                                                              default 0,
status                         varchar(128),
remarks                        text,
asset_holder_oid               varchar(128),
asset_details_oid              varchar(128)                                                not null,
asset_oid                      varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_asset_income                                             primary key    (oid),
constraint                     fk_asset_holder_oid_asset_income                            foreign key    (asset_holder_oid)
                                                                                           references     "schoolerp".people(oid),
constraint                     fk_asset_details_oid_asset_income                           foreign key    (asset_details_oid)
                                                                                           references     "schoolerp".asset_details(oid),
constraint                     fk_asset_oid_asset_income                                   foreign key    (asset_oid)
                                                                                           references     "schoolerp".asset(oid),
constraint                     fk_institute_oid_asset_income                               foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
income_collection_id           : 
collection_date                : 
payment_mode                   : [Cash, Bank]
received_amount                : 
adjustment_advance_amount      : 
total_received_amount          : 
status                         : [Due,Paid,Partially Paid]
remarks                        : 
asset_holder_oid               : 
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".income_collection
(
oid                            varchar(128)                                                not null,
income_collection_id           varchar(128)                                                not null,
collection_date                date,
payment_mode                   varchar(128),
received_amount                numeric(20,2)                                                              default 0,
adjustment_advance_amount      numeric(20,2)                                                              default 0,
total_received_amount          numeric(20,2)                                                              default 0,
status                         varchar(128),
remarks                        text,
asset_holder_oid               varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_income_collection                                        primary key    (oid),
constraint                     fk_asset_holder_oid_income_collection                       foreign key    (asset_holder_oid)
                                                                                           references     "schoolerp".people(oid),
constraint                     fk_institute_oid_income_collection                          foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
received_amount                : 
adjustment_advance_amount      : 
total_received_amount          : 
status                         : [Due,Paid,Partially Paid]
remarks                        : 
income_collection_oid          : 
asset_income_oid               : 
asset_details_oid              : 
asset_oid                      : 
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".income_collection_detail
(
oid                            varchar(128)                                                not null,
received_amount                numeric(20,2)                                                              default 0,
adjustment_advance_amount      numeric(20,2)                                                              default 0,
total_received_amount          numeric(20,2)                                                              default 0,
status                         varchar(128),
remarks                        text,
income_collection_oid          varchar(128),
asset_income_oid               varchar(128),
asset_details_oid              varchar(128),
asset_oid                      varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_income_collection_detail                                 primary key    (oid),
constraint                     fk_income_collection_oid_income_collection_detail           foreign key    (income_collection_oid)
                                                                                           references     "schoolerp".income_collection(oid),
constraint                     fk_asset_income_oid_income_collection_detail                foreign key    (asset_income_oid)
                                                                                           references     "schoolerp".asset_income(oid),
constraint                     fk_asset_details_oid_income_collection_detail               foreign key    (asset_details_oid)
                                                                                           references     "schoolerp".asset_details(oid),
constraint                     fk_asset_oid_income_collection_detail                       foreign key    (asset_oid)
                                                                                           references     "schoolerp".asset(oid),
constraint                     fk_institute_oid_income_collection_detail                   foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);


