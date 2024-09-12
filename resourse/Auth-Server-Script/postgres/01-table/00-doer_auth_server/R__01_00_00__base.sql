/*
-
oid                            : -
container_name                 : -
status                         : -
request_received_on            : -
response_sent_on               : -
response_time_in_ms            : -
request_source                 : -
request_source_service         : -
request_json                   : -
response_json                  : -
start_sequence                 : -
end_sequence                   : -
trace_id                       : -
created_by                     : -
created_on                     : -
updated_by                     : -
updated_on                     : -
*/
create table                   "doer_auth_server".request_log
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
created_by                     varchar(128)                                                not null       default 'System',
created_on                     timestamp                                                   not null       default current_timestamp,
updated_by                     varchar(128),
updated_on                     timestamp,
constraint                     ck_status_request_log                                       check          (status = 'RequestReceived' or status = 'SentForProcessing' or status = 'ReceivedAfterProcessing' or status = 'ResponseSent')
);


