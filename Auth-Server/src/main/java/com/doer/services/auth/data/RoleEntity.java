package com.doer.services.auth.data;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Collection;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "role")
public class RoleEntity implements Serializable {

    @Id
    @NotNull(message = "Role oid can't be null")
    @Size(max = 256, message = "Role oid must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String oid;

    @NotNull(message = "Role id can't be null")
    @Size(max = 256, message = "Role id must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String roleId;

    @NotNull(message = "Role name can't be null")
    @Size(max = 256, message = "Role name must not exceed 128 characters")
    @Column(nullable=false, length = 128)
    private String name;

    @NotBlank(message = "Role description cannot be blank")
    @Column(nullable=false)
    private String roleDescription;

    @NotBlank(message = "Menu Json cannot be blank")
    @Column(nullable=false)
    private String menuJson;

    @NotNull(message = "Role type can't be null")
    @Size(max = 32, message = "Role type must not exceed 32 characters")
    @Column(nullable=false, length = 32)
    private String roleType;

    @NotBlank(message = "Role status cannot be blank")
    @Size(max = 32, message = "Role status must not exceed 32 characters")
    @Pattern(regexp = "Active|Inactive", message = "Role status must be either 'Active' or 'Inactive'")
    @Column(nullable=false, length = 32)
    private String status;

    @NotBlank(message = "Authorities cannot be blank")
    @Column(nullable=false)
    private Collection<AuthorityEntity> authorities;

    public RoleEntity(String name, Collection<AuthorityEntity> authorities) {
        this.name = name;
        this.authorities = authorities;
    }

}
