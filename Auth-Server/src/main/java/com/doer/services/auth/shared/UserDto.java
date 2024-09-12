package com.doer.services.auth.shared;

import com.doer.services.auth.data.RoleEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.sql.Date;
import java.util.Collection;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserDto implements Serializable {

    private String oid;
    private String userId;
    private String password;
    private String userName;
    private String email;
    private String mobileNo;
    private String status;
    private String resetRequired;
    private String roleOid;
    private Date lastLoginTime;
    private Date lastLogoutTime;
    private Date passwordExpireTime;
    private Collection<RoleEntity> roles;

}
