package com.doer.services.auth.data;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsersRepository extends CrudRepository<UserEntity, Long> {
    UserEntity findByUserName(String userName);
    UserEntity findByUserId(String userId);
}
