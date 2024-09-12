/*

oid                            : Surrogate primary key
expense_no                     : 
expense_date                   : 
expense_make_by                : 
payment_mode                   : [Cash,Bank]
expense_amount                 : 
paid_amount                    : 
due_amount                     : 
expense_doc_json               : [{"documentName": SSC "Certificate", "name": "ssc_certificate_85858.jpg", "path":"", "url":""}, {"documentName": HSC "Certificate", "name": "hsc_certificate_85858.jpg", "path":"", "url":""}]
status                         : [Due,Paid,Partially Paid]
remarks                        : 
financial_period_oid           : 
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".expense
(
oid                            varchar(128)                                                not null,
expense_no                     varchar(128),
expense_date                   date,
expense_make_by                varchar(128),
payment_mode                   varchar(128),
expense_amount                 numeric(20,2)                                                              default 0,
paid_amount                    numeric(20,2)                                                              default 0,
due_amount                     numeric(20,2)                                                              default 0,
expense_doc_json               text                                                                       default '[]',
status                         varchar(128),
remarks                        text,
financial_period_oid           varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_expense                                                  primary key    (oid),
constraint                     fk_financial_period_oid_expense                             foreign key    (financial_period_oid)
                                                                                           references     "schoolerp".financial_period(oid),
constraint                     fk_institute_oid_expense                                    foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
expense_date                   : 
description                    : 
expense_amount                 : 
sort_order                     : Sorting processor for asc/desc
status                         : [Due,Paid,Partially Paid]
remarks                        : 
ledger_oid                     : ledger oid
expense_oid                    : expense oid
financial_period_oid           : financial period oid
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".expense_detail
(
oid                            varchar(128)                                                not null,
expense_date                   date,
description                    text,
expense_amount                 numeric(20,2)                                                              default 0,
sort_order                     numeric(5,0)                                                               default 0,
status                         varchar(128),
remarks                        text,
ledger_oid                     varchar(128),
expense_oid                    varchar(128),
financial_period_oid           varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_expense_detail                                           primary key    (oid),
constraint                     fk_ledger_oid_expense_detail                                foreign key    (ledger_oid)
                                                                                           references     "schoolerp".ledger(oid),
constraint                     fk_expense_oid_expense_detail                               foreign key    (expense_oid)
                                                                                           references     "schoolerp".expense(oid),
constraint                     fk_financial_period_oid_expense_detail                      foreign key    (financial_period_oid)
                                                                                           references     "schoolerp".financial_period(oid),
constraint                     fk_institute_oid_expense_detail                             foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
reference_type                 : [Due,Paid,Partially Paid]
reference_oid                  : [Due,Paid,Partially Paid]
expense_by_name                : [Due,Paid,Partially Paid]
expense_oid                    : expense oid
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".expense_by
(
oid                            varchar(128)                                                not null,
reference_type                 varchar(128),
reference_oid                  varchar(128),
expense_by_name                varchar(128),
expense_oid                    varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_expense_by                                               primary key    (oid),
constraint                     fk_expense_oid_expense_by                                   foreign key    (expense_oid)
                                                                                           references     "schoolerp".expense(oid),
constraint                     fk_institute_oid_expense_by                                 foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);


