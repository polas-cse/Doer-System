/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name_en                        : Bank name in english.
name_bn                        : Bank name in bangla.
hotline_number                 : 
contact_number                 : 
fax                            : 
head_office                    : 
website                        : Bank web link
email                          : Bank email address
bank_type                      : [Local,Foreign]
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who last update the role
updated_on                     : When it was updated
*/
create table                   "schoolerp".bank
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
hotline_number                 varchar(128),
contact_number                 varchar(128),
fax                            varchar(128),
head_office                    varchar(128),
website                        varchar(128),
email                          varchar(128),
bank_type                      varchar(128)                                                               default 'Local',
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_bank                                                     primary key    (oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
account_holder_name_en         : Account holder name in english.
account_holder_name_bn         : Account holder name in bangla.
account_type                   : Savings, Current etc
account_number                 : Bank account number.
opening_balance                : 
mobile_no                      : Account holder mobile no.
email                          : Account holder email address.
bank_oid                       : Bank Oid
branch_name                    : Bank branch name.
status                         : [Active, Inactive]
institute_oid                  : Institute Oid
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who last update the role
updated_on                     : When it was updated
*/
create table                   "schoolerp".bank_account
(
oid                            varchar(128)                                                not null,
account_holder_name_en         varchar(256)                                                not null,
account_holder_name_bn         varchar(256),
account_type                   varchar(128),
account_number                 varchar(128),
opening_balance                numeric(20,2)                                                              default 0,
mobile_no                      varchar(128),
email                          varchar(128),
bank_oid                       varchar(128),
branch_name                    varchar(128),
status                         varchar(128),
institute_oid                  varchar(128)                                                not null       default '',
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_bank_account                                             primary key    (oid),
constraint                     fk_bank_oid_bank_account                                    foreign key    (bank_oid)
                                                                                           references     "schoolerp".bank(oid),
constraint                     fk_institute_oid_bank_account                               foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);


