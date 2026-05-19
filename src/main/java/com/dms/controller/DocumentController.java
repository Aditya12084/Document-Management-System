package com.dms.controller;

import com.dms.entity.Document;
import com.dms.entity.User;
import com.dms.repository.UserRepository;
import com.dms.service.DocumentService;
//import jakarta.annotation.Resource;
import com.dms.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.core.io.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.datasource.UserCredentialsDataSourceAdapter;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import javax.print.Doc;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/document")
public class DocumentController extends BaseController{

    @Autowired
    private DocumentService service;

    @Autowired
    private UserService userService;

    private static final String UPLOAD_URL="c:/dms/uploads/";

    @PostMapping("/upload")
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile file,
                             @RequestParam(value = "targetUserId", required = false) Integer targetUserId,
                             @RequestParam("docCategory") String docCategory, HttpSession session) throws IOException {

        try {

            User user=(User) session.getAttribute("user");

            if (user==null){
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Please login first.");
            }

            String filename = file.getOriginalFilename();
            String filepath = UPLOAD_URL + filename;

            file.transferTo(new File(filepath));

            Document doc = new Document();
            doc.setFilename(filename);
            doc.setFiletype(file.getContentType());
            doc.setFilepath(filepath);
            doc.setUploadDate(LocalDateTime.now());
            if (!"ADMIN".equals(user.getRole())){
                doc.setStatus("PENDING");
            }
            doc.setFileSize(file.getSize());
            doc.setUploadedBy(user.getId());
            if ("ADMIN".equals(user.getRole())) {
                if (userService.findById(targetUserId) != null){
                    doc.setTargetUserId(targetUserId);
                }
                else {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not exists");
                }
            }
            doc.setDocCategory(docCategory);

            service.saveDocument(doc);

            return ResponseEntity.status(HttpStatus.CREATED).body("File uploaded successfully!");

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured.");
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

        if (!"ADMIN".equals(user.getRole()) && user.getId()!=doc.getUploadedBy() && user.getId()!=doc.getTargetUserId()){
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
    public ResponseEntity<?> updateDocumentStatus(@PathVariable int id, @RequestParam String status, @RequestBody(required = false) Map<String,String> data,HttpSession session){

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

            if (newStatus.equals("REJECTED")){
                doc.setRejectionRemark(data.get("rejectionRemark"));
            }

            doc.setStatus(status);
            doc.setStatusModificationTime(LocalDateTime.now());

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

    @PostMapping("/remove/{id}")
    public ResponseEntity<?> removeDocument(@PathVariable Integer id, HttpSession session){

        try {
            User user = getAutheticatedUser(session);

            Document doc=service.getDocumentById(id);

            if (doc==null){
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Document Not Found");
            }

            if (user.getId()==doc.getUploadedBy() && doc.getStatus().equals("PENDING")){
                service.removeDocumentService(id);
            }
            else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("You cant remove this Document");
            }

            return ResponseEntity.ok().build();

        }
        catch (ResponseStatusException e){
            return ResponseEntity.status(e.getStatusCode()).body(e.getReason());
        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured.");
        }

    }

}
