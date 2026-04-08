package com.dms.dto;

import com.dms.entity.User;
import lombok.Data;

@Data
public class UserDTO {

    String username;
    String fullname;
    String email;

    public UserDTO(String username,String fullname,String email){
        this.username=username;
        this.fullname=fullname;
        this.email=email;
    }

}
