package util;

import java.util.Properties;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Utility class for OTP operations
 */
public class OTPUtil {
    private static final Logger LOGGER = Logger.getLogger(OTPUtil.class.getName());
    private static final Random RANDOM = new Random(); // Faster than SecureRandom for OTPs
    private static final int OTP_LENGTH = 6;
    private static final String OTP_CHARS = "0123456789";
    private static final long OTP_EXPIRY_MINUTES = 15; // OTP valid for 15 minutes
    
    // Email configuration
    private static final String EMAIL_HOSTS = "smtp.gmail.com";
    private static final String EMAIL_PORT = "587";
    private static final String EMAIL_USERNAME = "np05cp4a230099@iic.edu.np";
    private static final String EMAIL_PASSWORD = "hwdd qxpp zqih ktlw";
    private static final String EMAIL_FROM = "np05cp4a230099@iic.edu.np";
    
    // Cache the email session and template
    private static final Session EMAIL_SESSION;
    private static final String EMAIL_TEMPLATE;
    
    static {
        // Initialize email session
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", EMAIL_HOSTS);
        props.put("mail.smtp.port", EMAIL_PORT);
        
        EMAIL_SESSION = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });
        
        // Initialize email template
        EMAIL_TEMPLATE = 
            "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;'>" +
            "<h2 style='color: #2563eb;'>Email Verification</h2>" +
            "<p>Hello %s,</p>" +
            "<p>Thank you for registering with Doctor Appointment System. To verify your email address, please use the following verification code:</p>" +
            "<div style='background-color: #f0f7ff; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; margin: 20px 0; border-radius: 5px;'>" +
            "%s" +
            "</div>" +
            "<p>This code will expire in " + OTP_EXPIRY_MINUTES + " minutes.</p>" +
            "<p>If you did not request this code, please ignore this email.</p>" +
            "<p>Best regards,<br>Doctor Appointment System Team</p>" +
            "</div>";
    }
    
    /**
     * Generates a random OTP code
     * 
     * @return Generated OTP code
     */
    public static String generateOTP() {
        StringBuilder otp = new StringBuilder(OTP_LENGTH);
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(OTP_CHARS.charAt(RANDOM.nextInt(OTP_CHARS.length())));
        }
        return otp.toString();
    }
    
    /**
     * Calculates OTP expiry timestamp
     * 
     * @return Expiry timestamp in milliseconds
     */
    public static long calculateOTPExpiry() {
        return System.currentTimeMillis() + (OTP_EXPIRY_MINUTES * 60 * 1000);
    }
    
    /**
     * Checks if OTP is valid
     * 
     * @param storedOTP The OTP stored in the database
     * @param inputOTP The OTP provided by the user
     * @param expiryTime The expiry timestamp
     * @return true if OTP is valid and not expired
     */
    public static boolean isOTPValid(String storedOTP, String inputOTP, long expiryTime) {
        if (storedOTP == null || inputOTP == null) {
            return false;
        }
        
        // Check if OTP is expired
        if (System.currentTimeMillis() > expiryTime) {
            return false;
        }
        
        // Compare OTP values
        return storedOTP.equals(inputOTP);
    }
    
    /**
     * Sends OTP to user's email using cached session and template
     * 
     * @param toEmail Recipient email
     * @param userName Recipient name
     * @param otpCode OTP code to send
     * @return true if email sent successfully
     */
    public static boolean sendOTPEmail(String toEmail, String userName, String otpCode) {
        try {
            // Create message using cached session
            Message message = new MimeMessage(EMAIL_SESSION);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Doctor Appointment System - Email Verification");
            
            // Use cached template
            String htmlContent = String.format(EMAIL_TEMPLATE, userName, otpCode);
            message.setContent(htmlContent, "text/html");
            
            // Send message
            Transport.send(message);
            
            LOGGER.info("OTP email sent to: " + toEmail);
            return true;
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Error sending OTP email", e);
            return false;
        }
    }
} 