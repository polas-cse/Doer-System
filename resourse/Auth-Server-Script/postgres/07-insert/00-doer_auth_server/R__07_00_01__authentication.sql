-- role
insert into "doer_auth_server".role (oid, role_id, name, role_description, menu_json, role_type, status) values ('doer-system-auth-server-super-admin-role-oid-00000001','super-admin-role-id-00000001','Super-Admin','super-admin-login','[]','Super-Admin','Active');
insert into "doer_auth_server".role (oid, role_id, name, role_description, menu_json, role_type, status) values ('doer-system-auth-server-admin-role-oid-00000001','admin-role-id-00000001','Admin','admin-login','[]','Admin','Active');
insert into "doer_auth_server".role (oid, role_id, name, role_description, menu_json, role_type, status) values ('doer-system-auth-server-user-role-oid-00000001','user-role-id-00000001','User','user-login','[]','User','Active');
commit;

-- authorities
insert into "doer_auth_server".authorities (oid, authorities_id, name, role_oid, status) values ('super-admin-authorities-oid-0000001','super-admin-authorities-id-0000001','READ','doer-system-auth-server-super-admin-role-oid-00000001','Active');
insert into "doer_auth_server".authorities (oid, authorities_id, name, role_oid, status) values ('super-admin-authorities-oid-0000002','super-admin-authorities-id-0000002','WRITE','doer-system-auth-server-super-admin-role-oid-00000002','Active');
insert into "doer_auth_server".authorities (oid, authorities_id, name, role_oid, status) values ('super-admin-authorities-oid-0000003','super-admin-authorities-id-0000003','DELETE','doer-system-auth-server-super-admin-role-oid-00000003','Active');
insert into "doer_auth_server".authorities (oid, authorities_id, name, role_oid, status) values ('admin-authorities-oid-0000001','admin-authorities-id-0000001','READ','doer-system-auth-server-admin-login-oid-00000001','Active');
insert into "doer_auth_server".authorities (oid, authorities_id, name, role_oid, status) values ('admin-authorities-oid-0000002','admin-authorities-id-0000002','WRITE','doer-system-auth-server-admin-login-oid-00000001','Active');
insert into "doer_auth_server".authorities (oid, authorities_id, name, role_oid, status) values ('user-authorities-oid-0000001','user-authorities-id-0000001','READ','doer-system-auth-server-user-login-oid-00000001','Active');
commit;

-- user
insert into "doer_auth_server".user (oid, user_id, password, user_name, email, status, reset_required, role_oid) values ('doer-system-auth-server-super-admin-login-oid-00000001','super-admin-login-id-00000001','super.admin','super.admin','polas@gmail.com','Active','Active','doer-system-auth-server-super-admin-role-oid-00000001');
insert into "doer_auth_server".user (oid, user_id, password, user_name, email, status, reset_required, role_oid) values ('doer-system-auth-server-admin-login-oid-00000001','admin-login-id-00000001','admin','admin','shihab@gmail.com','Active','Active','doer-system-auth-server-admin-role-oid-00000001');
insert into "doer_auth_server".user (oid, user_id, password, user_name, email, status, reset_required, role_oid) values ('doer-system-auth-server-user-login-oid-00000001','user-login-id-00000001','user','user','rana@gmail.com','Active','Active','doer-system-auth-server-user-role-oid-00000001');
commit;


