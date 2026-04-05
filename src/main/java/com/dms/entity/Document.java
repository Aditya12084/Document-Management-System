package com.dms.entity;

import jakarta.persistence.*;

@Entity
public class Document {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String filename;
    private String filetype;
    private String filepath;

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
