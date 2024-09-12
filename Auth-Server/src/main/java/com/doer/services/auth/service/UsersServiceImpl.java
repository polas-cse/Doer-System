package com.doer.services.auth.service;


import com.doer.services.auth.dao.LoginDao;
import com.doer.services.auth.data.*;
import com.doer.services.auth.shared.UserDto;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.UUID;

@Service
public class UsersServiceImpl implements UsersService {

    UsersRepository usersRepository;
    BCryptPasswordEncoder bCryptPasswordEncoder;
    //RestTemplate restTemplate;
    Environment environment;

    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private LoginDao loginDao;

    @Autowired
    public UsersServiceImpl(UsersRepository usersRepository,
                            BCryptPasswordEncoder bCryptPasswordEncoder,
                            Environment environment)
    {
        this.usersRepository = usersRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
        this.environment = environment;
    }

    @Override
    public UserDto createUser(UserDto userDetails) {
        // TODO Auto-generated method stub
        userDetails.setUserId(UUID.randomUUID().toString());
        userDetails.setPassword(bCryptPasswordEncoder.encode(userDetails.getPassword()));
        ModelMapper modelMapper = new ModelMapper();
        modelMapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserEntity userEntity = modelMapper.map(userDetails, UserEntity.class);
//        usersRepository.save(userEntity);
        loginDao.saveUser(userEntity);
        UserDto returnValue = modelMapper.map(userEntity, UserDto.class);
        return returnValue;
    }

    @Override
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {

        System.out.println("Okay.........................");
//        UserEntity userEntity = usersRepository.findByUserName(userName);
        UserEntity userEntity = null;
        try {
            userEntity = loginDao.getUser(userName);
            userEntity.setRoles(loginDao.getUserRoleList(userEntity.getRoleOid()));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        if(userEntity == null) throw new UsernameNotFoundException(userName);
        Collection<GrantedAuthority> authorities = new ArrayList<>();
        Collection<RoleEntity> roles = userEntity.getRoles();
        roles.forEach((role) -> {
            authorities.add(new SimpleGrantedAuthority(role.getName()));
            Collection<AuthorityEntity> authorityEntities = role.getAuthorities();
            authorityEntities.forEach((authorityEntity) -> {
                authorities.add(new SimpleGrantedAuthority(authorityEntity.getName()));
            });
        });

        return new User(userEntity.getUserName(),
                userEntity.getPassword(),
                true, true, true, true,
                authorities);
    }

    @Override
    public UserDto getUserByUserName(String userName) {
        UserEntity userEntity = usersRepository.findByUserName(userName);
        if(userEntity == null) throw new UsernameNotFoundException(userName);
        return new ModelMapper().map(userEntity, UserDto.class);
    }

    @Override
    public UserDto getUserByUserId(String userId, String authorization) {
        UserEntity userEntity = usersRepository.findByUserId(userId);
        if(userEntity == null) throw new UsernameNotFoundException("User not found");
        UserDto userDto = new ModelMapper().map(userEntity, UserDto.class);
        return userDto;
    }

}
