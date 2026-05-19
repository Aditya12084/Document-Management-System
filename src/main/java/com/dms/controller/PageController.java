package com.dms.controller;


import com.dms.entity.User;
import com.dms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;

@Controller
public class PageController {

    @Autowired
    private UserRepository repo;

    @GetMapping("/")
    public String loadLoginPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user != null){
            if ("ADMIN".equals(user.getRole())) {
                return "redirect:/dashboard";
            }
            if ("USER".equals(user.getRole())) {
                return "redirect:/home";
            }
        }
        return  "auth/auth";
    }

    @GetMapping("/dashboard")
    public String dashboardPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "admin/dashboard";
        }

        return "redirect:/home";
    }

    @GetMapping("/verify-otp-page")
    private String verifyOtp(@RequestParam String email,HttpSession session){

        User user=repo.findByEmailAndEnabledTrue(email);

        String registerEmail=(String) session.getAttribute("registerSession");

        if (registerEmail!=null){
            return "auth/verify-otp";
        }

        if (user == null || user.isEnabled()) {
            return "views/error-404";
        }
        return "auth/verify-otp";
    }

    @GetMapping("/verify-otp-pass-up")
    public String verifyOtpUpPassword(HttpSession session){

        User user = (User) session.getAttribute("user");
        if (user==null || !user.isEnabled()){
            return "views/error-404";
        }

        return "auth/verify-otp";
    }

    @GetMapping("/verify-otp-frg-pwd")
    public String verifyOtpForgetPassword(HttpSession session){

        String sessionEmail = (String) session.getAttribute("forgetPasswordSession");

        if (sessionEmail == null) {
            return "views/error-404";
        }

        User user = repo.findByEmailAndEnabledTrue(sessionEmail);

        if (user == null || user.getOtpCreationTime() == null) {
            return "views/error-404";
        }

        long minutesElapsed = java.time.Duration.between(user.getOtpCreationTime(), LocalDateTime.now()).toMinutes();

        if (minutesElapsed > 5) {
            user.setOtp(null);
            user.setOtpCreationTime(null);
            repo.save(user);

            session.removeAttribute("forgetPasswordSession");

            return "redirect:/";
        }

        return "auth/verify-otp";
    }


    @GetMapping("/submissions")
    public String submissionsPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "admin/submissions";
        }

        return "user/user-home";
    }

    @GetMapping("/upload-document")
    public String uploadDocumentPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "shared/upload-doc";
        }

        return "user/user-home";
    }

    @GetMapping("/manage-admins")
    public String manageAdminsPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole()) && user.isSuperAdmin()) {
            return "admin/manage-admins";
        }
        return "user/user-home";
    }

    @GetMapping("/users")
    public String usersPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "admin/users";
        }
        return "user/user-home";
    }

    @GetMapping("/profile")
    public String profilePage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "/views/error-404";
        }

        return "common/profile";
    }

    @GetMapping("/reset-password")
    public String resetPasswordPage(HttpSession session){

//        String resetPassEmail = (String) session.getAttribute("resetPasswordSession");
//        String forgetPassEmail= (String) session.getAttribute("forgetPasswordSession");
        Boolean otpVerified= (Boolean) session.getAttribute("otpVerified");

        if (otpVerified == null || !otpVerified) {
            return "views/error-404";
        }

        return "auth/reset-password";
    }


    @GetMapping("/home")
    public String homePage(HttpSession session){

        User user = (User) session.getAttribute("user");

        if (user==null){
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }

        return "user/home";
    }

    @GetMapping("/my-documents")
    public String myDocumentsPage(HttpSession session){

        User user = (User) session.getAttribute("user");

        if (user==null){
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }

        return "user/my-documents";
    }

    @GetMapping("/received-documents")
    public String recDocumentsPage(HttpSession session){

        User user = (User) session.getAttribute("user");

        if (user==null){
            return "views/error-404";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }

        return "user/received-documents";
    }

//    @GetMapping("/**")
//    public String handleNotFound() {
//        return "views/error-404";
//    }

}
