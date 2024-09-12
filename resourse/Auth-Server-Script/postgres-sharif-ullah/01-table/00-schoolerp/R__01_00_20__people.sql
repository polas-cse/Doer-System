/*

oid                            : Surrogate primary key
people_id                      : Sub ledger name in english.
people_type                    : Sub ledger name in bangla.
name_en                        : Sub ledger name in english.
name_bn                        : Sub ledger name in bangla.
date_of_birth                  : 
email                          : 
mobile_no                      : 
gender                         : 
religion                       : 
nationality                    : 
blood_group                    : 
national_id_no                 : Student national id no
birth_registration_no          : Student birth registration no.
father_name_en                 : 
father_name_bn                 : 
mother_name_en                 : 
mother_name_bn                 : 
emergency_contact_person       : 
emergency_contact_no           : 
present_address_json           : permanentAddressJson : {"careOf":"Nur Ahamed","houseNo":"54","roadNo":"06","postOffice":"Adabor","postCode":"1207","thana":"Adabor", "thanaOid":"Adabor", "district":"Dhaka", "districtOid":"Dhaka"}
permanent_address_json         : permanentAddressJson : {"careOf":"Nur Ahamed","houseNo":"54","roadNo":"06","postOffice":"Adabor","postCode":"1207","thana":"Adabor", "thanaOid":"Adabor", "district":"Dhaka", "districtOid":"Dhaka"}
photo_path                     : 
photo_url                      : 
status                         : [Active,Inactive]
institute_oid                  : Institute oid
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".people
(
oid                            varchar(128)                                                not null,
people_id                      varchar(128)                                                not null,
people_type                    varchar(128),
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
date_of_birth                  date,
email                          varchar(128),
mobile_no                      varchar(128),
gender                         varchar(128),
religion                       varchar(128),
nationality                    varchar(128),
blood_group                    varchar(128),
national_id_no                 varchar(128),
birth_registration_no          varchar(128),
father_name_en                 varchar(128),
father_name_bn                 varchar(128),
mother_name_en                 varchar(128),
mother_name_bn                 varchar(128),
emergency_contact_person       varchar(128),
emergency_contact_no           varchar(128),
present_address_json           varchar,
permanent_address_json         varchar,
photo_path                     varchar(256),
photo_url                      varchar(256),
status                         varchar(128),
institute_oid                  varchar(128),
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_people                                                   primary key    (oid),
constraint                     fk_institute_oid_people                                     foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid)
);


