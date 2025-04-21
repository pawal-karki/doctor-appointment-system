package filter;

import java.io.IOException;

import java.util.Date;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Filter to log all incoming requests
 */
@WebFilter(urlPatterns = {"/*"})
public class RequestLoggingFilter implements Filter {
    
    private static final Logger LOGGER = Logger.getLogger(RequestLoggingFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        // Get request details
        String remoteAddress = request.getRemoteAddr();
        String uri = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();
        String userAgent = httpRequest.getHeader("User-Agent");
        
        // Log the request
        LOGGER.log(Level.INFO, 
                "Request: {0} {1} from {2} - {3} - {4}", 
                new Object[]{method, uri, remoteAddress, new Date(), userAgent});
        
        // Calculate request processing time
        long startTime = System.currentTimeMillis();
        
        try {
            // Continue with the request
            chain.doFilter(request, response);
        } finally {
            // Log the request processing time
            long endTime = System.currentTimeMillis();
            LOGGER.log(Level.INFO, 
                    "Request completed: {0} {1} - {2}ms", 
                    new Object[]{method, uri, (endTime - startTime)});
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
