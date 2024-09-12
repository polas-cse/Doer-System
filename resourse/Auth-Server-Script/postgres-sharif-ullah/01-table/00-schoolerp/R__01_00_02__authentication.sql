/*
This table to be used to store user login information.
oid                            : Surrogate primary key
login_id                       : login Id
password                       : Password
user_name                      : User Name
name_en                        : 
name_bn                        : 
email                          : Email id
mobile_no                      : Mobile no
menu_json                      : Bank Id
user_photo_path                : user Photo path
user_photo_url                 : user Photo Url
status                         : Who deactivated
reset_required                 : Is password required
role_oid                       : Role oid
institute_oid                  : Institute oid
trace_id                       : Trace Id of this record
login_period_start_time        : 
login_period_end_time          : 
login_disable_start_date       : 
loginDisableEndDate            : 
temp_login_disable_start_date  : 
temp_login_disable_end_date    : 
last_login_time                : 
last_logout_time               : 
password_expire_time           : 
current_version                : Count of how many times a record is being approved. Each count is treated as a new version. Ex: 1,2,......
edited_by                      : Who (which login) last edited the record
edited_on                      : When the record was last edited
approved_by                    : Who (which login) approved the record
approved_on                    : When the record was approved
remarked_by                    : Who (which login) remarked the record
remarked_on                    : When the record was remarked
is_approver_remarks            : Status if approver add any remarks. It will be Yes or No
approver_remarks               : Approver remarks for further action
is_new_record                  : Record will show up new for a specific time. It will be Yes or No
created_by                     : Who (which login) created the record
created_on                     : When the record was created
activated_by                   : Who (which login) activated the record
activated_on                   : When the record was activated
closed_by                      : Who (which login) closed the record
closed_on                      : When the record was closed
closing_remark                 : Closing Remarks
deleted_by                     : Who (which login) deleted the record
deleted_on                     : When the record was deleted
deletion_remark                : Delition remarks
*/
create table                   "schoolerp".login
(
oid                            varchar(128)                                                not null,
login_id                       varchar(128)                                                not null,
password                       varchar(256),
user_name                      varchar(256)                                                not null,
name_en                        varchar(256),
name_bn                        varchar(256),
email                          varchar(256),
mobile_no                      varchar(64),
menu_json                      text,
user_photo_path                varchar(512),
user_photo_url                 varchar(512),
status                         varchar(128),
reset_required                 varchar(32),
role_oid                       varchar(128),
institute_oid                  varchar(128),
trace_id                       varchar(128),
login_period_start_time        varchar(32),
login_period_end_time          varchar(32),
login_disable_start_date       timestamp,
loginDisableEndDate            timestamp,
temp_login_disable_start_date  timestamp,
temp_login_disable_end_date    timestamp,
last_login_time                timestamp,
last_logout_time               timestamp,
password_expire_time           timestamp,
current_version                varchar(32)                                                                default '1',
edited_by                      varchar(128),
edited_on                      timestamp,
approved_by                    varchar(128),
approved_on                    timestamp,
remarked_by                    varchar(128),
remarked_on                    timestamp,
is_approver_remarks            varchar(32),
approver_remarks               text,
is_new_record                  varchar(32),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
activated_by                   varchar(128),
activated_on                   timestamp,
closed_by                      varchar(128),
closed_on                      timestamp,
closing_remark                 text,
deleted_by                     varchar(128),
deleted_on                     timestamp,
deletion_remark                text,
constraint                     pk_login                                                    primary key    (oid),
constraint                     uk_user_name_login                                          unique         (user_name),
constraint                     ck_status_login                                             check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_role_oid_login                                           foreign key    (role_oid)
                                                                                           references     "schoolerp".role(oid),
constraint                     ck_is_approver_remarks_login                                check          (is_approver_remarks = 'Yes' or is_approver_remarks = 'No'),
constraint                     ck_is_new_record_login                                      check          (is_new_record = 'Yes' or is_new_record = 'No')
);

