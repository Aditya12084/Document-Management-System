package com.dms.controller;

import com.dms.entity.Document;
import com.dms.entity.User;
import com.dms.repository.UserRepository;
import com.dms.service.DocumentService;
//import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpSession;
import org.springframework.core.io.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import javax.print.Doc;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

@RestController
@RequestMapping("/document")
public class DocumentController extends BaseController{

    @Autowired
    private DocumentService service;

    @Autowired
    private UserRepository userRepo;

    private static final String UPLOAD_URL="c:/dms/uploads/";

    @PostMapping("/upload")
    public String UploadFile(@RequestParam("file") MultipartFile file, HttpSession session) throws IOException {

        User user=(User) session.getAttribute("user");

        if (user==null){
            return "Please login first";
        }

//        if (user.getRole()==null && !"ADMIN".equals(user.getRole())){
//            return "Access Denied";
//        }

        try {
            String filename = file.getOriginalFilename();
            String filepath = UPLOAD_URL + filename;

            file.transferTo(new File(filepath));

            Document doc = new Document();
            doc.setFilename(filename);
            doc.setFiletype(file.getContentType());
            doc.setFilepath(filepath);
            doc.setUploadDate(LocalDateTime.now());
            doc.setStatus("PENDING");
            doc.setFileSize(file.getSize());
            doc.setUploadedBy(user.getId());



            service.saveDocument(doc);

            return "File uploaded successfully!";

        } catch (Exception e) {
           return  e.getMessage();
        }

    }

    @GetMapping("/{id}")
    public ResponseEntity<?> downloadFile(HttpSession session,@PathVariable int id){


        User user= (User) session.getAttribute("user");

        if (user==null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Please login first.");
        }

        Document doc=service.getDocumentById(id);

        if (doc==null){
            return ResponseEntity.notFound().build();
        }

        if (!"ADMIN".equals(user.getRole()) && user.getId()!=doc.getUploadedBy()){
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied");
        }

        File file=new File(doc.getFilepath());

        Resource resource = new FileSystemResource(file);

        MediaType mediaType=MediaType.parseMediaType(doc.getFiletype());

        return ResponseEntity.ok()
                .contentType(mediaType)
                .header(HttpHeaders.CONTENT_DISPOSITION,"inline; filename="+file.getName())
                .body(resource);
    }

    @PostMapping("/{id}/status")
    public ResponseEntity<?> updateDocumentStatus(@PathVariable int id,@RequestParam String status,HttpSession session){
        try {
            User user = getAutheticatedUser(session);

            if (!"ADMIN".equals(user.getRole())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied");
            }

            Document doc = service.getDocumentById(id);

            if (doc == null) {
                return ResponseEntity.notFound().build();
            }

            String newStatus=status.toUpperCase();
            List<String> allowedStatuses = Arrays.asList("PENDING", "APPROVED", "REJECTED");

            if (!allowedStatuses.contains(newStatus)){
                return  ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid status. Must be PENDING, APPROVED, or REJECTED.");
            }

            doc.setStatus(status);
            doc.setStatusModificationTime(LocalDateTime.now());

            System.out.print("user_id"+user.getId());
            doc.setStatusModifiedByAdminId(user.getId());
            service.saveDocument(doc);

            return ResponseEntity.ok("Status updated to"+newStatus);
        }
        catch (ResponseStatusException e){
            return ResponseEntity.status(e.getStatusCode()).body(e.getReason());
        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured.");
        }

    }

}
