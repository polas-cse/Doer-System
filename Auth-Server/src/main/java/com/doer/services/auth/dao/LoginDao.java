package com.doer.services.auth.dao;

import com.doer.services.auth.data.AuthorityEntity;
import com.doer.services.auth.data.RoleEntity;
import com.doer.services.auth.data.UserEntity;
import com.doer.services.auth.shared.UserDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Repository
public class LoginDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int saveUser(UserEntity userEntity) {

        return jdbcTemplate.update(
                "insert into doer_auth_server.user(oid, user_id, password, user_name, email, mobile_no, " +
                        "status, reset_required, role_oid, last_login_time, last_logout_time, password_expire_time) " +
                        "values(?,?,?,?,?,?,?,?,?,?,?,?)",
                userEntity.getOid(),
                userEntity.getUserId(),
                userEntity.getPassword(),
                userEntity.getUserName(),
                userEntity.getEmail(),
                userEntity.getMobileNo(),
                userEntity.getStatus(),
                userEntity.getResetRequired(),
                userEntity.getRoleOid(),
                userEntity.getLastLoginTime(),
                userEntity.getLastLogoutTime(),
                userEntity.getPasswordExpireTime()
        );


    }

    public UserEntity getUser(String userName) throws Exception{
        UserEntity user = new UserEntity();
        try {
            String sql = "select oid, user_id, password, user_name, email, mobile_no, status, reset_required," +
                    "role_oid, last_login_time, last_logout_time, password_expire_time from doer_auth_server.user u " +
                    "where user_name = '"+userName+"'";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
            for(Map<String, Object> row:rows){
                user.setOid((String) row.get("oid"));
                user.setUserId((String) row.get("user_id"));
                user.setPassword((String) row.get("password"));
                user.setUserName((String) row.get("user_name"));
                user.setEmail((String) row.get("email"));
                user.setMobileNo((String) row.get("mobile_no"));
                user.setStatus((String) row.get("status"));
                user.setResetRequired((String) row.get("reset_required"));
                user.setRoleOid((String) row.get("role_oid"));
                user.setLastLoginTime((Date) row.get("last_login_time"));
                user.setLastLogoutTime((Date) row.get("last_logout_time"));
                user.setPasswordExpireTime((Date) row.get("password_expire_time"));
                break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<RoleEntity> getUserRoleList(String roleOid) throws Exception{
        List<RoleEntity> roleList = new ArrayList<>();
        try {
            String sql = "select oid, role_id, name, role_description, menu_json, role_type, status from role r where r.oid = '"+roleOid+"'";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
            for(Map<String, Object> row:rows){
                RoleEntity role = new RoleEntity();
                role.setOid((String) row.get("oid"));
                role.setRoleId((String) row.get("user_id"));
                role.setName((String) row.get("name"));
                role.setRoleDescription((String) row.get("role_description"));
                role.setMenuJson((String) row.get("menu_json"));
                role.setRoleType((String) row.get("role_type"));
                role.setStatus((String) row.get("status"));

                String sqlForAuthorities = "select oid, authorities_id, name, role_oid, status from authorities a where a.role_oid = '"+role.getOid()+"'";
                List<Map<String, Object>> rowsForAuthorities = jdbcTemplate.queryForList(sqlForAuthorities);
                List<AuthorityEntity> authorityList = new ArrayList<>();
                for(Map<String, Object> rowForAuthorities:rowsForAuthorities){
                    AuthorityEntity authority = new AuthorityEntity();
                    authority.setOid((String) rowForAuthorities.get("oid"));
                    authority.setAuthoritiesId((String) rowForAuthorities.get("user_id"));
                    authority.setName((String) rowForAuthorities.get("name"));
                    authority.setRoleOid((String) rowForAuthorities.get("role_description"));
                    authority.setStatus((String) rowForAuthorities.get("status"));
                    authorityList.add(authority);
                }
                role.setAuthorities(authorityList);
                roleList.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roleList;
    }

    public UserDto getUserDto(String userName) throws Exception{
        UserDto user = new UserDto();
        try {
            String sql = "select oid, user_id, password, user_name, email, mobile_no, status, reset_required," +
                    "role_oid, last_login_time, last_logout_time, password_expire_time from doer_auth_server.user u " +
                    "where user_name = '"+userName+"'";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
            for(Map<String, Object> row:rows){
                user.setOid((String) row.get("oid"));
                user.setUserId((String) row.get("user_id"));
                user.setPassword((String) row.get("password"));
                user.setUserName((String) row.get("user_name"));
                user.setEmail((String) row.get("email"));
                user.setMobileNo((String) row.get("mobile_no"));
                user.setStatus((String) row.get("status"));
                user.setResetRequired((String) row.get("reset_required"));
                user.setRoleOid((String) row.get("role_oid"));
                user.setLastLoginTime((Date) row.get("last_login_time"));
                user.setLastLogoutTime((Date) row.get("last_logout_time"));
                user.setPasswordExpireTime((Date) row.get("password_expire_time"));
                break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

}
