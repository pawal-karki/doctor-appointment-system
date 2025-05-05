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
import model.User;
import util.EmailUtil;
import util.ValidationUtil;

/**
 * Servlet for handling the initial password reset request
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private static final int OTP_EXPIRY_MINUTES = 15;
    
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
        // Display the forgot password form
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        // Validate email
        if (email == null || !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Please enter a valid email address");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Sanitize input
        email = ValidationUtil.sanitizeInput(email);
        
        try {
            // Check if email exists
            User user = userDAO.getUserByEmail(email);
            
            if (user != null) {
                // Generate and store OTP
                String otp = tokenDAO.createPasswordResetToken(email);
                
                if (otp != null) {
                    // Send OTP via email
                    boolean emailSent = EmailUtil.sendPasswordResetOTP(email, otp, OTP_EXPIRY_MINUTES);
                    
                    if (emailSent) {
                        LOGGER.log(Level.INFO, "Password reset OTP sent to: {0}", email);
                        
                        // Store email in session for the reset form
                        HttpSession session = request.getSession();
                        session.setAttribute("resetEmail", email);
                        
                        // Redirect to OTP verification page
                        response.sendRedirect(request.getContextPath() + "/reset-password");
                        return;
                    } else {
                        LOGGER.log(Level.WARNING, "Failed to send password reset email to: {0}", email);
                        request.setAttribute("errorMessage", "Failed to send email. Please try again later.");
                    }
                } else {
                    LOGGER.log(Level.WARNING, "Failed to create password reset token for: {0}", email);
                    request.setAttribute("errorMessage", "Something went wrong. Please try again later.");
                }
            } else {
                // Don't reveal that the email doesn't exist (security best practice)
                LOGGER.log(Level.INFO, "Password reset requested for non-existent email: {0}", email);
                
                // Show a generic success message to prevent email enumeration
                request.setAttribute("successMessage", 
                        "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in forgot password process", e);
            request.setAttribute("errorMessage", "An error occurred. Please try again later.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
    }
} 