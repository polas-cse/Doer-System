package com.doer.services.auth.ui.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateUserResponseModel {

    private String oid;
    private String userId;
    private String password;
    private String userName;
    private String email;
    private String mobileNo;
    private String status;
    private String resetRequired;
    private String roleOid;

}
