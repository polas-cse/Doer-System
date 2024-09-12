/*

oid                            : Surrogate primary key
name_en                        : Ledger sub group name in english.
name_bn                        : Ledger sub group name in bangla.
period_type                    : [Yearly, Half Yearly, Quaterly, Monthly]
period_start_date              : 
period_end_date                : 
version_id                     : 
status                         : [Opened,Closed]
institute_oid                  : Institute Oid
created_by                     : When was created
created_on                     : Who was created
updated_by                     : When was edited
updated_on                     : Who was edited
*/
create table                   "schoolerp".financial_period
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
period_type                    varchar(128),
period_start_date              date,
period_end_date                date,
version_id                     varchar(128),
status                         varchar(128),
institute_oid                  varchar(128)                                                not null       default '',
created_by                     timestamp                                                   not null       default current_timestamp,
created_on                     varchar(64)                                                 not null       default 'System',
updated_by                     timestamp,
updated_on                     varchar(64),
constraint                     pk_financial_period                                         primary key    (oid),
constraint                     fk_institute_oid_financial_period                           foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Ledger group name in english.
name_bn                        : Ledger group name in bangla.
ledger_group_code              : 
ledger_group_type              : 
is_balance_sheet_item          : 
created_by                     : When was created
created_on                     : Who was created
updated_by                     : When was edited
updated_on                     : Who was edited
*/
create table                   "schoolerp".ledger_group
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
ledger_group_code              varchar(2),
ledger_group_type              varchar(16)                                                 not null,
is_balance_sheet_item          varchar(8)                                                  not null       default 'No',
created_by                     timestamp                                                   not null       default current_timestamp,
created_on                     varchar(64)                                                 not null       default 'System',
updated_by                     timestamp,
updated_on                     varchar(64),
constraint                     pk_ledger_group                                             primary key    (oid),
constraint                     ck_is_balance_sheet_item_ledger_group                       check          (is_balance_sheet_item = 'Yes' or is_balance_sheet_item = 'No')
);

/*

oid                            : Surrogate primary key
name_en                        : Ledger sub group name in english.
name_bn                        : Ledger sub group name in bangla.
ledger_sub_group_code          : 
ledger_sub_group_type          : 
is_balance_sheet_item          : 
ledger_group_code              : 
version_id                     : 
status                         : 
ledger_group_oid               : 
institute_oid                  : Institute oid
created_by                     : When was created
created_on                     : Who was created
updated_by                     : When was edited
updated_on                     : Who was edited
*/
create table                   "schoolerp".ledger_sub_group
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
ledger_sub_group_code          varchar(4)                                                  not null,
ledger_sub_group_type          varchar(64)                                                 not null,
is_balance_sheet_item          varchar(8)                                                  not null       default 'No',
ledger_group_code              varchar(32)                                                 not null,
version_id                     varchar(4)                                                                 default '1',
status                         varchar(32)                                                 not null       default 'Active',
ledger_group_oid               varchar(64)                                                 not null,
institute_oid                  varchar(128),
created_by                     timestamp                                                   not null       default current_timestamp,
created_on                     varchar(64)                                                 not null       default 'System',
updated_by                     timestamp,
updated_on                     varchar(64),
constraint                     pk_ledger_sub_group                                         primary key    (oid),
constraint                     ck_is_balance_sheet_item_ledger_sub_group                   check          (is_balance_sheet_item = 'Yes' or is_balance_sheet_item = 'No'),
constraint                     ck_status_ledger_sub_group                                  check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledger_group_oid_ledger_sub_group                        foreign key    (ledger_group_oid)
                                                                                           references     "schoolerp".ledger_group(oid),
