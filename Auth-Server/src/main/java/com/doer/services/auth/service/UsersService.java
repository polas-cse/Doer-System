package com.doer.services.auth.service;

import com.doer.services.auth.shared.UserDto;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface UsersService extends UserDetailsService {

    UserDto createUser(UserDto userDetails);
    UserDto getUserByUserName(String username); // Changed `getUserDetailsByUserName` to `getUserByUserName`
    UserDto getUserByUserId(String userId, String authorization);

}
