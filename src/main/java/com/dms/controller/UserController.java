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

import java.time.LocalDateTime;
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

            User existingUser=repo.findByUsername(user.getUsername());

            if (existingUser!=null && existingUser.isEnabled()){
                return ResponseEntity.status(HttpStatus.CONFLICT).body("Username already exists!");
            }

            User userToSave= existingUser!=null ? existingUser : user;

            userToSave.setPassword(encoder.encode(user.getPassword()));
            userToSave.setEmail(user.getEmail());

            String otp=generateOTP();
            userToSave.setOtp(otp);
            userToSave.setOtpCreationTime(LocalDateTime.now());
            userToSave.setEnabled(false);

            repo.save(userToSave);

            try {
                emailService.sendOtpEmail(user.getEmail(), otp);
            } catch (Exception e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                            .body("Failed to send OTP email.");
            }

            return ResponseEntity.status(HttpStatus.CREATED).body("Registration successful!");
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
              session.setAttribute("userRole", dbUser.getRole());
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

            System.out.println(email+" "+enteredOtp);

            User user=repo.findByEmail(email);

            if (user!=null && user.getOtp()!=null && user.getOtp().equals(enteredOtp)){

                LocalDateTime creationTime=user.getOtpCreationTime();

                long minutesElapsed=java.time.Duration.between(creationTime,LocalDateTime.now()).toMinutes();

                if (minutesElapsed>5) {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("OTP has expired. Please register again.");
                }

                user.setEnabled(true);
                user.setOtp(null);
                user.setOtpCreationTime(null);
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
