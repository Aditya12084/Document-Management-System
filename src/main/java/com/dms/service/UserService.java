package com.dms.service;

import com.dms.entity.User;
import com.dms.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository repo;

    @Autowired
    private BCryptPasswordEncoder encoder;

    public User login(String username){
        return repo.findByUsername(username);
    }

    public void register(User user){
        user.setPassword(encoder.encode(user.getPassword()));
        repo.save(user);
    }

}