/*
This table to be used to store user login information.
oid                            : Surrogate primary key
login_id                       : login Id, should not be unique
password                       : Password
user_name                      : User name of User
email                          : Email id
mobile_no                      : Mobile no
menu_json                      : Bank Id
role_oid                       : Role oid
user_photo_path                : user Photo path
status                         : Who deactivated
reset_required                 : Is password required
history_on                     : When Create
login_oid                      : _oid of login table or reference of login table
trace_id                       : Trace Id of this record
login_period_start_time        : 
login_period_end_time          : 
login_disable_start_date       : 
loginDisableEndDate            : 
temp_login_disable_start_date  : 
temp_login_disable_end_date    : 
last_login_time                : 
last_logout_time               : 
password_expire_time           : 
version                        : Count of how many times a record is being approved. Each count is treated as a new version. Ex: 1,2,......
edited_by                      : Who (which login) last edited the record
edited_on                      : When the record was last edited
approved_by                    : Who (which login) approved the record
approved_on                    : When the record was approved
remarked_by                    : Who (which login) remarked the record
remarked_on                    : When the record was remarked
is_approver_remarks            : Status if approver add any remarks. It will be Yes or No
approver_remarks               : Approver remarks for further action
is_new_record                  : Record will show up new for a specific time. It will be Yes or No
created_by                     : Who (which login) created the record
created_on                     : When the record was created
activated_by                   : Who (which login) activated the record
activated_on                   : When the record was activated
closed_by                      : Who (which login) closed the record
closed_on                      : When the record was closed
closing_remark                 : Closing Remarks
deleted_by                     : Who (which login) deleted the record
deleted_on                     : When the record was deleted
deletion_remark                : Delition remarks
*/
create table                   "schoolerp".login_history
(
oid                            varchar(128)                                                not null,
login_id                       varchar(128)                                                not null,
password                       varchar(256)                                                not null,
user_name                      varchar(128)                                                not null,
email                          varchar(256),
mobile_no                      varchar(64),
menu_json                      text,
role_oid                       varchar(128)                                                not null,
user_photo_path                varchar(512),
status                         varchar(128),
reset_required                 varchar(32),
history_on                     timestamp                                                   not null       default current_timestamp,
login_oid                      varchar(128)                                                not null,
trace_id                       varchar(128),
login_period_start_time        varchar(32),
login_period_end_time          varchar(32),
login_disable_start_date       timestamp,
loginDisableEndDate            timestamp,
temp_login_disable_start_date  timestamp,
temp_login_disable_end_date    timestamp,
last_login_time                timestamp,
last_logout_time               timestamp,
password_expire_time           timestamp,
version                        varchar(32)                                                 not null,
edited_by                      varchar(128),
edited_on                      timestamp,
approved_by                    varchar(128),
approved_on                    timestamp,
remarked_by                    varchar(128),
remarked_on                    timestamp,
is_approver_remarks            varchar(32),
approver_remarks               text,
is_new_record                  varchar(32),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
activated_by                   varchar(128),
activated_on                   timestamp,
closed_by                      varchar(128),
closed_on                      timestamp,
closing_remark                 text,
deleted_by                     varchar(128),
deleted_on                     timestamp,
deletion_remark                text,
constraint                     pk_login_history                                            primary key    (oid),
constraint                     fk_role_oid_login_history                                   foreign key    (role_oid)
                                                                                           references     "schoolerp".role(oid),
constraint                     ck_status_login_history                                     check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_login_oid_login_history                                  foreign key    (login_oid)
                                                                                           references     "schoolerp".login(oid),
constraint                     ck_is_approver_remarks_login_history                        check          (is_approver_remarks = 'Yes' or is_approver_remarks = 'No'),
constraint                     ck_is_new_record_login_history                              check          (is_new_record = 'Yes' or is_new_record = 'No')
);

