package com.dms.service;

import com.dms.dto.AdminDTO;
import com.dms.entity.User;
import com.dms.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

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

    public List<AdminDTO> getAdmins(){
        List<User> adminUsersList=repo.findAllByRoleAndIsSuperAdminFalseAndEnabledTrue("ADMIN");
        List<AdminDTO> adminDtoList=new ArrayList<>();

        for (User admin:adminUsersList){
            adminDtoList.add(new AdminDTO(admin.getId(),admin.getUsername(),admin.getFullname(),admin.getEmail()));
        }

        return adminDtoList;
    }

    public void removeAdmin(String adminId){
        repo.disableAdminById(adminId);
    }

}
