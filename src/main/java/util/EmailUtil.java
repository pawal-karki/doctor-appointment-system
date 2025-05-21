package util;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Utility class for sending emails with Jakarta Mail
 */
public class EmailUtil {
    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());
    
    // SMTP server settings - would be better to load from properties file
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "np05cp4a230099@iic.edu.np"; // Replace with actual email
    private static final String EMAIL_PASSWORD = "hwdd qxpp zqih ktlw"; // Replace with app password
    private static final String EMAIL_FROM = "np05cp4a230099@iic.edu.np";
    
    /**
     * Sends an email using SMTP
     * 
     * @param toEmail Recipient email address
     * @param subject Email subject
     * @param body Email body (HTML)
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendEmail(String toEmail, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            
            // Create session with authentication
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });
            
            // Create and send message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html");
            
            Transport.send(message);
            
            LOGGER.log(Level.INFO, "Email sent successfully to: {0}", toEmail);
            return true;
            
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send email to: " + toEmail, e);
            return false;
        }
    }
    
    /**
     * Send OTP email for password reset
     * 
     * @param email Recipient email
     * @param otp One-time password
     * @param expiryMinutes Expiry time in minutes
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendPasswordResetOTP(String email, String otp, int expiryMinutes) {
        String subject = "Password Reset - Your One-Time Password";
        
        String body = """
            <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;">
                <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px; border-top: 4px solid #2563eb;">
                    <h2 style="color: #2563eb; margin-top: 0;">Password Reset Request</h2>
                    <p>We received a request to reset your password for the Hospital Management System. Please use the following One-Time Password (OTP) to complete your password reset:</p>
                    
                    <div style="background-color: #e2e8f0; padding: 15px; border-radius: 5px; text-align: center; margin: 20px 0;">
                        <h3 style="font-size: 24px; margin: 0; letter-spacing: 5px; color: #1e293b;">%s</h3>
                    </div>
                    
                    <p>This OTP will expire in <strong>%d minutes</strong>.</p>
                    
                    <p style="margin-top: 30px; font-size: 13px; color: #64748b;">
                        If you did not request a password reset, please ignore this email or contact support if you have concerns.
                    </p>
                    
                    <p style="margin-top: 30px; font-size: 13px; color: #64748b;">
                        &copy; Hospital Management System
                    </p>
                </div>
            </body>
            </html>
            """.formatted(otp, expiryMinutes);
        
        return sendEmail(email, subject, body);
    }

    /**
     * Send appointment confirmation email to the patient
     * 
     * @param email Patient's email
     * @param doctorName Doctor's name
     * @param appointmentDate Appointment date
     * @param timeSlot Time slot details
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendAppointmentConfirmation(String email, String doctorName, String appointmentDate, String timeSlot) {
        String subject = "Appointment Confirmation - Hospital Management System";
        
        String body = """
            <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;">
                <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px; border-top: 4px solid #2563eb;">
                    <h2 style="color: #2563eb; margin-top: 0;">Appointment Confirmed</h2>
                    <p>Your appointment has been confirmed with the following details:</p>
                    
                    <div style="background-color: #e2e8f0; padding: 15px; border-radius: 5px; margin: 20px 0;">
                        <p><strong>Doctor:</strong> %s</p>
                        <p><strong>Date:</strong> %s</p>
                        <p><strong>Time:</strong> %s</p>
                    </div>
                    
                    <p>Please arrive 10 minutes before your scheduled appointment time.</p>
                    
                    <p style="margin-top: 30px; font-size: 13px; color: #64748b;">
                        If you need to reschedule or cancel your appointment, please contact us as soon as possible.
                    </p>
                    
                    <p style="margin-top: 30px; font-size: 13px; color: #64748b;">
                        &copy; Hospital Management System
                    </p>
                </div>
            </body>
            </html>
            """.formatted(doctorName, appointmentDate, timeSlot);
        
        return sendEmail(email, subject, body);
    }

    /**
     * Send appointment cancellation email to the patient
     * 
     * @param email Patient's email
     * @param doctorName Doctor's name
     * @param appointmentDate Appointment date
     * @param timeSlot Time slot details
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendAppointmentCancellation(String email, String doctorName, String appointmentDate, String timeSlot) {
        String subject = "Appointment Cancellation - Hospital Management System";
        
        String body = """
            <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;">
                <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px; border-top: 4px solid #dc2626;">
                    <h2 style="color: #dc2626; margin-top: 0;">Appointment Cancelled</h2>
                    <p>Your appointment has been cancelled. Here are the details of the cancelled appointment:</p>
                    
                    <div style="background-color: #e2e8f0; padding: 15px; border-radius: 5px; margin: 20px 0;">
                        <p><strong>Doctor:</strong> %s</p>
                        <p><strong>Date:</strong> %s</p>
                        <p><strong>Time:</strong> %s</p>
                    </div>
                    
                    <p>If you did not request this cancellation or have any questions, please contact our support team.</p>
                    
                    <p>If you would like to schedule a new appointment, please visit our website or contact us directly.</p>
                    
                    <p style="margin-top: 30px; font-size: 13px; color: #64748b;">
                        &copy; Hospital Management System
                    </p>
                </div>
            </body>
            </html>
            """.formatted(doctorName, appointmentDate, timeSlot);
        
        return sendEmail(email, subject, body);
    }
} 