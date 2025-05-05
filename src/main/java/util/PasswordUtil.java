package util;

import org.mindrot.jbcrypt.BCrypt;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for password hashing and verification using BCrypt
 */
public class PasswordUtil {
    
    private static final Logger LOGGER = Logger.getLogger(PasswordUtil.class.getName());
    
    /**
     * Hashes a password using BCrypt algorithm
     * 
     * @param password The password to hash
     * @return A BCrypt hash string
     */
    public static String hashPassword(String password) {
        try {
            // Generate a salt and hash the password
            return BCrypt.hashpw(password, BCrypt.gensalt());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error hashing password", e);
            return null;
        }
    }
    
    /**
     * Verifies a password against a stored BCrypt hash
     * 
     * @param password The password to verify
     * @param storedHash The stored BCrypt hash to verify against
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        try {
            return BCrypt.checkpw(password, storedHash);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying password", e);
            return false;
        }
    }
}
