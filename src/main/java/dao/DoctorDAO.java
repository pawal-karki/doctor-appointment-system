package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Doctor;

public class DoctorDAO {
    
    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM doctors";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setQualification(rs.getString("qualification"));
                doctor.setExperience(rs.getString("experience"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setImageUrl(rs.getString("image_url"));
                
                // Load department IDs for the doctor
                loadDoctorDepartments(conn, doctor);
                
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return doctors;
    }
    
    private void loadDoctorDepartments(Connection conn, Doctor doctor) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT department_id FROM doctor_departments WHERE doctor_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctor.getDoctorId());
            rs = ps.executeQuery();
            
            while (rs.next()) {
                doctor.addDepartmentId(rs.getInt("department_id"));
            }
        } finally {
            closeResources(rs, ps, null);
        }
    }
    
    public Doctor getDoctorById(int id) {
        Doctor doctor = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM doctors WHERE doctor_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setQualification(rs.getString("qualification"));
                doctor.setExperience(rs.getString("experience"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setImageUrl(rs.getString("image_url"));
                
                // Load department IDs for the doctor
                loadDoctorDepartments(conn, doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return doctor;
    }
    
    public List<Doctor> getDoctorsByDepartment(int departmentId) {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT d.* FROM doctors d " +
                        "JOIN doctor_departments dd ON d.doctor_id = dd.doctor_id " +
                        "WHERE dd.department_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, departmentId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setQualification(rs.getString("qualification"));
                doctor.setExperience(rs.getString("experience"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setImageUrl(rs.getString("image_url"));
                
                // Load department IDs for the doctor
                loadDoctorDepartments(conn, doctor);
                
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return doctors;
    }
    
    public boolean addDoctor(Doctor doctor) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet generatedKeys = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Insert doctor first
            String sql = "INSERT INTO doctors (name, specialization, qualification, experience, email, phone, image_url) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, doctor.getName());
            ps.setString(2, doctor.getSpecialization());
            ps.setString(3, doctor.getQualification());
            ps.setString(4, doctor.getExperience());
            ps.setString(5, doctor.getEmail());
            ps.setString(6, doctor.getPhone());
            ps.setString(7, doctor.getImageUrl());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int doctorId = generatedKeys.getInt(1);
                    doctor.setDoctorId(doctorId);
                    
                    // Add department associations
                    if (doctor.getDepartmentIds() != null && !doctor.getDepartmentIds().isEmpty()) {
                        addDoctorDepartments(conn, doctor);
                    }
                    
                    conn.commit();
                    success = true;
                }
            }
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(generatedKeys, ps, conn);
        }
        
        return success;
    }
    
    private void addDoctorDepartments(Connection conn, Doctor doctor) throws SQLException {
        PreparedStatement ps = null;
        
        try {
            String sql = "INSERT INTO doctor_departments (doctor_id, department_id) VALUES (?, ?)";
            ps = conn.prepareStatement(sql);
            
            for (Integer departmentId : doctor.getDepartmentIds()) {
                ps.setInt(1, doctor.getDoctorId());
                ps.setInt(2, departmentId);
                ps.addBatch();
            }
            
            ps.executeBatch();
        } finally {
            closeResources(null, ps, null);
        }
    }
    
    public boolean updateDoctor(Doctor doctor) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Update doctor info
            String sql = "UPDATE doctors SET name = ?, specialization = ?, qualification = ?, " +
                         "experience = ?, email = ?, phone = ?, image_url = ? " +
                         "WHERE doctor_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctor.getName());
            ps.setString(2, doctor.getSpecialization());
            ps.setString(3, doctor.getQualification());
            ps.setString(4, doctor.getExperience());
            ps.setString(5, doctor.getEmail());
            ps.setString(6, doctor.getPhone());
            ps.setString(7, doctor.getImageUrl());
            ps.setInt(8, doctor.getDoctorId());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Delete existing department associations
                deleteDoctorDepartments(conn, doctor.getDoctorId());
                
                // Add new department associations
                if (doctor.getDepartmentIds() != null && !doctor.getDepartmentIds().isEmpty()) {
                    addDoctorDepartments(conn, doctor);
                }
                
                conn.commit();
                success = true;
            }
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(null, ps, conn);
        }
        
        return success;
    }
    
    private void deleteDoctorDepartments(Connection conn, int doctorId) throws SQLException {
        PreparedStatement ps = null;
        
        try {
            String sql = "DELETE FROM doctor_departments WHERE doctor_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, null);
        }
    }
    
    public boolean deleteDoctor(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Delete doctor-department relations first
            deleteDoctorDepartments(conn, id);
            
            // Then delete the doctor
            String sql = "DELETE FROM doctors WHERE doctor_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            
            conn.commit();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(null, ps, conn);
        }
        
        return success;
    }
    
    public List<Doctor> getHeadDoctors(int limit) {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM doctors ORDER BY CAST(REGEXP_REPLACE(experience, '[^0-9]', '') AS SIGNED) DESC LIMIT ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setQualification(rs.getString("qualification"));
                doctor.setExperience(rs.getString("experience"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setImageUrl(rs.getString("image_url"));
                
                // Load department IDs for the doctor
                loadDoctorDepartments(conn, doctor);
                
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return doctors;
    }
    
    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get all distinct specializations available in the database
     * @return List of all unique specializations
     */
    public List<String> getAllSpecializations() {
        List<String> specializations = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT DISTINCT specialization FROM doctors ORDER BY specialization";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                specializations.add(rs.getString("specialization"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return specializations;
    }
    
    /**
     * Search for doctors by name and/or specialization
     * @param searchTerm Term to search in doctor's name
     * @param specialization Filter for specific specialization
     * @return List of doctors matching the search criteria
     */
    public List<Doctor> searchDoctors(String searchTerm, String specialization) {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM doctors WHERE 1=1");
            List<Object> params = new ArrayList<>();
            
            if (searchTerm != null && !searchTerm.isEmpty()) {
                sqlBuilder.append(" AND (name LIKE ? OR qualification LIKE ?)");
                params.add("%" + searchTerm + "%");
                params.add("%" + searchTerm + "%");
            }
            
            if (specialization != null && !specialization.isEmpty()) {
                sqlBuilder.append(" AND specialization = ?");
                params.add(specialization);
            }
            
            ps = conn.prepareStatement(sqlBuilder.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setQualification(rs.getString("qualification"));
                doctor.setExperience(rs.getString("experience"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setImageUrl(rs.getString("image_url"));
                
                // Load department IDs for the doctor
                loadDoctorDepartments(conn, doctor);
                
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return doctors;
    }
}