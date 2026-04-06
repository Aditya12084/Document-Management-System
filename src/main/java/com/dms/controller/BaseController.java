package com.dms.controller;

import com.dms.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

public abstract class BaseController {

    protected User getAutheticatedUser(HttpSession session){
        User user=(User) session.getAttribute("user");
        if (user==null){
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Unauthorized");
        }
        return user;
    }
}
