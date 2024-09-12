package com.doer.services.auth.ui.controllers;


import com.doer.security.and.log.model.CustomHttpResponse;
import com.doer.security.and.log.util.ResponseBuilder;
import com.doer.services.auth.service.UsersService;
import com.doer.services.auth.shared.UserDto;
import com.doer.services.auth.ui.model.CreateUserRequestModel;
import com.doer.services.auth.ui.model.CreateUserResponseModel;
import com.doer.services.auth.ui.model.UserResponseModel;
import jakarta.validation.Valid;

import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/users")
public class UsersController {

    @Autowired
    private Environment env;

    @Autowired
    UsersService usersService;

    @GetMapping("/status/check")
    public String status()
    {
        return "Working on port " + env.getProperty("local.server.port")+", with token = "+env.getProperty("token.secret");
    }

    @PostMapping(
            consumes = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE },
            produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE }
    )
    public ResponseEntity<CustomHttpResponse> createUser(@Valid @RequestBody CreateUserRequestModel userDetails) {
        try {
            ModelMapper modelMapper = new ModelMapper();
            modelMapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
            UserDto userDto = modelMapper.map(userDetails, UserDto.class);
            UserDto createdUser = usersService.createUser(userDto);
            CreateUserResponseModel returnValue = modelMapper.map(createdUser, CreateUserResponseModel.class);
        } catch (Exception ex) {
            return ResponseBuilder.buildFailureResponse(HttpStatus.BAD_REQUEST, "400", "Failed to add course! Reason: " + ex.getMessage());
        }
        return ResponseBuilder.buildSuccessResponse(HttpStatus.CREATED, Map.of("message", "Successfully created user"));
    }

//    @PostMapping(
//            consumes = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE },
//            produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE }
//    )
//    public ResponseEntity<CreateUserResponseModel> createUser(@Valid @RequestBody CreateUserRequestModel userDetails)
//    {
//        ModelMapper modelMapper = new ModelMapper();
//        modelMapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
//
//        UserDto userDto = modelMapper.map(userDetails, UserDto.class);
//
//        UserDto createdUser = usersService.createUser(userDto);
//
//        CreateUserResponseModel returnValue = modelMapper.map(createdUser, CreateUserResponseModel.class);
//
//        return ResponseEntity.status(HttpStatus.CREATED).body(returnValue);
//    }


    @GetMapping(value = "/{userId}", produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE })
    @PreAuthorize("hasRole('ADMIN') or principal == #userId")
    public ResponseEntity<CustomHttpResponse> getUser(@PathVariable("userId") String userId, @RequestHeader("Authorization") String authorization){
        UserResponseModel returnValue = null;
        try {
            UserDto userDto = usersService.getUserByUserId(userId, authorization);
            returnValue = new ModelMapper().map(userDto, UserResponseModel.class);
        } catch (Exception ex) {
            return ResponseBuilder.buildFailureResponse(HttpStatus.BAD_REQUEST, "400",
                    "Failed to fetch user list! Reason: " + ex.getMessage());
        }
        return ResponseBuilder.buildSuccessResponse(HttpStatus.OK, Map.of("userList", returnValue));
    }


//    @GetMapping(value = "/{userId}", produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE })
//    @PreAuthorize("hasRole('ADMIN') or principal == #userId")
////    @PreAuthorize("principal == #userId")
////    @PostAuthorize("principal == returnObject.body.userId")
//    public ResponseEntity<UserResponseModel> getUser(@PathVariable("userId") String userId,
//                                                     @RequestHeader("Authorization") String authorization){
//
//        UserDto userDto = usersService.getUserByUserId(userId, authorization);
//        UserResponseModel returnValue = new ModelMapper().map(userDto, UserResponseModel.class);
//
//        return ResponseEntity.status(HttpStatus.OK).body(returnValue);
//    }

    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PROFILE_DELETE')")
    @DeleteMapping("/{userId}")
    public String deleteUser(@PathVariable("userId") String userId){
        return "Delete user with id "+userId;
    }

}
