package com.dms.controller;


import com.dms.entity.User;
import com.dms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    @GetMapping("/verify-otp-pass-up")
    public String verifyOtpUpPassword(HttpSession session){

        User user = (User) session.getAttribute("user");
        if (user==null || !user.isEnabled()){
            return "redirect:/";
        }

        return "auth/verify-otp";
    }
    @GetMapping("/verify-otp-frg-pwd")
    public String verifyOtpForgetPassword(@RequestParam("email") String email){

        User user=repo.findByEmail(email);

        System.out.println("My email is :"+ email);

        if (user!=null && user.getOtpCreationTime()==null){
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

    @GetMapping("/users")
    public String usersPage(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/";
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
            return "redirect:/";
        }

        return "common/profile";
    }



    @GetMapping("/reset-password")
    public String resetPasswordPage(HttpSession session){

        String email = (String) session.getAttribute("resetPasswordSession");

        if (email==null){
            return "redirect:/";
        }

        return "auth/reset-password";
    }

}
