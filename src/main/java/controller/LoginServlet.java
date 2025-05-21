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
import util.CookieUtil;
import util.OTPUtil;
import util.PasswordUtil;
import util.ValidationUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private static final int REMEMBER_ME_EXPIRY_DAYS = 30;
    
    private UserDAO userDAO;
    private TokenDAO tokenDAO;
    
    public void init() {
        userDAO = new UserDAO();
        tokenDAO = new TokenDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in via session
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // User is already logged in, redirect to appropriate page
            redirectLoggedInUser(request, response, (User) session.getAttribute("user"));
            return;
        }
        
        // Check if user has a remember-me cookie
        String rememberMeToken = CookieUtil.getCookieValue(request, CookieUtil.REMEMBER_ME_COOKIE);
        if (rememberMeToken != null) {
            // Try to authenticate with the token
            int userId = tokenDAO.getUserIdByRememberMeToken(rememberMeToken);
            if (userId > 0) {
                User user = userDAO.getUserById(userId);
                if (user != null) {
                    // Auto login successful
                    LOGGER.log(Level.INFO, "Auto login successful for user ID: {0}", userId);
                    
                    // Create a new session
                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("user", user);
                    
                    // Redirect to appropriate page
                    redirectLoggedInUser(request, response, user);
                    return;
                }
            }
            
            // If auto-login failed, remove invalid cookies
            CookieUtil.removeAuthCookies(response);
        }
        
        // Display login page
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        
        // Sanitize input
        email = ValidationUtil.sanitizeInput(email);
        
        try {
            // Get user by email
            User user = userDAO.getUserByEmail(email);
            
            // Check if user exists and password is correct
            if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
                // Check if user is verified
                if (!user.isVerified()) {
                    LOGGER.log(Level.INFO, "Unverified login attempt: {0}", email);
                    
                    // Generate new OTP for verification
                    String otpCode = OTPUtil.generateOTP();
                    long otpExpiry = OTPUtil.calculateOTPExpiry();
                    
                    // Update user with new OTP
                    boolean updated = userDAO.updateOTP(user.getUserId(), otpCode, otpExpiry);
                    
                    if (updated) {
                        // Send OTP email
                        boolean sent = OTPUtil.sendOTPEmail(user.getEmail(), user.getName(), otpCode);
                        
                        if (sent) {
                            LOGGER.log(Level.INFO, "Verification email sent to: {0}", email);
                            
                            // Store email in session for verification page
                            request.getSession().setAttribute("pendingVerificationEmail", email);
                            
                            // Set error message and forward to verification page
                            request.getSession().setAttribute("warningMessage", 
                                "Your email is not verified. A verification code has been sent to your email.");
                            response.sendRedirect(request.getContextPath() + "/verify-otp");
                        } else {
                            LOGGER.log(Level.WARNING, "Failed to send verification email to: {0}", email);
                            request.setAttribute("errorMessage", 
                                "Your email is not verified, and we couldn't send a verification email. Please contact support.");
                            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                        }
                    } else {
                        LOGGER.log(Level.WARNING, "Failed to update OTP for user: {0}", email);
                        request.setAttribute("errorMessage", 
                            "Your email is not verified. Please try again or contact support.");
                        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                    }
                    
                    return;
                }
                
                // Authentication successful
                LOGGER.log(Level.INFO, "User logged in: {0}", email);
                
                // Create a new session
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                
                // Set session timeout
                if ("on".equals(rememberMe)) {
                    // Handle remember-me functionality
                    handleRememberMe(request, response, user);
                    
                    // Extend session timeout to match cookie (30 days)
                    session.setMaxInactiveInterval(REMEMBER_ME_EXPIRY_DAYS * 24 * 60 * 60);
                } else {
                    // Standard session timeout (30 minutes)
                    session.setMaxInactiveInterval(30 * 60);
                    
                    // Clear any existing remember-me cookies
                    CookieUtil.removeAuthCookies(response);
                }
                
                // Redirect to appropriate page
                redirectLoggedInUser(request, response, user);
            } else {
                // Log failed login attempt
                LOGGER.log(Level.WARNING, "Failed login attempt for email: {0}", email);
                
                // Show error message
                request.setAttribute("errorMessage", "Invalid email or password");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during login process", e);
            request.setAttribute("errorMessage", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle "Remember Me" functionality by creating a persistent token and cookies
     * 
     * @param request The HTTP request
     * @param response The HTTP response
     * @param user The authenticated user
     */
    private void handleRememberMe(HttpServletRequest request, HttpServletResponse response, User user) {
        // Generate a secure token
        String token = CookieUtil.generateRememberMeToken();
        
        // Save token to database
        boolean saved = tokenDAO.saveRememberMeToken(user.getUserId(), token, REMEMBER_ME_EXPIRY_DAYS);
        
        if (saved) {
            // Add cookies for auto-login
            CookieUtil.addRememberMeCookie(response, token);
            CookieUtil.addUserEmailCookie(response, user.getEmail());
            LOGGER.log(Level.INFO, "Remember-me token created for user: {0}", user.getEmail());
        } else {
            LOGGER.log(Level.WARNING, "Failed to save remember-me token for user: {0}", user.getEmail());
        }
    }
    
    /**
     * Redirect a logged-in user to the appropriate page based on role
     * 
     * @param request The HTTP request
     * @param response The HTTP response
     * @param user The authenticated user
     * @throws IOException If an I/O error occurs
     */
    private void redirectLoggedInUser(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            // Redirect to the originally requested URL if available
            String originalURL = null;
            HttpSession session = request.getSession(false);
            if (session != null) {
                originalURL = (String) session.getAttribute("originalURL");
            }
            
            if (originalURL != null) {
                session.removeAttribute("originalURL");
                response.sendRedirect(originalURL);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }
}
