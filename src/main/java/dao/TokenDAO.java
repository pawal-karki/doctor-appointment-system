package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Token.TokenType;

/**
 * Data Access Object for handling tokens (remember-me and password reset)
 */
public class TokenDAO {
    private static final Logger LOGGER = Logger.getLogger(TokenDAO.class.getName());
    private static final int OTP_LENGTH = 6;
    private static final int DEFAULT_PASSWORD_RESET_EXPIRY_MINUTES = 15;
    
    /**
     * Generate a random numeric OTP for password reset
     * 
     * @return OTP string
     */
    public String generateOTP() {
        Random random = new Random();
        StringBuilder otp = new StringBuilder();
        
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(random.nextInt(10));
        }
        
        return otp.toString();
    }
    
    /**
     * Save a new token for a user
     * 
     * @param userId The user ID
     * @param token The token string
     * @param tokenType Type of token (REMEMBER_ME or PASSWORD_RESET)
     * @param expiryMinutes Number of minutes until token expiry
     * @return true if successfully saved, false otherwise
     */
    public boolean saveToken(int userId, String token, TokenType tokenType, int expiryMinutes) {
        String sql = "INSERT INTO tokens (user_id, token, token_type, expires_at) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            // Calculate expiry date
            LocalDateTime expiryDate = LocalDateTime.now().plusMinutes(expiryMinutes);
            Timestamp expiryTimestamp = Timestamp.valueOf(expiryDate);
            
            stmt.setInt(1, userId);
            stmt.setString(2, token);
            stmt.setString(3, tokenType.name());
            stmt.setTimestamp(4, expiryTimestamp);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving " + tokenType + " token", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Convenience method for saving remember-me token
     * 
     * @param userId The user ID
     * @param token The token string
     * @param expiryDays Number of days until token expiry
     * @return true if successfully saved, false otherwise
     */
    public boolean saveRememberMeToken(int userId, String token, int expiryDays) {
        // Convert days to minutes
        int expiryMinutes = expiryDays * 24 * 60;
        return saveToken(userId, token, TokenType.REMEMBER_ME, expiryMinutes);
    }
    
    /**
     * Create a password reset token for a user
     * 
     * @param email User's email
     * @return The generated OTP or null if failed
     */
    public String createPasswordResetToken(String email) {
        // First, get the user ID from email
        UserDAO userDAO = new UserDAO();
        int userId = 0;
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT user_id FROM users WHERE email = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("user_id");
                    } else {
                        // User doesn't exist
                        LOGGER.log(Level.WARNING, "Password reset requested for non-existent email: {0}", email);
                        return null;
                    }
                }
            } finally {
                DBConnection.releaseConnection(conn);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user for password reset", e);
            return null;
        }
        
        // Generate OTP code
        String otp = generateOTP();
        
        // Delete any existing password reset tokens for this user
        deleteUserTokens(userId, TokenType.PASSWORD_RESET);
        
        // Store the new token
        boolean saved = saveToken(userId, otp, TokenType.PASSWORD_RESET, DEFAULT_PASSWORD_RESET_EXPIRY_MINUTES);
        
        if (saved) {
            LOGGER.log(Level.INFO, "Password reset token created for user ID: {0}", userId);
            return otp;
        } else {
            LOGGER.log(Level.WARNING, "Failed to create password reset token for user ID: {0}", userId);
            return null;
        }
    }
    
    /**
     * Find a user ID by remember-me token
     * 
     * @param token The token to look up
     * @return The user ID if found and valid, or -1 if not found or expired
     */
    public int getUserIdByRememberMeToken(String token) {
        String sql = "SELECT user_id FROM tokens WHERE token = ? AND token_type = ? AND expires_at > ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, token);
            stmt.setString(2, TokenType.REMEMBER_ME.name());
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by remember-me token", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return -1; // Not found or expired
    }
    
    /**
     * Validate a password reset token
     * 
     * @param email User's email
     * @param token Token to validate
     * @return User ID if valid, -1 otherwise
     */
    public int validatePasswordResetToken(String email, String token) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT t.user_id FROM tokens t " +
                         "JOIN users u ON t.user_id = u.user_id " +
                         "WHERE u.email = ? AND t.token = ? AND t.token_type = ? AND t.expires_at > ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, token);
            stmt.setString(3, TokenType.PASSWORD_RESET.name());
            stmt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                LOGGER.log(Level.INFO, "Valid password reset token for user ID: {0}", userId);
                return userId;
            }
            
            LOGGER.log(Level.WARNING, "Invalid or expired token: {0} for email: {1}", new Object[]{token, email});
            return -1;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error validating password reset token", e);
            return -1;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    /**
     * Delete a specific token
     * 
     * @param token The token to delete
     * @param tokenType The type of token
     * @return true if successfully deleted, false otherwise
     */
    public boolean deleteToken(String token, TokenType tokenType) {
        String sql = "DELETE FROM tokens WHERE token = ? AND token_type = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, token);
            stmt.setString(2, tokenType.name());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting " + tokenType + " token", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Delete a specific token for a user
     * 
     * @param userId User ID
     * @param token Token to delete
     * @param tokenType The type of token
     * @return True if deleted, false otherwise
     */
    public boolean deleteToken(int userId, String token, TokenType tokenType) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM tokens WHERE user_id = ? AND token = ? AND token_type = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, token);
            stmt.setString(3, tokenType.name());
            
            int rowsAffected = stmt.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting " + tokenType + " token", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Delete all tokens of a specific type for a user
     * 
     * @param userId The user ID
     * @param tokenType The type of tokens to delete
     * @return true if successfully deleted, false otherwise
     */
    public boolean deleteUserTokens(int userId, TokenType tokenType) {
        String sql = "DELETE FROM tokens WHERE user_id = ? AND token_type = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, userId);
            stmt.setString(2, tokenType.name());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting all " + tokenType + " tokens for user", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Delete all tokens for a user
     * 
     * @param userId The user ID
     * @return true if successfully deleted, false otherwise
     */
    public boolean deleteAllUserTokens(int userId) {
        String sql = "DELETE FROM tokens WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting all tokens for user", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Clean up expired tokens
     * 
     * @return Number of expired tokens removed
     */
    public int cleanupExpiredTokens() {
        String sql = "DELETE FROM tokens WHERE expires_at <= ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            int deleted = stmt.executeUpdate();
            
            if (deleted > 0) {
                LOGGER.log(Level.INFO, "Cleaned up {0} expired tokens", deleted);
            }
            return deleted;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error cleaning up expired tokens", e);
            return 0;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Helper method to close database resources
     */
    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DBConnection.releaseConnection(conn);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error closing database resources", e);
        }
    }
}