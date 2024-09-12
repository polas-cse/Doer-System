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
@Table(name = "authorities")
public class AuthorityEntity implements Serializable {

    @Id
    @NotNull(message = "Authorities oid can't be null")
    @Size(max = 128, message = "Authorities oid must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String oid;

    @NotNull(message = "Authorities id can't be null")
    @Size(max = 128, message = "Authorities id must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String authoritiesId;

    @NotNull(message = "Authorities name can't be null")
    @Size(max = 128, message = "Authorities name must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String name;

    @NotNull(message = "Authorities oid can't be null")
    @Size(max = 128, message = "Authorities oid must not exceed 128 characters")
    @Column(nullable=false, length = 128, unique = true)
    private String roleOid;

    @NotBlank(message = "Authorities status cannot be blank")
    @Size(max = 32, message = "Authorities status must not exceed 32 characters")
    @Pattern(regexp = "Active|Inactive", message = "Authorities user status must be either 'Active' or 'Inactive'")
    @Column(nullable=false, length = 32)
    private String status;

    @NotNull(message = "Authorities roles can't be null")
    @Column(nullable=false)
    private Collection<RoleEntity> roles;

    public AuthorityEntity(String name) {
        this.name = name;
    }

}
