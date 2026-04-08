package com.dms.controller;


import com.dms.entity.User;
import com.dms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PageController {

    @Autowired
    private UserRepository repo;

    @GetMapping("/")
    public String loadLoginPage(){
        return  "auth/auth";
    }

    @GetMapping("/dashboard")
    public String homePage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/";
        }

        if ("ADMIN".equals(user.getRole())) {
            return "admin/dashboard";
        }

        return "user/user-home";
    }

    @GetMapping("/verify-otp-page")
    private String verifyOtp(@RequestParam String email){

        User user=repo.findByEmail(email);



        if (user == null || user.isEnabled()) {
            return "redirect:/";
        }
        return "auth/verify-otp";
    }

    @GetMapping("/submissions")
    public String submissionsPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/";
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
            return "redirect:/";
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
            return "redirect:/";
        }

        if ("ADMIN".equals(user.getRole()) && user.isSuperAdmin()) {
            return "admin/manage-admins";
        }
        return "user/user-home";
    }


}
