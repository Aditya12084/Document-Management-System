package com.dms.dto;


import lombok.Data;

@Data
public class AdminDTO {

    int id;
    String username;
    String fullname;
    String email;

    public AdminDTO(int id,String username,String fullname,String email){
        this.id=id;
        this.username=username;
        this.fullname=fullname;
        this.email=email;
    }

}
