/*
Roles used for users
oid                            : Surrogate primary key
role_id                        : Role Id
role_description               : Description of Role
menu_json                      : Access JSON array comes from ANP sheet
role_type                      : Role status
status                         : Role status
created_by                     : Who created the role, default is System
created_on                     : When it was created
updated_by                     : Who last update the role
updated_on                     : When it was updated
*/
create table                   "schoolerp".role
(
oid                            varchar(128)                                                not null,
role_id                        varchar(128)                                                not null,
role_description               text                                                        not null,
menu_json                      text,
role_type                      varchar(32),
status                         varchar(32)                                                 not null,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_role                                                     primary key    (oid),
constraint                     uk_role_id_role                                             unique         (role_id),
constraint                     ck_role_type_role                                           check          (role_type = 'Admin' or role_type = 'Institute' or role_type = 'Student' or role_type = 'Teacher' or role_type = 'Guardian'),
constraint                     ck_status_role                                              check          (status = 'Active' or status = 'Inactive')
);


