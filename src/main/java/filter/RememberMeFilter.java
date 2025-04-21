package filter;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.TokenDAO;
import dao.UserDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.CookieUtil;

/**
 * Filter to handle automatic login via "Remember Me" cookies
 */
@WebFilter("/*")
public class RememberMeFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(RememberMeFilter.class.getName());
    private UserDAO userDAO;
    private TokenDAO tokenDAO;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDAO = new UserDAO();
        tokenDAO = new TokenDAO();
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Skip if user is already authenticated
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        if (!isLoggedIn) {
            // Try to auto-login with remember-me cookie
            String rememberMeToken = CookieUtil.getCookieValue(httpRequest, CookieUtil.REMEMBER_ME_COOKIE);
            if (rememberMeToken != null) {
                int userId = tokenDAO.getUserIdByRememberMeToken(rememberMeToken);
                if (userId > 0) {
                    User user = userDAO.getUserById(userId);
                    if (user != null) {
                        // Auto login successful
                        LOGGER.log(Level.INFO, "Auto login successful via remember-me cookie for user ID: {0}", userId);
                        
                        // Create a new session
                        HttpSession newSession = httpRequest.getSession(true);
                        newSession.setAttribute("user", user);
                        
                        // Set extended session timeout
                        newSession.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 days
                    } else {
                        // Invalid user, clear cookies
                        LOGGER.log(Level.WARNING, "Invalid remember-me token (user not found): {0}", rememberMeToken);
                        CookieUtil.removeAuthCookies(httpResponse);
                    }
                } else {
                    // Invalid or expired token, clear cookies
                    LOGGER.log(Level.WARNING, "Invalid or expired remember-me token: {0}", rememberMeToken);
                    CookieUtil.removeAuthCookies(httpResponse);
                }
            }
        }
        
        // Continue with the filter chain
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Nothing to destroy
    }
} 