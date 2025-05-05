package controller;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.TokenDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Token.TokenType;
import util.PasswordUtil;

/**
 * Servlet for handling password reset with OTP verification
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ResetPasswordServlet.class.getName());
    
    private UserDAO userDAO;
    private TokenDAO tokenDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        tokenDAO = new TokenDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if there's an email in the session (set by ForgotPasswordServlet)
        if (session == null || session.getAttribute("resetEmail") == null) {
            // No reset email in session, redirect to forgot password page
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        // Display the OTP verification and password reset form
        request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if there's an email in the session
        if (session == null || session.getAttribute("resetEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        String email = (String) session.getAttribute("resetEmail");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (otp == null || otp.trim().isEmpty()) {
            setErrorAndForward(request, response, "Please enter the OTP sent to your email");
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            setErrorAndForward(request, response, "Please enter a new password");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            setErrorAndForward(request, response, "Passwords do not match");
            return;
        }
        
        // Password strength validation
        if (newPassword.length() < 8) {
            setErrorAndForward(request, response, "Password must be at least 8 characters long");
            return;
        }
        
        try {
            // Validate OTP
            int userId = tokenDAO.validatePasswordResetToken(email, otp);
            
            if (userId > 0) {
                // OTP is valid, update the password
                String hashedPassword = PasswordUtil.hashPassword(newPassword);
                
                boolean updated = userDAO.updatePassword(userId, hashedPassword);
                
                if (updated) {
                    // Password updated successfully
                    LOGGER.log(Level.INFO, "Password reset successful for user ID: {0}", userId);
                    
                    // Delete the used token
                    tokenDAO.deleteToken(userId, otp, TokenType.PASSWORD_RESET);
                    
                    // Clear the reset email from session
                    session.removeAttribute("resetEmail");
                    
                    // Set success message and redirect to login
                    session.setAttribute("successMessage", "Your password has been reset successfully. Please login with your new password.");
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                } else {
                    LOGGER.log(Level.WARNING, "Failed to update password for user ID: {0}", userId);
                    setErrorAndForward(request, response, "Failed to update password. Please try again.");
                    return;
                }
            } else {
                // Invalid or expired OTP
                LOGGER.log(Level.WARNING, "Invalid or expired OTP: {0} for email: {1}", new Object[]{otp, email});
                setErrorAndForward(request, response, "Invalid or expired OTP. Please request a new one.");
                return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in password reset process", e);
            setErrorAndForward(request, response, "An error occurred. Please try again later.");
            return;
        }
    }
    
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(request, response);
    }
} 