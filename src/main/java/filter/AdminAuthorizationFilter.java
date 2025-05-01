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
 * Authorization filter to protect admin resources
 */
@WebFilter(urlPatterns = {"/admin/*"})
public class AdminAuthorizationFilter implements Filter {

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

        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");

            // Check if the user is an admin
            if (user.isAdmin()) {
                // User is an admin, proceed with the request
                chain.doFilter(request, response);
            } else {
                // User is not an admin, redirect to access denied page
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied");
            }
        } else {
            // Save the requested URL for redirect after login
            String originalURL = httpRequest.getRequestURL().toString();
            if (httpRequest.getQueryString() != null) {
                originalURL += "?" + httpRequest.getQueryString();
            }

            // Store the URL in the session
            httpRequest.getSession().setAttribute("originalURL", originalURL);

            // User is not logged in, redirect to login page
            httpRequest.setAttribute("errorMessage", "You must be logged in as an admin to access this page");
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
               requestURI.endsWith(".gif");
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
