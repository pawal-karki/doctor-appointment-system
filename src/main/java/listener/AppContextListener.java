package listener;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import dao.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Application context listener for initialization and cleanup
 */
@WebListener
public class AppContextListener implements ServletContextListener {
    
    private static final Logger logger = LogManager.getLogger(AppContextListener.class);
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Hospital Management System starting up...");
        
        // Initialize any application-wide resources here
        logger.info("Application initialized successfully");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Hospital Management System shutting down...");
        
        // Close database connections
        DBConnection.closeAllConnections();
        
        // Perform any other cleanup
        logger.info("Application shutdown complete");
    }
}
