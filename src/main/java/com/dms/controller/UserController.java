package com.dms.controller;

import com.dms.entity.User;
import com.dms.repository.UserRepository;
import com.dms.service.EmailService;
import com.dms.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class UserController {

    @Autowired
    private UserRepository repo;

    @Autowired
    private UserService service;

    @Autowired
    private BCryptPasswordEncoder encoder;
    @Autowired
    private EmailService emailService;


    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user){

        try{

//            String username=user.getUsername();
//            String password=user.getPassword();
//            String email=user.getEmail();

            if(repo.findByUsername(user.getUsername())==null){
//                User newUser=new User();
//                newUser.setUsername(username);
//                newUser.setEmail(email);
//                newUser.setPassword(encoder.encode(password));

                user.setPassword(encoder.encode(user.getPassword()));

                String otp=generateOTP();
                user.setOtp(otp);
                user.setEnabled(false);

                repo.save(user);

                try {
                    emailService.sendOtpEmail(user.getEmail(), otp);
                } catch (Exception e) {
                    e.printStackTrace();
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                            .body("Failed to send OTP email.");
                }

                return ResponseEntity.status(HttpStatus.CREATED).body("Registration successful!");
            }
            else{
                return ResponseEntity.status(HttpStatus.CONFLICT).body("Username already exists!");
            }
        }
        catch(Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred!");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User user, HttpSession session){

        HashMap<String,String> response=new HashMap<>();

        User dbUser=service.login(user.getUsername());

        if (dbUser!=null && encoder.matches(user.getPassword(),dbUser.getPassword())){
            session.setAttribute("user",dbUser);
              response.put("username",dbUser.getUsername());
              response.put("role",dbUser.getRole());

              return ResponseEntity.ok(response);
        }
        else{
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "logged out successfully!";
    }


    private String generateOTP() {
        java.util.Random random = new java.util.Random();
        int number = 100000 + random.nextInt(900000);
        return String.valueOf(number);
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody Map<String,String> request){
        try{
            String email=request.get("email");
            String enteredOtp=request.get("otp");

            User user=repo.findByEmail(email);

            if (user!=null && user.getOtp().equals(enteredOtp)){
                user.setEnabled(true);
                user.setOtp(null);
                repo.save(user);

                return ResponseEntity.ok("Email verified successfully!");
            }
            else{
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid OTP!");
            }
        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Verification failed.");

        }

    }

}
