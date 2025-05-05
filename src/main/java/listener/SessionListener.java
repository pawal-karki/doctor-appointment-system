package listener;

import java.util.logging.Level;

import java.util.logging.Logger;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

/**
 * Session listener to manage session lifecycle events
 */
@WebListener
public class SessionListener implements HttpSessionListener {
    
    private static final Logger LOGGER = Logger.getLogger(SessionListener.class.getName());

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        LOGGER.log(Level.INFO, "Session created: {0}", session.getId());
        
        // Set session timeout to 30 minutes
        session.setMaxInactiveInterval(30 * 60);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        LOGGER.log(Level.INFO, "Session destroyed: {0}", session.getId());
    }
}