/*
Audit log information of login
oid                            : Surrogate primary key
login_oid                      : login on which the log is
login_time                     : Time of log
logout_time                    : Type of log, what it was
log_type                       : JSON schema for log
ip_address                     : IP Address
location                       : Location of user
*/
create table                   "schoolerp".login_log
(
oid                            varchar(128)                                                not null,
login_oid                      varchar(128)                                                not null,
login_time                     timestamp                                                   not null       default current_timestamp,
logout_time                    timestamp                                                                  default current_timestamp,
log_type                       varchar(32)                                                 not null       default 'login',
ip_address                     varchar(32),
location                       text,
constraint                     pk_login_log                                                primary key    (oid),
constraint                     fk_login_oid_login_log                                      foreign key    (login_oid)
                                                                                           references     "schoolerp".login(oid),
constraint                     ck_log_type_login_log                                       check          (log_type = 'login' or log_type = 'Logout')
);

/*
This table is for storing password reset history
oid                            : Surrogate primary key
login_id                       : User login Id
old_password                   : User old password
new_password                   : User new password
maker_id                       : Who (which login) made the record. This is the Id of the login, not _oid
checker_id                     : Who (which login) checked the record. This is the Id of the login, not _oid
approver_id                    : Who (which login) approved the record. This is the Id of the login, not _oid
approved_on                    : When approved
resetstatus                    : Password reset status
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".password_reset_log
(
oid                            varchar(128)                                                not null,
login_id                       varchar(128)                                                not null,
old_password                   varchar(128)                                                not null,
new_password                   varchar(128)                                                not null,
maker_id                       varchar(128),
checker_id                     varchar(128),
approver_id                    varchar(128),
approved_on                    timestamp                                                                  default current_timestamp,
resetstatus                    varchar(32),
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp                                                                  default current_timestamp,
constraint                     pk_password_reset_log                                       primary key    (oid)
);

/*
This table to be used to store user login information.
oid                            : Surrogate primary key
registration_id                : registration id
login_id                       : registration id
name_en                        : login Id
name_bn                        : 
email                          : 
mobile_no                      : Email id
nid                            : Mobile no
photo_path                     : Bank Id
photo_url                      : user Photo path
is_verified                    : user Photo path Url
status                         : [Yes,No]
*/
create table                   "schoolerp".sign_up
(
oid                            varchar(128)                                                not null,
registration_id                varchar(128)                                                not null,
login_id                       varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(256),
email                          varchar(256)                                                not null,
mobile_no                      varchar(256)                                                not null,
nid                            varchar(64),
photo_path                     text,
photo_url                      varchar(512),
is_verified                    varchar(512)                                                               default 'no',
status                         varchar(32),
constraint                     pk_sign_up                                                  primary key    (oid),
constraint                     uk_registration_id_sign_up                                  unique         (registration_id),
constraint                     ck_status_sign_up                                           check          (status = 'Active' or status = 'Inactive')
);

/*
UserOtp table is the table for storing all otp related data
oid                            : Surrogate primary key
login_id                       : LoginId of user for which otp is generated
mobile_no                      : Mobile no of user
otp                            : Generated otp 
otp_status                     : Status of otp
otp_verified                   : Status of if otp varified
otp_generated_on               : When otp is generated
otp_expiration_time            : When otp will expire
otp_request_by                 : Otp requested by which user
otp_request_on                 : When otp request is generated
created_by                     : Who (which login) created the record
created_on                     : When created
updated_by                     : Who (which login) last updated the record
updated_on                     : When updated
*/
create table                   "schoolerp".otp
(
oid                            varchar(128)                                                not null,
login_id                       varchar(128)                                                not null,
mobile_no                      varchar(128)                                                not null,
otp                            varchar(128)                                                not null,
otp_status                     varchar(32)                                                                default 'Submitted',
otp_verified                   varchar(32)                                                                default 'No',
otp_generated_on               timestamp                                                   not null,
otp_expiration_time            timestamp                                                   not null,
otp_request_by                 varchar(128),
otp_request_on                 timestamp                                                                  default current_timestamp,
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_otp                                                      primary key    (oid),
constraint                     ck_otp_status_otp                                           check          (otp_status = 'Submitted' or otp_status = 'OtpSent' or otp_status = 'OtpVerified' or otp_status = 'OtpExpired' or otp_status = 'OtpCancelled'),
constraint                     ck_otp_verified_otp                                         check          (otp_verified = 'Yes' or otp_verified = 'No')
);


