/*
This table is for storing file details history
oid                            : Surrogate primary key
application_tracking_id        : this Id insert from application table id
registration_id                : this Id insert from user registration_id
offer_id                       : this Id insert from offer table id.
payment_id                     : this Id insert from payment table id.
policy_no                      : 
insurer_id                     : 
file_name                      : 
file_type                      : [Photo,Nid,Document,PolicyCertificate]
document_title                 : SSC Certificate, HSC Certificate etc.
file_url                       : file url
file_path                      : file path
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".file_detail
(
oid                            varchar(128)                                                not null,
application_tracking_id        varchar(128),
registration_id                varchar(128),
offer_id                       varchar(128),
payment_id                     varchar(128),
policy_no                      varchar(256),
insurer_id                     varchar(128),
file_name                      varchar(256)                                                not null,
file_type                      varchar(256)                                                not null,
document_title                 varchar(256),
file_url                       varchar(256)                                                not null,
file_path                      varchar(256)                                                not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_file_detail                                              primary key    (oid)
);


