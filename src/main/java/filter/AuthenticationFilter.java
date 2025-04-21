package filter;

import java.io.IOException;
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


/**
 * Authentication filter to protect resources that require user login
 */
@WebFilter(urlPatterns = {
    "/profile/*", 
    "/appointments/*", 
    "/book-appointment"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        
        // Check for public resources that should bypass authentication
        if (isPublicResource(requestURI)) {
            chain.doFilter(request, response);
            return;
        }
        
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        // Check if the user is logged in
        if (isLoggedIn) {
            // User is authenticated, proceed with the request
            chain.doFilter(request, response);
        } else {
            // Save the requested URL for redirect after login
            String originalURL = httpRequest.getRequestURL().toString();
            if (httpRequest.getQueryString() != null) {
                originalURL += "?" + httpRequest.getQueryString();
            }
            
            // Store the URL in the session
            httpRequest.getSession().setAttribute("originalURL", originalURL);
            
            // User is not authenticated, redirect to login page
            httpRequest.setAttribute("errorMessage", "You must be logged in to access this page");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
    
    private boolean isPublicResource(String requestURI) {
        // Check if the resource is public (CSS, JS, images, etc.)
        return requestURI.endsWith(".css") || 
               requestURI.endsWith(".js") || 
               requestURI.endsWith(".jpg") || 
               requestURI.endsWith(".jpeg") || 
               requestURI.endsWith(".png") || 
               requestURI.endsWith(".gif") ||
               requestURI.contains("/public/");
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