constraint                     fk_institute_oid_ledger_sub_group                           foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
name_en                        : Ledger sub group name in english.
name_bn                        : Ledger sub group name in bangla.
ledger_code                    : 
mnemonic                       : 
ledger_type                    : 
is_balance_sheet_item          : 
ledger_balance                 : 
opening_balance                : 
closing_balance                : -
ledger_sub_group_code          : -
version_id                     : -
status                         : -
ledger_sub_group_oid           : 
institute_oid                  : Institute oid
created_by                     : When was created
created_on                     : Who was created
updated_by                     : When was edited
updated_on                     : Who was edited
*/
create table                   "schoolerp".ledger
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
ledger_code                    varchar(32)                                                 not null,
mnemonic                       varchar(64),
ledger_type                    varchar(8)                                                  not null,
is_balance_sheet_item          varchar(8)                                                  not null       default 'No',
ledger_balance                 numeric(20,2)                                               not null       default 0,
opening_balance                numeric(20,2)                                                              default 0,
closing_balance                numeric(20,2)                                                              default 0,
ledger_sub_group_code          varchar(4)                                                  not null,
version_id                     varchar(4)                                                  not null       default '1',
status                         varchar(32)                                                 not null       default 'Active',
ledger_sub_group_oid           varchar(128)                                                not null,
institute_oid                  varchar(128),
created_by                     timestamp                                                   not null       default current_timestamp,
created_on                     varchar(64)                                                 not null       default 'System',
updated_by                     timestamp,
updated_on                     varchar(64),
constraint                     pk_ledger                                                   primary key    (oid),
constraint                     ck_is_balance_sheet_item_ledger                             check          (is_balance_sheet_item = 'Yes' or is_balance_sheet_item = 'No'),
constraint                     ck_status_ledger                                            check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledger_sub_group_oid_ledger                              foreign key    (ledger_sub_group_oid)
                                                                                           references     "schoolerp".ledger_sub_group(oid),
constraint                     fk_institute_oid_ledger                                     foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*

oid                            : Surrogate primary key
ledger_key                     : 
name_en                        : Sub ledger name in english.
name_bn                        : Sub ledger name in bangla.
sub_ledger_code                : 
mnemonic                       : 
sub_ledger_type                : 
is_balance_sheet_item          : 
sub_ledger_balance             : 
opening_balance                : 
closing_balance                : 
ledger_code                    : 
version_id                     : 
status                         : 
reference_type                 : 
reference_oid                  : 
ledger_oid                     : 
institute_oid                  : Institute oid
created_by                     : When was created
created_on                     : Who was created
updated_by                     : When was edited
updated_on                     : Who was edited
*/
create table                   "schoolerp".sub_ledger
(
oid                            varchar(128)                                                not null,
ledger_key                     varchar(64),
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
sub_ledger_code                varchar(10),
mnemonic                       varchar(32)                                                 not null,
sub_ledger_type                varchar(16)                                                 not null,
is_balance_sheet_item          varchar(8)                                                  not null       default 'No',
sub_ledger_balance             numeric(20,2)                                                              default 0,
opening_balance                numeric(20,2)                                                              default 0,
closing_balance                numeric(20,2)                                                              default 0,
ledger_code                    varchar(7),
version_id                     varchar(4)                                                  not null       default '1',
status                         varchar(32)                                                 not null       default 'Active',
reference_type                 varchar(32),
reference_oid                  varchar(128),
ledger_oid                     varchar(128),
institute_oid                  varchar(128),
created_by                     timestamp                                                   not null       default current_timestamp,
created_on                     varchar(64)                                                 not null       default 'System',
updated_by                     timestamp,
updated_on                     varchar(64),
constraint                     pk_sub_ledger                                               primary key    (oid),
constraint                     ck_is_balance_sheet_item_sub_ledger                         check          (is_balance_sheet_item = 'Yes' or is_balance_sheet_item = 'No'),
constraint                     fk_ledger_oid_sub_ledger                                    foreign key    (ledger_oid)
                                                                                           references     "schoolerp".ledger(oid),
constraint                     fk_institute_oid_sub_ledger                                 foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledger_key                     : 
ledger_name_en                 : 
ledger_code                    : 
status                         : 
ledger_oid                     : 
institute_oid                  : Institute oid
created_by                     : When was created
created_on                     : Who was created
updated_by                     : When was edited
updated_on                     : Who was edited
*/
create table                   "schoolerp".ledger_setting
(
oid                            varchar(128)                                                not null,
ledger_key                     varchar(128)                                                not null,
ledger_name_en                 varchar(128),
ledger_code                    varchar(32),
status                         varchar(32)                                                 not null       default 'Active',
ledger_oid                     varchar(128),
institute_oid                  varchar(128),
created_by                     timestamp                                                   not null       default current_timestamp,
created_on                     varchar(64)                                                 not null       default 'System',
updated_by                     timestamp,
updated_on                     varchar(64),
constraint                     pk_ledger_setting                                           primary key    (oid),
constraint                     fk_ledger_oid_ledger_setting                                foreign key    (ledger_oid)
                                                                                           references     "schoolerp".Ledger(oid),
constraint                     fk_institute_oid_ledger_setting                             foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);


