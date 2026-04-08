package com.dms.controller;


import com.dms.dto.ActivityDTO;
import com.dms.dto.SubmissionsDTO;
import com.dms.entity.Document;
import com.dms.entity.User;
import com.dms.service.DashboardService;
import com.dms.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.print.Doc;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/dashboard")
public class DashboardController extends BaseController{

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private UserService userService;


    @GetMapping("/stats")
    public ResponseEntity<HashMap<String, Object>> getDashboardStats(HttpSession session){

        HashMap<String,Object> stats=dashboardService.getStats();

        return ResponseEntity.ok(stats);
    }


    @GetMapping("/pending-docs")
    public ResponseEntity<?> getPendingDocs(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session expired");
        }

        if ("ADMIN".equals(user.getRole())) {
            List<Document> pendingDocs = dashboardService.getPendingDocuments();
            return ResponseEntity.ok(pendingDocs);
        }

        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You do not have ADMIN rights");
    }

    @GetMapping("/recent-docs")
    public ResponseEntity<?> getRecentDocs(HttpSession session){

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Session expired");
        }

        if ("ADMIN".equals(user.getRole())) {
            List<Document> recentDocs = dashboardService.getRecentDocuments();
            return ResponseEntity.ok(recentDocs);
        }

        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You do not have ADMIN rights");

    }

    @GetMapping("/recent-activity")
    public ResponseEntity<?> getRecentActivity(HttpSession session){

        try{
            User user=getAutheticatedUser(session);

            if (!"ADMIN".equals(user.getRole())){
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You do not have ADMIN rights");
            }

            List<ActivityDTO> activityList=dashboardService.getRecentActivity();
            return ResponseEntity.ok(activityList);
        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }

    }

    @GetMapping("/submissions")
    public ResponseEntity<?> getSubmissions(HttpSession session){

        try{
            User user=getAutheticatedUser(session);

            if (!"ADMIN".equals(user.getRole())){
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You do not have ADMIN rights");
            }

            List<SubmissionsDTO> submissionsDTOList=dashboardService.getSubmissions();

            return  ResponseEntity.ok(submissionsDTOList);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }
    }

    @GetMapping("/admins")
    public ResponseEntity<?> getAdmins(HttpSession session){
        try{
            User user=getAutheticatedUser(session);

            if("ADMIN".equals(user.getRole()) && user.isSuperAdmin()){
                return ResponseEntity.ok(userService.getAdmins());
            }

            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You do not have SUPER ADMIN rights");

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }

    }

}
