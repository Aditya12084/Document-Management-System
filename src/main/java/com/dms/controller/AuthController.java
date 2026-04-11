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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;


@RestController
public class AuthController {

    @Autowired
    private UserRepository repo;

    @Autowired
    private UserService service;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @Autowired
    private EmailService emailService;


    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user, HttpSession session){

        try{
            User adminUser=(User) session.getAttribute("user");

            User existingUser=repo.findByUsername(user.getUsername());

            if (existingUser!=null && existingUser.isEnabled()){
                return ResponseEntity.status(HttpStatus.CONFLICT).body("Username already exists!");
            }

            User userToSave= existingUser!=null ? existingUser : user;

            if (adminUser!=null && adminUser.isSuperAdmin()){
                userToSave.setRole("ADMIN");
                userToSave.setPassword(encoder.encode("admin"));
            } else{
                userToSave.setPassword(encoder.encode(user.getPassword()));
            }

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

            if (user.getRole()!=null && user.getRole().equals("ADMIN")){
                response.put("redirectUrl","/dashboard");
            }
            else {
                response.put("redirectUrl","/home");
            }

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

//            System.out.println(email+" "+enteredOtp);

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

    @PostMapping("/verify-otp-up-pwd")
    public ResponseEntity<?> verifyOtpUpdatePassword(@RequestBody Map<String,String> data,HttpSession session){
        try{
            User user=(User) session.getAttribute("user");
            String pendingNewPassword= (String) session.getAttribute("pendingNewPassword");

            Optional<User> dbUser=repo.findById(user.getId());

            String enteredOtp=data.get("otp");

            if (dbUser.isPresent()){
                User actualUser=dbUser.get();

                if (actualUser.getOtp()!=null && enteredOtp.equals(actualUser.getOtp())){

                    LocalDateTime creationTime=actualUser.getOtpCreationTime();

                    long minutesElapsed=java.time.Duration.between(creationTime,LocalDateTime.now()).toMinutes();

                    if (minutesElapsed>5) {
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("OTP has expired. Please try again.");
                    }

                    actualUser.setPassword(encoder.encode(pendingNewPassword));
                    actualUser.setOtp(null);
                    actualUser.setOtpCreationTime(null);
                    repo.save(actualUser);

                    return ResponseEntity.ok("Password updated successfully.");
                }
                else{
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid OTP!");
                }
            }

            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not exist.");

        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Verification failed.");

        }
    }


    @PostMapping("/verify-current-pwd")
    public ResponseEntity<?> verifyCurrentPassword(@RequestBody Map<String,String> data,HttpSession session){
        try{

            User user=(User) session.getAttribute("user");

            if (user==null){
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Please register/login first.");
            }

            String currentPwd=data.get("currentPwd");
            String newPwd=data.get("newPwd");

            if (currentPwd.equals(newPwd)){
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("New password cannot be the same as the current password.");
            }

            Optional<User> dbUser=repo.findById(user.getId());

            if(dbUser.isPresent()){
                User actualUser = dbUser.get();

                if (encoder.matches(currentPwd,actualUser.getPassword())){

                    String otp=generateOTP();
                    actualUser.setOtp(otp);
                    actualUser.setOtpCreationTime(LocalDateTime.now());

                    repo.save(actualUser);

                    session.setAttribute("pendingNewPassword",newPwd);

                    try {
                        emailService.sendOtpEmail(user.getEmail(), otp);
                    } catch (Exception e) {
                        e.printStackTrace();
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                .body("Failed to send OTP email.");
                    }
                    return ResponseEntity.ok().build();
                }
                else{
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect current Password");
                }
            }

            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not exists.");

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }

    }

    @PostMapping("/forget-pwd")
    public ResponseEntity<?> handleForgetPassword(@RequestBody Map<String,String> data){

        try{
            String email=data.get("email");

            User user=repo.findByEmail(email);

            if (user==null){
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not exists.");
            }

            String otp=generateOTP();
            user.setOtp(otp);
            user.setOtpCreationTime(LocalDateTime.now());

            repo.save(user);

            try {
                emailService.sendOtpEmail(user.getEmail(), otp);
            } catch (Exception e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("Failed to send OTP email.");
            }
            return ResponseEntity.ok().build();

        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }
    }


    @PostMapping("/verify-otp-forget-pass")
    public ResponseEntity<?> verifyOtpForgetPassword(@RequestBody Map<String,String> data,HttpSession session){
        try {
            String email=data.get("email");
            String enteredOtp=data.get("otp");

            User user=repo.findByEmail(email);

            if (user==null){
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not exists.");
            }

            if (user.getOtp()!=null && enteredOtp.equals(user.getOtp())){
                user.setOtp(null);
                user.setOtpCreationTime(null);
                repo.save(user);

                session.setAttribute("resetPasswordSession", email);

                return ResponseEntity.ok().build();
            }
            else{
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid OTP!");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }
    }

    @PostMapping("/reset-pwd")
    public ResponseEntity<?> handleResetPassword(@RequestBody Map<String,String> data,HttpSession session){
        try{
            String email = (String) session.getAttribute("resetPasswordSession");
            if (email==null){
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Session expired.");
            }

            User user=repo.findByEmail(email);

            if (user==null){
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not exits");
            }

            String newPassword=data.get("newPassword");

            user.setPassword(encoder.encode(newPassword));

            repo.save(user);

            session.removeAttribute("resetPasswordSession");

            return ResponseEntity.ok("Password reset successful");
        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occured");
        }
    }

}
