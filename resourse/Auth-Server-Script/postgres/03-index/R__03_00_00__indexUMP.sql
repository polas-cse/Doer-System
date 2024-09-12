create unique index index_otp_otp on otp (otp);

create index index_institute_oid_bank_account on bank_account (institute_oid);

create index index_bank_account_oid_bank_account_transaction on bank_account_transaction (bank_account_oid);

create index index_bank_account_oid_cash_book on cash_book (bank_account_oid);


