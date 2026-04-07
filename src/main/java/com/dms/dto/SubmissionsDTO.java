package com.dms.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SubmissionsDTO {
    Integer id;
    String owner;
    String docName;
    LocalDateTime uploadDate;
    String status;

    public SubmissionsDTO(Integer id,String owner,String docName,LocalDateTime uploadDate, String status){
        this.id=id;
        this.owner=owner;
       this.docName=docName;
       this.uploadDate=uploadDate;
       this.status=status;
    }

}
