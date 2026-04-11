package com.dms.controller;

import com.dms.dto.common.DocumentDTO;
import com.dms.entity.Document;
import com.dms.entity.User;
import com.dms.repository.UserRepository;
import com.dms.service.DocumentService;
import com.dms.service.EmailService;
import com.dms.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import javax.print.Doc;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private DocumentService docService;

    @GetMapping("/pending-docs")
    public ResponseEntity<?> getPendingDocs(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session expired");
        }

        List<DocumentDTO> pendingDocs = docService.getDocumentsByStatus(user.getId(),"PENDING");
        return ResponseEntity.ok(pendingDocs);
    }

    @GetMapping("/recent-shares")
    public ResponseEntity<?> getRecentShares(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session expired");
        }

        List<DocumentDTO> pendingDocs = docService.getRecentSharesService(user.getId());
        return ResponseEntity.ok(pendingDocs);
    }


    @GetMapping("/rejected-docs")
    public ResponseEntity<?> getRejectedDocuments(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session expired");
        }

        List<DocumentDTO> rejectedDocs = docService.getDocumentsByStatus(user.getId(),"REJECTED");

        return ResponseEntity.ok(rejectedDocs);
    }

    @GetMapping("/my-docs")
    public ResponseEntity<?> getMyDocuments(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session expired");
        }

        List<DocumentDTO> myDocs = docService.getMyDocumentsService(user.getId());

        return ResponseEntity.ok(myDocs);
    }

    @GetMapping("/received-docs")
    public ResponseEntity<?> getReceivedDocuments(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session expired");
        }

        List<DocumentDTO> receivedDocs = docService.getReceivedDocumentsService(user.getId());

        return ResponseEntity.ok(receivedDocs);
    }


}
