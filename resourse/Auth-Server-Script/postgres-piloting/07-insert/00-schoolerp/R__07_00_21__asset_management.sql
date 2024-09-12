-- asset
insert into "schoolerp".asset (oid, asset_id, name_en, name_bn, asset_type, quantity, founded, asset_nature, status, remarks, institute_oid) values ('SCHOOL-ERP-Asset-Oid-00001','AST-1308650001','School Shoping Complex','স্কুল শপিং কমপ্লেক্স',null,2,'2022','Both','Active',null,'SCHOOL-ERP-Demo-School-001');
insert into "schoolerp".asset (oid, asset_id, name_en, name_bn, asset_type, quantity, founded, asset_nature, status, remarks, institute_oid) values ('SCHOOL-ERP-Asset-Oid-00002','AST-1308650002','Laptop','ল্যাপটপ',null,1,null,'Institute','Active',null,'SCHOOL-ERP-Demo-School-001');
commit;

-- asset_details
insert into "schoolerp".asset_details (oid, name_en, name_bn, asset_detail_id, asset_nature, status, description, remarks, asset_oid, institute_oid) values ('SCHOOL-ERP-Asset-Detail-Oid-00001','Shop No - 100','দোকান নম্বর - ১০০','ASTD-1308650001','Rent','Active',null,null,'SCHOOL-ERP-Asset-Oid-00001','SCHOOL-ERP-Demo-School-001');
insert into "schoolerp".asset_details (oid, name_en, name_bn, asset_detail_id, asset_nature, status, description, remarks, asset_oid, institute_oid) values ('SCHOOL-ERP-Asset-Detail-Oid-00002','Shop No - 101','দোকান নম্বর - ১০১','ASTD-1308650002','Rent','Active',null,null,'SCHOOL-ERP-Asset-Oid-00001','SCHOOL-ERP-Demo-School-001');
insert into "schoolerp".asset_details (oid, name_en, name_bn, asset_detail_id, asset_nature, status, description, remarks, asset_oid, institute_oid) values ('SCHOOL-ERP-Asset-Detail-Oid-00003','Dell Laptop - 100','ডেল ল্যাপটপ  - ১০১','ASTD-1308650003','Institute','Active',null,null,'SCHOOL-ERP-Asset-Oid-00002','SCHOOL-ERP-Demo-School-001');
commit;

-- asset_allocation
insert into "schoolerp".asset_allocation (oid, asset_oid, asset_details_oid, asset_holder_oid, rent_amount, advance_amount, current_advance_amount, payment_mode, adjustment_advance_with_rent, contract_date, commencement_date, end_date_of_contract, closing_date, remarks, status, institute_oid) values ('SCHOOL-ERP-Asset-Allocation-Oid-00001','SCHOOL-ERP-Asset-Oid-00001','SCHOOL-ERP-Asset-Detail-Oid-00001','SCHOOL-ERP-People-Oid-00001',1500,10000,10000,'Monthly',500,'now()','now()','2025-01-31',null,null,'Active','SCHOOL-ERP-Demo-School-001');
commit;


