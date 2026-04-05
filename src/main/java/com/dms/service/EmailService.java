package com.dms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendVerificationEmail(String to,String token){
        String subject="Verify your email";
        String confirmationUrl="http://localhost:8080/verify?token=" +token;
        SimpleMailMessage email=new SimpleMailMessage();
        email.setTo(to);
        email.setSubject(subject);
        email.setText("Click here to verify: "+confirmationUrl);
        mailSender.send(email);

    }

    public void sendOtpEmail(String to, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Your Verification Code");
        message.setText("Your 6-digit verification code is: " + otp +
                "\n\nThis code will expire shortly.");
        mailSender.send(message);
    }

}
