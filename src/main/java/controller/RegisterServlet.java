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
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PasswordUtil;
import util.ValidationUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private UserDAO userDAO;
    
    public void init() {
        userDAO = new UserDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // User is already logged in, redirect to home page
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Display registration page
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        
        // Validate input
        boolean hasError = false;
        
        // Sanitize inputs
        name = ValidationUtil.sanitizeInput(name);
        email = ValidationUtil.sanitizeInput(email);
        phone = ValidationUtil.sanitizeInput(phone);
        
        // Validate name
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("nameError", "Name is required");
            hasError = true;
        }
        
        // Validate email
        if (email == null || !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Please enter a valid email address");
            hasError = true;
        } else {
            // Check if email already exists
            User existingUser = userDAO.getUserByEmail(email);
            if (existingUser != null) {
                request.setAttribute("emailError", "Email address is already registered");
                hasError = true;
            }
        }
        
        // Validate password
        if (password == null || !ValidationUtil.isValidPassword(password)) {
            request.setAttribute("passwordError", "Password must be at least 8 characters and contain at least one letter and one number");
            hasError = true;
        }
        
        // Validate password confirmation
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match");
            hasError = true;
        }
        
        // Validate phone
        if (phone == null || !ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Please enter a valid phone number");
            hasError = true;
        }
        
        // If there are validation errors, redisplay the form with error messages
        if (hasError) {
            // Preserve form data
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Create new user
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setPhone(phone);
            user.setRole("user"); // Default role is user
            
            // Save user to database
            boolean success = userDAO.registerUser(user);
            
            if (success) {
                // Log successful registration
                LOGGER.log(Level.INFO, "New user registered: {0}", email);
                
                // Set success message and redirect to login page
                request.getSession().setAttribute("successMessage", "Registration successful! Please login with your credentials.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                // Log registration failure
                LOGGER.log(Level.WARNING, "Failed to register user: {0}", email);
                
                // Set error message and redisplay form
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                
                // Preserve form data
                request.setAttribute("name", name);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during registration process", e);
            
            // Set error message and redisplay form
            request.setAttribute("errorMessage", "An error occurred during registration. Please try again.");
            
            // Preserve form data
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
