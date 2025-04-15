package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.User;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    
    public User getUserByEmail(String email) {
        User user = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setImageUrl(rs.getString("image_url"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting user by email", e);
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return user;
    }
    
    public User getUserById(int id) {
        User user = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setImageUrl(rs.getString("image_url"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting user by ID", e);
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return user;
    }
    
    public boolean registerUser(User user) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO users (name, email, password, phone, role, image_url) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getImageUrl());
            
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error registering user", e);
        } finally {
            closeResources(null, ps, conn);
        }
        
        return success;
    }
    
    public boolean updateUser(User user) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET name = ?, email = ?, phone = ?, image_url = ? WHERE user_id = ?";
            LOGGER.info("Updating user with SQL: " + sql);
            LOGGER.info("User data - Name: " + user.getName() + ", Email: " + user.getEmail() + 
                       ", Phone: " + user.getPhone() + ", Image URL: " + user.getImageUrl() + 
                       ", ID: " + user.getUserId());
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getImageUrl());
            ps.setInt(5, user.getUserId());
            
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
            LOGGER.info("Update result - Rows affected: " + rowsAffected + ", Success: " + success);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user", e);
        } finally {
            closeResources(null, ps, conn);
        }
        
        return success;
    }
    
    public boolean updatePassword(int userId, String newPassword) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET password = ? WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating password", e);
        } finally {
            closeResources(null, ps, conn);
        }
        
        return success;
    }
    
    public List<User> getAllPatients() {
        List<User> patients = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE role = 'user'";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setImageUrl(rs.getString("image_url"));
                patients.add(user);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all patients", e);
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return patients;
    }
    
    // Helper method to close database resources
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error closing database resources", e);
        }
    }
}
