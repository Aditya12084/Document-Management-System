package com.dms.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
public class Document {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String filename;
    private String filetype;
    private String filepath;

    @Column(name = "doc_category")
    private String docCategory;

    public String getDocCategory() {
        return docCategory;
    }

    public void setDocCategory(String docCategory) {
        this.docCategory = docCategory;
    }

    public Integer getTargetUserId() {
        return targetUserId;
    }

    public void setTargetUserId(Integer targetUserId) {
        this.targetUserId = targetUserId;
    }

    private String status;


    @Column(name = "target_user_id",nullable = true)
    private Integer targetUserId;

    @Column(name = "status_modification_time")
    private LocalDateTime statusModificationTime;

    public Integer getStatusModifiedByAdminId() {
        return statusModifiedByAdminId;
    }

    public void setStatusModifiedByAdminId(Integer statusModifiedByAdminId) {
        this.statusModifiedByAdminId = statusModifiedByAdminId;
    }

    public LocalDateTime getStatusModificationTime() {
        return statusModificationTime;
    }

    public void setStatusModificationTime(LocalDateTime statusModificationTime) {
        this.statusModificationTime = statusModificationTime;
    }

    @Column(name = "status_modified_by_admin_id")
    private Integer statusModifiedByAdminId;

    @Column(nullable = false)
    private Integer uploadedBy;

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    private long fileSize;

    public Integer getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(Integer uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public LocalDateTime getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(LocalDateTime uploadDate) {
        this.uploadDate = uploadDate;
    }

    private LocalDateTime uploadDate;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    //getters
    public int getId() {
        return id;
    }

    public String getFilename() {
        return filename;
    }

    public String getFiletype() {
        return filetype;
    }

    public String getFilepath() {
        return filepath;
    }

    //setters
    public void setId(int id) {
        this.id = id;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public void setFiletype(String filetype) {
        this.filetype = filetype;
    }

    public void setFilepath(String filepath) {
        this.filepath = filepath;
    }

}
