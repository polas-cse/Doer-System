package com.doer.services.auth.controller;

import com.doer.services.auth.service.UsersService;
import org.springframework.core.env.Environment;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private Environment environment;

    public AuthController(Environment environment)
                                 {
        this.environment = environment;
    }

    @GetMapping("/msg")
    public String getMsg(){
        return "Hello! i'm from auth controller";
    }

}
