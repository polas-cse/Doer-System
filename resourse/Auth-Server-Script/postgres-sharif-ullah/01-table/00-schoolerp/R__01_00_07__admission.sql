/*

oid                            : Surrogate primary key
admission_id                   : Surrogate primary key
institute_oid                  : Institute oid
institute_session_oid          : Institute session oid
institute_class_oid            : Institute class oid
institute_class_group_oid      : Institute Group oid
institute_shift_oid            : Institute shift oid
institute_version_oid          : Institute version oid
education_curriculum_oid       : Education Curriculum oid
applicant_name_en              : login Id
applicant_name_bn              : 
date_of_birth                  : 
email                          : 
mobile_no                      : 
gender                         : 
religion                       : 
nationality                    : 
blood_group                    : 
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
status                         : [Submitted,Approved,Rejected]
approved_by                    : Who created request
approved_on                    : When reqeust created
created_by                     : Who created request
created_on                     : When reqeust created
updated_by                     : Who updated request
updated_on                     : When request updated
*/
create table                   "schoolerp".institute_admission
(
oid                            varchar(128)                                                not null,
admission_id                   varchar(128)                                                not null,
institute_oid                  varchar(128),
institute_session_oid          varchar(128),
institute_class_oid            varchar(128),
institute_class_group_oid      varchar(128),
institute_shift_oid            varchar(128),
institute_version_oid          varchar(128),
education_curriculum_oid       varchar(128),
applicant_name_en              varchar(128)                                                not null,
applicant_name_bn              varchar(256),
date_of_birth                  date,
email                          varchar(128),
mobile_no                      varchar(128),
gender                         varchar(128),
religion                       varchar(128),
nationality                    varchar(128),
blood_group                    varchar(128),
father_name_en                 varchar(128)                                                not null,
father_name_bn                 varchar(256),
father_occupation              varchar(128),
father_contact_number          varchar(128),
father_email                   varchar(128),
mother_name_en                 varchar(128)                                                not null,
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
approved_by                    varchar(128),
approved_on                    timestamp,
created_by                     varchar(128)                                                               default current_user,
created_on                     timestamp                                                                  default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     pk_institute_admission                                      primary key    (oid),
constraint                     uk_admission_id_institute_admission                         unique         (admission_id),
constraint                     fk_institute_oid_institute_admission                        foreign key    (institute_oid)
                                                                                           references     "schoolerp".institute(oid),
constraint                     fk_institute_session_oid_institute_admission                foreign key    (institute_session_oid)
                                                                                           references     "schoolerp".institute_session(oid),
constraint                     fk_institute_class_oid_institute_admission                  foreign key    (institute_class_oid)
                                                                                           references     "schoolerp".institute_class(oid),
constraint                     fk_institute_class_group_oid_institute_admission            foreign key    (institute_class_group_oid)
                                                                                           references     "schoolerp".institute_class_group(oid),
constraint                     fk_institute_shift_oid_institute_admission                  foreign key    (institute_shift_oid)
                                                                                           references     "schoolerp".institute_shift(oid),
constraint                     fk_institute_version_oid_institute_admission                foreign key    (institute_version_oid)
                                                                                           references     "schoolerp".institute_version(oid)
);


