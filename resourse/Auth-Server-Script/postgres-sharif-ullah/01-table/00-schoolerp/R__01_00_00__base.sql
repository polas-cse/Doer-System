/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
container_name                 : Name of container
status                         : RequestReceived, SentForProcessing, ReceivedAfterProcessing, ResponseSent
request_received_on            : Timestamp when request was received from calling service
response_sent_on               : Timestamp when response was sent to calling service
response_time_in_ms            : Duration of response time
request_source                 : Which product sent the request
request_source_service         : Which service sent the request
request_json                   : Full Json payload of the request
response_json                  : Full Json payload of the response
start_sequence                 : Start sequence
end_sequence                   : End sequence
trace_id                       : To track using ID
*/
create table                   "schoolerp".request_log
(
oid                            varchar(128)                                                not null,
container_name                 varchar(256)                                                not null,
status                         varchar(32)                                                 not null,
request_received_on            timestamp                                                   not null,
response_sent_on               timestamp,
response_time_in_ms            numeric(10,0)                                               not null       default 0,
request_source                 varchar(64)                                                 not null,
request_source_service         varchar(256)                                                not null,
request_json                   text                                                        not null,
response_json                  text,
start_sequence                 numeric(20,0)                                               not null       default 0,
end_sequence                   numeric(20,0)                                               not null       default 0,
trace_id                       varchar(32)                                                 not null,
constraint                     ck_status_request_log                                       check          (status = 'RequestReceived' or status = 'SentForProcessing' or status = 'ReceivedAfterProcessing' or status = 'ResponseSent')
);

/*
App settings for all users
oid                            : Surrogate primary key
name                           : App Settings Name
value                          : App Settings Value
remarks                        : Remarks
status                         : Status of Company
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".app_settings
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
value                          varchar(32)                                                 not null,
remarks                        text,
status                         varchar(32)                                                 not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_app_settings                                             primary key    (oid),
constraint                     uk_name_app_settings                                        unique         (name),
constraint                     ck_value_app_settings                                       check          (value = 'Yes' or value = 'No')
);

/*
Roles used for users
oid                            : Surrogate primary key
name_en                        : Education board name in english.
name_bn                        : Education board name in bangla.
capital                        : Education board name in bangla.
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".country
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
capital                        varchar(128),
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_country                                                  primary key    (oid)
);

/*
Roles used for users
oid                            : Surrogate primary key
name_en                        : Division name in english.
name_bn                        : Education board name in bangla.
capital                        : Division name in bangla.
establish_year                 : Education board short name.
status                         : 
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".division
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
capital                        varchar(128),
establish_year                 varchar(32),
status                         varchar(128),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_division                                                 primary key    (oid)
);

/*
District Information
oid                            : Surrogate primary key
name_en                        : District name in english.
name_bn                        : District name in bangla.
establish_year                 : District establish year.
district_code                  : District code.
website                        : District web link
status                         : 
division_oid                   : Division oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".district
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
establish_year                 varchar(128),
district_code                  varchar(128),
website                        varchar(128),
status                         varchar(128),
division_oid                   varchar(128)                                                not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_district                                                 primary key    (oid),
constraint                     fk_division_oid_district                                    foreign key    (division_oid)
                                                                                           references     "schoolerp".division(oid)
);

/*
Roles used for users
oid                            : Surrogate primary key
name_en                        : Education board name in english.
name_bn                        : Education board name in bangla.
website                        : Thana web link
status                         : 
district_oid                   : District oid
created_by                     : Who (which login) created the record
created_on                     : When created
*/
create table                   "schoolerp".thana
(
oid                            varchar(128)                                                not null,
name_en                        varchar(256)                                                not null,
name_bn                        varchar(256),
website                        varchar(128),
status                         varchar(128),
district_oid                   varchar(128)                                                not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
constraint                     pk_thana                                                    primary key    (oid),
constraint                     fk_district_oid_thana                                       foreign key    (district_oid)
                                                                                           references     "schoolerp".district(oid)
);


