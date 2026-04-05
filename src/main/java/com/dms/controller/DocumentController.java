package com.dms.controller;

import com.dms.entity.Document;
import com.dms.entity.User;
import com.dms.service.DocumentService;
//import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpSession;
import org.springframework.core.io.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.print.Doc;
import java.io.File;
import java.io.IOException;

@RestController
public class DocumentController {

    @Autowired
    private DocumentService service;

    private static final String UPLOAD_URL="c:/dms/uploads/";

    @PostMapping("/upload")
    public String UploadFile(@RequestParam("file") MultipartFile file, HttpSession session) throws IOException {

        User user=(User) session.getAttribute("user");

        if (user==null){
            return "Please login first";
        }

        if (user.getRole()==null && !"ADMIN".equals(user.getRole())){
            return "Access Denied";
        }

        try {
            String filename = file.getOriginalFilename();
            String filepath = UPLOAD_URL + filename;

            file.transferTo(new File(filepath));

            Document doc = new Document();
            doc.setFilename(filename);
            doc.setFiletype(file.getContentType());
            doc.setFilepath(filepath);

            service.saveDocument(doc);

            return "File uploaded successfully!";

        } catch (Exception e) {
           return  e.getMessage();
        }

    }

    @GetMapping("/document/{id}")
    public ResponseEntity<Resource> downloadFile(@PathVariable int id){

        Document doc=service.getDocumentById(id);

        if (doc==null){
            return ResponseEntity.notFound().build();
        }

        File file=new File(doc.getFilepath());

        Resource resource = new FileSystemResource(file);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,"attachment; filename="+file.getName())
                .body(resource);
    }

}
