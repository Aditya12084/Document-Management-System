package com.dms.dto.common;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class DocumentDTO {
    Integer id;
    String owner;
    String docName;
    String docCategory;
    LocalDateTime uploadDate;
    String rejectionRemark;
    String status;
    Long fileSize;
    LocalDateTime statusModificationTime;

    public DocumentDTO(Integer id, String owner,
                       String docName, LocalDateTime uploadDate,
                       String rejectionRemark, String status,
                       String docCategory, Long fileSize, LocalDateTime statusModificationTime){
        this.id=id;
        this.owner=owner;
        this.docName=docName;
        this.uploadDate=uploadDate;
        this.rejectionRemark=rejectionRemark;
        this.status=status;
        this.docCategory=docCategory;
        this.fileSize=fileSize;
        this.statusModificationTime=statusModificationTime;
    }

}
