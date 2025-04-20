package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for handling remember-me tokens
 */
public class RememberMeTokenDAO {
    private static final Logger LOGGER = Logger.getLogger(RememberMeTokenDAO.class.getName());
    
    /**
     * Save a new remember-me token for a user
     * 
     * @param userId The user ID
     * @param token The token string
     * @param expiryDays Number of days until token expiry
     * @return true if successfully saved, false otherwise
     */
    public boolean saveToken(int userId, String token, int expiryDays) {
        String sql = "INSERT INTO remember_me_tokens (user_id, token, expires_at) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            // Calculate expiry date (current time + expiry days)
            LocalDateTime expiryDate = LocalDateTime.now().plusDays(expiryDays);
            Timestamp expiryTimestamp = Timestamp.valueOf(expiryDate);
            
            stmt.setInt(1, userId);
            stmt.setString(2, token);
            stmt.setTimestamp(3, expiryTimestamp);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving remember-me token", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Find a user ID by remember-me token
     * 
     * @param token The token to look up
     * @return The user ID if found and valid, or -1 if not found or expired
     */
    public int getUserIdByToken(String token) {
        String sql = "SELECT user_id FROM remember_me_tokens WHERE token = ? AND expires_at > ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, token);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            
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
     * Delete a specific token
     * 
     * @param token The token to delete
     * @return true if successfully deleted, false otherwise
     */
    public boolean deleteToken(String token) {
        String sql = "DELETE FROM remember_me_tokens WHERE token = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, token);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting remember-me token", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Delete all tokens for a specific user
     * 
     * @param userId The user ID
     * @return true if successfully deleted, false otherwise
     */
    public boolean deleteAllUserTokens(int userId) {
        String sql = "DELETE FROM remember_me_tokens WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting all remember-me tokens for user", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    /**
     * Clean up expired tokens (scheduled task)
     * 
     * @return Number of expired tokens removed
     */
    public int cleanupExpiredTokens() {
        String sql = "DELETE FROM remember_me_tokens WHERE expires_at <= ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            return stmt.executeUpdate();
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error cleaning up expired remember-me tokens", e);
            return 0;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    // Helper method to close database resources
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) DBConnection.releaseConnection(conn);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error closing database resources", e);
        }
    }
}