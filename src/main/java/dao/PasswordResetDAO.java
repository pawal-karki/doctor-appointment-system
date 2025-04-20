package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Random;

/**
 * Data Access Object for handling password reset tokens
 */
public class PasswordResetDAO {

    private static final int OTP_LENGTH = 6;
    private static final int DEFAULT_EXPIRY_MINUTES = 15;

    /**
     * Generate a random numeric OTP
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
     * Create a password reset token for a user
     *
     * @param email User's email
     * @return The generated OTP or null if failed
     */
    public String createResetToken(String email) {
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
                        return null;
                    }
                }
            } finally {
                DBConnection.releaseConnection(conn);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        String otp = generateOTP();
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(DEFAULT_EXPIRY_MINUTES);

        deleteUserTokens(userId);

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);

            stmt.setInt(1, userId);
            stmt.setString(2, otp);
            stmt.setTimestamp(3, Timestamp.valueOf(expiryTime));

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                return otp;
            } else {
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Validate a reset token
     *
     * @param email User's email
     * @param token Token to validate
     * @return User ID if valid, -1 otherwise
     */
    public int validateToken(String email, String token) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT t.user_id FROM password_reset_tokens t " +
                         "JOIN users u ON t.user_id = u.user_id " +
                         "WHERE u.email = ? AND t.token = ? AND t.expires_at > ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, token);
            stmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("user_id");
            }

            return -1;

        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Delete a token after use
     *
     * @param userId User ID
     * @param token Token to delete
     * @return True if deleted, false otherwise
     */
    public boolean deleteToken(int userId, String token) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM password_reset_tokens WHERE user_id = ? AND token = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, token);

            int rowsAffected = stmt.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Delete all tokens for a user
     *
     * @param userId User ID
     */
    public void deleteUserTokens(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM password_reset_tokens WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Clean up expired tokens
     */
    public void cleanupExpiredTokens() {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM password_reset_tokens WHERE expires_at <= ?";

            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
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
            e.printStackTrace();
        }
    }
}