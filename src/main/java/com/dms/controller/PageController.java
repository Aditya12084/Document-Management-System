package com.dms.controller;


import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String loadLoginPage(){
        return  "auth/auth";
    }

    @GetMapping("/home")
    public String homePage(HttpSession session){

        if (session.getAttribute("user")==null){
            return "redirect:/";
        }

        return "auth/home";
    }



}
