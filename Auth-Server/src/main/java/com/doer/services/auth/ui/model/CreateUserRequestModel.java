package com.doer.services.auth.ui.model;

import jakarta.persistence.Column;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateUserRequestModel {

    @NotNull(message = "User oid can't be null")
    @Size(max = 256, message = "User oid must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String oid;

    @NotNull(message = "User id can't be null")
    @Size(max = 256, message = "User id must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String userId;

    @NotNull(message = "User password can't be null")
    @Size(min = 8, max = 256, message = "Password must be between 8 and 256 characters")
    @Column(nullable = false, length = 256)
    private String password;

    @NotNull(message = "User name can't be null")
    @Size(max = 128, message = "User name must not exceed 128 characters")
    @Column(nullable=false, length = 128)
    private String userName;

    @Size(max = 128, message = "User email must not exceed 128 characters")
    @Email(message = "User email must be a valid email address")
    @Column(nullable = true, length = 128)
    private String email;

    @Size(max = 64, message = "User mobile number must not exceed 64 characters")
    @Pattern(
            regexp = "^(\\+\\d{1,3}[- ]?)?\\d{7,15}$",
            message = "User mobile number must be a valid format"
    )
    @Column(nullable = false, length = 64)
    private String mobileNo;

    @NotBlank(message = "User status cannot be blank")
    @Size(max = 32, message = "User status must not exceed 32 characters")
    @Pattern(regexp = "Active|Inactive", message = "User status must be either 'Active' or 'Inactive'")
    @Column(nullable=false, length = 32)
    private String status;

    @NotBlank(message = "User reset required cannot be blank")
    @Size(max = 32, message = "User status must not exceed 32 characters")
    @Pattern(regexp = "Active|Inactive", message = "User status must be either 'Active' or 'Inactive'")
    @Column(nullable=false, length = 32)
    private String resetRequired;

    @NotNull(message = "User role oid can't be null")
    @Size(max = 256, message = "User role oid must not exceed 128 characters")
    @Column(nullable=false, length = 128)
    private String roleOid;

}
