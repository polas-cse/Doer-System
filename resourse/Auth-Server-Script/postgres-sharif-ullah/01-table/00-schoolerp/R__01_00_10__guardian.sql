/*

oid                            : Surrogate primary key
login_id                       : Login Id
guardian_id                    : Surrogate primary key
name_en                        : login Id
name_bn                        : 
date_of_birth                  : 
email                          : 
mobile_no                      : 
gender                         : 
religion                       : 
nationality                    : 
blood_group                    : 
educational_qualification      : 
father_name_en                 : login Id
father_name_bn                 : 
father_occupation              : 
father_contact_number          : 
father_email                   : 
mother_name_en                 : login Id
mother_name_bn                 : 
mother_occupation              : 
mother_contact_number          : 
mother_email                   : 
emergency_contact_person       : 
emergency_contact_no           : 
present_address_json           : permanentAddressJson : {"careOf":"Nur Ahamed","houseNo":"54","roadNo":"06","postOffice":"Adabor","postCode":"1207","thana":"Adabor", "thanaOid":"Adabor", "district":"Dhaka", "districtOid":"Dhaka"}
permanent_address_json         : permanentAddressJson : {"careOf":"Nur Ahamed","houseNo":"54","roadNo":"06","postOffice":"Adabor","postCode":"1207","thana":"Adabor", "thanaOid":"Adabor", "district":"Dhaka", "districtOid":"Dhaka"}
photo_path                     : 
photo_url                      : 
status                         : 
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".guardian
(
oid                            varchar(128)                                                not null,
login_id                       varchar(128),
guardian_id                    varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(256),
date_of_birth                  date,
email                          varchar(128),
mobile_no                      varchar(128),
gender                         varchar(128),
religion                       varchar(128),
nationality                    varchar(128),
blood_group                    varchar(128),
educational_qualification      varchar(128),
father_name_en                 varchar(128),
father_name_bn                 varchar(256),
father_occupation              varchar(128),
father_contact_number          varchar(128),
father_email                   varchar(128),
mother_name_en                 varchar(128),
mother_name_bn                 varchar(256),
mother_occupation              varchar(128),
mother_contact_number          varchar(128),
mother_email                   varchar(128),
emergency_contact_person       varchar(128),
emergency_contact_no           varchar(128),
present_address_json           varchar,
permanent_address_json         varchar,
photo_path                     varchar(256),
photo_url                      varchar(256),
status                         varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_guardian                                                 primary key    (oid),
constraint                     uk_guardian_id_guardian                                     unique         (guardian_id)
);

/*

oid                            : Surrogate primary key
guardian_id                    : Guardian Id
student_id                     : Student Id
guardian_oid                   : Guardian oid
student_oid                    : Student oid
created_by                     : Who created request
created_on                     : When reqeust created
*/
create table                   "schoolerp".guardian_student
(
oid                            varchar(128)                                                not null,
guardian_id                    varchar(128),
student_id                     varchar(128),
guardian_oid                   varchar(128),
student_oid                    varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
constraint                     pk_guardian_student                                         primary key    (oid),
constraint                     fk_guardian_oid_guardian_student                            foreign key    (guardian_oid)
                                                                                           references     "schoolerp".guardian(oid),
constraint                     fk_student_oid_guardian_student                             foreign key    (student_oid)
                                                                                           references     "schoolerp".student(oid)
);


