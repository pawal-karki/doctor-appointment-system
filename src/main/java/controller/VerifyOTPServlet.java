package controller;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import util.OTPUtil;

@WebServlet("/verify-otp")
public class VerifyOTPServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(VerifyOTPServlet.class.getName());
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if we have email in session (user just registered)
        String email = (String) request.getSession().getAttribute("pendingVerificationEmail");
        
        if (email == null) {
            // No pending verification, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setAttribute("email", email);
        request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if this is a resend action
        String action = request.getParameter("action");
        if ("resend".equals(action)) {
            resendOTP(request, response);
            return;
        }
        
        // Get email from request, fallback to session if not found
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = (String) request.getSession().getAttribute("pendingVerificationEmail");
            if (email == null) {
                request.setAttribute("errorMessage", "Email information is missing. Please try again.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }
        
        String otp = request.getParameter("otp");
        
        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Verification code is required");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
            return;
        }
        
        try {
            // Get user by email
            User user = userDAO.getUserByEmail(email);
            
            if (user == null) {
                request.setAttribute("errorMessage", "User not found");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
                return;
            }
            
            // Verify OTP
            if (OTPUtil.isOTPValid(user.getOtpCode(), otp, user.getOtpExpiry())) {
                // OTP is valid, mark user as verified
                boolean verified = userDAO.verifyUser(user.getUserId());
                
                if (verified) {
                    LOGGER.log(Level.INFO, "User verified: {0}", email);
                    
                    // Clear pending verification email from session
                    request.getSession().removeAttribute("pendingVerificationEmail");
                    
                    // Set success message and redirect to login
                    request.getSession().setAttribute("successMessage", "Email verification successful! You can now log in.");
                    response.sendRedirect(request.getContextPath() + "/login");
                } else {
                    LOGGER.log(Level.WARNING, "Failed to verify user: {0}", email);
                    request.setAttribute("errorMessage", "Verification failed. Please try again.");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
                }
            } else {
                // Invalid OTP
                LOGGER.log(Level.WARNING, "Invalid OTP attempt for user: {0}", email);
                request.setAttribute("errorMessage", "Invalid or expired verification code");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during OTP verification", e);
            request.setAttribute("errorMessage", "An error occurred during verification. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
        }
    }
    
    private void resendOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get email from request, fallback to session
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = (String) request.getSession().getAttribute("pendingVerificationEmail");
            if (email == null) {
                request.setAttribute("errorMessage", "Email information is missing. Please try again from login.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }
        
        try {
            // Get user by email
            User user = userDAO.getUserByEmail(email);
            
            if (user == null) {
                request.setAttribute("errorMessage", "User not found");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
                return;
            }
            
            // Generate new OTP
            String otpCode = OTPUtil.generateOTP();
            long otpExpiry = OTPUtil.calculateOTPExpiry();
            
            // Update user with new OTP
            boolean updated = userDAO.updateOTP(user.getUserId(), otpCode, otpExpiry);
            
            if (updated) {
                // Send OTP email
                boolean sent = OTPUtil.sendOTPEmail(user.getEmail(), user.getName(), otpCode);
                
                if (sent) {
                    LOGGER.log(Level.INFO, "OTP resent to: {0}", email);
                    request.setAttribute("successMessage", "A new verification code has been sent to your email");
                } else {
                    LOGGER.log(Level.WARNING, "Failed to send OTP email to: {0}", email);
                    request.setAttribute("errorMessage", "Failed to send verification code. Please try again.");
                }
            } else {
                LOGGER.log(Level.WARNING, "Failed to update OTP for user: {0}", email);
                request.setAttribute("errorMessage", "Failed to generate new verification code. Please try again.");
            }
            
            // Ensure the email is stored in session
            request.getSession().setAttribute("pendingVerificationEmail", email);
            
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during OTP resend", e);
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
        }
    }
} 