package controller;

import java.io.IOException;

import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet that handles errors and exceptions
 */
@WebServlet("/error-handler")
public class ErrorHandlerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ErrorHandlerServlet.class.getName());
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processError(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processError(request, response);
    }
    
    private void processError(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the error information
        Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
        Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
        String servletName = (String) request.getAttribute("javax.servlet.error.servlet_name");
        String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
        
        // Log the error
        if (throwable != null) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            throwable.printStackTrace(pw);
            LOGGER.log(Level.SEVERE, "Error in {0} for URI {1}: {2}\n{3}", 
                    new Object[]{servletName, requestUri, throwable.getMessage(), sw.toString()});
        } else {
            LOGGER.log(Level.WARNING, "Error status {0} for URI {1}", 
                    new Object[]{statusCode, requestUri});
        }
        
        // Set attributes for the error page
        request.setAttribute("statusCode", statusCode);
        request.setAttribute("throwable", throwable);
        request.setAttribute("servletName", servletName);
        request.setAttribute("requestUri", requestUri);
        
        // Forward to appropriate error page
        if (statusCode != null) {
            if (statusCode == 404) {
                request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
            } else if (statusCode == 403) {
                request.getRequestDispatcher("/WEB-INF/views/error/access-denied.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
            }
        } else {
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
