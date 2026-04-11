package com.dms.dto.admin;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ActivityDTO {
    private String filename;
    private String owner;
    private String adminName;
    private String status;
    private LocalDateTime time;

    // Constructor, Getters, and Setters
    public ActivityDTO(String filename, String owner,String adminName, String status, LocalDateTime time) {
        this.filename = filename;
        this.owner=owner;
        this.adminName = adminName;
        this.status = status;
        this.time = time;
    }
}