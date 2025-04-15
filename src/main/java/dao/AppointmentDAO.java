package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Appointment;

public class AppointmentDAO {
    
    public List<Appointment> getAllAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM appointments ORDER BY appointment_date DESC";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getInt("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setNote(rs.getString("note"));
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByUser(int userId) {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM appointments WHERE user_id = ? ORDER BY appointment_date DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getInt("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setNote(rs.getString("note"));
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM appointments WHERE doctor_id = ? ORDER BY appointment_date DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getInt("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setNote(rs.getString("note"));
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return appointments;
    }
    
    public Appointment getAppointmentById(int id) {
        Appointment appointment = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM appointments WHERE appointment_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getInt("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setNote(rs.getString("note"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return appointment;
    }
    
    public boolean bookAppointment(Appointment appointment) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Book the appointment
            String sql = "INSERT INTO appointments (user_id, doctor_id, appointment_date, time_slot, status, note) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointment.getUserId());
            ps.setInt(2, appointment.getDoctorId());
            ps.setDate(3, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            ps.setInt(4, appointment.getTimeSlot());
            ps.setString(5, appointment.getStatus());
            ps.setString(6, appointment.getNote());
            
            int rowsAffected = ps.executeUpdate();
            ps.close();
            
            // Update the doctor-timeslot availability
            sql = "UPDATE doctor_timeslots SET is_available = false " +
                  "WHERE doctor_id = ? AND timeslot_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointment.getDoctorId());
            ps.setInt(2, appointment.getTimeSlot());
            ps.executeUpdate();
            
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
    
    public boolean updateAppointmentStatus(int id, String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE appointments SET status = ? WHERE appointment_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            
            success = ps.executeUpdate() > 0;
            
            // If appointment is cancelled, free up the time slot
            if (success && "cancelled".equals(status)) {
                Appointment appointment = getAppointmentById(id);
                ps.close();
                
                sql = "UPDATE doctor_timeslots SET is_available = true " +
                      "WHERE doctor_id = ? AND timeslot_id = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, appointment.getDoctorId());
                ps.setInt(2, appointment.getTimeSlot());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
        
        return success;
    }
    
    public boolean cancelAppointment(int id) {
        return updateAppointmentStatus(id, "cancelled");
    }
    
    public List<Appointment> getTodayAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM appointments WHERE appointment_date = CURDATE()";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getInt("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setNote(rs.getString("note"));
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return appointments;
    }
    
    public List<Appointment> getFutureAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM appointments WHERE appointment_date > CURDATE()";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getInt("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setNote(rs.getString("note"));
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return appointments;
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
}