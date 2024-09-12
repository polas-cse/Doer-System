/*
-
oid                            : -
role_id                        : -
name                           : -
role_description               : -
menu_json                      : -
role_type                      : -
status                         : -
created_by                     : -
created_on                     : -
updated_by                     : -
updated_on                     : -
*/
create table                   "doer_auth_server".role
(
oid                            varchar(128)                                                not null,
role_id                        varchar(128)                                                not null,
name                           varchar(128)                                                not null,
role_description               text                                                        not null,
menu_json                      text                                                        not null,
role_type                      varchar(32),
status                         varchar(32)                                                 not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_role                                                     primary key    (oid),
constraint                     uk_role_id_role                                             unique         (role_id)
);

/*
-
oid                            : -
authorities_id                 : -
name                           : -
role_oid                       : -
status                         : -
created_by                     : -
created_on                     : -
updated_by                     : -
updated_on                     : -
*/
create table                   "doer_auth_server".authorities
(
oid                            varchar(128)                                                not null,
authorities_id                 varchar(128)                                                not null,
name                           varchar(128)                                                not null,
role_oid                       varchar(128)                                                not null,
status                         varchar(32)                                                 not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_authorities                                              primary key    (oid),
constraint                     uk_authorities_id_authorities                               unique         (authorities_id)
);

/*
-
oid                            : -
user_id                        : -
password                       : -
user_name                      : -
email                          : -
mobile_no                      : -
status                         : -
reset_required                 : -
role_oid                       : -
last_login_time                : -
last_logout_time               : -
password_expire_time           : -
created_by                     : -
created_on                     : -
updated_by                     : -
updated_on                     : -
*/
create table                   "doer_auth_server".user
(
oid                            varchar(128)                                                not null,
user_id                        varchar(128)                                                not null,
password                       varchar(128)                                                not null,
user_name                      varchar(128)                                                not null,
email                          varchar(128),
mobile_no                      varchar(64),
status                         varchar(32)                                                 not null,
reset_required                 varchar(32)                                                 not null,
role_oid                       varchar(128)                                                not null,
last_login_time                timestamp,
last_logout_time               timestamp,
password_expire_time           timestamp,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_user                                                     primary key    (oid),
constraint                     uk_user_id_user                                             unique         (user_id),
constraint                     fk_role_oid_user                                            foreign key    (role_oid)
                                                                                           references     "doer_auth_server".role(oid)
);


