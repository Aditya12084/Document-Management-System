package com.dms.controller;

import com.dms.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AdminController {

    @Autowired
    private UserService service;

    @PostMapping("/remove-admin")
    public ResponseEntity<?> removeAdmin(@RequestBody String adminId){
        try{
            service.removeAdmin(adminId);

            return ResponseEntity.ok("Admin removed successfully");

        } catch (Exception e) {
            return  ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }
    }
}
