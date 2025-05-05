package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.DoctorDepartment;

/**
 * Data Access Object for handling doctor-department relationships
 */
public class DoctorDepartmentDAO {
    
    private DoctorDepartment extractFromResultSet(ResultSet rs) throws SQLException {
        DoctorDepartment doctorDepartment = new DoctorDepartment();
        doctorDepartment.setId(rs.getInt("id"));
        doctorDepartment.setDoctorId(rs.getInt("doctor_id"));
        doctorDepartment.setDepartmentId(rs.getInt("department_id"));
        return doctorDepartment;
    }

    public boolean addDoctorToDepartment(int doctorId, int departmentId) {
        if (isDoctorInDepartment(doctorId, departmentId)) {
            return true;
        }

        String sql = "INSERT INTO doctor_department (doctor_id, department_id) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            stmt.setInt(2, departmentId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean removeDoctorFromDepartment(int doctorId, int departmentId) {
        String sql = "DELETE FROM doctor_department WHERE doctor_id = ? AND department_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            stmt.setInt(2, departmentId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean isDoctorInDepartment(int doctorId, int departmentId) {
        String sql = "SELECT * FROM doctor_department WHERE doctor_id = ? AND department_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            stmt.setInt(2, departmentId);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public List<Integer> getDepartmentsByDoctor(int doctorId) {
        String sql = "SELECT department_id FROM doctor_department WHERE doctor_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Integer> departmentIds = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                departmentIds.add(rs.getInt("department_id"));
            }
            return departmentIds;
        } catch (SQLException e) {
            e.printStackTrace();
            return departmentIds;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public List<Integer> getDoctorsByDepartment(int departmentId) {
        String sql = "SELECT doctor_id FROM doctor_department WHERE department_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Integer> doctorIds = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, departmentId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                doctorIds.add(rs.getInt("doctor_id"));
            }
            return doctorIds;
        } catch (SQLException e) {
            e.printStackTrace();
            return doctorIds;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public List<DoctorDepartment> getAllDoctorDepartments() {
        String sql = "SELECT * FROM doctor_department";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<DoctorDepartment> relationships = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                relationships.add(extractFromResultSet(rs));
            }
            return relationships;
        } catch (SQLException e) {
            e.printStackTrace();
            return relationships;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean updateDoctorDepartments(int doctorId, List<Integer> departmentIds) {
        Connection conn = null;
        PreparedStatement deleteStmt = null;
        PreparedStatement insertStmt = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String deleteSql = "DELETE FROM doctor_department WHERE doctor_id = ?";
            deleteStmt = conn.prepareStatement(deleteSql);
            deleteStmt.setInt(1, doctorId);
            deleteStmt.executeUpdate();

            String insertSql = "INSERT INTO doctor_department (doctor_id, department_id) VALUES (?, ?)";
            insertStmt = conn.prepareStatement(insertSql);

            for (Integer departmentId : departmentIds) {
                insertStmt.setInt(1, doctorId);
                insertStmt.setInt(2, departmentId);
                insertStmt.addBatch();
            }

            insertStmt.executeBatch();
            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(null, deleteStmt, null);
            closeResources(null, insertStmt, conn);
        }
    }

    /**
     * Helper method to close database resources
     */
    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
