package controller;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.RememberMeTokenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.CookieUtil;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());
    private RememberMeTokenDAO tokenDAO;
    
    public void init() {
        tokenDAO = new RememberMeTokenDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Log the logout and cleanup tokens
            User user = (User) session.getAttribute("user");
            if (user != null) {
                LOGGER.log(Level.INFO, "User logged out: {0}", user.getEmail());
                
                // Delete all remember me tokens for the user
                tokenDAO.deleteAllUserTokens(user.getUserId());
            }
            
            // Invalidate the session
            session.invalidate();
        }
            
        // Clear all auth cookies
        CookieUtil.removeAuthCookies(response);
        
        // Clear session cookie
        Cookie sessionCookie = new Cookie("JSESSIONID", "");
        sessionCookie.setMaxAge(0);
        sessionCookie.setPath("/");
        response.addCookie(sessionCookie);
        
        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
