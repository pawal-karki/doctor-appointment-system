package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.logging.Logger;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;
import util.PasswordUtil;
import util.ValidationUtil;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5, // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    private UserDAO userDAO;
    private static final String UPLOAD_DIR = "uploads/users";
    
    public void init() {
        userDAO = new UserDAO();
        // Create upload directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            LOGGER.info("Created upload directory: " + uploadPath + " - " + created);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the current user from session
        User currentUser = (User) session.getAttribute("user");
        
        // Refresh user data from database
        User user = userDAO.getUserById(currentUser.getId());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Update session with fresh user data
        session.setAttribute("user", user);
        
        String action = request.getParameter("action");
        
        if (action == null) {
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        } else if (action.equals("changePassword")) {
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action != null && action.equals("update")) {
            updateProfile(request, response, user);
        } else if (action != null && action.equals("changePassword")) {
            changePassword(request, response, user);
        }
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // Log the request content type and size
        LOGGER.info("Request Content Type: " + request.getContentType());
        LOGGER.info("Request Content Length: " + request.getContentLength());
        
        // Sanitize inputs
        name = ValidationUtil.sanitizeInput(name);
        email = ValidationUtil.sanitizeInput(email);
        phone = ValidationUtil.sanitizeInput(phone);
        
        // Validate inputs
        boolean hasError = false;
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("nameError", "Name is required");
            hasError = true;
        }
        
        if (email == null || !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Please enter a valid email address");
            hasError = true;
        }
        
        if (phone == null || !ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Please enter a valid phone number");
            hasError = true;
        }
        
        if (hasError) {
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }
        
        // Handle image upload
        Part filePart = request.getPart("image");
        String imageUrl = user.getImageUrl(); // Keep existing image if no new one uploaded
        
        LOGGER.info("Processing image upload. Current imageUrl: " + imageUrl);
        LOGGER.info("File part: " + (filePart != null ? "exists" : "null"));
        
        if (filePart != null && filePart.getSize() > 0) {
            LOGGER.info("File size: " + filePart.getSize());
            LOGGER.info("Content type: " + filePart.getContentType());
            LOGGER.info("Submitted file name: " + filePart.getSubmittedFileName());
            
            String fileName = getSubmittedFileName(filePart);
            LOGGER.info("Original filename: " + fileName);
            
            if (fileName != null && !fileName.isEmpty()) {
                // Generate unique filename
                String extension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = UUID.randomUUID().toString() + extension;
                LOGGER.info("Generated unique filename: " + uniqueFileName);
                
                // Save file
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                LOGGER.info("Upload path: " + uploadPath);
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    boolean created = uploadDir.mkdirs();
                    LOGGER.info("Created upload directory: " + created);
                }
                
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(uploadPath, uniqueFileName), StandardCopyOption.REPLACE_EXISTING);
                    imageUrl = UPLOAD_DIR + "/" + uniqueFileName;
                    LOGGER.info("Image saved successfully. New imageUrl: " + imageUrl);
                } catch (IOException e) {
                    LOGGER.severe("Failed to save image: " + e.getMessage());
                    e.printStackTrace(); // Print full stack trace
                    request.setAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
                    request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
                    return;
                }
            }
        }
        
        // Update user object
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        user.setImageUrl(imageUrl);
        
        LOGGER.info("Updating user with new imageUrl: " + imageUrl);
        
        boolean success = userDAO.updateUser(user);
        LOGGER.info("User update " + (success ? "successful" : "failed"));
        
        if (success) {
            // Update session with updated user
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            request.setAttribute("successMessage", "Profile updated successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update profile");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        boolean hasError = false;
        
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("currentPasswordError", "Current password is required");
            hasError = true;
        }
        
        if (newPassword == null || !ValidationUtil.isValidPassword(newPassword)) {
            request.setAttribute("newPasswordError", "Password must be at least 8 characters and contain at least one letter and one number");
            hasError = true;
        }
        
        if (confirmPassword == null || !confirmPassword.equals(newPassword)) {
            request.setAttribute("confirmPasswordError", "New passwords do not match");
            hasError = true;
        }
        
        if (hasError) {
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }
        
        // Get the latest user data from database to ensure we have the correct password hash
        User latestUser = userDAO.getUserById(user.getId());
        if (latestUser == null) {
            request.setAttribute("errorMessage", "User not found");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }
        
        // Verify current password against the latest stored hash
        if (!PasswordUtil.verifyPassword(currentPassword, latestUser.getPassword())) {
            request.setAttribute("errorMessage", "Current password is incorrect");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }
        
        // Hash the new password
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        if (hashedPassword == null) {
            request.setAttribute("errorMessage", "Failed to hash new password");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }
        
        boolean success = userDAO.updatePassword(user.getId(), hashedPassword);
        
        if (success) {
            // Update user in session with the new hashed password
            user.setPassword(hashedPassword);
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            request.setAttribute("successMessage", "Password changed successfully");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to change password");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
        }
    }
    
    private String getSubmittedFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
